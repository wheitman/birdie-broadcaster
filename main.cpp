#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include "quazip.h"
#include "quazipfile.h"
#include "lib/quazip/JlCompress.h"
#include "packagemanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QQuickStyle::setFallbackStyle("Universal");

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/main.qml"));

    //JlCompress::compressDir("hana.bpkg","D:/OneDrive/Pictures/zoo-simple");
    //JlCompress::extractDir("hana.bpkg","hana");
    packageManager pkgManager;

    return app.exec();
}
