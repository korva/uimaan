import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait
    tools: infoTools

    Image {
        anchors.fill: parent
        source: "qrc:/common/woodenwall_light.jpg"
    }

    Titlebar {
        id: titleBar
        text: "Säätiedot"
    }

    BusyIndicator {
        anchors {top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }
        running: image.status == Image.Loading
        visible: running

    }

    Flickable {
        anchors { top: titleBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        contentHeight: column.height
        clip: true

        Column {
            id: column
            width: parent.width
            spacing: 10

            Label {
                id: data
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
                font.pixelSize: 20
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                text: spot.temperatureDataAvailable ? "Arvioitu veden lämpötila: " + spot.waterTemperature + " °C" : "Huomio: vesien lämpötilatietojen hakeminen ei onnistunut. Voit edelleen toki selata uimapaikkoja. Koita tarjeta :)"
                platformInverted: true
            }

            Label {
                id: location
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
                font.pixelSize: 20
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                text: spot.temperatureDataAvailable ? "Mittauspiste: " + spot.measurementLocation() : ""
                platformInverted: true
            }

            Label {
                id: label
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
                font.pixelSize: 20
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                text: "Huomio: ilmoitettu veden lämpötila on karkea arvio perustuen lähimpään mittaustulokseen Ympäristöhallinnon sivustolta."
                visible: spot.temperatureDataAvailable
                platformInverted: true

            }

            Label {
                id: label2
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
                font.pixelSize: 20
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                text: "Huomio: ilmoitettu veden lämpötila on karkea arvio perustuen lähimpään mittaustulokseen Ympäristöhallinnon sivustolta."
                platformInverted: true
            }

            Image {
                id: image
                width: parent.width
                fillMode: Image.Stretch
                source: "http://wwwi3.ymparisto.fi/i3/tilanne/fin/Lampotila/image/lampo.gif"

                onStatusChanged: {

                    if (status === Image.Ready)
                    {
                        label2.text = "Allaoleva kuva selvittää mittauspisteiden sijaintia.(c) Valtion ympäristöhallinto"

                    }
                }


            }
        }
    }

    ToolBarLayout {
        id: infoTools
        visible: true
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }


}
