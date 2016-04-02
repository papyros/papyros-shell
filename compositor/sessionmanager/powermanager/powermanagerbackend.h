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

#ifndef POWERMANAGERBACKEND_H
#define POWERMANAGERBACKEND_H

#include <QtCore/QtGlobal>
#include <QtCore/QObject>

#include "powermanager.h"

class PowerManagerBackend : public QObject
{
public:
    explicit PowerManagerBackend();
    virtual ~PowerManagerBackend();

    virtual QString name() const = 0;

    virtual PowerManager::Capabilities capabilities() const = 0;

    virtual void powerOff() = 0;
    virtual void restart() = 0;
    virtual void suspend() = 0;
    virtual void hibernate() = 0;
    virtual void hybridSleep() = 0;
};

#endif // POWERMANAGERBACKEND_H
