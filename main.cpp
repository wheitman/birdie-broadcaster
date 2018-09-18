#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include "quazip.h"
#include "quazipfile.h"
#include "lib/quazip/JlCompress.h"
#include "packagemanager.h"
#include "tvmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QQuickStyle::setFallbackStyle("Universal");

    QQmlApplicationEngine engine;
    qmlRegisterType<tvManager>("com.broadcaster.tvmanager",1,0,"TvManager");
    engine.load(QUrl("qrc:/main.qml"));

    packageManager manager;
    JlCompress::compressDir(manager.getDirectoryPath()+"/animals.bpak","C:/Users/wheit/AppData/Roaming/Broadcaster/packages/animal_facts");
    JlCompress::extractDir(manager.getDirectoryPath()+"/animals.bpak",manager.getDirectoryPath()+"/animal_facts2");
    qDebug(manager.getDirectoryPath().toLatin1());

    return app.exec();
}
