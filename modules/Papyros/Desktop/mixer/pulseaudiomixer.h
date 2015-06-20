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

#ifndef PULSEAUDIOMIXER_H
#define PULSEAUDIOMIXER_H

#include <pulse/pulseaudio.h>

#include "sound.h"

struct pa_glib_mainloop;

struct Sink;

class PulseAudioMixer : public Backend
{
public:
    ~PulseAudioMixer();

    static PulseAudioMixer *create(Sound *sound);

    void getBoundaries(int *min, int *max) const override;

    int rawVol() const override;
    void setRawVol(int vol) override;
    bool muted() const override;
    void setMuted(bool muted) override;

private:
    PulseAudioMixer(Sound *sound);

    void contextStateCallback(pa_context *c);
    void subscribeCallback(pa_context *c, pa_subscription_event_type_t t, uint32_t index);
    void sinkCallback(pa_context *c, const pa_sink_info *i, int eol);
    void cleanup();

    Sound *m_mixer;
    pa_glib_mainloop *m_mainLoop;
    pa_mainloop_api *m_mainloopApi;
    pa_context *m_context;
    Sink *m_sink;
};

#endif
