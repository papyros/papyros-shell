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

#ifndef LOGINMANAGER_H
#define LOGINMANAGER_H

#include <QtCore/QObject>
#include <QtCore/QLoggingCategory>

#include "loginmanagerbackend.h"

Q_DECLARE_LOGGING_CATEGORY(LOGINMANAGER)

class SessionManager;

class LoginManager : public QObject
{
    Q_OBJECT
public:
    LoginManager(SessionManager *sm, QObject *parent = 0);
    ~LoginManager();

    void setIdle(bool value);

    void takeControl();
    void releaseControl();

    int takeDevice(const QString &path);
    void releaseDevice(int fd);

    void lockSession();
    void unlockSession();

    void switchToVt(int index);

public Q_SLOTS:
    void locked();
    void unlocked();

Q_SIGNALS:
    void logOutRequested();
    void sessionLocked();
    void sessionUnlocked();

private:
    LoginManagerBackend *m_backend;
};

#endif // LOGINMANAGER_H
