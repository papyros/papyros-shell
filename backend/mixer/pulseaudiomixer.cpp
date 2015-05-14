/*
 * Copyright 2013-2014 Giulio Camuffo <giuliocamuffo@gmail.com>
 *
 * This file is part of Orbital. Originally licensed under the GPLv3, relicensed
 * with permission for use in Papyros.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <pulse/glib-mainloop.h>
#include <pulse/volume.h>

#include "pulseaudiomixer.h"

struct Sink
{
    Sink() : muted(false) {}
    uint32_t index;
    pa_cvolume volume;
    bool muted;
};

PulseAudioMixer::PulseAudioMixer(Sound *m)
               : Backend()
               , m_mixer(m)
               , m_sink(new Sink)
{
}

PulseAudioMixer::~PulseAudioMixer()
{
    delete m_sink;
    cleanup();
}

PulseAudioMixer *PulseAudioMixer::create(Sound *mixer)
{
    PulseAudioMixer *pulse = new PulseAudioMixer(mixer);

    if (!(pulse->m_mainLoop = pa_glib_mainloop_new(nullptr))) {
        qWarning("pa_mainloop_new() failed.");
        delete pulse;
        return nullptr;
    }

    pulse->m_mainloopApi = pa_glib_mainloop_get_api(pulse->m_mainLoop);

    // pluseaudio tries to connect to X if DISPLAY is set. the problem is that if we have
    // xwayland running it will try to connect to it, and we don't want that.
    char *dpy = getenv("DISPLAY");
    setenv("DISPLAY", "", 1);
    pulse->m_context = pa_context_new(pulse->m_mainloopApi, nullptr);
    setenv("DISPLAY", dpy, 1);
    if (!pulse->m_context) {
        qWarning("pa_context_new() failed.");
        delete pulse;
        return nullptr;
    }

    pa_context_set_state_callback(pulse->m_context, [](pa_context *c, void *ud) {
        static_cast<PulseAudioMixer *>(ud)->contextStateCallback(c);
    }, pulse);
    if (pa_context_connect(pulse->m_context, nullptr, (pa_context_flags_t)0, nullptr) < 0) {
        qWarning("pa_context_connect() failed: %s", pa_strerror(pa_context_errno(pulse->m_context)));
        delete pulse;
        return nullptr;
    }

    return pulse;
}

void PulseAudioMixer::contextStateCallback(pa_context *c)
{
    switch (pa_context_get_state(c)) {
        case PA_CONTEXT_CONNECTING:
        case PA_CONTEXT_AUTHORIZING:
        case PA_CONTEXT_SETTING_NAME:
            break;

        case PA_CONTEXT_READY:
            pa_context_set_subscribe_callback(c, [](pa_context *c, pa_subscription_event_type_t t, uint32_t index, void *ud) {
                static_cast<PulseAudioMixer *>(ud)->subscribeCallback(c, t, index);
            }, this);
            pa_context_subscribe(c, PA_SUBSCRIPTION_MASK_SINK, nullptr, nullptr);

            pa_context_get_sink_info_list(c, [](pa_context *c, const pa_sink_info *i, int eol, void *ud) {
                static_cast<PulseAudioMixer *>(ud)->sinkCallback(c, i, eol);
            }, this);
            break;

        case PA_CONTEXT_TERMINATED:
            cleanup();
            break;

        case PA_CONTEXT_FAILED:
        default:
            qWarning("Connection with the pulseaudio server failed: %s", pa_strerror(pa_context_errno(c)));
            cleanup();
            break;
    }
}

void PulseAudioMixer::subscribeCallback(pa_context *c, pa_subscription_event_type_t t, uint32_t index)
{
    Q_UNUSED(index);
    switch (t & PA_SUBSCRIPTION_EVENT_FACILITY_MASK) {
        case PA_SUBSCRIPTION_EVENT_SINK:
            pa_context_get_sink_info_list(c, [](pa_context *c, const pa_sink_info *i, int eol, void *ud) {
                static_cast<PulseAudioMixer *>(ud)->sinkCallback(c, i, eol);
            }, this);
            break;
        default:
            break;
    }
}

void PulseAudioMixer::sinkCallback(pa_context *c, const pa_sink_info *i, int eol)
{
    if (eol < 0) {
        if (pa_context_errno(c) == PA_ERR_NOENTITY)
            return;

        qWarning() << "Sink callback failure";
        return;
    }

    if (eol > 0) {
        return;
    }

    m_sink->index = i->index;
    if (m_sink->muted != (bool)i->mute) {
        m_sink->muted = (bool)i->mute;
        emit m_mixer->mutedChanged();
    }
    m_sink->volume = i->volume;
    emit m_mixer->masterChanged();
}

void PulseAudioMixer::cleanup()
{

}

void PulseAudioMixer::getBoundaries(int *min, int *max) const
{
    *min = PA_VOLUME_MUTED;
    *max = PA_VOLUME_NORM;
}

void PulseAudioMixer::setRawVol(int vol)
{
    setMuted(false);
    pa_cvolume_set(&m_sink->volume, m_sink->volume.channels, vol);
    pa_context_set_sink_volume_by_index(m_context, m_sink->index, &m_sink->volume, nullptr, nullptr);
}

int PulseAudioMixer::rawVol() const
{
    return pa_cvolume_avg(&m_sink->volume);
}

bool PulseAudioMixer::muted() const
{
    return m_sink->muted;
}

void PulseAudioMixer::setMuted(bool muted)
{
    pa_context_set_sink_mute_by_index(m_context, m_sink->index, muted, nullptr, nullptr);
}
