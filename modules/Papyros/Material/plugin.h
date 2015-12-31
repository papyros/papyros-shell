#ifndef MATERIAL_PLUGIN_H
#define MATERIAL_PLUGIN_H

#include <QQmlExtensionPlugin>
#include <qqml.h>

class MaterialPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // MATERIAL_PLUGIN_H
