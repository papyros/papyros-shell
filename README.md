Papyros Shell
============

[![GitHub release](https://img.shields.io/github/release/papyros/papyros-shell.svg)](https://github.com/papyros/papyros-shell)
[![GitHub issues](https://img.shields.io/github/issues/papyros/papyros-shell.svg)](https://github.com/papyros/papyros-shell/issues)
[![Bountysource](https://img.shields.io/bountysource/team/papyros/activity.svg)](https://www.bountysource.com/teams/papyros)

Papyros Shell is the desktop shell for Papyros, an operating system based upon Linux which conforms to Google’s Material Design guidelines. The focus will be on creating a stable and easy-to-use operating system with a heavy emphasis on well-thought-out design.

Brought to you by the [Papyros development team](https://github.com/papyros/papyros-shell/graphs/contributors).

### Implementation Details ###

The shell is built as a compositor for Wayland using the Green Island compositor framework and QtQuick. The goal is to develop a convergent shell that adapts to the form factor of the device it is running on, and to also support HIDPI screens.

Green Island provides the C++ code necessary to interact with Wayland, and QML Desktop provides C++ plugins for QML for the desktop indicators, so the majority of the shell is implemented in QML and Javascript.

### Dependencies ###

 * Qt 5.5
 * Wayland
 * [GreenIsland](https://github.com/greenisland/greenisland)
   * Requires an in-development branch ([feature/window_manager](https://github.com/papyros/greenisland/tree/feature/window_manager). This is branch is currently awaiting upstream review.
 * A Green Island development version of QtCompositor, as described on the Green Island GitHub page.
 * [QML Extras](https://github.com/papyros/qml-extras) (the `develop` branch).
 * [QML Material](https://github.com/papyros/qml-material) (the `develop` branch).
 * [GSettings QML module](https://launchpad.net/gsettings-qt) (AUR package available for Arch Linux users).
 * Several KDE Frameworks
   * [KDeclarative](api.kde.org/frameworks-api/frameworks5-apidocs/kdeclarative/html/)
   * [Solid](api.kde.org/frameworks-api/frameworks5-apidocs/solid/html/)
 * ALSA or PulseAudio for the sound indicator

### Installation ###

Once the necessary dependencies are installed, you can build and install the Papyros shell as follows:

    mkdir build; cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DQML_INSTALL_DIR=lib/qt/qml
    make && sudo make install

And run the compositor from an X11 desktop:

    greenisland --shell io.papyros.shell

Or as from a virtual terminal as a full Wayland compositor:

    greenisland --platform eglfs --shell io.papyros.shell

### Licensing ###

Papyros Shell is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
