#ifndef DESKTOP_PLUGIN_H
#define DESKTOP_PLUGIN_H

#include <QQmlExtensionPlugin>
#include <qqml.h>

class DesktopPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // DESKTOP_PLUGIN_H
