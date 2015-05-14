#ifndef DESKTOP_PLUGIN_H
#define DESKTOP_PLUGIN_H

#include <QQmlExtensionPlugin>
#include <qqml.h>

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

#include "loginhelper/loginhelper.h"

class DesktopPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // DESKTOP_PLUGIN_H
