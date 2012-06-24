import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait
    tools: infoTools

    onStatusChanged: {
        //enable map button after returning to page
        if(status === PageStatus.Active) mapButton.enabled = true
    }

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Titlebar {
        id: titleBar
        text: "Säätiedot"
    }

    Image {
        anchors { top: titleBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        fillMode: Image.Stretch
        source: "http://wwwi3.ymparisto.fi/i3/tilanne/fin/Lampotila/image/lampo.gif"
    }

//    Flickable {
//        id: infoFlickable
//        anchors { top: titleBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
//        contentWidth: parent.width
//        contentHeight: infoColumn.height + 50
//        flickableDirection: Flickable.VerticalFlick
//        clip: true

//        Column {
//            id: infoColumn
//            anchors { top: parent.top; topMargin: 16; left: parent.left; leftMargin: 6; right: parent.right }
//            spacing: 6

//            InfoLine {
//                title: "Liikkeen nimi:"
//                body: alko.name
//            }

//            InfoLine {
//                title: "Osoite:"
//                body: alko.address

//                Button {
//                    id: mapButton
//                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 3 }
//                    width: 100
//                    iconSource: "location_mark.svg"

//                    onClicked: {
//                        mapButton.enabled = false //to prevent multiple presses
//                        pageStack.push(Qt.resolvedUrl("MapPage.qml"))
//                    }

//                    BusyIndicator {
//                        id: mapBusyIndicator
//                        anchors { left: parent.left; leftMargin: 6; verticalCenter: parent.verticalCenter }
//                        width: 30
//                        height: 30
//                        running: !mapButton.enabled
//                        visible: running
//                    }
//                }

//            }

//            InfoLine {
//                title: "Postinumero ja -paikka:"
//                body: alko.postcode + " " + alko.city
//            }


//            InfoTimeLine {
//                day: "Maanantai"
//                time: alko.openStatusSimple(1);
//            }

//            InfoTimeLine {
//                day: "Tiistai"
//                time: alko.openStatusSimple(2);
//            }

//            InfoTimeLine {
//                day: "Keskiviikko"
//                time: alko.openStatusSimple(3);
//            }

//            InfoTimeLine {
//                day: "Torstai"
//                time: alko.openStatusSimple(4);
//            }

//            InfoTimeLine {
//                day: "Perjantai"
//                time: alko.openStatusSimple(5);
//            }

//            InfoTimeLine {
//                day: "Lauantai"
//                time: alko.openStatusSimple(6);
//            }

//            InfoLine {
//                title: "Puhelinnumero:"
//                body: alko.phone

//                Button {
//                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 3 }
//                    width: 100
//                    iconSource: "calling.svg"
//                    enabled: mapButton.enabled

//                    // trim whitespaces from phone number
//                    onClicked: Qt.openUrlExternally("tel:" + alko.phone.replace(/\s/g, ""))
//                }
//            }

//            InfoLine {
//                title: "Sähköposti:"
//                body: alko.email

//                Button {
//                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 3 }
//                    width: 100
//                    iconSource: "messaging.svg"
//                    enabled: mapButton.enabled

//                    onClicked: Qt.openUrlExternally("mailto:" + alko.email)
//                }
//            }

//            InfoLine {
//                title: "Muuta tietoa:"
//                body: alko.additionalInfo
//                opacity: alko.additionalInfo ? 1.0 : 0.0
//            }


//        }

//    }

    ToolBarLayout {
        id: infoTools
        visible: true
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }


}
