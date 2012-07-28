import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait
    tools: infoTools

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Titlebar {
        id: titleBar
        text: "Tarkemmat tiedot myymälästä"
    }

    Flickable {
        id: infoFlickable
        anchors { top: titleBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        contentWidth: parent.width
        contentHeight: infoColumn.height + 50
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Column {
            id: infoColumn
            anchors { top: parent.top; topMargin: 16; left: parent.left; leftMargin: 6; right: parent.right }
            spacing: 12

            InfoLine {
                title: "Liikkeen nimi:"
                body: spot.name
            }

            InfoLine {
                title: "Osoite:"
                body: spot.address

                Button {
                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 7 }
                    width: 100
                    iconSource: "image://theme/icon-s-location-picker"

                    onClicked: pageStack.push(Qt.resolvedUrl("MapPage.qml"))
                }

            }

            InfoLine {
                title: "Postinumero ja -paikka:"
                body: spot.postcode + " " + spot.city
            }


            InfoTimeLine {
                day: "Maanantai"
                time: spot.openStatusSimple(1);
            }

            InfoTimeLine {
                day: "Tiistai"
                time: spot.openStatusSimple(2);
            }

            InfoTimeLine {
                day: "Keskiviikko"
                time: spot.openStatusSimple(3);
            }

            InfoTimeLine {
                day: "Torstai"
                time: spot.openStatusSimple(4);
            }

            InfoTimeLine {
                day: "Perjantai"
                time: spot.openStatusSimple(5);
            }

            InfoTimeLine {
                day: "Lauantai"
                time: spot.openStatusSimple(6);
            }

            InfoLine {
                title: "Puhelinnumero:"
                body: spot.phone

                Button {
                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 7 }
                    width: 100
                    iconSource: "image://theme/icon-s-call"

                    // trim whitespaces from phone number
                    onClicked: Qt.openUrlExternally("tel:" + spot.phone.replace(/\s/g, ""))
                }
            }

            InfoLine {
                title: "Sähköposti:"
                body: spot.email

                Button {
                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter; verticalCenterOffset: 7 }
                    width: 100
                    iconSource: "image://theme/icon-s-email"

                    onClicked: Qt.openUrlExternally("mailto:" + spot.email)
                }
            }

            InfoLine {
                title: "Muuta tietoa:"
                body: spot.additionalInfo
                opacity: spot.additionalInfo ? 1.0 : 0.0
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
