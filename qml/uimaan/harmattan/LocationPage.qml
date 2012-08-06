import QtQuick 1.1
import com.nokia.meego 1.0
import "Storage.js" as Storage

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait

    Image {
        anchors.fill: parent
        source: "qrc:/common/woodenwall_light.jpg"
    }

    Column {
        anchors.centerIn: parent
        spacing: 16

        width: parent.width

        Label {

            anchors.margins: 6
            width: parent.width
            text: "Saako Uimaan käyttää nykyistä sijaintiasi?"
            font.family: "Nokia Pure Text"
            font.pixelSize: 30
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
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
                Storage.initialize()
                Storage.setSetting("locationEnabled",true);
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
