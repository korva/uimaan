import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2

Page {

    tools: mapTools
    orientationLock: PageOrientation.LockPortrait

    function centerMap() {
        // hack to enable map update... :(
        map.center = userCoordinate
        map.zoomLevel = 15
        map.center = spotCoordinate
    }

    Coordinate {
        id: spotCoordinate
        latitude: spot.latitude
        longitude: spot.longitude
    }

    Coordinate {
        id: userCoordinate
        latitude: spot.currentLatitude
        longitude: spot.currentLongitude
    }





    Map {
        id: map
        anchors.fill: parent
        plugin : Plugin {
            name : "nokia"
        }
        size.width: parent.width
        size.height: parent.height
        zoomLevel: 15
        center: spotCoordinate

        MapImage {
            id: mapImage
            source: "qrc:/mapicon.png"
            coordinate: spotCoordinate
            offset.x: -width/2
            offset.y: -height/2
        }

//        MapText {
//            coordinate: spotCoordinate
////            offset.x: -width/2
////            offset.y: 40
//            color: spotRed
//            font.family: "Nokia Pure Text"
//            font.pixelSize: 24
//            text: spot.name
//            visible: map.zoomLevel > 12
//        }

        MapImage {
            source: "qrc:/usericon.png"
            coordinate: userCoordinate
            offset.x: -width/2
            offset.y: -height/2
            visible: spot.positionFound
        }


        MapMouseArea {
            property int lastX : -1
            property int lastY : -1

            onPressed : {
                lastX = mouse.x
                lastY = mouse.y
            }
            onReleased : {
                lastX = -1
                lastY = -1
            }
            onPositionChanged: {
                if (mouse.button == Qt.LeftButton) {
                    if ((lastX != -1) && (lastY != -1)) {
                        var dx = mouse.x - lastX
                        var dy = mouse.y - lastY
                        map.pan(-dx, -dy)
                    }
                    lastX = mouse.x
                    lastY = mouse.y
                }
            }
            onDoubleClicked: {
                map.center = mouse.coordinate
                map.zoomLevel += 1
                lastX = -1
                lastY = -1
            }
        }

        // add 20 nearest spots to map too
        Repeater {
            onItemAdded: {
                map.addMapObject(item)
                centerMap()
            }
            onItemRemoved: {
                //map.removeMapObject(item)
            }
            model: 0

            Component.onCompleted: if(nearest) model = 20

            SpotMapDelegate {
                lat: spot.latitudeAtIndex(index+1)
                lng: spot.longitudeAtIndex(index+1)
                spotIndex: index+1
            }


        }


    }

    Rectangle {
        id: mapZoomer
        anchors { bottom: parent.bottom; bottomMargin: 15; horizontalCenter: parent.horizontalCenter }
        width: 160
        height: 46
        radius: 20
        opacity: 0.8
        color: "black"

        Text {
            anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
            text: "-"
            color: "white"
            font.pixelSize: 34
        }

        Text {
            anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }
            text: "+"
            color: "white"
            font.pixelSize: 34
        }

        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: parent.width / 2
            radius: 30
            color: minusArea.pressed ? "grey" : "transparent"
        }

        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: parent.width / 2
            radius: 30
            color: plusArea.pressed ? "grey" : "transparent"
        }

        MouseArea {
            id: minusArea
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: parent.width / 2

            onClicked: map.zoomLevel -= 1
        }

        MouseArea {
            id: plusArea
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: parent.width / 2

            onClicked: map.zoomLevel += 1
        }


    }


    ToolBarLayout {
        id: mapTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: {
                pageStack.pop()
            }
        }

        ToolIcon {
            iconSource: "image://theme/icon-s-location-picker"
            onClicked: {
                centerMap()
            }
        }


        ToolIcon {
            iconSource: "image://theme/icon-s-common-drive"
            onClicked: mapsDialog.open()
        }


    }

    Component.onCompleted: centerMap()


    QueryDialog {
        id: mapsDialog
        titleText: "Avaa Kartat?"
        message: "Avataanko Nokia Kartat navigointia varten?\n\nVoit palata tänne avoimien sovellusten listasta."
        rejectButtonText: "Ei"
        acceptButtonText: "Kyllä"

        onAccepted: {
            spot.launchMaps()
        }

    }


}
