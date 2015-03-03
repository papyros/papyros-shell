/*
* Papyros Shell - The desktop shell for Papyros following Material Design
* Copyright (C) 2014-2015 Michael Spencer
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/
#include "qmlcompositor.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QmlCompositor compositor;
    compositor.setTitle(QLatin1String("Papyros Shell"));
    compositor.show();

    compositor.rootContext()->setContextProperty("compositor", &compositor);

    QObject::connect(compositor.rootContext()->engine(), SIGNAL(quit()), &app, SLOT(quit()));

    return app.exec();
}
