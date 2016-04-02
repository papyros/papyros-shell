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

#ifndef FAKEBACKEND_H
#define FAKEBACKEND_H

#include "loginmanagerbackend.h"

class FakeBackend : public LoginManagerBackend
{
public:
    static FakeBackend *create();

    QString name() const;

    void setIdle(bool value);

    void lockSession();
    void unlockSession();

    void locked();
    void unlocked();

    void switchToVt(int index);

private:
    FakeBackend();
};

#endif // FAKEBACKEND_H
