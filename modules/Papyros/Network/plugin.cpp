/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2015 Pier Luigi Fiorini
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

#include <QtQml/QtQml>

#include "availabledevices.h"
#include "appletproxymodel.h"
#include "connectionicon.h"
#include "enabledconnections.h"
#include "enums.h"
#include "handler.h"
#include "networkmodel.h"
#include "networkstatus.h"

class NetworkManagerPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri)
    {
        // @uri Papyros.Network
        Q_ASSERT(uri == QStringLiteral("Papyros.Network"));

        qmlRegisterType<AppletProxyModel>(uri, 0, 1, "AppletProxyModel");
        qmlRegisterType<AvailableDevices>(uri, 0, 1, "AvailableDevices");
        qmlRegisterType<ConnectionIcon>(uri, 0, 1, "ConnectionIcon");
        qmlRegisterType<EnabledConnections>(uri, 0, 1, "EnabledConnections");
        qmlRegisterUncreatableType<Enums>(uri, 0, 1, "Enums",
                                          QStringLiteral("Can't instantiate Enums objects"));
        qmlRegisterType<Handler>(uri, 0, 1, "Handler");
        qmlRegisterType<NetworkModel>(uri, 0, 1, "NetworkModel");
        qmlRegisterType<NetworkStatus>(uri, 0, 1, "NetworkStatus");
    }
};

#include "plugin.moc"
