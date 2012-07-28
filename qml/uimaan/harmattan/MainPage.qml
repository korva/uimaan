import QtQuick 1.1
import com.nokia.meego 1.0
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
            PropertyChanges { target: timeText; opacity: 0.0}
            PropertyChanges { target: mapButton; opacity: 0.0}
            PropertyChanges { target: infoButton; opacity: 0.0}
            PropertyChanges { target: distanceText; opacity: 0.0}
            PropertyChanges { target: nameText; text: qsTr("waiting_location")}
            PropertyChanges { target: addressText; text: qsTr("select_shop")}
            PropertyChanges { target: timer; running: false}
        },
        State {
            name: "noPositionSpotSelected"
            when: !spot.positionFound && spotSelectedWithoutLocation
            PropertyChanges { target: titleText; opacity: 1.0}
            PropertyChanges { target: addressText; opacity: 1.0}
            PropertyChanges { target: timeText; opacity: 1.0}
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
            PropertyChanges { target: timeText; opacity: 1.0}
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

            timeText.text = spot.openStatus

        }
    }





    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }


    Image {
        id: logo
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        width: 300
        height: 300
        source: "qrc:/common/buoy.png"

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
        color: spotRed
        text: ""
        //font.pixelSize: 28
        font.pixelSize: 30
        anchors.bottom: logo.bottom
        anchors.bottomMargin: 25
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

    Image {
        id: aboutButton
        anchors { top: parent.top; topMargin: 18; right: parent.right; rightMargin: 18 }
        source: "qrc:/about.png"
        scale: 1.2

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

    Text {
        id: titleText
        text: nearest ? qsTr("nearest_spot") : qsTr("chosen_spot")
        font.family: "Nokia Pure Text"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 30
        //font.pointSize: 22
        font.pixelSize: 34
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

        text: qsTr("waiting_location")
        font.pixelSize: 38
        anchors { top: titleText.bottom; topMargin: 0; left: parent.left; leftMargin: 4; right: parent.right; rightMargin: 4 }

        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        elide: Text.ElideRight

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

        text: "" //spot.address
        //font.pointSize: 16
        font.pixelSize: 24
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
        color: spot.isOpen ? spotGreen : spotRed
        anchors.horizontalCenter: parent.horizontalCenter
        //font.pointSize: 26
        font.pixelSize: 34
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

    Column {
        anchors {top: timeText.bottom; topMargin: 26; left: parent.left; leftMargin: 30; right: parent.right; rightMargin: 30}
        spacing: 20

        Button {
            id: mapButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("show_on_map")
            iconSource: "image://theme/icon-s-location-picker"
            opacity: 0.0
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
            text: qsTr("spot_info")
            iconSource: "image://theme/icon-s-description"
            opacity: 0.0
            width: mapButton.width

            onClicked: pageStack.push(Qt.resolvedUrl("InfoPage.qml"))
        }

    }




    //    Text {
    //        id: headingText
    //        color: "#E63D2C"
    //        text: "x"
    //        font.pixelSize: 18
    //        anchors.top: parent.top
    //        anchors.topMargin: 15
    //        font.family: "Nokia Pure Text"
    //        horizontalAlignment: Text.AlignHCenter
    //    }

    //    Text {
    //        id: distanceDebugText
    //        color: "#E63D2C"
    //        text: "y"
    //        font.pixelSize: 18
    //        anchors.top: headingText.bottom
    //        anchors.topMargin: 3
    //        font.family: "Nokia Pure Text"
    //        horizontalAlignment: Text.AlignHCenter
    //    }

    //    Text {
    //        id: statusText
    //        color: "#E63D2C"
    //        text: spot.positionFound
    //        font.pixelSize: 18
    //        anchors.top: distanceDebugText.bottom
    //        anchors.topMargin: 3
    //        font.family: "Nokia Pure Text"
    //        horizontalAlignment: Text.AlignHCenter
    //    }

    ToolBarLayout {
        id: commonTools
        visible: true

        //        ToolIcon {
        //            id: catalogButton
        //            iconId: "toolbar-search"

        //            onClicked: {
        //                pageStack.push(Qt.resolvedUrl("ProductSearchPage.qml"))
        //            }

        //        }

        ButtonRow {
            id: buttonRow
            checkedButton: nearestButton

            TabButton {
                id: nearestButton
                text: qsTr("nearest_spot_button")
                enabled: spot.positionFound

                onClicked: {
                    spot.sortByLocation()
                    spot.selectSpot(0)
                    nearest = true;
                }
            }

            TabButton {
                id: selectButton
                text: qsTr("select_spot_button")

                onClicked: {
                    spot.sortByLocation()
                    pageStack.push(Qt.resolvedUrl("SelectPage.qml"))
                }
            }
        }

        //        ToolIcon {
        //            iconId: "toolbar-view-menu"
        //            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        //        }

    }


}
