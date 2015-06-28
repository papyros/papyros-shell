/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "windowdecorations.h"
#include <QDebug>
#include <private/qwaylandwindow_p.h>
#include <private/qwaylandabstractdecoration_p.h>
#include <QTimer>

using namespace QtWaylandClient;

WindowDecorations::WindowDecorations(QObject *parent)
        : QObject(parent), mColor("#1976D2"), mWindow(nullptr)
{
}

void WindowDecorations::update()
{
    if (!mWindow) return;

    QPlatformWindow *platformWindow = mWindow->handle();

    if (platformWindow == nullptr) {
        qDebug() << "No platform window yet, trying later";
        QTimer::singleShot(10, this, &WindowDecorations::update);
        return;
    }

    QWaylandWindow *waylandWindow = dynamic_cast<QWaylandWindow *>(platformWindow);

    if (waylandWindow == nullptr) {
        qDebug() << "Not running on wayland, no custom window decorations!";
        return;
    }

    QWaylandAbstractDecoration *decoration = waylandWindow->decoration();

    qDebug() << "We have decorations now!" << decoration;
}
