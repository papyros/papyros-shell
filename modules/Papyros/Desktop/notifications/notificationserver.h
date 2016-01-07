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

#ifndef NOTIFICATIONSERVER_H
#define NOTIFICATIONSERVER_H

#include <QQuickItem>
#include <QQmlListProperty>
#include <QList>
#include <QDBusConnection>
#include <QObject>

#include <Papyros/QQuickList>

#include "notification.h"

class NotificationAdaptor;

class NotificationServer : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(NotificationServer)

    Q_PROPERTY(QObjectListModel *notifications READ notifications CONSTANT)

public:
    explicit NotificationServer(QQuickItem *parent = new QQuickItem());

    QObjectListModel *notifications()
    {
        return notificationsList.getModel();
    }

public slots:
    Notification *notify(QString app_name, uint replaces_id, QString app_icon,
            QString summary, QString body, QStringList actions, QVariantMap hints,
            int expire_timeout = 0, int progress = -1);

    void closeNotification(uint id);
    void onNotificationUpdated(uint id, Notification *notification);
    void onNotificationAdded(uint id, Notification *notification);
    void onNotificationRemoved(uint id);

private slots:
    void forTimer(QString id);

private:
    uint availableId = 1;
    NotificationAdaptor *adaptor;
    QQuickList<Notification> notificationsList;
};

#endif // NOTIFICATIONSERVER_H
