/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2012-2016 Pier Luigi Fiorini
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
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusError>

#include <GreenIsland/QtWaylandCompositor/QWaylandCompositor>

#include "application.h"
#include "processlauncher/processlauncher.h"
#include "sessionmanager/sessionmanager.h"
#include "sigwatch/sigwatch.h"

static const QEvent::Type StartupEventType = (QEvent::Type)QEvent::registerEventType();

Application::Application(QObject *parent)
    : QObject(parent)
    , m_failSafe(false)
    , m_started(false)
{
    // Unix signals watcher
    UnixSignalWatcher *sigwatch = new UnixSignalWatcher(this);
    sigwatch->watchForSignal(SIGINT);
    sigwatch->watchForSignal(SIGTERM);

    // Quit when the process is killed
    connect(sigwatch, &UnixSignalWatcher::unixSignal, this, &Application::unixSignal);

    // Home application
    m_homeApp = new HomeApplication(this);

    // Process launcher
    m_launcher = new ProcessLauncher(this);

    // Session manager
    m_sessionManager = new SessionManager(this);

    // Fail safe mode
    connect(m_homeApp, &HomeApplication::objectCreated,
            this, &Application::objectCreated);

    // Invole shutdown sequence when quitting
    connect(QCoreApplication::instance(), &QCoreApplication::aboutToQuit,
            this, &Application::shutdown);
}

void Application::setScreenConfiguration(const QString &fakeScreenData)
{
    m_homeApp->setScreenConfiguration(fakeScreenData);
}

void Application::setUrl(const QUrl &url)
{
    m_url = url;
}

void Application::customEvent(QEvent *event)
{
    if (event->type() == StartupEventType)
        startup();
}

void Application::startup()
{
    // Can't do the startup sequence twice
    if (m_started)
        return;

    // Register D-Bus service
    if (!QDBusConnection::sessionBus().registerService(QStringLiteral("io.papyros.Session"))) {
        qWarning("Failed to register D-Bus service: %s",
                 qPrintable(QDBusConnection::sessionBus().lastError().message()));
        QCoreApplication::exit(1);
    }

    // Session manager
    if (!m_sessionManager->registerWithDBus())
        QCoreApplication::exit(1);

    // Process launcher
    if (!ProcessLauncher::registerWithDBus(m_launcher))
        QCoreApplication::exit(1);

    // Session interface
    m_homeApp->setContextProperty(QStringLiteral("SessionInterface"),
                                  m_sessionManager);

    // Load the compositor
    if (!m_homeApp->loadUrl(m_url))
        QCoreApplication::exit(1);

    // Set Wayland socket name
    QObject *rootObject = m_homeApp->rootObjects().at(0);
    QWaylandCompositor *compositor = qobject_cast<QWaylandCompositor *>(rootObject);
    if (compositor)
        m_launcher->setWaylandSocketName(QString::fromUtf8(compositor->socketName()));

    m_started = true;
}

void Application::shutdown()
{
    m_launcher->deleteLater();
    m_launcher = Q_NULLPTR;

    m_homeApp->deleteLater();
    m_homeApp = Q_NULLPTR;

    m_sessionManager->deleteLater();
    m_sessionManager = Q_NULLPTR;
}

void Application::unixSignal()
{
    QCoreApplication::quit();
}

void Application::objectCreated(QObject *object, const QUrl &)
{
    // All went fine
    if (object)
        return;

    // Compositor failed to load
    if (m_failSafe) {
        // We give up because even the error screen has an error
        qWarning("A fatal error has occurred while running Papyros, but the error "
                 "screen has errors too. Giving up.");
        QCoreApplication::exit(1);
    } else {
        // Load the error screen in case of error
        m_failSafe = true;
        m_homeApp->loadUrl(QUrl(QStringLiteral("qrc:/error/ErrorCompositor.qml")));
    }
}

StartupEvent::StartupEvent()
    : QEvent(StartupEventType)
{
}

#include "moc_application.cpp"
