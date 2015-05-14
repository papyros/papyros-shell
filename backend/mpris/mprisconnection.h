/*
 * QML Desktop - Set of tools written in C++ for QML
 *
 * Copyright (C) 2014 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *               2014 Ricardo Vieira <ricardo.vieira@tecnico.ulisboa.pt>
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

#ifndef MPRISCONNECTION_H
#define MPRISCONNECTION_H

#include <QQuickItem>
#include <QDBusServiceWatcher>
#include <QDBusReply>
#include <QDBusConnectionInterface>
#include <QVariantList>
#include "mpris2player.h"
#include <QQmlListProperty>

class MprisConnection : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(MprisConnection)

    Q_PROPERTY(QQmlListProperty<Mpris2Player> playerList READ getPlayerList NOTIFY playerListChanged)

public:
    MprisConnection(QQuickItem *parent = 0);
    ~MprisConnection();

    QQmlListProperty<Mpris2Player> getPlayerList() {
        return QQmlListProperty<Mpris2Player>(this, playerList);
    }

public slots:
    void serviceOwnerChanged(const QString &serviceName,
                             const QString &oldOwner,
                             const QString &newOwner);

signals:
    QQmlListProperty<Mpris2Player> playerListChanged(QQmlListProperty<Mpris2Player> playerList);


private:
    QDBusServiceWatcher *watcher;
    QList<Mpris2Player*> playerList;

};

#endif // MPRISCONNECTION_H
