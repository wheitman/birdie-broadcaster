#include "package.h"
#include "lib/quazip/JlCompress.h"
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

QSettings settings("Heitman","Birdie Broadcaster");

Package::Package(QString fileName){
    mPackageFileName = fileName;
    if(!QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.toLatin1()).exists()){ //if the package file doesn't already exist
        QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the folder if it exists
        QDir().mkdir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a fresh package folder
        QFile manifest(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //create the manifest in the package folder
        manifest.open(QFile::WriteOnly);
        manifest.close();
        close();
    }
}

Package::Package(QString fileName, QString title){
    mPackageFileName = fileName;
    mPackageTitle = title;
    qDebug("Associating "+mPackageFileName.toLatin1()+" with "+mPackageTitle.toLatin1());
    settings.setValue(mPackageFileName,mPackageTitle); //associate the file name with the title
}

void Package::open(){
    JlCompress::extractDir(settings.value("packageRoot").toString()+"/"+mPackageFileName,settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first());
    updateManifest();
}

void Package::updateManifest(){
    QFile manifestFile(getPackageFolderDirectory()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest");
    if(!manifestFile.open(QIODevice::ReadWrite | QIODevice::Text)) {
        qCritical("Package: couldn't open manifest for write");
    }
    QByteArray manifestArray = manifestFile.readAll();
    QJsonDocument manifestDoc(QJsonDocument::fromJson(manifestArray));
    QJsonObject manifestObject(manifestDoc.object());
    mSlideArray = manifestObject["slides"].toArray();
}

QStringList Package::getSlideFilenames(){
    if(!mSlideArray.isEmpty()){
        QStringList slideNames;
        for(int i = 0; i<mSlideArray.size(); i++){
            QString slideName = mSlideArray[i].toObject()["fileName"].toString();
            slideNames.append(slideName);
        }
        return slideNames;
    }
    else{
        QStringList yeet = {"NULL ERROR"};
        return yeet;
    }
}

QString Package::getPackageFolderDirectory(){
    return settings.value("packageRoot").toString()+"/"+Package::mPackageFileName.split(".").first();
}

void Package::close(){
    if(!isOpened()){
        qWarning("Package: cannot close an unopen package.");
    }
    QDir().remove(settings.value("packageRoot").toString()+"/"+mPackageFileName); //delete the old bpak
    JlCompress::compressDir(settings.value("packageRoot").toString()+"/"+mPackageFileName,settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a new bpak
    QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the temporary directory
}

void Package::remove(){
    if(isOpened())
        close();
    QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName).remove();
    qDebug("Removing "+mPackageFileName.toLatin1());
}

bool Package::isOpened(){
    return QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).exists();
}
