# - Try to find mobile-broadband-provider-info
# Once done this will define
#
#  MOBILEBROADBANDPROVIDERINFO_FOUND - system has mobile-broadband-provider-info
#  MOBILEBROADBANDPROVIDERINFO_CFLAGS - the mobile-broadband-provider-info directory

# Copyright (c) 2011, Lamarque Souza <lamarque@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF (MOBILEBROADBANDPROVIDERINFO_CFLAGS)
   # in cache already
   SET(MobileBroadbandProviderInfo_FIND_QUIETLY TRUE)
ENDIF (MOBILEBROADBANDPROVIDERINFO_CFLAGS)

IF (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   find_package(PkgConfig)
   PKG_SEARCH_MODULE( MOBILEBROADBANDPROVIDERINFO mobile-broadband-provider-info )
ENDIF (NOT WIN32)

IF (MOBILEBROADBANDPROVIDERINFO_FOUND)
   IF (NOT MobileBroadbandProviderInfo_FIND_QUIETLY)
       MESSAGE(STATUS "Found mobile-broadband-provider-info ${MOBILEBROADBANDPROVIDERINFO_VERSION}: ${MOBILEBROADBANDPROVIDERINFO_CFLAGS}")
   ENDIF (NOT MobileBroadbandProviderInfo_FIND_QUIETLY)
ELSE (MOBILEBROADBANDPROVIDERINFO_FOUND)
   IF (MobileBroadbandProviderInfo_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could NOT find mobile-broadband-provider-info, check FindPkgConfig output above!")
   ENDIF (MobileBroadbandProviderInfo_FIND_REQUIRED)
ENDIF (MOBILEBROADBANDPROVIDERINFO_FOUND)

MARK_AS_ADVANCED(MOBILEBROADBANDPROVIDERINFO_CFLAGS)

