TEMPLATE = app

QT += qml quick widgets websockets

HEADERS += types/io/filestream.h

SOURCES += main.cpp \
           types/io/filestream.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
