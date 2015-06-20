file(GLOB_RECURSE QML_FILES *.qml)

install(FILES qmldir ${QML_FILES} DESTINATION ${QML_INSTALL_DIR}/Papyros/Components)
