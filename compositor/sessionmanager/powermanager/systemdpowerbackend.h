/****************************************************************************
 * This file is part of Hawaii Shell.
 *
 * Copyright (C) 2013-2016 Pier Luigi Fiorini
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

#ifndef SYSTEMDPOWERBACKEND_H
#define SYSTEMDPOWERBACKEND_H

#include <QtDBus/QDBusInterface>

#include "powermanagerbackend.h"

class SystemdPowerBackend : public PowerManagerBackend
{
public:
    SystemdPowerBackend();
    virtual ~SystemdPowerBackend();

    static QString service();

    QString name() const;

    PowerManager::Capabilities capabilities() const;

    void powerOff();
    void restart();
    void suspend();
    void hibernate();
    void hybridSleep();

private:
    QDBusInterface *m_interface;
};

#endif // SYSTEMDPOWERBACKEND_H
