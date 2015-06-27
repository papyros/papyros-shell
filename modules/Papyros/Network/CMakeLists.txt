find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Network)

find_package(KF5ModemManagerQt 5.9.0)
set_package_properties(KF5ModemManagerQt PROPERTIES
                       TYPE OPTIONAL)

find_package(NetworkManager 0.9.8.4)
set_package_properties(NetworkManager PROPERTIES
                       TYPE REQUIRED)

find_package(ModemManager 1.0.0)
set_package_properties(ModemManager PROPERTIES
                       TYPE OPTIONAL)

find_package(MobileBroadbandProviderInfo)
set_package_properties(MobileBroadbandProviderInfo PROPERTIES
                       DESCRIPTION "Database of mobile broadband service providers"
                       URL "http://live.gnome.org/NetworkManager/MobileBroadband/ServiceProviders"
                       TYPE OPTIONAL)

if(NOT ENABLE_MODEMMANAGER_SUPPORT)
    message(STATUS "Disabling ModemManager support")
    set(WITH_MODEMMANAGER_SUPPORT 0)
else()
    if(KF5ModemManagerQt_FOUND)
        message(STATUS "Enabling ModemManager support")
        set(WITH_MODEMMANAGER_SUPPORT 1)
    else()
        message(STATUS "ModemManager or ModemManagerQt not found")
        set(WITH_MODEMMANAGER_SUPPORT 0)
    endif()
endif()

add_definitions(-DWITH_MODEMMANAGER_SUPPORT=${WITH_MODEMMANAGER_SUPPORT})

include_directories(
    ${CMAKE_BINARY_DIR}/headers
)

add_definitions(-DQT_NO_KEYWORDS)

set(SOURCES
    appletproxymodel.cpp
    availabledevices.cpp
    connectionicon.cpp
    debug.cpp
    enabledconnections.cpp
    enums.cpp
    handler.cpp
    networkitemslist.cpp
    networkmodel.cpp
    networkmodelitem.cpp
    networkstatus.cpp
    plugin.cpp
    uiutils.cpp
)

add_library(nmplugin SHARED ${SOURCES})
target_link_libraries(nmplugin
                      Qt5::Core
                      Qt5::DBus
                      Qt5::Network
                      Qt5::Gui
                      Qt5::Qml
                      Qt5::Quick
                      KF5::NetworkManagerQt)
if(WITH_MODEMMANAGER_SUPPORT)
    target_link_libraries(nmplugin KF5::ModemManagerQt)
endif()

install(FILES qmldir
        DESTINATION ${QML_INSTALL_DIR}/Papyros/Network)
install(TARGETS nmplugin
        DESTINATION ${QML_INSTALL_DIR}/Papyros/Network)
