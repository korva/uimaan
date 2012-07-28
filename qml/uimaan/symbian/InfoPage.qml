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
//                body: spot.name
//            }

//            InfoLine {
//                title: "Osoite:"
//                body: spot.address

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
//                body: spot.postcode + " " + spot.city
//            }


//            InfoTimeLine {
//                day: "Maanantai"
//                time: spot.openStatusSimple(1);
//            }

//            InfoTimeLine {
//                day: "Tiistai"
//                time: spot.openStatusSimple(2);
//            }

//            InfoTimeLine {
//                day: "Keskiviikko"
//                time: spot.openStatusSimple(3);
//            }

//            InfoTimeLine {
//                day: "Torstai"
//                time: spot.openStatusSimple(4);
//            }

//            InfoTimeLine {
//                day: "Perjantai"
//                time: spot.openStatusSimple(5);
//            }

//            InfoTimeLine {
//                day: "Lauantai"
//                time: spot.openStatusSimple(6);
//            }

//            InfoLine {
//                title: "Puhelinnumero:"
//                body: spot.phone

//                Button {
//                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 3 }
//                    width: 100
//                    iconSource: "calling.svg"
//                    enabled: mapButton.enabled

//                    // trim whitespaces from phone number
//                    onClicked: Qt.openUrlExternally("tel:" + spot.phone.replace(/\s/g, ""))
//                }
//            }

//            InfoLine {
//                title: "Sähköposti:"
//                body: spot.email

//                Button {
//                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 3 }
//                    width: 100
//                    iconSource: "messaging.svg"
//                    enabled: mapButton.enabled

//                    onClicked: Qt.openUrlExternally("mailto:" + spot.email)
//                }
//            }

//            InfoLine {
//                title: "Muuta tietoa:"
//                body: spot.additionalInfo
//                opacity: spot.additionalInfo ? 1.0 : 0.0
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
