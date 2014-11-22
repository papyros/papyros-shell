Quartz Shell
============

Quartz Shell is the desktop shell for Quartz OS, an operating system based upon Linux which conforms to Google’s Material Design guidelines. The focus will be on creating a stable and easy-to-use operating system with a heavy emphasis on well-thought-out design.

Brought to you by the [Quartz OS development team](https://github.com/quartz-os/quartz-shell/graphs/contributors).

### Implementation Details ###

The shell is built as a compositor for Wayland using the QtCompositor API and QtQuick. The goal is to develop a convergent shell that adapts to the form factor of the device it is running on, and to also support HIDPI screens.

QtCompositor requires a small C++ wrapper, but the majority of the shell will be implemented in QML and Javascript.

### Installation ###

Quartz Shell is a wayland compositor based on QtCompositor, and requires Wayland and Qt 5.4. In addition, will also need the [qml-material](https://github.com/quartz-os/qml-material) repo installed as a QML module, like this:

    modules
      Material (renamed qml-material repo)
    quartz-shell
      quartz-shell.qml-project
      README.md
      ...

Once you have that set up, run the following commands to compile the C++ wrapper:

    qmake
    make

And run the compositor from an X11 desktop:

    ./quartz-shell -platform xcb

### Licensing ###

Quartz Shell is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
