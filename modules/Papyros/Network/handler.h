/*
    Copyright 2013-2014 Jan Grulich <jgrulich@redhat.com>
    Copyright 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef HAWAII_NM_HANDLER_H
#define HAWAII_NM_HANDLER_H

#include <QDBusInterface>

#include <NetworkManagerQt/Connection>
#if WITH_MODEMMANAGER_SUPPORT
#include <ModemManagerQt/GenericTypes>
#endif

#include <config.h>


class Q_DECL_EXPORT Handler : public QObject
{
Q_OBJECT

public:
    enum HandlerAction {
        ActivateConnection,
        AddAndActivateConnection,
        AddConnection,
        DeactivateConnection,
        RemoveConnection,
        RequestScan,
        UpdateConnection
    };

    explicit Handler(QObject* parent = 0);
    virtual ~Handler();

public Q_SLOTS:
    /**
     * Activates given connection
     * @connection - d-bus path of the connection you want to activate
     * @device - d-bus path of the device where the connection should be activated
     * @specificParameter - d-bus path of the specific object you want to use for this activation, i.e access point
     */
    void activateConnection(const QString &connection, const QString &device, const QString &specificParameter);
    /**
     * Adds and activates a new wireless connection
     * @device - d-bus path of the wireless device where the connection should be activated
     * @specificParameter - d-bus path of the accesspoint you want to connect to
     * @password - pre-filled password which should be used for the new wireless connection
     * @autoConnect - boolean value whether this connection should be activated automatically when it's available
     *
     * Works automatically for wireless connections with WEP/WPA security, for wireless connections with WPA/WPA
     * it will open the connection editor for advanced configuration.
     * */
    void addAndActivateConnection(const QString &device, const QString &specificParameter, const QString &password = QString());
    /**
     * Adds a new connection
     * @map - NMVariantMapMap with connection settings
     */
    void addConnection(const NMVariantMapMap &map);
    /**
     * Deactivates given connection
     * @connection - d-bus path of the connection you want to deactivate
     * @device - d-bus path of the connection where the connection is activated
     */
    void deactivateConnection(const QString &connection, const QString &device);
    /**
     * Disconnects all connections
     */
    void disconnectAll();
    void enableAirplaneMode(bool enable);
    void enableBt(bool enable);
    void enableNetworking(bool enable);
    void enableWireless(bool enable);
    void enableWimax(bool enable);
    void enableWwan(bool enable);

//     /**
//      * Opens connection editor for given connection
//      * @uuid - uuid of the connection you want to edit
//      */
//     void editConnection(const QString & uuid);
    /**
     * Removes given connection
     * @connection - d-bus path of the connection you want to edit
     */
    void removeConnection(const QString & connection);
    /**
     * Updates given connection
     * @connection - connection which should be updated
     * @map - NMVariantMapMap with new connection settings
     */
    void updateConnection(const NetworkManager::Connection::Ptr &connection, const NMVariantMapMap &map);
    void openEditor();
    void requestScan();

private Q_SLOTS:
    void initKdedModule();
    void replyFinished(QDBusPendingCallWatcher * watcher);
#if WITH_MODEMMANAGER_SUPPORT
    void unlockRequiredChanged(MMModemLock modemLock);
#endif

private:
    bool m_tmpBluetoothEnabled;
    bool m_tmpWimaxEnabled;
    bool m_tmpWirelessEnabled;
    bool m_tmpWwanEnabled;
#if WITH_MODEMMANAGER_SUPPORT
    QString m_tmpConnectionPath;
#endif
    QString m_tmpConnectionUuid;
    QString m_tmpDevicePath;
    QString m_tmpSpecificPath;

    bool isBtEnabled();
#if 0
    QDBusInterface m_agentIface;
#endif
};

#endif // HAWAII_NM_HANDLER_H
