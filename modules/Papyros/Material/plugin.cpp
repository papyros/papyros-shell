#include "plugin.h"

#include "windowdecorations.h"

void MaterialPlugin::registerTypes(const char *uri)
{
    // @uri Papyros.Material
    Q_ASSERT(uri == QStringLiteral("Papyros.Material"));

    qmlRegisterType<WindowDecorations>(uri, 0, 1, "WindowDecorations");
}
