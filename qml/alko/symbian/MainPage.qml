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
            when: !alko.positionFound && !alkoSelectedWithoutLocation
            PropertyChanges { target: titleText; opacity: 0.0}
            PropertyChanges { target: timeText; opacity: 0.0}
            PropertyChanges { target: mapButton; opacity: 0.0}
            PropertyChanges { target: infoButton; opacity: 0.0}
            PropertyChanges { target: distanceText; opacity: 0.0}
            PropertyChanges { target: nameText; text: "Haetaan sijaintiasi..."}
            PropertyChanges { target: addressText; text: "Jos on kiire, valitse uimapaikka valikosta"}
            PropertyChanges { target: timer; running: false}
        },
        State {
            name: "noPositionAlkoSelected"
            when: !alko.positionFound && alkoSelectedWithoutLocation
            PropertyChanges { target: titleText; opacity: 1.0}
            PropertyChanges { target: addressText; opacity: 1.0}
            PropertyChanges { target: timeText; opacity: 0.0}
            PropertyChanges { target: mapButton; opacity: 1.0}
            PropertyChanges { target: infoButton; opacity: 1.0}
            PropertyChanges { target: distanceText; opacity: 0.0}
            PropertyChanges { target: nameText; text: alko.name}
            PropertyChanges { target: addressText; text: alko.address}
            PropertyChanges { target: timer; running: true}
        },
        State {
            name: "Position"
            when: alko.positionFound
            PropertyChanges { target: titleText; opacity: 1.0}
            PropertyChanges { target: addressText; opacity: 1.0}
            PropertyChanges { target: timeText; opacity: 0.0}
            PropertyChanges { target: mapButton; opacity: 1.0}
            PropertyChanges { target: infoButton; opacity: 1.0}
            PropertyChanges { target: distanceText; opacity: 1.0}
            PropertyChanges { target: nameText; text: alko.name}
            PropertyChanges { target: addressText; text: alko.address}
            PropertyChanges { target: timer; running: true}
        }

    ]

    Timer {
        id: timer
        interval: 200
        repeat: true
        running: false

        onTriggered: {

            if (alko.positionFound) {
                // update compass pointer
                if (compassEnabled) {
                    compassPointer.angle = -compassAzimuth + alko.azimuth + 270
                }

                if (alko.distance >= 1000)
                {
                    distanceText.text = Math.round(alko.distance/1000) + " km"
                    logoAnimation.running = false
                }
                else
                {
                    distanceText.text = Math.round(alko.distance) + " m"
                }
            }

            timeText.text = alko.openStatus

        }
    }





    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }


    Image {
        id: logo
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 200
        source: "qrc:/alkoon_logo.png"

        property int animationPace: 900

        SequentialAnimation {
            id: logoAnimation
            running: false
            alwaysRunToEnd: true
            loops: Animation.Infinite

            NumberAnimation { target: logo; property: "scale"; from: 1.0; to: 1.05; duration: logo.animationPace }
            NumberAnimation { target: logo; property: "scale"; from: 1.05; to: 1.0; duration: logo.animationPace }
        }
    }

    Text {
        id: distanceText
        color: alkoRed
        text: ""
        font.pixelSize: 20
        anchors.bottom: logo.bottom
        anchors.bottomMargin: 17
        anchors.horizontalCenter: logo.horizontalCenter
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

    CompassPointer {
        id: compassPointer
        x: logo.x + logo.width/2
        y: logo.y + logo.height/2
        radius: logo.width / 2 + 15
        running: true
        opacity: compassEnabled && alko.positionFound

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

        onTextChanged: {
            nameTextAnimation.restart()
            addressTextAnimation.restart()
            timeTextAnimation.restart()
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

        text: "" //alko.address
        //font.pointSize: 16
        font.pixelSize: 18
        anchors.top: nameText.bottom
        anchors.topMargin: 2
        font.family: "Nokia Pure Text"
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 1.0



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

    Text {
        id: timeText
        text: ""
        color: alko.isOpen ? alkoGreen : alkoRed
        anchors.horizontalCenter: parent.horizontalCenter
        //font.pointSize: 26
        font.pixelSize: 28
        anchors.top: addressText.bottom
        anchors.topMargin: 2
        font.family: "Nokia Pure Text"
        opacity: 0.0

        SequentialAnimation {
            id: timeTextAnimation
            alwaysRunToEnd: true
            running: false
            loops: 1

            PauseAnimation { duration: 200 }
            NumberAnimation { target: timeText; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
            NumberAnimation { target: timeText; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
        }

    }

    Row {
        anchors {top: timeText.bottom; topMargin: 26; horizontalCenter: parent.horizontalCenter}
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
            enabled: alko.positionFound && mapButton.enabled

            onClicked: {
                alko.sortByLocation()
                alko.selectAlko(0)
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
                    alko.sortByLocation()
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
