// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.location 1.2

MapImage {
    property alias lat: coord.latitude
    property alias lng: coord.longitude
    property int spotIndex: -1

    source: "qrc:/mapicon.png"

    coordinate: Coordinate {
        id: coord

    }

    offset.x: -width/2
    offset.y: -height/2

    MapMouseArea {
        anchors.fill: parent
        onClicked: {
            if(spotIndex !== -1) {

                spot.selectSpot(spotIndex)
                nearest = false
                pageStack.pop()
            }
        }
    }


}

