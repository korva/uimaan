import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait


    Image {
        anchors.fill: parent
        source: "qrc:/common/woodenwall_light.jpg"
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Saako Uimaan käyttää nykyistä sijaintiasi?"
            font.family: "Nokia Pure Text"
            font.pixelSize: 26
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Kyllä"
            onClicked: {
                spot.locationEnabled = true
                pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Kyllä, ja älä kysy enää"
            onClicked: {
                spot.locationEnabled = true
                // write to settings database
                pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ei nyt"
            onClicked: {
                pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
        }
    }


}
