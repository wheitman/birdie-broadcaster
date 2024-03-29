#include "package.h"
#include "lib/quazip/JlCompress.h"
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFileInfoList>

QSettings settings("Heitman","Birdie Broadcaster");

Package::Package(QString fileName){
    mPackageFileName = fileName;
    if(!QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.toLatin1()).exists()){ //if the package file doesn't already exist
        qInfo("Package "+mPackageFileName.toLatin1()+" is being created at "+settings.value("packageRoot").toString().toLatin1());
        QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the folder if it exists
        QDir().mkdir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a fresh package folder
        QFile manifest(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //create the manifest in the package folder
        manifest.open(QFile::WriteOnly);
        manifest.close();
        close();
    }
    else{
        //TODO: Fix this
        //qDebug("Package "+mPackageFileName.toLatin1()+" has been located in "+settings.value("packageRoot").toString().toLatin1());
    }
}

Package::Package(QString fileName, bool open){
    mPackageFileName = fileName;
    if(open){
        if(!QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.toLatin1()).exists()){ //if the package file doesn't already exist
            qInfo("Package "+mPackageFileName.toLatin1()+" is being created at "+settings.value("packageRoot").toString().toLatin1());
            QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the folder if it exists
            QDir().mkdir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a fresh package folder
            QFile manifest(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //create the manifest in the package folder
            manifest.open(QFile::WriteOnly);
            manifest.close();
        }
    }
    else{
        new Package(fileName);
    }

}

Package::Package(QString fileName, QString title){
    mPackageFileName = fileName;
    if(!QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.toLatin1()).exists()){ //if the package file doesn't already exist
        QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the folder if it exists
        QDir().mkdir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a fresh package folder
        QFile manifest(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //create the manifest in the package folder
        manifest.open(QFile::WriteOnly);
        manifest.close();
        close();
    }
    mPackageTitle = title;
    qDebug("Associating "+mPackageFileName.toLatin1()+" with "+mPackageTitle.toLatin1());
    settings.setValue(mPackageFileName,mPackageTitle); //associate the file name with the title
}

void Package::open(){
    qDebug("Package "+mPackageFileName.toLatin1()+" is being opened.");
    if(!QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.toLatin1()).exists()){ //if the package file doesn't already exist
        qInfo("Package "+mPackageFileName.toLatin1()+" is being created at "+settings.value("packageRoot").toString().toLatin1());
        QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the folder if it exists
        QDir().mkdir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a fresh package folder
        QFile manifest(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //create the manifest in the package folder
        manifest.open(QFile::WriteOnly);
        manifest.close();
        close();
    }
    JlCompress::extractDir(settings.value("packageRoot").toString()+"/"+mPackageFileName,settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first());
    updateManifest();
}

void Package::setPackageTitle(QString title){
    mPackageTitle = title;
    settings.setValue(mPackageFileName,mPackageTitle);
}

QString Package::getPackageTitle(){
    return settings.value(mPackageFileName).toString();
}

void Package::open(bool overwrite){
    qDebug("Package "+mPackageFileName.toLatin1()+" is being opened.");
    if(QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).exists()){
        if(overwrite){
            qWarning("Package "+mPackageFileName.toLatin1()+" is overwriting the old folder.");
            QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).remove(); //delete the old directory
            JlCompress::extractDir(settings.value("packageRoot").toString()+"/"+mPackageFileName,settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first());
            updateManifest();
        }
        else{
            qWarning("Package "+mPackageFileName.toLatin1()+" is keeping old folder.");
            return;
        }
    }
}

void Package::updateManifest(){
    QFile manifestFile(getPackageFolderDirectory()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //find the proper manifest file
    if(!manifestFile.open(QIODevice::ReadWrite | QIODevice::Text)) { //if open failed
        qCritical("Package "+mPackageFileName.toLatin1()+": couldn't open manifest for write");
        QDir().mkdir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a fresh package folder
        QFile manifest(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //create the manifest in the package folder
        manifest.open(QFile::WriteOnly);
        manifest.close();
    }
    QByteArray manifestArray = manifestFile.readAll();
    QJsonDocument manifestDoc(QJsonDocument::fromJson(manifestArray));
    QJsonObject manifestObject(manifestDoc.object());
    mSlideArray = manifestObject["slides"].toArray();
    QStringList slideNames = getSlideFilenames();
    for(int i=0; i<slideNames.length();i++){
        mSlideArray.append(slideNames[i]);
    }
    qDebug("Slides: "+mSlideArray.last().toString().toLatin1());
}

QStringList Package::getSlideFilenames(){
    QFileInfoList slideInfos = QDir(getPackageFolderDirectory()).entryInfoList(QStringList() << "*.jpg" << "*.JPG" << "*.png" << "*.gif");
    QStringList slideNames;
    for(int i = 0; i<slideInfos.length(); i++){
        slideNames.append("file:"+slideInfos.at(i).absoluteFilePath());
    }
    //qDebug(QString::number(slideNames.length()).toLatin1());
    return slideNames;
//    if(!mSlideArray.isEmpty()){
//        QStringList slideNames;
//        for(int i = 0; i<mSlideArray.size(); i++){
//            QString slideName = mSlideArray[i].toObject()["fileName"].toString();
//            slideNames.append(slideName);
//        }
//        return slideNames;
//    }
//    else{
//        QStringList yeet = {"NULL ERROR"};
//        return yeet;
//    }
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

void Package::addSlide(QString location){
    QString fileName = location.split("/").last();
    QString copyName = getPackageFolderDirectory()+"/"+fileName;
    if (QFile::exists(copyName))
    {
        QFile::remove(copyName);
        qWarning(fileName.toLatin1()+" already found in package. Overwriting.");
    }
    if(!QFile::copy(location.mid(8), copyName))
            qDebug("ERROR");
    qDebug("Copying "+location.toLatin1()+" to "+copyName.toLatin1());
}

void Package::deleteSlide(QString name){
    qDebug("Deleting "+settings.value("packageRoot").toString().toLatin1()+"/"+mPackageFileName.split(".").first().toLatin1()+"/"+name.toLatin1());
    if(!isOpened()){
        open();
        QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+name.toLatin1()).remove();
        close();
    }
    else{
        QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+name.toLatin1()).remove();
    }
}
