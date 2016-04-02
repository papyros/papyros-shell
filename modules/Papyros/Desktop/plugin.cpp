#include "plugin.h"

#include "config/kquickconfig.h"

#include "mpris/mprisconnection.h"
#include "mpris/mpris2player.h"

#include "notifications/notification.h"
#include "notifications/notificationserver.h"

#include "mixer/sound.h"

#include "keyeventfilter/keyeventfilter.h"

#include "desktop/desktopfile.h"
#include "desktop/desktopfiles.h"

#include "hardware/hardwareengine.h"

#include "launcher/application.h"
#include "launcher/launchermodel.h"

#include "session/sessionmanager.h"

void DesktopPlugin::registerTypes(const char *uri)
{
    // @uri Papyros.Desktop
    Q_ASSERT(uri == QStringLiteral("Papyros.Desktop"));

    qmlRegisterType<KQuickConfig>(uri, 0, 1, "KQuickConfig");

    qmlRegisterType<MprisConnection>(uri, 0, 1, "MprisConnection");
    qmlRegisterUncreatableType<Mpris2Player>(uri, 0, 1, "Mpris2Player", "Player class");

    qmlRegisterType<NotificationServer>(uri, 0, 1, "NotificationServer");
    qmlRegisterUncreatableType<Notification>(uri, 0, 1, "Notification", "A notification from NotificationServer");

    qmlRegisterType<Sound>(uri, 0, 1, "Sound");

    qmlRegisterType<KeyEventFilter>(uri, 0, 1, "KeyEventFilter");

    qmlRegisterType<DesktopFile>(uri, 0, 1, "DesktopFile");
    qmlRegisterSingletonType<DesktopFiles>(uri, 0, 1, "DesktopFiles",
            DesktopFiles::qmlSingleton);
    qmlRegisterUncreatableType<Application>(uri, 0, 1, "Application", "Applications are managed by the launcher model");
    qmlRegisterUncreatableType<QObjectListModel>(uri, 0, 1, "QObjectListModel", "For cool animations");


    qmlRegisterType<LauncherModel>(uri, 0, 1, "LauncherModel");

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
