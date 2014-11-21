Quartz Shell
============

Quartz Shell is the desktop shell for Quartz OS, an operating system based upon Linux which conforms to Google’s Material Design guidelines. The focus will be on creating a stable and easy-to-use operating system with a heavy emphasis on well-thought-out design.

Brought to you by the [Quartz OS development team](https://github.com/quartz-os/quartz-shell/graphs/contributors).

### Implementation Details ###

The shell is built as a compositor for Wayland using the QtCompositor API and QtQuick. The goal is to develop a convergent shell that adapts to the form factor of the device it is running on, and to also support HIDPI screens.

QtCompositor requires a small C++ wrapper, but the majority of the shell will be implemented in QML and Javascript.

### Installation ###

The plan is for Quartz Shell to be a wayland compositor, which will require Wayland and Qt 5.4. However, while in the experimental/mockups stage, it is just an ordinary QML app for simplicity. So, just open the `quartz-shell.qmlproject` in Qt Creator, and run it! You will also need the [qml-material](https://github.com/quartz-os/qml-material) repo installed as a QML module, like this:

    modules
      Material (renamed qml-material repo)
    quartz-shell
      quartz-shell.qml-project
      README.md
      ...

### Licensing ###

Quartz Shell is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
