/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2015-2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include "loginmanagerbackend.h"

LoginManagerBackend::LoginManagerBackend(QObject *parent)
    : QObject(parent)
    , m_sessionControl(false)
{
}

LoginManagerBackend::~LoginManagerBackend()
{
}

bool LoginManagerBackend::hasSessionControl() const
{
    return m_sessionControl;
}

void LoginManagerBackend::takeControl()
{
}

void LoginManagerBackend::releaseControl()
{
}

int LoginManagerBackend::takeDevice(const QString &path)
{
    Q_UNUSED(path)
    return false;
}

void LoginManagerBackend::releaseDevice(int fd)
{
    Q_UNUSED(fd)
}

#include "moc_loginmanagerbackend.cpp"
