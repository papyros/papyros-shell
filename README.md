Papyros Shell
============

[![Join the chat at https://gitter.im/papyros/papyros](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/papyros/papyros?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![ZenHub.io](https://img.shields.io/badge/supercharged%20by-zenhub.io-blue.svg)](https://zenhub.io)
[![GitHub release](https://img.shields.io/github/release/papyros/papyros-shell.svg)](https://github.com/papyros/papyros-shell)
[![GitHub issues](https://img.shields.io/github/issues/papyros/papyros-shell.svg)](https://github.com/papyros/papyros-shell/issues)
[![Bountysource](https://img.shields.io/bountysource/team/papyros/activity.svg)](https://www.bountysource.com/teams/papyros)

Papyros Shell is the desktop shell for Papyros, an operating system based upon Linux which conforms to Google’s Material Design guidelines. The focus will be on creating a stable and easy-to-use operating system with a heavy emphasis on well-thought-out design.

Brought to you by the [Papyros development team](https://github.com/papyros/papyros-shell/graphs/contributors).

### Implementation Details ###

The shell is built as a compositor for Wayland using the Green Island compositor framework and QtQuick. The goal is to develop a convergent shell that adapts to the form factor of the device it is running on, and to also support HIDPI screens.

Green Island provides the C++ code necessary to interact with Wayland, and QML Desktop provides C++ plugins for QML for the desktop indicators, so the majority of the shell is implemented in QML and Javascript.

Special thanks to Hawaii shell and its author Pier Luigi Fiorini for some of the QML backend plugins, including the hardware plugin and the original code for the app launcher model.

### Dependencies ###

 * Qt 5.5
 * Wayland
 * [GreenIsland](https://github.com/greenisland/greenisland)
   * Requires an in-development branch ([feature/window_manager](https://github.com/papyros/greenisland/tree/feature/window_manager)). This is branch is currently awaiting upstream review.
 * A Green Island development version of QtCompositor, as described on the Green Island GitHub page.
 * [QML Material](https://github.com/papyros/qml-material) (the `develop` branch).
 users).
 * [QT5XDG](https://github.com/lxde/libqtxdg) for desktop file parsing
 * PAM for authentication
 * Several KDE Frameworks
   * [KConfig](http://api.kde.org/frameworks-api/frameworks5-apidocs/kconfig/html/)
   * [KDeclarative](http://api.kde.org/frameworks-api/frameworks5-apidocs/kdeclarative/html/)
   * [Solid](http://api.kde.org/frameworks-api/frameworks5-apidocs/solid/html/)
   * [NetworkManagerQt](http://api.kde.org/frameworks-api/frameworks5-apidocs/networkmanager-qt/html/)
   * [ModemManagerQt](http://api.kde.org/frameworks-api/frameworks5-apidocs/modemmanager-qt/html/) (optional)
 * ALSA or PulseAudio for the sound indicator

### Installation ###

Once the necessary dependencies are installed, you can build and install the Papyros shell as follows:

    mkdir build; cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DQML_INSTALL_DIR=lib/qt/qml
    make && sudo make install

### Running the shell ###

To run the shell as a window on your desktop, you need to create a fake screen configuration similar to this one for a MacBook Pro:

```json
{
    "outputs": [
        {
            "mode": {
                "refreshRate": 60000,
                "size": {
                    "height": 736,
                    "width": 1285
                }
            },
            "name": "Fake1",
            "orientation": 2,
            "position": {
                "x": 0,
                "y": 0
            }
        }
    ]
}
```

You will need to tweak the width and height to match your screen, taking into account the window decoration of the shell window and any system panels in your desktop environment. Save this file somewhere, for example, `~/.config/fake-screen.json`.

You can then test the shell by running it in a new window on top of your desktop:

    greenisland --fake-screen ~/.config/fake-screen.json --shell io.papyros.shell

To run the shell from a virtual terminal as a full Wayland compositor:

    greenisland --platform eglfs --shell io.papyros.shell

### Using the SDDM theme ###

The SDDM theme for Papyros is installed along with the shell. To set it as the current theme, edit the `/etc/sddm.conf` file and edit the `Current` key under the `[Theme]` group to match:

    [Theme]
    # Current theme name
    Current=papyros

Now restart your computer and enjoy the new theme!

### Licensing ###

Papyros Shell is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
