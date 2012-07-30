#include "temperature.h"

const QString WEATHERURL = "http://wwwi3.ymparisto.fi/i3/tilanne/fin/Lampotila/Lampotila.htm";



Temperature::Temperature(QObject *parent) :
    QObject(parent)
{
    m_isValid = false;
    m_surfaceTemperature = "";
    m_airTemperature = 0;
    m_latitude = 0;
    m_longitude = 0;
    m_reply = "";
    m_loading = true;
    m_parsingOk = false;

    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));
    connect(m_manager, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)),
            this, SLOT(onIgnoreSSLErrors(QNetworkReply*,QList<QSslError>)));
    connect(m_manager, SIGNAL(authenticationRequired(QNetworkReply*,QAuthenticator*)),
            this, SLOT(networkError()));
    connect(m_manager, SIGNAL(proxyAuthenticationRequired(QNetworkProxy,QAuthenticator*)),
            this, SLOT(networkError()));

    m_manager->get(QNetworkRequest(QUrl(WEATHERURL)));

    addMeasurementPoint("Pielinen,Nurmes", 63.245994 , 29.672699);
    addMeasurementPoint("Pyhäselkä,Joensuu", 62.501858 , 29.747543);
    addMeasurementPoint("Pielinen,Nurmes", 63.245994,29.672699);
    addMeasurementPoint("Pyhäselkä,Joensuu", 62.501858,29.747543);
    addMeasurementPoint("Kallavesi,Kuopio", 62.8635771,27.8209597);
    addMeasurementPoint("Haukivesi,Oravi", 62.1366587,28.3954793);
    addMeasurementPoint("Saimaa,Lauritsala", 61.4635199,27.9971038);
    addMeasurementPoint("Pääjärvi,Karstula", 62.8785357,24.7593313);
    addMeasurementPoint("Pielavesi,Säviä", 63.2893242,26.609901);
    addMeasurementPoint("Konnevesi,etelä", 62.6413624,26.4437092);
    addMeasurementPoint("Jääsjärvi,Hartola", 61.5888366,26.1607776);
    addMeasurementPoint("Päijänne,Sysmä", 61.4664465,25.6113658);
    addMeasurementPoint("Ala-Rieveli,Heinola", 61.30579,26.1743439);
    addMeasurementPoint("Kyyvesi,Haukivuori", 61.993935,27.0679439);
    addMeasurementPoint("Päijänne,Päijätsalo", 61.8566069,25.5907664);
    addMeasurementPoint("Tuusulanjärvi", 60.4363177,25.0664111);
    addMeasurementPoint("Lohjanjärvi", 60.2510791,24.0467543);
    addMeasurementPoint("Säkylän Pyhäjärvi", 61.0000937,22.3112873);
    addMeasurementPoint("Längelmävesi,Kaivanto", 61.591757,24.4486032);
    addMeasurementPoint("Pääjärvi,Lammi", 61.0591884,25.1485557);
    addMeasurementPoint("Kitusjärvi,Virrat", 62.2752067,23.7998209); //ei varma
    addMeasurementPoint("Kuivajärvi,Saari, Tammela", 60.7679053,23.8324817); //ei varma
    addMeasurementPoint("Näsijärvi,Kyrönlahti", 61.7060793,23.6429305);
    addMeasurementPoint("Lappajärvi,Halkosaari", 63.2094423,23.7346149);
    addMeasurementPoint("Pesiöjärvi,Suomussalmi", 64.9445726,28.6695489);
    addMeasurementPoint("Nuasjärvi,Vuokatti", 64.1591038,28.1631507);
    addMeasurementPoint("Oulujärvi,Manamansalo", 64.3237594,27.1605124);
    addMeasurementPoint("Oijärvi", 65.6457513,25.90799);
    addMeasurementPoint("Ounasjärvi,Enontekiö", 68.375845,23.5991989);
    addMeasurementPoint("Unari,Sodankylä", 67.1603042,25.744572);
    addMeasurementPoint("Kilpisjärvi", 69.0287998,20.8246098);
    addMeasurementPoint("Tornionjoki,Kukkolankoski", 65.8478997,24.1614759);
    addMeasurementPoint("Kevojärvi,Kevoniemi", 69.7535468,27.0159936);
    addMeasurementPoint("Inari,Nellim", 68.8503965,28.3161308);
    addMeasurementPoint("Hinjärvi,Närpiö", 62.4658598,21.3709498); // ei varma


}

void Temperature::addMeasurementPoint(QString name, double latitude, double longitude)
{
    Measurement m;
    m.name = name;
    m.latitude = latitude;
    m.longitude = longitude;
    m_measurements.append(m);
    return;
}

void Temperature::setCoordinate(double lat, double lng)
{
    m_latitude = lat;
    m_longitude = lng;
    if(m_parsingOk) getMeasurement();
    return;
}

void Temperature::getMeasurement()
{
    if(m_latitude == 0 || m_longitude == 0)
    {
        qDebug() << "Can't measure, no coordinate set";
        return;

    }

    if(!m_parsingOk)
    {
        qDebug() << "Can't measure, no data available";
        return;
    }

    QGeoCoordinate target(m_latitude, m_longitude);
    QGeoCoordinate measurementLocation;
    double distance = -1;
    int closestIndex = 0;

    for (int i=0; i<m_measurements.length();i++)
    {
        measurementLocation.setLatitude(m_measurements[i].latitude);
        measurementLocation.setLongitude(m_measurements[i].longitude);
        qreal newDistance = target.distanceTo(measurementLocation);
        //qDebug() << "dist: " << newDistance;
        if(distance == -1)
        {
            distance = newDistance;
            closestIndex = i;
        }
        else if(newDistance < distance)
        {
            distance = newDistance;
            closestIndex = i;
        }
    }

    //qDebug() << "closestIndex: " << closestIndex;
    m_surfaceTemperature = m_measurements[closestIndex].measurement;
    //qDebug() << "surfTemp: " << m_surfaceTemperature;
    m_airTemperature = 22;
    m_isValid = true;

    emit ready();
    return;

}

bool Temperature::isValid() const
{
    return m_isValid;
}

QString Temperature::waterTemperature() const
{
    return m_surfaceTemperature;
}

qreal Temperature::airTemperature() const
{
    return m_airTemperature;
}

bool Temperature::parseHTML()
{
    // simple sanity check
    if(!m_reply.contains("Pielinen")) return false;

    // remove whitespace
    m_reply = m_reply.simplified();
    m_reply.replace(" ", "");

    int pos = -1;
    QString temp = "";

    for(int i=0; i<m_measurements.length();i++)
    {
        // find name in HTML, temperature will come right after that
        pos = m_reply.lastIndexOf(m_measurements[i].name);
        if(pos < 0) {
            // no measurement for this place
            qDebug() << "No measurement for " << m_measurements[i].name << ", removing";
            m_measurements.removeAt(i);
            i--;
            continue;
        }

        pos += m_measurements[i].name.length();
        temp = "";

        // get digits before decimal point
        for(int j=0; j<3; j++)
        {
            if(m_reply.at(pos+j) == '.') break;
            temp += m_reply.at(pos+j);

        }

        m_measurements[i].measurement = temp;

        //qDebug() << "Temp for " << m_measurements[i].name << " is " << m_measurements[i].measurement;
    }

    return true;
}

void Temperature::replyFinished(QNetworkReply *reply)
{
    qDebug() << "reply arrived";
    m_reply = reply->readAll();
    //qDebug() << "reply: " << m_reply;

    //empty reply; might be problems with connection.
    if(m_reply == "")
    {
        //emit error();
        qDebug() << "empty reply";
        m_loading = false;
        return;
    }

    m_parsingOk = parseHTML();
    if(!m_parsingOk) {
        qDebug() << "Parsing failed";
    }
    else {
        getMeasurement();
    }

    m_loading = false;


}

void Temperature::onIgnoreSSLErrors(QNetworkReply *reply, QList<QSslError> error)
{
    reply->ignoreSslErrors(error);
}

void Temperature::networkError()
{
    qDebug() << "authorization error";
    //emit error();
    m_loading = false;
    m_isValid = false;
}
