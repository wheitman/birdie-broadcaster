#include "packagemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QtGlobal>

packageManager::packageManager(QObject *parent) : QObject(parent)
{
    checkDirectory();
}

void packageManager::checkDirectory(){
    qDebug("Checking directory");
    QDir dir(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages");
    if (!dir.exists()) {
        dir.mkpath(".");
    }
}
