QT += quick qml
QT += compositor

SOURCES += src/main.cpp

OTHER_FILES = images/*.png \
	COPYING \
	README.md

RESOURCES += quantum-shell.qrc

target.path = /usr/bin
INSTALLS += target
