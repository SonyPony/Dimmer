#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "types/io/filestream.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<FileStream>("FileStream", 1, 0, "FileStream");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
