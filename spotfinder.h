#ifndef SPOTFINDER_H
#define SPOTFINDER_H

#include <QObject>
#include <qgeocoordinate.h>
#include <qgeopositioninfo.h>
#include <qgeopositioninfosource.h>
#include <QUrl>
#include <QDesktopServices>
#include "spot.h"
#include "spotmodel.h"
#include "temperature.h"

QTM_USE_NAMESPACE

class SpotFinder : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString address READ address NOTIFY addressChanged)
    Q_PROPERTY(QString additionalInfo READ additionalInfo NOTIFY additionalInfoChanged)
    Q_PROPERTY(qreal distance READ distance NOTIFY distanceChanged)
    Q_PROPERTY(qreal azimuth READ azimuth NOTIFY azimuthChanged)
    Q_PROPERTY(qreal latitude READ latitude NOTIFY latitudeChanged)
    Q_PROPERTY(qreal longitude READ longitude NOTIFY longitudeChanged)
    Q_PROPERTY(qreal currentLatitude READ currentLatitude NOTIFY currentLatitudeChanged)
    Q_PROPERTY(qreal currentLongitude READ currentLongitude NOTIFY currentLongitudeChanged)
    Q_PROPERTY(bool positionFound READ positionFound NOTIFY positionFoundChanged)
    Q_PROPERTY(bool spotFound READ spotFound NOTIFY spotFoundChanged)
    Q_PROPERTY(SpotModel* model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(bool temperatureDataAvailable READ temperatureDataAvailable NOTIFY temperatureDataAvailableChanged)
    //Q_PROPERTY(QString selectedSpot READ selectedSpot WRITE setSelectedSpot)


    Q_PROPERTY(QString waterTemperature READ waterTemperature NOTIFY waterTemperatureChanged)
    Q_PROPERTY(QString airTemperature READ airTemperature NOTIFY airTemperatureChanged)

public:
    explicit SpotFinder(QObject *parent = 0);
    ~SpotFinder();

    Q_INVOKABLE void selectSpot(int index);
    Q_INVOKABLE void sortByLocation();
    Q_INVOKABLE void sortByName();

    QString name() const;
    QString address() const;
    QString additionalInfo() const;

    qreal distance() const;
    qreal azimuth() const;
    QGeoCoordinate* target() const;
    qreal latitude() const;
    qreal longitude() const;
    qreal currentLatitude() const;
    qreal currentLongitude() const;
    bool positionFound() const;
    bool spotFound() const;
    bool temperatureDataAvailable();

    QString waterTemperature() const;
    QString airTemperature() const;

    SpotModel* model();
    void setModel(QObject* model);

    Q_INVOKABLE void launchMaps() const;
    Q_INVOKABLE double latitudeAtIndex(int index);
    Q_INVOKABLE double longitudeAtIndex(int index);


signals:

    void nameChanged();
    void addressChanged();
    void additionalInfoChanged();
    void distanceChanged();
    void azimuthChanged();
    void positionFoundChanged();
    void spotFoundChanged();
    void initializationComplete();
    void modelChanged();
    void targetChanged();
    void latitudeChanged();
    void longitudeChanged();
    void currentLatitudeChanged();
    void currentLongitudeChanged();
    void waterTemperatureChanged();
    void airTemperatureChanged();
    void temperatureDataAvailableChanged();

public slots:
    void positionUpdated(const QGeoPositionInfo &info);
    void temperatureDataUpdated();

private:
    QGeoPositionInfoSource *m_source;
    QGeoCoordinate *m_targetCoordinate;
    QGeoCoordinate *m_currentCoordinate;
    qreal m_azimuth;
    qreal m_distance;
    bool m_positionFound;
    bool m_spotFound;

    SpotModel* m_model;
    Spot* m_selectedSpot;

    Temperature* m_temperature;

    //void setSpot();



};

#endif // SPOTFINDER_H
