file(GLOB_RECURSE SOURCES *.cpp *.h)

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
                      KF5::Solid
                      KF5::ConfigCore
                      GreenIsland::GreenIsland
                      ${QTXDG_LIBRARIES})

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

install(FILES qmldir
    DESTINATION ${QML_INSTALL_DIR}/Papyros/Desktop)
install(TARGETS papyrosdesktop
    DESTINATION ${QML_INSTALL_DIR}/Papyros/Desktop)