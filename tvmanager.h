#ifndef TVMANAGER_H
#define TVMANAGER_H

#include <QObject>
#include <QDir>

class tvManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString canaryType READ getCanaryType WRITE setCanaryType NOTIFY canaryChanged)
    Q_PROPERTY(QString canaryTitle READ getCanaryTitle WRITE setCanaryTitle NOTIFY canaryChanged)
    Q_PROPERTY(QString canaryBody READ getCanaryBody WRITE setCanaryBody NOTIFY canaryChanged)
public:
    explicit tvManager(QObject *parent = nullptr);
    Q_INVOKABLE QStringList getTvList();
    Q_INVOKABLE QStringList getIpList();
    Q_INVOKABLE QDir getTvPath();
    Q_INVOKABLE void addTv(QString name, QString ip);
    Q_INVOKABLE void removeTv(QString ip);
    Q_INVOKABLE void broadcastCanary();
    void setCanaryType(QString type);
    void setCanaryTitle(QString title);
    void setCanaryBody(QString body);
    QString getCanaryType() const {return mCanaryType;}
    QString getCanaryTitle() const {return mCanaryTitle;}
    QString getCanaryBody() const {return mCanaryBody;}
private:
    QString mCanaryType;
    QString mCanaryTitle;
    QString mCanaryBody;
signals:
    void canaryChanged();
};

#endif // TVMANAGER_H
