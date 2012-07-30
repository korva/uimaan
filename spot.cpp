#include "spot.h"
#include <QDebug>

const char SEPARATOR = ';';

Spot::Spot(QObject *parent):
    QObject(parent)
{
    m_name = "";
    m_address = "";
    m_postcode = "";
    m_city = "";
    m_phone = "";
    m_email = "";
    m_additionalInfo = "";
    m_latitude = 0;
    m_longitude = 0;
    m_distance = 0;

    sortMode = Spot::SortByName;


}

bool Spot::operator< (const Spot *other) const
{
    if (sortMode == Spot::SortByName)
    {
        //qDebug() << "operator< name";
        return m_name < other->name();
    }
    else if (sortMode == Spot::SortByLocation)
    {
        //qDebug() << "operator< location";
        return m_distance < other->distance();
    }

    return false;
}

bool Spot::initialize(QString data)
{
    // format is Imatra;Ukonlinnan rantauimala;61.206688969;28.722762284
    m_name = data.section(SEPARATOR, 1, 1);
    m_address = data.section(SEPARATOR, 0, 0);
    m_latitude = data.section(SEPARATOR, 2, 2).toFloat();
    m_longitude = data.section(SEPARATOR, 3, 3).toFloat();


    //qDebug() << m_name << m_city << m_latitude << m_longitude;

    return true;
}

void Spot::parseTime(QString time)
{
    //qDebug() << "parseTime: " << time;

    // not valid string
    if (time == "kiinni")
    {
        m_openingHours.append(QTime(0, 0, 0, 0));
        m_closingHours.append(QTime(0, 0, 0, 0));
        //qDebug() << "parse1";
        return;
    }

    QString openstring = "";
    QString closestring = "";
    int open = 0;
    int close = 0;
    int openmin = 0;
    int closemin = 0;

    //Jostain kumman syystä '-' ei pelitä. Mutta '?' korvaa sen!?!?!
    openstring = time.section('?', 0, 0);
    closestring = time.section('?', 1, 1);

    //qDebug() << "parseTime openstring: " << openstring;

    if (openstring.contains('.'))
    {

        open = openstring.section('.', 0, 0).toInt();
        openmin = openstring.section('.', 1, 1).toInt();
        //qDebug() << "parse open yes: " << open << "/" << openmin;
    }
    else
    {

        open = openstring.toInt();
        //qDebug() << "parse open no: " << openstring << "/" << open;
    }

    if (closestring.contains('.'))
    {
        //qDebug() << "parse c:";
        close = closestring.section('.', 0, 0).toInt();
        closemin = closestring.section('.', 1, 1).toInt();
    }
    else
    {
        //qDebug() << "parse c";
        close = closestring.toInt();
    }

    // not valid values
    if (open < 0 || open > 23 || close < 0 || close > 23)
    {
        //qDebug() << "parse not valid";
        m_openingHours.append(QTime(0, 0, 0, 0));
        m_closingHours.append(QTime(0, 0, 0, 0));
    }
    else
    {
        //qDebug() << "parse OK?";
        m_openingHours.append(QTime(open, openmin, 0, 0));
        m_closingHours.append(QTime(close, closemin, 0, 0));
    }

    return;
}

QString Spot::name() const
{
    //qDebug() << "SpotName";
    return m_name;
}

QString Spot::address() const
{
    return m_address;
}

QString Spot::postcode() const
{
    return m_postcode;
}

QString Spot::city() const
{
    return m_city;
}

QString Spot::phone() const
{
    return m_phone;
}

QString Spot::email() const
{
    return m_email;
}

QString Spot::additionalInfo() const
{
    return m_additionalInfo;
}

qreal Spot::latitude() const
{
    return m_latitude;
}

qreal Spot::longitude() const
{
    return m_longitude;
}
qreal Spot::distance() const
{
    return m_distance;
}

QString Spot::storeId() const
{
    return m_storeId;
}

void Spot::setDistance(qreal amount)
{
    m_distance = amount;
}

QTime Spot::opens(int day) const
{
    if(day < 1 || day > m_openingHours.size()) return QTime(0,0,0,0);

    return m_openingHours[day-1];
}

QTime Spot::closes(int day) const
{
    if(day < 1 || day > m_closingHours.size()) return QTime(0,0,0,0);

    return m_closingHours[day-1];
}
