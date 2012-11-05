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
    // format for Uimaan is: Imatra;Ukonlinnan rantauimala;61.206688969;28.722762284
    m_name = data.section(SEPARATOR, 1, 1);
    m_address = data.section(SEPARATOR, 0, 0);
    m_latitude = data.section(SEPARATOR, 2, 2).toFloat();
    m_longitude = data.section(SEPARATOR, 3, 3).toFloat();

    return true;
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

