# Create the cmakedirs.h header file
configure_file(cmakedirs.h.in ${CMAKE_CURRENT_BINARY_DIR}/cmakedirs.h)

# Create the config.h header file
configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)
