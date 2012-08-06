import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.sensors 1.1

Page {
    id: mainPage
    orientationLock: PageOrientation.LockPortrait
    tools: commonTools
    //state: "noPosition"



    onStatusChanged: {
        //enable map button after returning to page
        if(status === PageStatus.Active) mapButton.enabled = true
    }

    Timer {
        id: timer
        interval: 200
        repeat: true
        running: spot.positionFound

        onTriggered: {

            if (spot.positionFound) {
                // update compass pointer
                if (compassEnabled) {
                    compassPointer.angle = -compassAzimuth + spot.azimuth + 270
                }

                if (spot.distance >= 1000)
                {
                    distanceText.text = Math.round(spot.distance/1000) + " km"
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
    }

    Image {
        id: logo
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        width: 330
        height: 330
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
            font.pixelSize: 30
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Nokia Pure Text"
            horizontalAlignment: Text.AlignHCenter
            visible: spot.positionFound

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
            font.pixelSize: 30
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
        visible: compassEnabled && spot.positionFound

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

    Image {
        id: aboutButton
        anchors { top: parent.top; topMargin: 18; right: parent.right; rightMargin: 18 }
        source: "qrc:/about.png"
        width: 50
        height: 50


        Rectangle {
            width: parent.width + 16
            height: parent.height + 16
            anchors.centerIn: parent
            color: "#105086"
            opacity: infoMouseArea.pressed ? 0.6 : 0.0
            radius: 12
        }

        MouseArea {
            id: infoMouseArea
            anchors.fill: parent
            onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
        }
    }

    Rectangle {
        id: sign

        anchors.left: parent.left
        anchors.top: titleText.visible ? titleText.top : nameText.top
        anchors.topMargin: -10
        anchors.bottom: addressText.text == "" ? nameText.bottom : addressText.bottom
        anchors.bottomMargin: -10
        width: parent.width
        color: "white"
        opacity: 0.5

    }

    Text {
        id: titleText
        text: nearest ? qsTr("Lähin uimapaikka:") : qsTr("Valitsemasi uimapaikka:")
        font.family: "Nokia Pure Text"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 30
        //font.pointSize: 22
        font.pixelSize: 34
        visible: spot.spotFound

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

        text: spot.spotFound ? spot.name : (spot.locationEnabled ? qsTr("Haetaan sijaintiasi...") : qsTr("Sijaintisi ei tiedossa"))
        font.pixelSize: 38
        anchors { top: titleText.bottom; topMargin: 0; left: parent.left; leftMargin: 4; right: parent.right; rightMargin: 4 }

        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight

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

        text: spot.spotFound ? spot.address : (spot.locationEnabled ? qsTr("Odota tai valitse uimapaikka valikosta") : qsTr("Valitse uimapaikka valikosta"))
        //font.pointSize: 16
        font.pixelSize: 24
        anchors.top: nameText.bottom
        anchors.topMargin: 2
        font.family: "Nokia Pure Text"
        anchors.horizontalCenter: parent.horizontalCenter




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


    Column {
        anchors {top: sign.bottom; topMargin: 30; left: parent.left; leftMargin: 30; right: parent.right; rightMargin: 30}
        spacing: 20

        Button {
            id: mapButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Näytä kartalla")
            iconSource: "image://theme/icon-s-location-picker"
            visible: spot.spotFound
            width: 260
            enabled: true

            onClicked: {
                mapButton.enabled = false //to prevent multiple presses
                pageStack.push(Qt.resolvedUrl("MapPage.qml"))
            }

        }


        Button {
            id: infoButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Säätiedot")
            iconSource: "image://theme/icon-s-description"
            visible: spot.spotFound
            width: mapButton.width

            onClicked: pageStack.push(Qt.resolvedUrl("InfoPage.qml"))
        }

    }






    ToolBarLayout {
        id: commonTools
        visible: false



        ButtonRow {
            id: buttonRow
            checkedButton: nearestButton

            TabButton {
                id: nearestButton
                text: qsTr("Etsi lähin")
                enabled: spot.positionFound

                onClicked: {
                    spot.sortByLocation()
                    spot.selectSpot(0)
                    nearest = true;
                }
            }

            TabButton {
                id: selectButton
                text: qsTr("Valitse...")

                onClicked: {
                    if (spot.positionFound) spot.sortByLocation()
                    else spot.sortByName()

                    pageStack.push(Qt.resolvedUrl("SelectPage.qml"))
                }
            }
        }



    }



}
