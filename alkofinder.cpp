#include "alkofinder.h"
#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN
#include <QDebug>

AlkoFinder::AlkoFinder(QObject *parent) :
    QObject(parent)
{
    m_source = NULL;
    m_azimuth = 0;
    m_distance = 0;
    m_positionFound = false;
    m_alkoFound = false;
    m_isOpen = false;
    m_targetCoordinate = NULL;
    m_currentCoordinate = NULL;
    m_selectedAlko = NULL;
    m_model = NULL;

    m_source = QGeoPositionInfoSource::createDefaultSource(0);

    if (m_source) {
        connect(m_source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                this, SLOT(positionUpdated(QGeoPositionInfo)));
        m_source->setUpdateInterval(2000);
        m_source->startUpdates();
        //qDebug() << "position source created";
    }

    //m_model = new AlkoModel();

    emit initializationComplete();

}

AlkoFinder::~AlkoFinder()
{
    if (m_source) delete m_source;
}

void AlkoFinder::positionUpdated(const QGeoPositionInfo &info)
{
    //qDebug() << "position update";

    // save current location
    if(m_currentCoordinate) delete m_currentCoordinate;
    m_currentCoordinate = new QGeoCoordinate(info.coordinate());
    emit currentLatitudeChanged();
    emit currentLongitudeChanged();

    // by default, select nearest Alko if none is selected (at startup)
    if (!m_alkoFound && m_model)
    {
        m_model->sortByLocation(m_currentCoordinate);
        selectAlko(0);
        m_alkoFound = true;
        emit alkoFoundChanged();

    }

    // calculate azimuth and distance to the selected Alko
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

void AlkoFinder::selectAlko(int index)
{
    //qDebug() << "AlkoFinder::selectAlko";

    if (m_model == NULL)
    {
        qDebug() << "AlkoFinder::selectAlko no model!";
        m_alkoFound = false;
        return;
    }

    m_selectedAlko = m_model->alkoAt(index);

    if (m_selectedAlko == NULL)
    {
        qDebug() << "AlkoFinder::selectAlko NULL";
        m_alkoFound = false;
        return;
    }

    if (m_targetCoordinate) delete m_targetCoordinate;

    m_targetCoordinate = new QGeoCoordinate(m_selectedAlko->latitude(), m_selectedAlko->longitude());

    m_alkoFound = true;

    emit nameChanged();
    emit addressChanged();
    emit postcodeChanged();
    emit cityChanged();
    emit phoneChanged();
    emit emailChanged();
    emit additionalInfoChanged();
    emit openStatusChanged();
    emit alkoFoundChanged();
    emit targetChanged();
    emit latitudeChanged();
    emit longitudeChanged();

    return;
}

void AlkoFinder::sortByLocation()
{
    if(!m_model || !m_currentCoordinate) return;

    m_model->sortByLocation(m_currentCoordinate);
    emit modelChanged();

    return;
}

void AlkoFinder::sortByName()
{
    if(!m_model) return;
    m_model->sortByName();
    emit modelChanged();
}

qreal AlkoFinder::azimuth() const
{
    return m_azimuth;
}

qreal AlkoFinder::distance() const
{
    if (!m_selectedAlko) return 0;
    //int for easier UI creation...
    int dist = m_selectedAlko->distance();
    return dist;
}

QGeoCoordinate* AlkoFinder::target() const
{
    if (!m_targetCoordinate) return new QGeoCoordinate();
    else return m_targetCoordinate;
}

qreal AlkoFinder::latitude() const
{
    if (!m_targetCoordinate) return 0;
    else return m_targetCoordinate->latitude();
}

qreal AlkoFinder::longitude() const
{
    if (!m_targetCoordinate) return 0;
    else return m_targetCoordinate->longitude();
}

qreal AlkoFinder::currentLatitude() const
{
    if (!m_currentCoordinate) return 0;
    else return m_currentCoordinate->latitude();
}

qreal AlkoFinder::currentLongitude() const
{
    if (!m_currentCoordinate) return 0;
    else return m_currentCoordinate->longitude();
}

QString AlkoFinder::name() const
{
    if (!m_selectedAlko) return "";
    return m_selectedAlko->name();
}

QString AlkoFinder::address() const
{
    //qDebug() << "address";
    if (!m_selectedAlko) return "";
    return m_selectedAlko->address();
}

QString AlkoFinder::postcode() const
{
    if (!m_selectedAlko) return "";
    return m_selectedAlko->postcode();
}

QString AlkoFinder::city() const
{
    if (!m_selectedAlko) return "";
    return m_selectedAlko->city();
}

QString AlkoFinder::phone() const
{
    if (!m_selectedAlko) return "";
    return m_selectedAlko->phone();
}
QString AlkoFinder::email() const
{
    if (!m_selectedAlko) return "";
    return m_selectedAlko->email();
}

QString AlkoFinder::additionalInfo() const
{
    if (!m_selectedAlko) return "";
    return m_selectedAlko->additionalInfo();
}

QString AlkoFinder::openStatus()
{
    //qDebug() << "opesstatus";
    if (!m_selectedAlko) return "";

    QTime now = QTime::currentTime();
    QDate date = QDate::currentDate();
    int day = date.dayOfWeek();
    QTime open = m_selectedAlko->opens(day);
    QTime close = m_selectedAlko->closes(day);
    QTime result = QTime(0, 0, 0, 0);

    if (day == 7) // Sunday
    {
        //qDebug() << "AlkoFinder::openStatus sunday";
        open = m_selectedAlko->opens(1);
        m_isOpen = false; emit isOpenChanged();
        return "Aukeaa maanantaina klo " + open.toString("H:mm");
    }
    else if(now > close) // past closing time
    {
        m_isOpen = false; emit isOpenChanged();
        // opens next monday (it's saturday night, baby!)
        if (day == 6)
        {
            //qDebug() << "AlkoFinder::openStatus closed sat";
            open = m_selectedAlko->opens(1);
            return "Aukeaa maanantaina klo " + open.toString("H:mm");
        }
        else
        {
            //qDebug() << "AlkoFinder::openStatus closed other";
            open = m_selectedAlko->opens(day+1);
            //qDebug() << "AlkoFinder::openStatus closed other: " << open.toString("H:mm");
            return "Aukeaa huomenna klo " + open.toString("H:mm");
        }

    }
    else if(now < open) // before opening time
    {
        m_isOpen = false; emit isOpenChanged();
        //qDebug() << "AlkoFinder::openStatus early";
        return "Aukeaa klo " + open.toString("H:mm");

    }
    else // we're open!
    {
        m_isOpen = true; emit isOpenChanged();
        //qDebug() << "AlkoFinder::openStatus open!";
        int remains = now.msecsTo(close);
        //qDebug() << "AlkoFinder::openStatus open remains " << remains;
        result = result.addMSecs(remains);
        return "Avoinna vielä " + QString::number(result.hour()) + " h " + QString::number(result.minute()+1) + " min";
    }

}

QString AlkoFinder::openStatusSimple(int day) const
{
    if (day >= 7) return "";
    if (!m_selectedAlko) return "";

    QTime open = m_selectedAlko->opens(day);
    QTime close = m_selectedAlko->closes(day);
    QString result = "";

    if (open.hour() == 0) return "suljettu";

    result += QString::number(open.hour());
    if (open.minute() != 0) result += ":" + QString::number(open.minute());
    result += "-";
    result += QString::number(close.hour());
    if (close.minute() != 0) result +=  ":" + QString::number(close.minute());

    return result;
}

bool AlkoFinder::positionFound() const
{
    //qDebug() << "posfound";
    return m_positionFound;
}

bool AlkoFinder::alkoFound() const
{
    //qDebug() << "alkofound";
    return m_alkoFound;
}

bool AlkoFinder::isOpen() const
{
    //qDebug() << "isopen";
    return m_isOpen;
}

AlkoModel* AlkoFinder::model()
{
    //qDebug() << "model";
    return m_model;
}

void AlkoFinder::setModel(QObject *model)
{
    m_model = qobject_cast<AlkoModel *>(model);
    emit modelChanged();
    return;
}

void AlkoFinder::launchMaps() const
{
    if (!m_selectedAlko) return;
#if defined(MEEGO_EDITION_HARMATTAN)
    QDesktopServices::openUrl(QUrl("geo:" + QString::number(m_selectedAlko->latitude()) + "," + QString::number(m_selectedAlko->longitude()) + "?action=showOnMap&zoomLevel=13"));
#else
    QDesktopServices::openUrl(QUrl("http://m.ovi.me/?c=" + QString::number(m_selectedAlko->latitude()) + "," + QString::number(m_selectedAlko->longitude())));
#endif

}


