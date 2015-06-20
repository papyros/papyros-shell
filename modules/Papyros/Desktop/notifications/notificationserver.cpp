/*
 * QML Desktop - Set of tools written in C++ for QML
 * Copyright (C) 2014 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
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
#include "notificationserver.h"
#include "notificationadaptor.h"

NotificationServer::NotificationServer(QQuickItem *parent) : QQuickItem(parent)
{
    adaptor = new NotificationAdaptor(parent, this);
    QDBusConnection::sessionBus().registerObject("/org/freedesktop/Notifications", parent);
    QDBusConnection::sessionBus().registerService("org.freedesktop.Notifications");
}

void NotificationServer::closeNotification(uint id)
{
    adaptor->closeNotification(id);
}

void NotificationServer::onNotificationUpdated(uint id, Notification *notification)
{
	onNotificationRemoved(id);
	notificationsList << notification;
}

void NotificationServer::onNotificationAdded(uint id, Notification *notification)
{
	notificationsList << notification;
}

void NotificationServer::onNotificationRemoved(uint id)
{
	for (Notification *notification : notificationsList) {
		if (notification->m_id == id) {
			notificationsList.removeOne(notification);
			delete notification;
			return;
		}
	}
}
