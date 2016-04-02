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

#ifndef LOGINMANAGERBACKEND_H
#define LOGINMANAGERBACKEND_H

#include <QtCore/QObject>

class LoginManagerBackend : public QObject
{
    Q_OBJECT
public:
    LoginManagerBackend(QObject *parent = 0);
    virtual ~LoginManagerBackend();

    virtual QString name() const = 0;

    bool hasSessionControl() const;

    virtual void setIdle(bool value) = 0;

    virtual void takeControl();
    virtual void releaseControl();

    virtual int takeDevice(const QString &path);
    virtual void releaseDevice(int fd);

    virtual void lockSession() = 0;
    virtual void unlockSession() = 0;

    virtual void locked() = 0;
    virtual void unlocked() = 0;

    virtual void switchToVt(int index) = 0;

Q_SIGNALS:
    void logOutRequested();
    void sessionControlChanged(bool value);
    void sessionLocked();
    void sessionUnlocked();

protected:
    bool m_sessionControl;
};

#endif // LOGINMANAGERBACKEND_H
