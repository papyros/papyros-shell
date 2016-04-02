project(PapyrosShell)

cmake_minimum_required(VERSION 2.8.12)

option(ENABLE_MODEMMANAGER_SUPPORT "Enables ModemManager support" OFF)

# Set version
set(PROJECT_VERSION "0.1.0")
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_SOVERSION 0)

# Options
option(DEVELOPMENT_BUILD "Enable options for developers" OFF)
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
include(CheckIncludeFile)
include(CheckSymbolExists)

# Build flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden -Werror -Wall -Wextra -Wno-unused-parameter -pedantic -std=c++11")

add_definitions(-DQT_USE_FAST_CONCATENATION -DQT_USE_FAST_OPERATOR_PLUS)
remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_STRICT_ITERATORS -DQT_NO_CAST_FROM_BYTEARRAY)

# Check for prctl
check_include_file("sys/prctl.h" HAVE_SYS_PRCTL_H)
check_symbol_exists(PR_SET_DUMPABLE "sys/prctl.h" HAVE_PR_SET_DUMPABLE)
add_feature_info("prctl-dumpable" HAVE_PR_SET_DUMPABLE "Required to prevent ptrace on the compositor process")

# Minimum version requirements
set(QT_MIN_VERSION "5.4.0")
set(KF5_MIN_VERSION "5.8.0")

# Find pkg-config here so that it can be referenced soon
find_package(PkgConfig)

find_package(PAM REQUIRED)
find_package(GreenIsland 0.7.90 REQUIRED COMPONENTS Server)

# Find Qt5
find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
             Core
             DBus
             Xml
             Gui
             Widgets
             Qml
             Quick)

find_package(QT5XDG REQUIRED)

# Find KF5
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
             Solid Config Declarative NetworkManagerQt)

install(DIRECTORY sddm/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/sddm/themes/papyros
        PATTERN dummydata EXCLUDE)

add_subdirectory(3rdparty)
add_subdirectory(compositor)
add_subdirectory(data)
add_subdirectory(headers)
add_subdirectory(modules)

# Install the shell with development builds
if(DEVELOPMENT_BUILD)
    greenisland_install_shell(io.papyros.shell shell)
endif()

# Display featute summary
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
