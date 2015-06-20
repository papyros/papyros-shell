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

#ifndef MPRIS2PLAYER_H
#define MPRIS2PLAYER_H

#include <QDBusInterface>
#include <QMap>
#include <QVariantMap>
#include <QDBusArgument>

class Mpris2Player : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap metadata READ metadata NOTIFY metadataNotify)
    Q_PROPERTY(QString name MEMBER name CONSTANT)
    Q_PROPERTY(QString playbackStatus READ playbackStatus NOTIFY playbackStatusChanged)
    Q_PROPERTY(QVariant canSeek MEMBER m_canSeek CONSTANT)
    Q_PROPERTY(QVariant canGoNext MEMBER m_canGoNext CONSTANT)
    Q_PROPERTY(QVariant canGoPrevious MEMBER m_canGoPrevious CONSTANT)

public:
    explicit Mpris2Player(QString serviceName, QObject *parent = 0);

    QVariantMap metadata() const;

    QString playbackStatus() const;

    Q_INVOKABLE void playPause();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void seek(const QVariant &position);
    Q_INVOKABLE void openUri(const QVariant &uri);
    Q_INVOKABLE void raise();
    Q_INVOKABLE void quit();

    QDBusInterface iface;
    QDBusInterface playerInterface;
    QString name;
    QVariant m_canGoNext;
    QVariant m_canSeek;
    QVariant m_canGoPrevious;

signals:
    void metadataNotify();
    void playbackStatusChanged();

private slots:
    void metadataReceived(QDBusMessage msg);

};

#endif // MPRIS2PLAYER_H
