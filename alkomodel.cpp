#include "alkomodel.h"
#include <QDebug>

const char SEPARATOR = ';';

AlkoModel::AlkoModel()
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[AddressRole] = "address";
    setRoleNames(roles);

    initialize(":/uimapaikat.txt");
}

//bool AlkoModel::checkUpdateNeed()
//{
//    QFile file("log.txt");
//    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
//    {
//        qDebug() << "opening log failed";
//        return false;
//    }

//}



bool AlkoModel::initialize(QString filename)
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

        qDebug() << "AlkoModel::initialize line: " << line;

        //detect title lines, only accept valid for initializing
        if (line == "")  continue;
        //if (line.length() < 20) continue;
        if (!line.contains(SEPARATOR))  continue;
        if (line.section(SEPARATOR, 0, 0) == "Nimi")  continue;

        Alko* alko = new Alko(this);
        if (alko)
        {
            alko->initialize(line);
            m_alkos.append(alko);
            qDebug() << "AlkoModel::initialize appended " + m_alkos[m_alkos.length() - 1]->name();
        }
        else qDebug() << "Error creating Alko-object";

    }

    return true;

}

bool nameLessThan(const Alko *a1, const Alko *a2)
{
    //qDebug() << "AlkoModel::nameLessThan";
    return a1->name() < a2->name();
}

bool distanceLessThan(const Alko *a1, const Alko *a2)
{
    //qDebug() << "AlkoModel::distanceLessThan";
    return a1->distance() < a2->distance();
}

void AlkoModel::sortByLocation(QGeoCoordinate *location)
{
    if (m_alkos.length() <= 1) return;

    //update the locations of the list
    for (int i=0 ; i<m_alkos.length() ; i++ )
    {
        if (m_alkos[i])
        {
            m_alkos[i]->setDistance(location->distanceTo(QGeoCoordinate(m_alkos[i]->latitude(), m_alkos[i]->longitude())));
            m_alkos[i]->sortMode = Alko::SortByLocation;
            //qDebug() << "AlkoModel::sortByLocation setting distance: " + m_alkos[i]->name() + "/" + QString::number(m_alkos[i]->distance());
        }
    }

    qSort(m_alkos.begin(), m_alkos.end(), distanceLessThan);

    //notify the view that whole model has been updated
    emit dataChanged(index(0, 0, QModelIndex()), index(m_alkos.length() - 1, 0, QModelIndex()));

    return;
}

void AlkoModel::sortByName()
{
    if (m_alkos.length() <= 1) return;

    //update the locations of the list
    for (int i=0 ; i<m_alkos.length() ; i++ )
    {
        if (m_alkos[i])
        {
            //qDebug() << "AlkoModel::sortByName";
            m_alkos[i]->sortMode = Alko::SortByName;
        }
    }

    qSort(m_alkos.begin(), m_alkos.end(), nameLessThan);

    //notify the view that whole model has been updated
    emit dataChanged(index(0, 0, QModelIndex()), index(m_alkos.length() - 1, 0, QModelIndex()));

    return;
}

Alko* AlkoModel::alkoAt(int index)
{
    //qDebug() << "AlkoModel::alkoAt";
    if (index >= m_alkos.length()) {
        qDebug() << "AlkoModel::alkoAt invalid index";
        return NULL;
    }
    return m_alkos[index];
}

void AlkoModel::updateInfo(Alko *newInfo)
{
    foreach(Alko* oldInfo, m_alkos)
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
int AlkoModel::rowCount(const QModelIndex &parent) const
{
    //qDebug() << "AlkoModel::rowCount";
    return m_alkos.count();
}

QVariant AlkoModel::data(const QModelIndex &index, int role) const
{
    //qDebug() << "AlkoModel::data";

    //Check if QList item's index is valid before access it, index should be between 0 and count - 1
    if (index.row() < 0 || index.row() >= m_alkos.count()) {
        return QVariant();
    }

    const Alko *alko = m_alkos[index.row()];

    if (role == NameRole) {
        //qDebug() << "AlkoModel::data about to return " << alko->name();
        return alko->name();
}
        else if (role == AddressRole) {
        //qDebug() << "AlkoModel::data about to return " << alko->address();
        return alko->address();
    }

    qDebug() << "AlkoModel::data returned empty";
    return QVariant();


}
