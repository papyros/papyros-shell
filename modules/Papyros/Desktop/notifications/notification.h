/*
 * QML Desktop - Set of tools written in C++ for QML
 * Copyright (C) 2014 Bogdan Cuza <bogdan.cuza@hotmail.com>
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

#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>

class Notification : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appName MEMBER m_app_name CONSTANT)
    Q_PROPERTY(uint id MEMBER m_id CONSTANT)
    Q_PROPERTY(QString appIcon MEMBER m_app_icon CONSTANT)
    Q_PROPERTY(QString summary MEMBER m_summary CONSTANT)
    Q_PROPERTY(QString body MEMBER m_body CONSTANT)
    Q_PROPERTY(QStringList actions MEMBER m_actions CONSTANT)
    Q_PROPERTY(QVariantMap hints MEMBER m_hints CONSTANT)
    Q_PROPERTY(int expireTimeout MEMBER m_expire_timeout CONSTANT)
    Q_ENUMS(Urgency)
public:
    enum Urgency {
        Low, Normal, Critical
    };
    explicit Notification(QString &app_name, uint id, QString &app_icon, QString &summary, QString &body, QStringList actions, QVariantMap &hints, int &expire_timeout, QObject *parent = 0) : QObject(parent){
        m_app_name = app_name;
        m_id = id;
        m_app_icon = app_icon;
        m_summary = summary;
        m_body = body;
        m_actions = actions;
        m_hints = hints;
        m_expire_timeout = expire_timeout;
    }
    QString m_app_name;
    uint m_id;
    QString m_app_icon;
    QString m_summary;
    QString m_body;
    QStringList m_actions;
    QVariantMap m_hints;
    int m_expire_timeout;
};

#endif // NOTIFICATION_H
