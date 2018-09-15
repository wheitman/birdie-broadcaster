#include "tvmanager.h"
#include <QJsonDocument>
#include <QtGlobal>
#include <QStandardPaths>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QVariant>

tvManager::tvManager(QObject *parent) : QObject(parent)
{

}

QDir tvManager::getTvPath(){
    return QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/manifest.json";
}

void tvManager::addTv(QString name, QString ip){
    qDebug("TV Manager is adding "+name.toLatin1()+" at "+ip.toLatin1());
    QFile manifestFile(getTvPath().absolutePath());
    if(!manifestFile.open(QIODevice::ReadWrite | QIODevice::Text)) {
        qCritical("Couldn't open TV manifest for write");
    }
    QByteArray manifestArray = manifestFile.readAll();
    QJsonDocument manifestDoc(QJsonDocument::fromJson(manifestArray));
    QJsonObject manifestObject(manifestDoc.object());

    QVariantList tvList = manifestObject["tvs"].toArray().toVariantList();

    QVariantMap tv;
    tv.insert("name",name);
    tv.insert("ip",ip);
    tvList.append(tv);

    manifestObject.take("tvs");
    manifestObject.insert("tvs",QJsonValue::fromVariant(tvList));

    manifestFile.resize(0);
    manifestFile.write(QJsonDocument(manifestObject).toJson());

    manifestFile.close();
}

void tvManager::removeTv(QString ip){
    qDebug("TV Manager is removing the TV at "+ip.toLatin1());
    QFile manifestFile(getTvPath().absolutePath());
    if(!manifestFile.open(QIODevice::ReadWrite | QIODevice::Text)) {
        qCritical("Couldn't open TV manifest for write");
    }
    QByteArray manifestArray = manifestFile.readAll();
    QJsonDocument manifestDoc(QJsonDocument::fromJson(manifestArray));
    QJsonObject manifestObject(manifestDoc.object());

    QVariantList tvList = manifestObject["tvs"].toArray().toVariantList();

    for(int i = 0; i < tvList.length(); i++){
        if(tvList.at(i).toMap().value("ip")==ip){
            tvList.removeAt(i);
            break;
        }
    }

    manifestObject.take("tvs");
    manifestObject.insert("tvs",QJsonValue::fromVariant(tvList));

    manifestFile.resize(0);
    manifestFile.write(QJsonDocument(manifestObject).toJson());

    manifestFile.close();
}

QStringList tvManager::getTvList(){
    qDebug("TV Manager is getting the TV list");
    QStringList TVs = {"NULL ERROR"};

    QFile manifestFile(getTvPath().absolutePath());

    if (!manifestFile.open(QIODevice::ReadOnly)) {
            qCritical("Couldn't open TV manifest for read");
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
    else
        qDebug("TV Manager: No TV array found.");
    manifestFile.close();
    return TVs;
}

QStringList tvManager::getIpList(){
    qDebug("TV Manager is getting the IP list");
    QStringList IPs = {"NULL ERROR"};

    QFile manifestFile(getTvPath().absolutePath());

    if (!manifestFile.open(QIODevice::ReadOnly)) {
            qCritical("Couldn't open TV manifest for read");
    }

    QByteArray manifestArray = manifestFile.readAll();

    QJsonDocument manifestDoc(QJsonDocument::fromJson(manifestArray));
    QJsonObject manifestObject(manifestDoc.object());

    if(manifestObject.contains("tvs") && manifestObject["tvs"].isArray()){
        QJsonArray tvArray = manifestObject["tvs"].toArray();
        IPs.clear();
        for (int tvIndex = 0; tvIndex < tvArray.size(); tvIndex++) {
            QString tvIp = tvArray[tvIndex].toObject()["ip"].toString();
            IPs.append(tvIp);
        }
    }
    else
        qDebug("TV Manager: No TV array found.");
    manifestFile.close();
    return IPs;
}
