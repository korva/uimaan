import QtQuick 1.1
import com.nokia.meego 1.0

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
                font.pixelSize: 26
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                textFormat: Text.RichText
                text: spot.temperatureDataAvailable ? "Arvioitu veden lämpötila: " + spot.waterTemperature + " °C" : "Huomio: vesien lämpötilatietojen hakeminen ei onnistunut. Voit edelleen toki selata uimapaikkoja. Koita tarjeta :)"

            }

            Label {
                id: location
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
                font.pixelSize: 26
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                textFormat: Text.RichText
                text: spot.temperatureDataAvailable ? "Mittauspiste: " + spot.measurementLocation() : ""

            }

            Label {
                id: label
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
                font.pixelSize: 26
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                textFormat: Text.RichText
                text: "Huomio: ilmoitettu veden lämpötila on karkea arvio perustuen lähimpään mittaustulokseen Ympäristöhallinnon sivustolta."
                visible: spot.temperatureDataAvailable

            }

            Label {
                id: label2
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
                font.pixelSize: 26
                font.family: "Nokia Pure Text"
                horizontalAlignment: Text.AlignLeft
                textFormat: Text.RichText
                text: "Huomio: ilmoitettu veden lämpötila on karkea arvio perustuen lähimpään mittaustulokseen Ympäristöhallinnon sivustolta."

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
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
    }


}
