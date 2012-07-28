#include "spotmodel.h"
#include <QDebug>

const char SEPARATOR = ';';

SpotModel::SpotModel()
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[AddressRole] = "address";
    setRoleNames(roles);

    initialize(":/uimapaikat.txt");
}

//bool SpotModel::checkUpdateNeed()
//{
//    QFile file("log.txt");
//    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
//    {
//        qDebug() << "opening log failed";
//        return false;
//    }

//}



bool SpotModel::initialize(QString filename)
{

    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug() << "opening file failed";
        return false;
    }

    QTextStream in(&file);
    in.setCodec("ISO 8859-1 to 10"); // the right one
    //in.setCodec("Windows-1250 to 1258");

    while (!in.atEnd()) {
        QString line = in.readLine().toLatin1();
        //QString line = in.readLine().toUtf8();

        //qDebug() << "SpotModel::initialize line: " << line;

        //detect title lines, only accept valid for initializing
        if (line == "")  continue;
        //if (line.length() < 20) continue;
        if (!line.contains(SEPARATOR))  continue;
        if (line.section(SEPARATOR, 0, 0) == "Nimi")  continue;

        Spot* spot = new Spot(this);
        if (spot)
        {
            spot->initialize(line);
            m_spots.append(spot);
            //qDebug() << "SpotModel::initialize appended " + m_spots[m_spots.length() - 1]->name();
        }
        else qDebug() << "Error creating Spot-object";

    }

    return true;

}

bool nameLessThan(const Spot *a1, const Spot *a2)
{
    //qDebug() << "SpotModel::nameLessThan";
    return a1->name() < a2->name();
}

bool distanceLessThan(const Spot *a1, const Spot *a2)
{
    //qDebug() << "SpotModel::distanceLessThan";
    return a1->distance() < a2->distance();
}

void SpotModel::sortByLocation(QGeoCoordinate *location)
{
    if (m_spots.length() <= 1) return;

    //update the locations of the list
    for (int i=0 ; i<m_spots.length() ; i++ )
    {
        if (m_spots[i])
        {
            m_spots[i]->setDistance(location->distanceTo(QGeoCoordinate(m_spots[i]->latitude(), m_spots[i]->longitude())));
            m_spots[i]->sortMode = Spot::SortByLocation;
            //qDebug() << "SpotModel::sortByLocation setting distance: " + m_spots[i]->name() + "/" + QString::number(m_spots[i]->distance());
        }
    }

    qSort(m_spots.begin(), m_spots.end(), distanceLessThan);

    //notify the view that whole model has been updated
    emit dataChanged(index(0, 0, QModelIndex()), index(m_spots.length() - 1, 0, QModelIndex()));

    return;
}

void SpotModel::sortByName()
{
    if (m_spots.length() <= 1) return;

    //update the locations of the list
    for (int i=0 ; i<m_spots.length() ; i++ )
    {
        if (m_spots[i])
        {
            //qDebug() << "SpotModel::sortByName";
            m_spots[i]->sortMode = Spot::SortByName;
        }
    }

    qSort(m_spots.begin(), m_spots.end(), nameLessThan);

    //notify the view that whole model has been updated
    emit dataChanged(index(0, 0, QModelIndex()), index(m_spots.length() - 1, 0, QModelIndex()));

    return;
}

Spot* SpotModel::spotAt(int index)
{
    //qDebug() << "SpotModel::spotAt";
    if (index >= m_spots.length()) {
        qDebug() << "SpotModel::spotAt invalid index";
        return NULL;
    }
    return m_spots[index];
}

void SpotModel::updateInfo(Spot *newInfo)
{
    foreach(Spot* oldInfo, m_spots)
    {
        if (oldInfo->storeId() == newInfo->storeId())
        {
            continue;
        }
        else
        {
            qDebug() << "No match for " << newInfo->storeId() << " / " << newInfo->name();
            return;
        }
    }

    //update values
}

// From QAbstractListModel
int SpotModel::rowCount(const QModelIndex &parent) const
{
    //qDebug() << "SpotModel::rowCount";
    return m_spots.count();
}

QVariant SpotModel::data(const QModelIndex &index, int role) const
{
    //qDebug() << "SpotModel::data";

    //Check if QList item's index is valid before access it, index should be between 0 and count - 1
    if (index.row() < 0 || index.row() >= m_spots.count()) {
        return QVariant();
    }

    const Spot *spot = m_spots[index.row()];

    if (role == NameRole) {
        //qDebug() << "SpotModel::data about to return " << spot->name();
        return spot->name();
}
        else if (role == AddressRole) {
        //qDebug() << "SpotModel::data about to return " << spot->address();
        return spot->address();
    }

    qDebug() << "SpotModel::data returned empty";
    return QVariant();


}
