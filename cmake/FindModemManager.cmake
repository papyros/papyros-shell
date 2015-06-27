# - Try to find ModemManager
# Once done this will define
#
#  MODEMMANAGER_FOUND - system has ModemManager
#  MODEMMANAGER_INCLUDE_DIRS - the ModemManager include directories
#  MODEMMANAGER_LIBRARIES - the libraries needed to use ModemManager
#  MODEMMANAGER_CFLAGS - Compiler switches required for using ModemManager
#  MODEMMANAGER_VERSION - version number of ModemManager

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Will Stephenson, <wstephenson@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF (MODEMMANAGER_INCLUDE_DIRS)
   # in cache already
   SET(ModemManager_FIND_QUIETLY TRUE)
ENDIF (MODEMMANAGER_INCLUDE_DIRS)

IF (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   find_package(PkgConfig)
   PKG_SEARCH_MODULE( MODEMMANAGER ModemManager )
ENDIF (NOT WIN32)

IF (MODEMMANAGER_FOUND)
   IF (ModemManager_FIND_VERSION AND ("${MODEMMANAGER_VERSION}" VERSION_LESS "${ModemManager_FIND_VERSION}"))
      MESSAGE(FATAL_ERROR "ModemManager ${MODEMMANAGER_VERSION} is too old, need at least ${ModemManager_FIND_VERSION}")
   ELSEIF (NOT ModemManager_FIND_QUIETLY)
      MESSAGE(STATUS "Found ModemManager ${MODEMMANAGER_VERSION}: ${MODEMMANAGER_LIBRARY_DIRS}")
   ENDIF()
ELSE (MODEMMANAGER_FOUND)
   IF (ModemManager_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could NOT find ModemManager, check FindPkgConfig output above!")
   ENDIF (ModemManager_FIND_REQUIRED)
ENDIF (MODEMMANAGER_FOUND)

MARK_AS_ADVANCED(MODEMMANAGER_INCLUDE_DIRS NM-UTIL_INCLUDE_DIRS)

