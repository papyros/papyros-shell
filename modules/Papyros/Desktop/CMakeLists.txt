file(GLOB_RECURSE SOURCES *.cpp *.h)
file(GLOB_RECURSE QML_FILES *.qml)

configure_file(qml/ShellSettings.qml.in ShellSettings.qml)

if(ENABLE_ALSA)
    find_package(ALSA)

    if(NOT ALSA_FOUND)
        message(WARNING "Alsa was not found!")
    endif()
endif()
if(ENABLE_PULSEAUDIO)
    pkg_check_modules(PulseAudio libpulse)
    pkg_check_modules(PulseAudioGLib libpulse-mainloop-glib)

    if(NOT PulseAudio_FOUND)
        message(WARNING "PulseAudio was not found!")
    endif()
endif()

if(!PulseAudio_FOUND)
    list(REMOVE_ITEM SOURCES mixer/pulseaudiomixer.cpp)
endif()

if(!ALSA_FOUND)
    list(REMOVE_ITEM SOURCES mixer/alsamixer.cpp)
endif()

add_library(papyrosdesktop SHARED ${SOURCES})
target_link_libraries(papyrosdesktop
                      Qt5::Core
                      Qt5::Qml
                      Qt5::DBus
                      Qt5::Quick
                      Qt5::WaylandClient
                      KF5::Solid
                      KF5::ConfigCore
                      Papyros::Core
                      GreenIsland::Server
                      Qt5Xdg
                      ${PAM_LIBRARIES})

include_directories(
    ${Qt5WaylandClient_INCLUDE_DIRS}
    ${Qt5WaylandClient_PRIVATE_INCLUDE_DIRS}
)

if(ALSA_FOUND)
    include_directories(${ALSA_INCLUDE_DIRS})
    add_definitions(-DHAVE_ALSA)
    target_link_libraries(papyrosdesktop ${ALSA_LIBRARIES})
endif()

if(PulseAudio_FOUND)
    include_directories(${PulseAudioGLib_INCLUDE_DIRS})
    add_definitions(-DHAVE_PULSEAUDIO)
    target_link_libraries(papyrosdesktop ${PulseAudio_LIBRARIES} ${PulseAudioGLib_LIBRARIES})
endif()

install(FILES qmldir ${QML_FILES} ${CMAKE_CURRENT_BINARY_DIR}/ShellSettings.qml
    DESTINATION ${QML_INSTALL_DIR}/Papyros/Desktop)
install(TARGETS papyrosdesktop
    DESTINATION ${QML_INSTALL_DIR}/Papyros/Desktop)
