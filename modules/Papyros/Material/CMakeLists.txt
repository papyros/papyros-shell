file(GLOB_RECURSE SOURCES *.cpp *.h)
file(GLOB_RECURSE QML_FILES *.qml)

link_directories(${CMAKE_INSTALL_PREFIX}/lib/qt/plugins/wayland-decoration-client)
add_library(papyrosmaterial SHARED ${SOURCES})
target_link_libraries(papyrosmaterial
                      Qt5::Core
                      Qt5::Qml
                      Qt5::Quick
                      Qt5::WaylandClient
                      Papyros::MaterialDecorations)

include_directories(
    ${Qt5WaylandClient_INCLUDE_DIRS}
    ${Qt5WaylandClient_PRIVATE_INCLUDE_DIRS}
)

install(FILES qmldir ${QML_FILES}
    DESTINATION ${QML_INSTALL_DIR}/Papyros/Material)
install(TARGETS papyrosmaterial
    DESTINATION ${QML_INSTALL_DIR}/Papyros/Material)
