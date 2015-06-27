# - Try to find NetworkManager
# Once done this will define
#
#  NETWORKMANAGER_FOUND - system has NetworkManager
#  NETWORKMANAGER_INCLUDE_DIRS - the NetworkManager include directories
#  NETWORKMANAGER_LIBRARIES - the libraries needed to use NetworkManager
#  NETWORKMANAGER_CFLAGS - Compiler switches required for using NetworkManager
#  NETWORKMANAGER_VERSION - version number of NetworkManager

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Will Stephenson, <wstephenson@kde.org>
# Copyright (c) 2015, Jan Grulich, <jgrulich@redhat.com>

# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF (NETWORKMANAGER_INCLUDE_DIRS AND NM-CORE_INCLUDE_DIRS)
    # in cache already
    SET(NetworkManager_FIND_QUIETLY TRUE)
ENDIF (NETWORKMANAGER_INCLUDE_DIRS AND NM-CORE_INCLUDE_DIRS)

IF (NOT WIN32)
    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    find_package(PkgConfig)
    PKG_SEARCH_MODULE( NETWORKMANAGER NetworkManager )

    IF (NETWORKMANAGER_FOUND)
        IF (NetworkManager_FIND_VERSION AND ("${NETWORKMANAGER_VERSION}" VERSION_LESS "${NetworkManager_FIND_VERSION}"))
            MESSAGE(FATAL_ERROR "NetworkManager ${NETWORKMANAGER_VERSION} is too old, need at least ${NetworkManager_FIND_VERSION}")
        ELSE ()
            # Since NetworkManager 1.0.0 we need to find different libraries
            IF (NetworkManager_FIND_VERSION AND ("${NETWORKMANAGER_VERSION}" VERSION_GREATER "1.0.0" OR "${NETWORKMANAGER_VERSION}" VERSION_EQUAL "1.0.0"))
                PKG_SEARCH_MODULE( NM-CORE libnm )
                IF (NM-CORE_FOUND)
                    IF (NOT NetworkManager_FIND_QUIETLY)
                        MESSAGE(STATUS "Found libnm-core: ${NM-CORE_LIBRARY_DIRS}")
                    ENDIF ()
                ELSE ()
                    MESSAGE(FATAL_ERROR "Could NOT find libnm-core, check FindPkgConfig output above!")
                ENDIF ()
            ENDIF ()
        ENDIF ()
    ELSE ()
        MESSAGE(FATAL_ERROR "Could NOT find NetworkManager, check FindPkgConfig output above!")
    ENDIF ()
ENDIF (NOT WIN32)

MARK_AS_ADVANCED(NETWORKMANAGER_INCLUDE_DIRS NM-UTIL_INCLUDE_DIRS NM-GLIB_INCLUDE_DIRS NM-CORE_INCLUDE_DIRS)

