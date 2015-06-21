configure_file(
    papyros.desktop.in
    ${CMAKE_CURRENT_BINARY_DIR}/papyros.desktop
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/papyros.desktop
    DESTINATION ${CMAKE_INSTALL_DATADIR}/wayland-sessions)

install(FILES eglfs_kms.json DESTINATION ${DATA_INSTALL_DIR}/papyros-shell/eglfs)
