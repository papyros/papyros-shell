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

#include <linux/input.h>

#include <qmath.h>

#include "sound.h"

#ifdef HAVE_ALSA
#include "alsamixer.h"
#endif
#include "pulseaudiomixer.h"

Sound::Sound(QQuickItem *parent)
            : QQuickItem(parent)
            , m_backend(nullptr)
{
    init();
}

Sound::~Sound()
{
    delete m_backend;
}

void Sound::init()
{
    m_backend = PulseAudioMixer::create(this);
    if (!m_backend) {
#ifdef HAVE_ALSA
        m_backend = AlsaMixer::create(this);
#endif
    }
    if (!m_backend) {
        qWarning() << "Sound: could not load a mixer backend.";
        return;
    }

    m_backend->getBoundaries(&m_min, &m_max);
    m_step = (m_max - m_min) / 50;
}

void Sound::changeMaster(int change)
{
    setMaster(master() + change);
}

void Sound::increaseMaster()
{
    if (m_backend) {
        long v = qBound(m_min, m_backend->rawVol() + m_step, m_max);
        m_backend->setRawVol(v);
    }
}

void Sound::decreaseMaster()
{
    if (m_backend) {
        long v = qBound(m_min, m_backend->rawVol() - m_step, m_max);
        m_backend->setRawVol(v);
    }
}

void Sound::setMaster(int volume)
{
    if (m_backend) {
        int v = qBound(m_min, (int)((double)volume * (double)m_max / 100.), m_max);
        m_backend->setRawVol(v);
    }
}

int Sound::master() const
{
    if (m_backend) {
        int vol = m_backend->rawVol();
        vol = (float)vol * 100.f / (float)m_max;
        return vol;
    }
    return 0;
}

bool Sound::muted() const
{
    if (m_backend) {
        return m_backend->muted();
    }
    return false;
}

void Sound::setMuted(bool muted)
{
    if (m_backend) {
        m_backend->setMuted(muted);
    }
}

void Sound::toggleMuted()
{
    if (m_backend) {
        setMuted(!m_backend->muted());
    }
}
