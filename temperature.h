#ifndef TEMPERATURE_H
#define TEMPERATURE_H

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QSslError>
#include <QtNetwork/QNetworkProxy>
#include <QtNetwork/QAuthenticator>
#include <QGeoCoordinate>

QTM_USE_NAMESPACE

class Temperature : public QObject
{
    Q_OBJECT
public:
    explicit Temperature(QObject *parent = 0);

    void setCoordinate(double lat, double lng);
    bool isValid() const;
    QString waterTemperature() const;
    qreal airTemperature() const;

    struct Measurement {
        QString name;
        double latitude;
        double longitude;
        QString measurement;
    };


signals:
    void ready();
    void error();

public slots:
    void replyFinished(QNetworkReply *reply);
    void onIgnoreSSLErrors(QNetworkReply *reply, QList<QSslError> error);
    void networkError();

    
private:

    bool m_isValid;
    QString m_surfaceTemperature;
    qreal m_airTemperature;
    double m_latitude;
    double m_longitude;

    QNetworkAccessManager *m_manager;
    QString m_reply;
    bool m_loading;
    bool m_parsingOk;

    QList<Measurement> m_measurements;

    bool parseHTML();
    void addMeasurementPoint(QString name, double latitude, double longitude);
    void getMeasurement(); // gets the nearest temperature if coordinate and data are available. Emits ready() if so.
    
};

#endif // TEMPERATURE_H
