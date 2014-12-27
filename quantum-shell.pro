QT += quick qml
QT += compositor dbus

SOURCES += src/main.cpp src/mpris.cpp

OTHER_FILES = images/*.png \
	COPYING \
	README.md

RESOURCES += quantum-shell.qrc

target.path = /usr/bin
INSTALLS += target
