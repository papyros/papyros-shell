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

Notification *NotificationServer::notify(QString app_name, uint replaces_id, QString app_icon,
        QString summary, QString body, QStringList actions, QVariantMap hints,
        int expire_timeout, int progress)
{
    if (expire_timeout == 0) {
        expire_timeout = 2500;
    }

    Notification *notification = new Notification(app_name,
            (replaces_id == 0 ? availableId++ : replaces_id),
            app_icon, summary, body, actions, hints, expire_timeout, progress);

    if (expire_timeout != -1) {
        notification->timeout(this, SLOT(forTimer(QString)));
    }

    if (replaces_id != 0) {
        onNotificationUpdated(replaces_id, notification);
    } else {
        onNotificationAdded(notification->m_id, notification);
    }

    return notification;
}

void NotificationServer::onNotificationUpdated(uint id, Notification *notification)
{
    for (int i = 0; i < notificationsList.size(); i++) {
        Notification *existing_notification = notificationsList[i];

    	if (existing_notification->m_id == id) {
			notificationsList.replace(i, notification);
			delete existing_notification;
			return;
		}
	}

    onNotificationAdded(id, notification);
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

void NotificationServer::forTimer(QString id)
{
    onNotificationRemoved(id.toInt());
    emit adaptor->NotificationClosed(QVariant(id).toUInt(), NotificationAdaptor::Expired);
}
