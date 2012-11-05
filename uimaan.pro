# Add more folders to ship with the application, here
folder_01.source = qml/uimaan
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

QT += core network

# Dev UID
symbian:TARGET.UID3 = 0xE160B555

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices Location

symbian: DEPLOYMENT.display_name = Uimaan

symbian {
    VERSION = 1.0.0

    my_deployment.pkg_prerules += vendorinfo

    my_deployment.pkg_prerules += \
        "; Dependency to Symbian Qt Quick components" \
        "(0x200346de), 1, 1, 0 , {\"Qt Quick components for Symbian\"}"

    DEPLOYMENT += my_deployment

    vendorinfo += "%{\"11latoa\"}" ":\"11latoa\""
}

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
CONFIG += mobility
MOBILITY += location

# Add dependency to symbian components
CONFIG += qtquickcomponents

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    temperature.cpp \
    spot.cpp \
    spotmodel.cpp \
    spotfinder.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES +=

HEADERS += \
    temperature.h \
    spot.h \
    spotmodel.h \
    spotfinder.h

RESOURCES += \
    uimaan.qrc














