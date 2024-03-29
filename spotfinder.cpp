#include "spotfinder.h"
#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN
#include <QDebug>

SpotFinder::SpotFinder(QObject *parent) :
    QObject(parent)
{
    m_source = NULL;
    m_azimuth = 0;
    m_distance = 0;
    m_positionFound = false;
    m_spotFound = false;
    m_locationEnabled = false;
    m_targetCoordinate = NULL;
    m_currentCoordinate = NULL;
    m_selectedSpot = NULL;
    m_model = NULL;

    m_temperature = new Temperature();
    connect(m_temperature, SIGNAL(ready()), this, SLOT(temperatureDataUpdated()));

    emit initializationComplete();

}

SpotFinder::~SpotFinder()
{
    if (m_source) delete m_source;
}

void SpotFinder::setLocationEnabled(bool enabled)
{

    // enable location updates based on m_locationEnabled

    m_locationEnabled = enabled;

    // just stop updating location when disabled
    if(!enabled) {
        if(m_source) m_source->stopUpdates();
        emit locationEnabledChanged();
        return;
    }

    // create a new position source if not existing yet
    if(!m_source)
    {
        m_source = QGeoPositionInfoSource::createDefaultSource(this);

        if (m_source) {
            connect(m_source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                    this, SLOT(positionUpdated(QGeoPositionInfo)));
            m_source->setUpdateInterval(2000);
        }
    }

    m_source->startUpdates();
    emit locationEnabledChanged();
    return;
}

bool SpotFinder::locationEnabled() const
{
    return m_locationEnabled;
}

void SpotFinder::positionUpdated(const QGeoPositionInfo &info)
{
    //qDebug() << "position update";

    // save current location
    if(m_currentCoordinate) delete m_currentCoordinate;
    m_currentCoordinate = new QGeoCoordinate(info.coordinate());
    emit currentLatitudeChanged();
    emit currentLongitudeChanged();

    // by default, select nearest Spot if none is selected (at startup)
    if (!m_spotFound && m_model)
    {
        m_model->sortByLocation(m_currentCoordinate);
        selectSpot(0);
        m_spotFound = true;
        emit spotFoundChanged();

    }

    // calculate azimuth and distance to the selected Spot
    if (m_targetCoordinate)
    {
        //m_azimuth = m_targetCoordinate->azimuthTo(info.coordinate());
        m_azimuth = m_currentCoordinate->azimuthTo(*m_targetCoordinate);
        m_distance = m_currentCoordinate->distanceTo(*m_targetCoordinate);
        emit azimuthChanged();
        emit distanceChanged();

    }

    if (!m_positionFound)
    {
        //qDebug() << "position found";
        m_positionFound = true;
        emit positionFoundChanged();
    }
}

void SpotFinder::selectSpot(int index)
{
    if (m_model == NULL)
    {
        qDebug() << "SpotFinder::selectSpot no model!";
        m_spotFound = false;
        return;
    }

    if (index < 0)
    {
       qDebug() << "SpotFinder::selectSpot index < 0";
       m_spotFound = false;
    }


    m_selectedSpot = NULL;
    m_selectedSpot = m_model->spotAt(index);

    if (m_selectedSpot == NULL)
    {
        qDebug() << "SpotFinder::selectSpot NULL";
        m_spotFound = false;
        return;
    }

    if (m_targetCoordinate) delete m_targetCoordinate;

    m_targetCoordinate = new QGeoCoordinate(m_selectedSpot->latitude(), m_selectedSpot->longitude());
    m_temperature->setCoordinate(m_selectedSpot->latitude(), m_selectedSpot->longitude());

    m_spotFound = true;

    emit nameChanged();
    emit addressChanged();
    emit additionalInfoChanged();
    emit spotFoundChanged();
    emit targetChanged();
    emit latitudeChanged();
    emit longitudeChanged();

    if (m_temperature)
    {
        emit waterTemperatureChanged();
        emit airTemperatureChanged();
    }

    return;
}

void SpotFinder::sortByLocation()
{
    if(!m_model || !m_currentCoordinate) return;

    m_model->sortByLocation(m_currentCoordinate);
    emit modelChanged();

    return;
}

void SpotFinder::sortByName()
{
    if(!m_model) return;
    m_model->sortByName();
    emit modelChanged();
}

qreal SpotFinder::azimuth() const
{
    return m_azimuth;
}

qreal SpotFinder::distance() const
{
    if (!m_selectedSpot) return 0;
    //int for easier UI creation...
    int dist = m_selectedSpot->distance();
    return dist;
}

QGeoCoordinate* SpotFinder::target() const
{
    if (!m_targetCoordinate) return new QGeoCoordinate();
    else return m_targetCoordinate;
}

qreal SpotFinder::latitude() const
{
    if (!m_targetCoordinate) return 0;
    else return m_targetCoordinate->latitude();
}

qreal SpotFinder::longitude() const
{
    if (!m_targetCoordinate) return 0;
    else return m_targetCoordinate->longitude();
}

qreal SpotFinder::currentLatitude() const
{
    if (!m_currentCoordinate) return 0;
    else return m_currentCoordinate->latitude();
}

qreal SpotFinder::currentLongitude() const
{
    if (!m_currentCoordinate) return 0;
    else return m_currentCoordinate->longitude();
}

QString SpotFinder::name() const
{
    if (!m_selectedSpot) return "";
    return m_selectedSpot->name();
}

QString SpotFinder::address() const
{
    //qDebug() << "address";
    if (!m_selectedSpot) return "";

    if(m_selectedSpot->address() == "www.liikuntapaikat.fi"
            || m_selectedSpot->address() == "Kansanterveyslaitos, SYKE")
    {
        return "";
    }
    else return m_selectedSpot->address();
}


QString SpotFinder::additionalInfo() const
{
    if (!m_selectedSpot) return "";
    return m_selectedSpot->additionalInfo();
}

bool SpotFinder::positionFound() const
{
    //qDebug() << "posfound";
    return m_positionFound;
}

bool SpotFinder::spotFound() const
{
    //qDebug() << "spotfound";
    return m_spotFound;
}


SpotModel* SpotFinder::model()
{
    //qDebug() << "model";
    return m_model;
}

void SpotFinder::setModel(QObject *model)
{
    m_model = qobject_cast<SpotModel *>(model);
    emit modelChanged();
    return;
}

void SpotFinder::launchMaps() const
{
    if (!m_selectedSpot) return;
#if defined(MEEGO_EDITION_HARMATTAN)
    QDesktopServices::openUrl(QUrl("geo:" + QString::number(m_selectedSpot->latitude()) + "," + QString::number(m_selectedSpot->longitude()) + "?action=showOnMap&zoomLevel=13"));
#else
    QDesktopServices::openUrl(QUrl("http://m.ovi.me/?c=" + QString::number(m_selectedSpot->latitude()) + "," + QString::number(m_selectedSpot->longitude())));
#endif

}

QString SpotFinder::waterTemperature() const
{
    if(m_temperature) return m_temperature->waterTemperature();
    else return "N/A";
}

QString SpotFinder::airTemperature() const
{
    if(m_temperature) return QString::number(m_temperature->airTemperature());
    else return 0;
}

QString SpotFinder::measurementLocation() const
{
    if(m_temperature) return m_temperature->measurementLocation();
    else return "";
}

bool SpotFinder::temperatureDataAvailable()
{
    return m_temperature->isValid();
}

void SpotFinder::temperatureDataUpdated()
{

    emit temperatureDataAvailableChanged();
    emit waterTemperatureChanged();

}

double SpotFinder::latitudeAtIndex(int index)
{
    if (!m_model) return 0;
    Spot *temp = m_model->spotAt(index);
    if (temp) return temp->latitude();
    else return 0;
}

double SpotFinder::longitudeAtIndex(int index)
{
    if (!m_model) return 0;
    Spot *temp = m_model->spotAt(index);
    if (temp) return temp->longitude();
    else return 0;
}

