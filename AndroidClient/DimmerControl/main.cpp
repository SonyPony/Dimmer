#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QTranslator>
#include "types/io/filestream.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QTranslator myTr;
    myTr.load(":/translations/" + QLocale::system().name() + ".qm" );
    app.installTranslator(&myTr);

    QQmlApplicationEngine engine;
    qmlRegisterType<FileStream>("FileStream", 1, 0, "FileStream");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
