PROJECT(papyros-shell)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(CMAKE_AUTOMOC ON)

FIND_PACKAGE(Qt5Quick REQUIRED)
FIND_PACKAGE(Qt5Compositor REQUIRED)

INCLUDE_DIRECTORIES(${Qt5Quick_INCLUDE_DIRS})
ADD_DEFINITIONS(${Qt5Quick_DEFINITIONS})
INCLUDE_DIRECTORIES(${Qt5Compositor_INCLUDE_DIRS})
ADD_DEFINITIONS(${Qt5Compositor_DEFINITIONS})

SET(SHELL_SRCS
    ${CMAKE_SOURCE_DIR}/src/cpp/main.cpp
    ${CMAKE_SOURCE_DIR}/src/cpp/qmlcompositor.cpp
    ${CMAKE_SOURCE_DIR}/src/cpp/qmlcompositor.h
)

ADD_EXECTUTABLE(papyros-shell ${SHELL_SRCS})
TARGET_LINK_LIBRARIES(papyros-shell Qt5::Quick)
TARGET_LINK_LIBRARIES(papyros-shell Qt5::Compositor)

INSTALL(TARGETS papyros-shell DESTINATION /usr/bin)
INSTALL(FILES ${CMAKE_SOURCE_DIR}/data/papyros-session DESTINATION /usr/bin)
INSTALL(FILES ${CMAKE_SOURCE_DIR}/data/papyros.desktop DESTINATION /usr/share/wayland-sessions)
INSTALL(DIRECTORY ${CMAKE_SOURCE_DIR}/src/qml DESTINATION /usr/share/papyros-shell)
INSTALL(DIRECTORY ${CMAKE_SOURCE_DIR}/src/images DESTINATION /usr/share/papyros-shell)
INSTALL(DIRECTORY ${CMAKE_SOURCE_DIR}/src/js DESTINATION /usr/share/papyros-shell)
