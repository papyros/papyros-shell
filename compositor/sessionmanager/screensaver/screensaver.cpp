/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2014-2016 Pier Luigi Fiorini
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

#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusError>

#include "screensaver.h"
#include "sessionmanager/sessionmanager.h"

Q_LOGGING_CATEGORY(SCREENSAVER, "papyros.screensaver")

ScreenSaver::ScreenSaver(QObject *parent)
    : QObject(parent)
    , m_active(false)
    , m_sessionManager(qobject_cast<SessionManager *>(parent))
{
}

ScreenSaver::~ScreenSaver()
{
}

bool ScreenSaver::GetActive()
{
    return m_active;
}

bool ScreenSaver::SetActive(bool state)
{
    if (state) {
        Lock();
        return true;
    }

    return false;
}

uint ScreenSaver::GetActiveTime()
{
    return 0;
}

uint ScreenSaver::GetSessionIdleTime()
{
    return 0;
}

void ScreenSaver::SimulateUserActivity()
{
}

uint ScreenSaver::Inhibit(const QString &appName, const QString &reason)
{
    Q_UNUSED(appName)
    Q_UNUSED(reason)

    static uint cookieSeed = 0;
    int newCookie = cookieSeed++;

    Q_EMIT m_sessionManager->idleInhibitRequested();

    return newCookie;
}

void ScreenSaver::UnInhibit(uint cookie)
{
    Q_UNUSED(cookie)

    m_sessionManager->idleUninhibitRequested();
}

void ScreenSaver::Lock()
{
    //SessionManager::instance()->setLocked(true);
}

uint ScreenSaver::Throttle(const QString &appName, const QString &reason)
{
    // TODO:
    Q_UNUSED(appName);
    Q_UNUSED(reason);
    return 0;
}

void ScreenSaver::UnThrottle(uint cookie)
{
    // TODO:
    Q_UNUSED(cookie);
}

#include "moc_screensaver.cpp"
