##############################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
################################################################################

#TODO This module need test. Not sure it actually works.

function(Qt4_project)
set(ep Qt4)


## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep}_dependencies 
  ""
  )
  
  
## #############################################################################
## Prepare the project
## #############################################################################

EP_Initialisation(${ep}
  USE_SYSTEM ON 
  BUILD_SHARED_LIBS ON
  REQUIRED_FOR_PLUGIN OFF
  )


if (NOT USE_SYSTEM_${ep})
## #############################################################################
## Set directories
## #############################################################################

EP_SetDirectories(${ep}
  EP_DIRECTORIES ep_dirs
  ) 


## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${ep}_SOURCE_DIR)
    set(location
      URL "http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.4.tar.gz"
      URL_MD5 "89c5ecba180cae74c66260ac732dc5cb"
      )
endif()


## #############################################################################
## Define specific configuration command
## #############################################################################

set(ConfigCommand 
  CONFIGURE_COMMAND ${SOURCE_DIR}/configure
  )
  
set(ConfigCommonOptions 
  --prefix=${CMAKE_CURRENT_BINARY_DIR}/Qt4/install
  -confirm-license 
  -opensource 
  -optimized-qmake 
  -release 
  -largefile 
  -plugin-sql-mysql 
  -plugin-sql-odbc 
  -plugin-sql-psql 
  -plugin-sql-sqlite
)

IF (WIN32)
  set(ConfigCommand "${ConfigCommand}.exe")
  set(QtPlatformOptions)
else()
  set(QtPlatformOptions 
    -no-rpath 
    -reduce-relocations 
    -sm 
    -xinput 
    -xcursor 
    -xfixes 
    -xinerama 
    -xshape 
    -xrandr 
    -xrender
    -xkb 
    -glib 
    -openssl-linked 
    -xmlpatterns 
    -dbus-linked 
    -no-webkit
    )

  if (NOT APPLE)
      set(QtPlatformOptions 
        ${QtPlatformOptions} 
        -dbus-linked
        )
  endif()
endif()

set(ConfigCommand 
  ${ConfigCommand} 
  ${ConfigCommonOptions} 
  ${QtPlatformOptions}
  )


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep}
  ${ep_dirs}
  ${location}
  ${ConfigCommand}
  UPDATE_COMMAND ""
  )


## #############################################################################
## Add custom targets
## #############################################################################

EP_AddCustomTargets(${ep})


endif() #NOT USE_SYSTEM_ep


## #############################################################################
## Provide path of qmake executable for Asclepios and visages plugins 
## #############################################################################
  
  
  file(APPEND ${${PROJECT_NAME}_CONFIG_FILE}
    "set(QT_QMAKE_EXECUTABLE ${QT_QMAKE_EXECUTABLE})
    find_package(Qt REQUIRED)\n\n"
    )


#TODO it si mark as advanced because not really tested yet.
mark_as_advanced(USE_SYSTEM_${ep})
endfunction()
