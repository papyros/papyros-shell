/****************************************************************************
 * This file is part of Hawaii Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include <QtQuick/QQuickWindow>

#include "keyeventfilter.h"

KeyEventFilter::KeyEventFilter(QQuickItem *parent)
    : QQuickItem(parent)
{
    connect(this, &QQuickItem::windowChanged, [=](QQuickWindow *window) {
        // Remove event filter previously installed if any
        if (!m_window.isNull()) {
            m_window->removeEventFilter(this);
            m_window.clear();
        }

        // Install this event filter when the item is on the window
        if (window) {
            window->installEventFilter(this);
            m_window = window;
        }
    });
}

bool KeyEventFilter::eventFilter(QObject *object, QEvent *event)
{
    Q_UNUSED(object);
    // Discard events not related to keyboard
    if (event->type() != QEvent::KeyPress && event->type() != QEvent::KeyRelease)
        return false;

    // Pass this event to QML for processing
    event->accept();
    QCoreApplication::sendEvent(this, event);
    return event->isAccepted();
}

#include "moc_keyeventfilter.cpp"
