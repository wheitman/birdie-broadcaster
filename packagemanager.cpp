#include "packagemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QtGlobal>

packageManager::packageManager(QObject *parent) : QObject(parent)
{
    checkDirectory();
}

void packageManager::checkDirectory(){
    qInfo("Package Manager is checking the package directory");
    QDir dir(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages");
    if (!dir.exists()) {
        dir.mkpath(".");
        qInfo("Package Manager is creating the package directory.");
    }
}
