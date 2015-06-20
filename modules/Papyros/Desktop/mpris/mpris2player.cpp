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

#include "mpris2player.h"

Mpris2Player::Mpris2Player(QString serviceName, QObject *parent) : QObject(parent),
        iface(serviceName, "/org/mpris/MediaPlayer2",
              "org.mpris.MediaPlayer2.Player"),
        playerInterface(serviceName, "/org/mpris/MediaPlayer2",
                        "org.mpris.MediaPlayer2"),
        name(playerInterface.property("Identity").toString()), m_canGoNext(iface.property("CanGoNext")), m_canSeek(iface.property("CanSeek")), m_canGoPrevious(iface.property("CanGoPrevious"))
{
    QDBusConnection::sessionBus().connect(serviceName,
            "/org/mpris/MediaPlayer2", "org.freedesktop.DBus.Properties",
            "PropertiesChanged", this, SLOT(metadataReceived(QDBusMessage)));
}

QVariantMap Mpris2Player::metadata() const
{
    QDBusInterface iface(this->iface.service(), "/org/mpris/MediaPlayer2",
            "org.freedesktop.DBus.Properties");
    QDBusMessage result = iface.call("Get", "org.mpris.MediaPlayer2.Player",
            "Metadata");
    const QDBusArgument &arg = result.arguments().at(0).value<QDBusVariant>().variant().value<QDBusArgument>();
    arg.beginMap();
    QVariantMap map;
    while (!arg.atEnd()) {
        QVariant var;
        QString str;
        arg.beginMapEntry();
        arg >> str >> var;
        arg.endMapEntry();
        map.insert(str, var);
      }
     arg.endMap();
     return map;
}

QString Mpris2Player::playbackStatus() const
{
    return QDBusInterface(this->iface.service(), "/org/mpris/MediaPlayer2",
            "org.freedesktop.DBus.Properties").call("Get",
            "org.mpris.MediaPlayer2.Player", "PlaybackStatus").arguments()
            .at(0).value<QDBusVariant>().variant().toString();
}

void Mpris2Player::playPause()
{
    iface.call("PlayPause");
}

void Mpris2Player::next()
{
    iface.call("Next");
}

void Mpris2Player::previous()
{
    iface.call("Previous");
}

void Mpris2Player::stop()
{
    iface.call("Stop");
}

void Mpris2Player::seek(const QVariant &position)
{
    iface.call("Seek", position.toLongLong());
}

void Mpris2Player::openUri(const QVariant &uri)
{
    iface.call("OpenUri", uri.toString());
}

void Mpris2Player::raise()
{
    playerInterface.call("Raise");
}

void Mpris2Player::quit()
{
    playerInterface.call("Quit");
}

void Mpris2Player::metadataReceived(QDBusMessage msg)
{
    const QDBusArgument &arg = msg.arguments().at(1).value<QDBusArgument>();
    arg.beginMap();
    while (!arg.atEnd()) {
        QString key;
        arg.beginMapEntry();
        arg >> key;
        if (key == "Metadata") {
            emit metadataNotify();
        } else if (key == "PlaybackStatus") {
            emit playbackStatusChanged();
        }
        arg.endMapEntry();
    }
    arg.endMap();
}
