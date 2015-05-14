#include "qmldesktop_plugin.h"

void DesktopPlugin::registerTypes(const char *uri)
{
    // @uri Material.Desktop
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
    qmlRegisterUncreatableType<QObjectListModel>(uri, 0, 1, "QObjectListModel", "For cool animations");
    
    qmlRegisterSingletonType<ProcessHelper>(uri, 0, 1, "ProcessHelper", ProcessHelper::process_helper);

    qmlRegisterSingletonType<LoginHelper>(uri, 0, 1, "LoginHelper", LoginHelper::login_helper);
}
