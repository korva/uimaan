import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: productPage
    orientationLock: PageOrientation.LockPortrait
    tools: productTools

    property string productId: "004551"

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Titlebar {
        id: titleBar
        text: "Caballo de Mendoza (esimerkkisivu)"
    }


    Flickable {
        id: productFlickable
        anchors { top: titleBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        contentWidth: parent.width
        contentHeight: productImage.height + productColumn.height + 50
        flickableDirection: Flickable.VerticalFlick
        clip: true


        Image {
            id:productImage
            anchors { top: parent.top; topMargin: 6; horizontalCenter: parent.horizontalCenter}
            source: "http://www.alko.fi/cgi-bin/gwi.exe/gm?Model=com/gwiimageload.gws&Id=" + productId
        }

        Column {
            id: productColumn
            anchors { top: productImage.bottom; topMargin: 16; left: parent.left; leftMargin: 6; right: parent.right}
            spacing: 12

            InfoLine {
                title: "Valmistaja:"
                body: "Altia"
            }

            InfoLine {
                title: "Pullokoko:"
                body: "0.75 l"
            }

            InfoLine {
                title: "Tyyppi:"
                body: "Punaviini"
            }

            InfoLine {
                title: "Valmistusmaa:"
                body: "Argentiina, Mendoza"
            }

            InfoLine {
                title: "Alkoholi-%:"
                body: "13"

            }

            InfoLine {
                title: "Luonnehdinta:"
                body: "Keskitäyteläinen, keskitanniininen, tumman marjainen, mausteinen, kevyen yrttinen"
            }

            InfoLine {
                id: availabilityLine
                title: "Saatavuus myymälässä " + alko.name
                body: "11 kpl"
                opacity: alko.name ? 1.0 : 0.0

                SequentialAnimation {
                    id: availabilityAnimation
                    running: false
                    alwaysRunToEnd: true
                    loops: 3

                    NumberAnimation { target: availabilityLine; property: "scale"; from: 1.0; to: 1.05; duration: 300 }
                    NumberAnimation { target: availabilityLine; property: "scale"; from: 1.05; to: 1.0; duration: 300 }
                }

            }

        }

    }


    ToolBarLayout {
        id: productTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ButtonRow {


            TabButton {
                id: nearestButton
                text: "Lähin Alko"

                onClicked: {
                    alko.sortByLocation()
                    alko.selectAlko(0)
                    nearest = true;
                    productFlickable.contentY = productFlickable.contentHeight - productFlickable.height
                    availabilityAnimation.restart()
                }
            }

            TabButton {
                id: selectButton
                text: "Valitse..."

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SelectPage.qml"))
                    productFlickable.contentY = productFlickable.contentHeight - productFlickable.height
                }
            }
        }

        ToolIcon {
            iconId: "icon-m-toolbar-home"
            onClicked: pageStack.pop(null, false)
        }
    }


}
