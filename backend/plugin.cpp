#include "plugin.h"

#include "mpris/mprisconnection.h"
#include "mpris/mpris2player.h"

#include "notifications/notification.h"
#include "notifications/notificationserver.h"

#include "upower/upowerconnection.h"
#include "upower/upowerdevicetype.h"
#include "upower/upowerdevicestate.h"
#include "upower/upowerdevice.h"

#include "mixer/sound.h"

#include "keyeventfilter/keyeventfilter.h"

#include "desktop/desktopfile.h"
#include "desktop/desktopscrobbler.h"

#include "processhelper/processhelper.h"

#include "hardware/hardwareengine.h"

#include "launcher/application.h"
#include "launcher/launchermodel.h"

#include "session/sessionmanager.h"

void DesktopPlugin::registerTypes(const char *uri)
{
    // @uri Papyros.Desktop
    Q_ASSERT(uri == QStringLiteral("Papyros.Desktop"));

    qmlRegisterType<MprisConnection>(uri, 0, 1, "MprisConnection");
    qmlRegisterUncreatableType<Mpris2Player>(uri, 0, 1, "Mpris2Player", "Player class");

    qmlRegisterType<NotificationServer>(uri, 0, 1, "NotificationServer");
    qmlRegisterUncreatableType<Notification>(uri, 0, 1, "Notification", "A notification from NotificationServer");

    qmlRegisterType<UPowerConnection>(uri, 0, 1, "UPowerConnection");
    qmlRegisterUncreatableType<UPowerDevice>(uri, 0, 1, "UPowerDevice", "A device reported by UPower");
    qmlRegisterUncreatableType<UPowerDeviceType>(uri, 0, 1, "UPowerDeviceType", "Enum class for UPower device type");
    qmlRegisterUncreatableType<UPowerDeviceState>(uri, 0, 1, "UPowerDeviceState", "Enum class for UPower device state");

    qmlRegisterType<Sound>(uri, 0, 1, "Sound");

    qmlRegisterType<KeyEventFilter>(uri, 0, 1, "KeyEventFilter");

    qmlRegisterType<DesktopFile>(uri, 0, 1, "DesktopFile");
    qmlRegisterType<DesktopScrobbler>(uri, 0, 1, "DesktopScrobbler");
    qmlRegisterType<LauncherModel>(uri, 0, 1, "LauncherModel");
    qmlRegisterUncreatableType<Application>(uri, 0, 1, "Application", "Applications are managed by the launcher model");
    qmlRegisterUncreatableType<QObjectListModel>(uri, 0, 1, "QObjectListModel", "For cool animations");

    qmlRegisterSingletonType<ProcessHelper>(uri, 0, 1, "ProcessHelper", ProcessHelper::process_helper);

    // Hardware (battery and storage)

    qmlRegisterType<HardwareEngine>(uri, 0, 1, "HardwareEngine");
    qmlRegisterUncreatableType<Battery>(uri, 0, 1, "Battery",
            QStringLiteral("Cannot create Battery object"));
    qmlRegisterUncreatableType<StorageDevice>(uri, 0, 1, "StorageDevice",
            QStringLiteral("Cannot create StorageDevice object"));

    // Session management

    qmlRegisterSingletonType<SessionManager>(uri, 0, 1, "SessionManager",
            SessionManager::qmlSingleton);
}
