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

#include <QtCore/QCoreApplication>
#include <QtCore/QTimer>
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusError>

#include <qt5xdg/xdgautostart.h>
#include <qt5xdg/xdgdesktopfile.h>

#include "authenticator.h"
#include "cmakedirs.h"
#include "loginmanager/loginmanager.h"
#include "powermanager/powermanager.h"
#include "sessionmanager.h"
#include "sessionmanager/screensaver/screensaver.h"
#include "sessionmanager/screensaver/screensaveradaptor.h"

#include <sys/types.h>
#include <signal.h>

Q_LOGGING_CATEGORY(SESSION_MANAGER, "papyros.session.manager")

/*
 * CustomAuthenticator
 */

class CustomAuthenticator : public QObject
{
public:
    CustomAuthenticator(SessionManager *parent, const QJSValue &callback)
        : m_parent(parent)
        , m_callback(callback)
        , m_succeded(false)
    {
        connect(m_parent->m_authenticator, &Authenticator::authenticationSucceded, this, [=] {
            m_succeded = true;
            authenticate();
        });
        connect(m_parent->m_authenticator, &Authenticator::authenticationFailed, this, [=] {
            m_succeded = false;
            authenticate();
        });
        connect(m_parent->m_authenticator, &Authenticator::authenticationError, this, [=] {
            m_succeded = false;
            authenticate();
        });
    }

private:
    SessionManager *m_parent;
    QJSValue m_callback;
    bool m_succeded;

private Q_SLOTS:
    void authenticate() {
        if (m_callback.isCallable())
            m_callback.call(QJSValueList() << m_succeded);

        m_parent->m_authRequested = false;

        if (m_succeded)
            m_parent->setLocked(false);

        deleteLater();
    }
};

/*
 * SessionManager
 */

SessionManager::SessionManager(QObject *parent)
    : QObject(parent)
    , m_authenticatorThread(new QThread(this))
    , m_authRequested(false)
    , m_authenticator(new Authenticator)
    , m_loginManager(new LoginManager(this, this))
    , m_powerManager(new PowerManager(this))
    , m_screenSaver(new ScreenSaver(this))
    , m_idle(false)
    , m_locked(false)
{
    // Lock and unlock the session
    connect(m_loginManager, &LoginManager::sessionLocked, this, [this] {
        setLocked(true);
    });
    connect(m_loginManager, &LoginManager::sessionUnlocked, this, [this] {
        setLocked(false);
    });

    // Logout session before the system goes off
    connect(m_loginManager, &LoginManager::logOutRequested,
            this, &SessionManager::logOut);

    // Authenticate in a separate thread
    m_authenticator->moveToThread(m_authenticatorThread);
    m_authenticatorThread->start();
}

SessionManager::~SessionManager()
{
    m_authenticatorThread->quit();
    m_authenticatorThread->wait();
    m_authenticator->deleteLater();
}

bool SessionManager::registerWithDBus()
{
    QDBusConnection bus = QDBusConnection::sessionBus();

    new ScreenSaverAdaptor(m_screenSaver);
    if (!bus.registerObject(QStringLiteral("/org/freedesktop/ScreenSaver"), m_screenSaver)) {
        qCWarning(SESSION_MANAGER,
                  "Couldn't register /org/freedesktop/ScreenSaver D-Bus object: %s",
                  qPrintable(bus.lastError().message()));
        return false;
    }

    return true;
}

bool SessionManager::isIdle() const
{
    return m_idle;
}

void SessionManager::setIdle(bool value)
{
    if (m_idle == value)
        return;

    m_idle = value;
    m_loginManager->setIdle(m_idle);
    Q_EMIT idleChanged(value);
}

bool SessionManager::isLocked() const
{
    return m_locked;
}

void SessionManager::setLocked(bool value)
{
    if (m_locked == value)
        return;

    m_locked = value;
    Q_EMIT lockedChanged(value);

    if (value)
        Q_EMIT sessionLocked();
    else
        Q_EMIT sessionUnlocked();
}

bool SessionManager::canLock() const
{
    // Always true, but in the future we might consider blocking
    // this; might come in handy for kiosk systems
    return true;
}

bool SessionManager::canLogOut()
{
    // Always true, but in the future we might consider blocking
    // logout; might come in handy for kiosk systems
    return true;
}

bool SessionManager::canStartNewSession()
{
    // Always false, but in the future we might consider
    // allowing this
    return false;
}

bool SessionManager::canPowerOff()
{
    return m_powerManager->capabilities() & PowerManager::PowerOff;
}

bool SessionManager::canRestart()
{
    return m_powerManager->capabilities() & PowerManager::Restart;
}

bool SessionManager::canSuspend()
{
    return m_powerManager->capabilities() & PowerManager::Suspend;
}

bool SessionManager::canHibernate()
{
    return m_powerManager->capabilities() & PowerManager::Hibernate;
}

bool SessionManager::canHybridSleep()
{
    return m_powerManager->capabilities() & PowerManager::HybridSleep;
}

void SessionManager::autostart()
{
    Q_FOREACH (const XdgDesktopFile &entry, XdgAutoStart::desktopFileList()) {
        if (!entry.isSuitable(true, QStringLiteral("X-Papyros")))
            continue;

        qCDebug(SESSION_MANAGER) << "Autostart:" << entry.name() << "from" << entry.fileName();
        //m_launcher->launchEntry(const_cast<XdgDesktopFile *>(&entry));
    }
}

void SessionManager::logOut()
{
    // Close all applications we launched
    //m_launcher->closeApplications();

    // Exit
    QCoreApplication::quit();
}

void SessionManager::powerOff()
{
    m_powerManager->powerOff();
}

void SessionManager::restart()
{
    m_powerManager->restart();
}

void SessionManager::suspend()
{
    m_powerManager->suspend();
}

void SessionManager::hibernate()
{
    m_powerManager->hibernate();
}

void SessionManager::hybridSleep()
{
    m_powerManager->hybridSleep();
}

void SessionManager::lockSession()
{
    m_loginManager->lockSession();
}

void SessionManager::unlockSession(const QString &password, const QJSValue &callback)
{
    if (m_authRequested)
        return;

    (void)new CustomAuthenticator(this, callback);
    QMetaObject::invokeMethod(m_authenticator, "authenticate", Q_ARG(QString, password));
    m_authRequested = true;
}

void SessionManager::startNewSession()
{
    // TODO: Implement
    qWarning("SessionManager::startNewSession() is not implemented");
}

void SessionManager::activateSession(int index)
{
    m_loginManager->switchToVt(index);
}

void SessionManager::requestLogOut()
{
    if (!canLogOut())
        return;
    Q_EMIT logOutRequested();
}

void SessionManager::requestPowerOff()
{
    if (!canPowerOff())
        return;
    Q_EMIT powerOffRequested();
}

void SessionManager::requestRestart()
{
    if (!canRestart())
        return;
    Q_EMIT restartRequested();
}

void SessionManager::requestSuspend()
{
    if (!canSuspend())
        return;
    Q_EMIT suspendRequested();
}

void SessionManager::requestHibernate()
{
    if (!canHibernate())
        return;
    Q_EMIT hibernateRequested();
}

void SessionManager::requestHybridSleep()
{
    if (!canHybridSleep())
        return;
    Q_EMIT hybridSleepRequested();
}

void SessionManager::cancelShutdownRequest()
{
    Q_EMIT shutdownRequestCanceled();
}

#include "moc_sessionmanager.cpp"
