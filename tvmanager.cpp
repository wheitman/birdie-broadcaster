#include "tvmanager.h"
#include <QJsonDocument>
#include <QtGlobal>
#include <QStandardPaths>
#include <QJsonObject>
#include <QJsonArray>

tvManager::tvManager(QObject *parent) : QObject(parent)
{

}

QDir tvManager::getTvPath(){
    return QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/manifest.json";
}

QStringList tvManager::getTvList(){
    qDebug("TV Manager is getting the TV list");
    QStringList TVs = {"NULL ERROR"};

    QFile manifestFile(getTvPath().absolutePath());

    if (!manifestFile.open(QIODevice::ReadOnly)) {
            qCritical("Couldn't open save file.");
    }

    QByteArray manifestArray = manifestFile.readAll();

    QJsonDocument manifestDoc(QJsonDocument::fromJson(manifestArray));
    QJsonObject manifestObject(manifestDoc.object());

    if(manifestObject.contains("tvs") && manifestObject["tvs"].isArray()){
        QJsonArray tvArray = manifestObject["tvs"].toArray();
        TVs.clear();
        for (int tvIndex = 0; tvIndex < tvArray.size(); tvIndex++) {
            QString tvName = tvArray[tvIndex].toObject()["name"].toString();
            TVs.append(tvName);
        }
    }
    return TVs;
}
