import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.sensors 1.1

Page {
    id: mainPage
    orientationLock: PageOrientation.LockPortrait
    tools: commonTools
    state: "noPosition"



    onStatusChanged: {
        //enable map button after returning to page
        if(status === PageStatus.Active) mapButton.enabled = true
    }


    states: [
        State {
            name: "noPosition"
            when: !spot.positionFound && !spotSelectedWithoutLocation
            PropertyChanges { target: titleText; opacity: 0.0}
            PropertyChanges { target: mapButton; opacity: 0.0}
            PropertyChanges { target: infoButton; opacity: 0.0}
            PropertyChanges { target: distanceText; opacity: 0.0}
            PropertyChanges { target: nameText; text: "Haetaan sijaintiasi..."}
            PropertyChanges { target: addressText; text: "Voit myös valita uimapaikan valikosta"}
            PropertyChanges { target: timer; running: false}
        },
        State {
            name: "noPositionSpotSelected"
            when: !spot.positionFound && spotSelectedWithoutLocation
            PropertyChanges { target: titleText; opacity: 1.0}
            PropertyChanges { target: addressText; opacity: 1.0}
            PropertyChanges { target: mapButton; opacity: 1.0}
            PropertyChanges { target: infoButton; opacity: 1.0}
            PropertyChanges { target: distanceText; opacity: 0.0}
            PropertyChanges { target: nameText; text: spot.name}
            PropertyChanges { target: addressText; text: spot.address}
            PropertyChanges { target: timer; running: true}
        },
        State {
            name: "Position"
            when: spot.positionFound
            PropertyChanges { target: titleText; opacity: 1.0}
            PropertyChanges { target: addressText; opacity: 1.0}
            PropertyChanges { target: mapButton; opacity: 1.0}
            PropertyChanges { target: infoButton; opacity: 1.0}
            PropertyChanges { target: distanceText; opacity: 1.0}
            PropertyChanges { target: nameText; text: spot.name}
            PropertyChanges { target: addressText; text: spot.address}
            PropertyChanges { target: timer; running: true}
        }

    ]

    Timer {
        id: timer
        interval: 200
        repeat: true
        running: false

        onTriggered: {

            if (spot.positionFound) {
                // update compass pointer
                if (compassEnabled) {
                    compassPointer.angle = -compassAzimuth + spot.azimuth + 270
                }

                if (spot.distance >= 1000)
                {
                    distanceText.text = Math.round(spot.distance/1000) + " km"
                    logoAnimation.running = false
                }
                else
                {
                    distanceText.text = Math.round(spot.distance) + " m"
                }
            }

        }
    }





    Image {
        anchors.fill: parent
        source: "qrc:/common/woodenwall.jpg"
        fillMode: Image.Stretch
    }


    Image {
        id: logo
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        width: 260
        height: 260
        source: "qrc:/common/buoy.png"
        rotation: compassPointer.angle

    }

    Column {
        anchors.centerIn: logo
        spacing: 10

        Text {
            id: distanceText
            color: spotRed
            text: ""
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter


            font.family: "Nokia Pure Text"
            horizontalAlignment: Text.AlignHCenter
            opacity: 0.0

            SequentialAnimation {
                id: distanceTextAnimation
                alwaysRunToEnd: true
                running: false
                loops: 1

                NumberAnimation { target: titleText; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
                NumberAnimation { target: titleText; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
            }
        }

        Text {
            id: waterTemperatureText
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Vesi: " + spot.waterTemperature + " °C"
            font.family: "Nokia Pure Text"
            color: spotRed
            font.pixelSize: 20
            visible: spot.temperatureDataAvailable

            onTextChanged: waterTemperatureTextAnimation.restart()

            SequentialAnimation {
                id: waterTemperatureTextAnimation
                alwaysRunToEnd: true
                running: false
                loops: 1

                NumberAnimation { target: waterTemperatureText; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
                NumberAnimation { target: waterTemperatureText; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
            }
        }
    }

    MouseArea {
        anchors.fill: logo
        onClicked: {
            pageStack.push(Qt.resolvedUrl("InfoPage.qml"))
        }
    }

    CompassPointer {
        id: compassPointer
        x: logo.x + logo.width/2
        y: logo.y + logo.height/2
        radius: logo.width / 2 + 15
        running: true
        opacity: compassEnabled && spot.positionFound

        SequentialAnimation {
            id: compassPointerAnimation
            alwaysRunToEnd: true
            running: false
            loops: 1

            PauseAnimation { duration: 3000 }
            NumberAnimation { target: compassPointer; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
            NumberAnimation { target: compassPointer; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
        }
    }



    Rectangle {
        id: sign

        anchors.left: parent.left
        anchors.top: titleText.top
        anchors.topMargin: -10
        anchors.bottom: addressText.bottom
        anchors.bottomMargin: -10
        width: parent.width
        color: "black"
        opacity: 0.7

    }




    Text {
        id: titleText
        text: nearest ? "Lähin uimapaikka:" : "Valitsemasi uimapaikka:"
        font.family: "Nokia Pure Text"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 20
        //font.pointSize: 22
        font.pixelSize: 28
        opacity: 0.0
        color: "white"

        onTextChanged: titleTextAnimation.restart()

        SequentialAnimation {
            id: titleTextAnimation
            alwaysRunToEnd: true
            running: false
            loops: 1

            NumberAnimation { target: titleText; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
            NumberAnimation { target: titleText; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
        }
    }

    Text {
        id: nameText

        text: "Haetaan sijantiasi.."
        font.pixelSize: 28
        anchors { top: titleText.bottom; topMargin: 0 }
        width: parent.width
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        elide: Text.ElideRight
        maximumLineCount: 2
        wrapMode: Text.WordWrap
        color: "white"

        onTextChanged: {
            nameTextAnimation.restart()
            addressTextAnimation.restart()
            compassPointerAnimation.restart()
        }

        SequentialAnimation {
            id: nameTextAnimation
            alwaysRunToEnd: true
            running: false
            loops: 1

            NumberAnimation { target: nameText; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
            NumberAnimation { target: nameText; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
        }


    }

    Text {
        id: addressText

        text: "" //spot.address
        //font.pointSize: 16
        font.pixelSize: 22
        anchors.top: nameText.bottom
        anchors.topMargin: 2
        font.family: "Nokia Pure Text"
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 1.0
        color: "white"



        SequentialAnimation {
            id: addressTextAnimation
            alwaysRunToEnd: true
            running: false
            loops: 1

            PauseAnimation { duration: 100 }
            NumberAnimation { target: addressText; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
            NumberAnimation { target: addressText; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
        }
    }



    Row {
        anchors {top: addressText.bottom; topMargin: 36; horizontalCenter: parent.horizontalCenter}
        spacing: 20

        Button {
            id: mapButton
            text: "Näytä kartalla"
            iconSource: enabled ? "map.svg" : "empty.svg"
            opacity: 0.0
            //            platformInverted: true
            enabled: true

            onClicked: {
                mapButton.enabled = false //to prevent multiple presses
                pageStack.push(Qt.resolvedUrl("MapPage.qml"))

            }

            BusyIndicator {
                id: mapBusyIndicator
                anchors { top: parent.top; topMargin: 4; horizontalCenter: parent.horizontalCenter }
                width: 30
                height: 30
                running: !mapButton.enabled
                visible: running
            }

        }


        Button {
            id: infoButton
            text: "Säätila"
            iconSource: "information_userguide.svg"
            opacity: 0.0
            width: mapButton.width
            //platformInverted: true
            enabled: mapButton.enabled

            onClicked: pageStack.push(Qt.resolvedUrl("InfoPage.qml"))
        }

    }


    ToolBarLayout {
        id: commonTools
        visible: true

        ToolButton {
            iconSource: "close_stop.svg"
            onClicked: Qt.quit()
        }

        ToolButton {
            id: nearestButton
            text: nearest ? "Päivitä" : "Etsi lähin"
            iconSource: "toolbar-refresh"
            enabled: spot.positionFound && mapButton.enabled

            onClicked: {
                spot.sortByLocation()
                spot.selectSpot(0)
                nearest = true;
            }
        }

        ToolButton {
            iconSource: "toolbar-menu"
            enabled: mapButton.enabled
            onClicked: menu.open()
        }


    }

    Image {
        id: topLeftCorner
        anchors { top: parent.top; left: parent.left }
        source: "qrc:/corner.png"
    }

    Image {
        id: topRightCorner
        anchors { top: parent.top; right: parent.right }
        source: "qrc:/corner.png"
        rotation: 90
    }


    Menu {
        id: menu
        MenuLayout {
            MenuItem {
                text: "Valitse toinen uimapaikka"
                enabled: mapButton.enabled
                onClicked: {
                    spot.sortByLocation()
                    pageStack.push(Qt.resolvedUrl("SelectPage.qml"))
                }
            }
            MenuItem {
                text: "Tietoja ohjelmasta"
                enabled: mapButton.enabled
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

        }
    }


}
