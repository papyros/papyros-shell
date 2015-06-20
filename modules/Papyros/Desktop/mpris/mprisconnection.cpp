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

#include "mprisconnection.h"

MprisConnection::MprisConnection(QQuickItem *parent):
    QQuickItem(parent)
{
    QDBusConnection bus = QDBusConnection::sessionBus();
    const QStringList services = bus.interface()->registeredServiceNames();

    foreach(QString name, services.filter("org.mpris.MediaPlayer2")) {
        playerList.append(new Mpris2Player(name));
    }
    watcher = new QDBusServiceWatcher(QString(), bus);

    connect(watcher, SIGNAL(serviceOwnerChanged(QString, QString, QString)),
            this, SLOT(serviceOwnerChanged(QString,QString,QString)));
}

MprisConnection::~MprisConnection(){
    delete watcher;
    while (!playerList.isEmpty())
                delete playerList.takeFirst();
}

void MprisConnection::serviceOwnerChanged(const QString &serviceName,
        const QString &oldOwner, const QString &newOwner)
{
    if (oldOwner.isEmpty() && serviceName.startsWith("org.mpris.MediaPlayer2.")) {
                playerList.append(new Mpris2Player(serviceName));
                emit playerListChanged(QQmlListProperty<Mpris2Player>(this, playerList));
    } else if (newOwner.isEmpty() && serviceName.startsWith("org.mpris.MediaPlayer2.")) {
        for (int i = 0; i < playerList.size(); ++i) {
            if (playerList.at(i)->iface.service() == serviceName) {
                playerList.removeAt(i);
                emit playerListChanged(QQmlListProperty<Mpris2Player>(this, playerList));
            }
         }
    }
}
