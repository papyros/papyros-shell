project(PapyrosShell)

cmake_minimum_required(VERSION 2.8.12)

# Set version
set(PROJECT_VERSION "0.1.0")
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_SOVERSION 0)

# Options
option(ENABLE_ALSA "Enables Alsa mixer backend" ON)
option(ENABLE_PULSEAUDIO "Enables PulseAudio mixer backend" ON)

# ECM setup
find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} "${CMAKE_SOURCE_DIR}/cmake")

# Macros
include(FeatureSummary)
include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)

# Find pkg-config here so that it can be referenced soon
find_package(PkgConfig)

find_package(GreenIsland 0.5.9 REQUIRED)

# Find Qt5
find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
             Core
             DBus
             Xml
             Gui
             Widgets
             Qml
             Quick)

greenisland_install_shell(io.papyros.shell shell)

add_subdirectory(backend)

# Display featute summary
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
