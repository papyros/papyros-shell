QT += quick qml
QT += compositor

SOURCES += src/main.cpp

OTHER_FILES = images/*.png \
	COPYING \
	README.md

RESOURCES += papyros-shell.qrc

target.path = /usr/bin
INSTALLS += target

session.files = papyros-session
session.path = /usr/bin

desktop.files = papyros.desktop
desktop.path = /usr/share/wayland-sessions

INSTALLS += session desktop
