TEMPLATE = app

QT += qml quick widgets websockets

HEADERS += types/io/filestream.h

SOURCES += main.cpp \
           types/io/filestream.cpp

RESOURCES += qml.qrc

TRANSLATIONS = translations/cs.ts

lupdate_only{
SOURCES = *.qml \
          components/dialogs/*.qml \
          components/other/*.qml \
          components/tabs/*.qml \
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
