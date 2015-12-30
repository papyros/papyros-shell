set(SOURCES main.cpp icons.qrc)

add_library(material SHARED ${SOURCES})
target_link_libraries(material
                      Qt5::Core
                      Qt5::WaylandClient)

install(TARGETS material
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/qt/plugins/wayland-decoration-client)

include_directories(
    ${Qt5WaylandClient_INCLUDE_DIRS}
    ${Qt5WaylandClient_PRIVATE_INCLUDE_DIRS}
)
