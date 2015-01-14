Papyros Shell
============

Papyros Shell is the desktop shell for Papyros, an operating system based upon Linux which conforms to Google’s Material Design guidelines. The focus will be on creating a stable and easy-to-use operating system with a heavy emphasis on well-thought-out design.

Brought to you by the [Papyros development team](https://github.com/papyros/papyros-shell/graphs/contributors).

### Implementation Details ###

The shell is built as a compositor for Wayland using the QtCompositor API and QtQuick. The goal is to develop a convergent shell that adapts to the form factor of the device it is running on, and to also support HIDPI screens.

QtCompositor requires a small C++ wrapper, but the majority of the shell will be implemented in QML and Javascript.

### Installation ###

Papyros Shell is a wayland compositor based on QtCompositor, and requires Wayland and Qt 5.4. In addition, will also need the [qml-material](https://github.com/papyros/qml-material) repo installed as a QML system module.

	$ git clone https://github.com/papyros/qml-material
	$ cd qml-material/
	$ qmake
	$ make
	# make install

As well as [qml-extras](https://github.com/papyros/qml-extras) that can be installed the same way as [qml-material](https://github.com/papyros/qml-material)

Once you have that set up, run the following commands to compile the C++ wrapper:

    $ qmake
    $ make

And run the compositor from an X11 desktop:

    $ ./papyros-shell -platform xcb

### Dependencies ###

 * Qt 5.4
 * QtWayland 5.4 with QtCompositor (a CONFIG option is required to enable QtCompositor as it is not compiled by default)
 * The [GSettings QML module](https://launchpad.net/gsettings-qt). This is developed for Ubuntu Touch, but is not Ubuntu-specific

If you're using Arch Linux, you can install the required dependencies using these packages from the [AUR](aur.archlinux.org):

 * qt5-base-git
 * qt5-declarative-git
 * qt5-wayland-dev-git
 * gsettings-qt-bzr

### Licensing ###

Papyros Shell is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
