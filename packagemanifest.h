#ifndef PACKAGEMANIFEST_H
#define PACKAGEMANIFEST_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QVariant>
#include <QFile>
#include <QStandardPaths>

class PackageManifest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList slideNames READ getSlideNames NOTIFY slideNamesChanged)
    Q_PROPERTY(QString packageName READ getPackageName WRITE setPackageName NOTIFY packageNameChanged)
public:
    PackageManifest();
    PackageManifest(QString packageName);
    QStringList getSlideNames();
    void setPackageName(QString packageName);
    QString getPackageName() const {return mPackageName;}
private:
    QString mPackageName;
    QFile *mManifestFile;
signals:
    void slideNamesChanged();
    void packageNameChanged();
};

#endif // PACKAGEMANIFEST_H
