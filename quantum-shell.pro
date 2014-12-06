LIBS += -L ../../lib

QT += quick qml
QT += compositor

SOURCES += main.cpp

OTHER_FILES = images/*.png \
	COPYING \
	README.md

RESOURCES += quantum-shell.qrc

target.path = /usr/bin
INSTALLS += target
