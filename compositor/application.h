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

#ifndef APPLICATION_H
#define APPLICATION_H

#include <QtCore/QObject>

#include <GreenIsland/Server/HomeApplication>

using namespace GreenIsland::Server;

class ProcessLauncher;
class ScreenSaver;
class SessionManager;

class Application : public QObject
{
    Q_OBJECT
public:
    Application(QObject *parent = Q_NULLPTR);

    void setScreenConfiguration(const QString &fakeScreenData);
    void setUrl(const QUrl &url);

protected:
    void customEvent(QEvent *event) Q_DECL_OVERRIDE;

private:
    QUrl m_url;
    HomeApplication *m_homeApp;
    ProcessLauncher *m_launcher;
    SessionManager *m_sessionManager;
    bool m_failSafe;
    bool m_started;

private Q_SLOTS:
    void startup();
    void shutdown();
    void unixSignal();
    void objectCreated(QObject *object, const QUrl &);
};

class StartupEvent : public QEvent
{
public:
    StartupEvent();
};

#endif // APPLICATION_H
