#include <QApplication>
#include <QQmlApplicationEngine>
#include "components/controls/circleslider.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<CircleSlider>("CircleSlider", 1, 0, "CircleSlider");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
