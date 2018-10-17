#ifndef PACKAGEMANAGER_H
#define PACKAGEMANAGER_H

#include <QObject>
#include <QDir>
#include "package.h"

class packageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPackageName READ getCurrentPackageName WRITE setCurrentPackage NOTIFY currentPackageNameChanged)
    Q_PROPERTY(QString currentPackageTitle READ getCurrentPackageTitle WRITE setCurrentPackageTitle NOTIFY currentPackageTitleChanged)
    Q_PROPERTY(QStringList currentSlideSources READ getCurrentSlideSources NOTIFY currentSlideSourcesChanged)
public:
    explicit packageManager(QObject *parent = nullptr);
    QDir getDirectory() const {return mDirectory;}
    QString getDirectoryPath() const {return mDirectory.absolutePath();}
    QString getFilePath(QString fileName) const {return mDirectory.absoluteFilePath(fileName);}
    Q_INVOKABLE QStringList getPackageFilenames();
    Q_INVOKABLE QString getPackageTitle(QString fileName);
    Q_INVOKABLE QString getCurrentPackageName();
    Q_INVOKABLE QString getCurrentPackageTitle();
    Q_INVOKABLE QStringList getCurrentSlideSources();
    void setCurrentSlideSources(QStringList slideSourceList);
    Q_INVOKABLE void setCurrentPackageTitle(QString title);
    void setCurrentPackageName(QString fileName);
    Q_INVOKABLE Package* getCurrentPackage();
    int count() const {return mPackages.length();}
    Q_INVOKABLE void setCurrentPackage(QString fileName);
    void initSettings();
    Q_INVOKABLE void resetPackages();
    Q_INVOKABLE void addPackage(QString fileName);
    Q_INVOKABLE void addPackage(QString fileName, QString title);
    Q_INVOKABLE bool removePackage(QString fileName);
    Q_INVOKABLE void addSlideToCurrent(QString location) const {mCurrentPackage->addSlide(location);}
private:
    void checkDirectory();
    QDir mDirectory;
    static Package *mCurrentPackage;
    QList<Package*> mPackages;
    QString defaultExtension;
signals:
    void currentPackageNameChanged();
    void currentPackageTitleChanged();
    void currentSlideSourcesChanged();
public slots:
};

#endif // PACKAGEMANAGER_H
