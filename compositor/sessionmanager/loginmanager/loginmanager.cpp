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

#include "fakebackend.h"
#include "loginmanager.h"
#include "logindbackend.h"

Q_LOGGING_CATEGORY(LOGINMANAGER, "papyros.loginmanager")

LoginManager::LoginManager(SessionManager *sm, QObject *parent)
    : QObject(parent)
{
    // Create backend
    m_backend = LogindBackend::create(sm);
    if (!m_backend)
        m_backend = FakeBackend::create();
    qCDebug(LOGINMANAGER) << "Using" << m_backend->name() << "login manager backend";

    // Relay backend signals
    connect(m_backend, SIGNAL(logOutRequested()),
            this, SIGNAL(logOutRequested()));
    connect(m_backend, SIGNAL(sessionLocked()),
            this, SIGNAL(sessionLocked()));
    connect(m_backend, SIGNAL(sessionUnlocked()),
            this, SIGNAL(sessionUnlocked()));
}

LoginManager::~LoginManager()
{
    if (m_backend)
        m_backend->deleteLater();
}

void LoginManager::setIdle(bool value)
{
    m_backend->setIdle(value);
}

void LoginManager::takeControl()
{
    m_backend->takeControl();
}

void LoginManager::releaseControl()
{
    m_backend->releaseControl();
}

int LoginManager::takeDevice(const QString &path)
{
    return m_backend->takeDevice(path);
}

void LoginManager::releaseDevice(int fd)
{
    m_backend->releaseDevice(fd);
}

void LoginManager::lockSession()
{
    m_backend->lockSession();
}

void LoginManager::unlockSession()
{
    m_backend->unlockSession();
}

void LoginManager::switchToVt(int index)
{
    m_backend->switchToVt(index);
}

void LoginManager::locked()
{
    m_backend->locked();
}

void LoginManager::unlocked()
{
    m_backend->unlocked();
}

#include "moc_loginmanager.cpp"
