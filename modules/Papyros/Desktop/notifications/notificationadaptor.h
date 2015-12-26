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

#ifndef NOTIFICATIONADAPTOR_H
#define NOTIFICATIONADAPTOR_H

#include <QDBusAbstractAdaptor>
#include <QStringList>
#include <QList>
#include "notification.h"
#include <QQmlListProperty>
#include "notificationserver.h"

class NotificationAdaptor : public QDBusAbstractAdaptor
{

    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.freedesktop.Notifications")
public:

    enum CloseReason {
        Expired = 1,
        Dismissed = 2,
        Requested = 3,
        Unknown = 4
    };

    NotificationAdaptor(QObject *parent, NotificationServer *server) : QDBusAbstractAdaptor(parent) {
        this->server = server;
    }

public slots:
    QStringList GetCapabilities()
    {
        return QStringList() << "body";
    }

    void CloseNotification(uint id)
    {
        server->onNotificationRemoved(id);

        emit NotificationClosed(id, Requested);
    }

    void GetServerInformation(QString &name, QString &vendor, QString &version, QString &spec_version)
    {
        name = "Papyros Notification Server";
        vendor = "Papyros";
        version = "0.1";
        spec_version = "1.2"; // TODO: Check that this is correct
    }

    uint Notify(QString app_name, uint replaces_id, QString app_icon, QString summary,
            QString body, QStringList actions, QVariantMap hints, int expire_timeout)
    {
        Notification *notification = server->notify(app_name, replaces_id, app_icon, summary,
                body, actions, hints, expire_timeout);

        return notification->m_id;
    }

    void closeNotification(int id)
    {
        server->onNotificationRemoved(id);
        emit NotificationClosed(id, Dismissed);
    }

signals:
    void NotificationClosed(uint id, uint reason);
    void ActionInvoked(uint id, QString action_key);

private:

    NotificationServer *server;
};

#endif // NOTIFICATIONADAPTOR_H
