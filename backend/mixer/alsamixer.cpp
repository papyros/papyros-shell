/*
 * Copyright 2013 Giulio Camuffo <giuliocamuffo@gmail.com>
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

#include "alsamixer.h"

static const char *card = "default";
static const char *selem_name = "Master";

AlsaMixer::AlsaMixer(Sound *m)
         : Backend()
         , m_mixer(m)
{
}

AlsaMixer *AlsaMixer::create(Sound *m)
{
    AlsaMixer *alsa = new AlsaMixer(m);
    if (!alsa) {
        return nullptr;
    }

    snd_mixer_open(&alsa->m_handle, 0);
    snd_mixer_attach(alsa->m_handle, card);
    snd_mixer_selem_register(alsa->m_handle, NULL, NULL);
    snd_mixer_load(alsa->m_handle);

    snd_mixer_selem_id_alloca(&alsa->m_sid);
    snd_mixer_selem_id_set_index(alsa->m_sid, 0);
    snd_mixer_selem_id_set_name(alsa->m_sid, selem_name);
    alsa->m_elem = snd_mixer_find_selem(alsa->m_handle, alsa->m_sid);
    if (!alsa->m_elem) {
        delete alsa;
        return nullptr;
    }

    snd_mixer_selem_get_playback_volume_range(alsa->m_elem, &alsa->m_min, &alsa->m_max);
    return alsa;
}

AlsaMixer::~AlsaMixer()
{
    snd_mixer_close(m_handle);
}

void AlsaMixer::getBoundaries(int *min, int *max) const
{
    *min = m_min;
    *max = m_max;
}

void AlsaMixer::setRawVol(int volume)
{
    snd_mixer_selem_set_playback_volume_all(m_elem, volume);
    emit m_mixer->masterChanged();
}

int AlsaMixer::rawVol() const
{
    long vol;
    snd_mixer_selem_get_playback_volume(m_elem, SND_MIXER_SCHN_UNKNOWN, &vol);
    return vol;
}

bool AlsaMixer::muted() const
{
    int mute;
    snd_mixer_selem_get_playback_switch(m_elem, SND_MIXER_SCHN_UNKNOWN, &mute);
    return !mute;
}

void AlsaMixer::setMuted(bool muted)
{
    snd_mixer_selem_set_playback_switch_all(m_elem, !muted);
    emit m_mixer->mutedChanged();
}
