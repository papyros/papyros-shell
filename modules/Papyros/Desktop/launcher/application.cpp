/*
 * QML Desktop - Set of tools written in C++ for QML
 *
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <GreenIsland/Server/ApplicationManager>
#include <QtCore/QLocale>
#include <QtCore/QStandardPaths>
#include <QtCore/QDebug>
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusInterface>

#include "application.h"

Application::Application(const QString &appId, bool pinned, QObject *parent)
		: QObject(parent), m_appId(appId),
		  m_focused(false), m_pinned(pinned),
		  m_state(Application::NotRunning)
{
	m_desktopFile = new DesktopFile(appId, this);
}

Application::Application(const QString &appId, QObject *parent)
		: Application(appId, false, parent)
{
}

void Application::setPinned(bool pinned)
{
	if (pinned == m_pinned)
		return;

	m_pinned = pinned;
	emit pinnedChanged();
}

void Application::setState(State state)
{
	if (state == m_state)
		return;

	m_state = state;
	emit stateChanged();
}

void Application::setFocused(bool focused)
{
	if (focused == m_focused)
		return;

	m_focused = focused;
	emit focusedChanged();
}

bool Application::launch(const QStringList& urls)
{
    if (isRunning())
        return true;

    desktopFile()->launch(urls);

    setState(Application::Starting);

    Q_EMIT launched();

    return true;
}

bool Application::quit()
{
	if (!isRunning())
        return false;

    GreenIsland::ApplicationManager::instance()->quit(appId());

    return true;
}
