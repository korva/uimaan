import QtQuick 1.1
import com.nokia.meego 1.0
import "Storage.js" as Storage

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait
    tools: aboutTools

    Image {
        anchors.fill: parent
        source: "qrc:/common/woodenwall_light.jpg"


    }

    Label {
        id: label1
        anchors {top: parent.top; topMargin: 6; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 34
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        text: "Uimaan v1.0"
        color: spotRed
    }

    Label {
        id: label2
        anchors {top: label1.bottom; topMargin: 4; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 20
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.RichText
        text: "by Jaakko Koskenkorva<br><a href=11latoa.com>11latoa.com</a>"

        Rectangle {
            id: shader
            anchors.fill: parent
            color: "black"
            radius: 10
            opacity: label2marea.pressed ? 0.4 : 0.0
        }


        MouseArea {
            id: label2marea
            anchors.fill: parent
            onClicked: Qt.openUrlExternally("http://11latoa.com")
        }
    }



    Label {
        id: label3
        anchors {top: label2.bottom; topMargin: 12; left: parent.left; leftMargin: 4; right: parent.right; rightMargin: 4 }
        font.pixelSize: 26
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        text: "Löydä lähin uimapaikka. Helposti!"
    }

    Label {
        id: label4
        anchors {top: label3.bottom; topMargin: 12; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 22
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.RichText
        text: "Tiedot uimapaikoista ovat peräisin OIVA - Ympäristö- ja paikkatietopalvelusta. (c) Valtion ympäristöhallinnon virastot."


    }

    Button {
        id: button4
        anchors { top: label4.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
        text: "Avaa Oiva -sivusto"
        onClicked: Qt.openUrlExternally("http://wwwp2.ymparisto.fi/scripts/oiva.asp")
    }



    Label {
        id: label6
        anchors {top: button4.bottom; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 22
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.RichText
        text: "Jos pidit sovelluksesta, käythän arvostelemassa sen Nokia Storessa!"


    }

    Button {
        id: button6
        anchors { top: label6.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
        text: "Avaa Nokia Store"
        onClicked: Qt.openUrlExternally("http://store.ovi.com/content/301843")
    }

    Label {
        id: label7
        anchors {top: button6.bottom; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 22
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        text: "Kysyttävää, kommentteja, ehdotuksia, haukkuja? Lähetäthän palautetta."


    }

    Button {
        id: button7
        anchors { top: label7.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
        text: "Kirjoita palaute"
        onClicked: Qt.openUrlExternally("mailto:korva@ovi.com?subject=Uimaan/Palaute&body=Palautetta N9 versiosta 1.0:")
    }

    Row {
        id: row
        anchors {top: button7.bottom; topMargin: 20; horizontalCenter: parent.horizontalCenter }
        spacing: 20

        Switch {
            id: positionSwitch


            onCheckedChanged: {

                // allow position updates for this session, but not as default.
                if(checked) {
                    spot.locationEnabled = true
                }
                // block location updates as default too
                else {
                    spot.locationEnabled = false
                    Storage.initialize()
                    Storage.setSetting("locationEnabled",false);
                }
            }

            Component.onCompleted: checked = spot.locationEnabled
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 22
            font.family: "Nokia Pure Text"
            text: "Salli sijaintitietosi käyttäminen"
        }

    }

    Label {
        id: label8
        anchors {top: row.bottom; topMargin: 20; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 20
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        text: "Background image from http://fav.me/d1igijr \n Buoy image (c) VectorStock "


    }


    ToolBarLayout {
        id: aboutTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
    }


}


