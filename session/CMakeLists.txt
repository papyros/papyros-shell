include_directories(
    ${CMAKE_SOURCE_DIR}/3rdparty
    ${CMAKE_SOURCE_DIR}/headers
    ${CMAKE_BINARY_DIR}/headers
)

set(SOURCES
    main.cpp
    compositorlauncher.h
    compositorlauncher.cpp
    loginmanager.h
    loginmanager.cpp
    sessionadaptor.h
    sessionadaptor.cpp
    sessionmanager.h
    sessionmanager.cpp
)

add_executable(papyros-session ${SOURCES})
target_link_libraries(papyros-session
    Qt5::Core
    Qt5::DBus
    PapyrosSigWatch
    ${QTXDG_LIBRARIES}
)

install(TARGETS papyros-session DESTINATION ${BIN_INSTALL_DIR})
