QT += quick qml
QT += compositor

SOURCES += src/main.cpp \
	src/qmlcompositor.cpp

HEADERS += src/qmlcompositor.h

INCLUDEPATH = src

OTHER_FILES = README.md \ 
	COPYING

RESOURCES += src/papyros-shell.qrc

target.path = /usr/bin
INSTALLS += target

session.files = data/papyros-session
session.path = /usr/bin

desktop.files = data/papyros.desktop
desktop.path = /usr/share/wayland-sessions

INSTALLS += session desktop
