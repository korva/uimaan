import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait
    tools: aboutTools

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"


    }

    Label {
        id: label1
        anchors {top: parent.top; topMargin: 6; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 28
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        text: "Alkoon v1.0"
        color: alkoRed
        platformInverted: true
    }

    Label {
        id: label2
        anchors {top: label1.bottom; topMargin: 4; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 16
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        platformInverted: true
        text: "by Jaakko Koskenkorva\n11latoa.com"

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
        font.pixelSize: 20
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        text: "Löydä lähin Alkon myymälä. Helposti!"
        wrapMode: Text.WordWrap
        platformInverted: true
    }

    Label {
        id: label4
        anchors {top: label3.bottom; topMargin: 12; left: parent.left; leftMargin: 4; right: parent.right; rightMargin: 4 }
        font.pixelSize: 14
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        platformInverted: true
        wrapMode: Text.WordWrap
        text: "Kaikki sovelluksen data on peräisin Alko Oy:n verkkopalvelusta. Tässä sovelluksen versiossa ei vielä tunnisteta erikoispäivien aukioloaikoja, ne ovat saatavilla verkkopalvelusta. "


    }

    Button {
        id: button4
        anchors { top: label4.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
        text: "Avaa www.alko.fi"
        onClicked: Qt.openUrlExternally("http://www.alko.fi")
        platformInverted: true
    }

    Label {
        id: label5
        anchors {top: button4.bottom; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 14
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.RichText
        text: "Alkoon on saatavilla myös iPhonelle App Storesta!\nVinkkaa kaverillesi."
        platformInverted: true
        wrapMode: Text.WordWrap


    }

    Button {
        id: button5
        anchors { top: label5.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
        text: "Kirjoita viesti"
        platformInverted: true
        onClicked: Qt.openUrlExternally("mailto:?subject=Alkoon&body=Kokeilehan Alkoon -applikaatiota iPhonelle, suosittelen lämpimästi!\nLinkki App Storeen:\nhttp://itunes.apple.com/us/app/alkoon/id512594834?ls=1&mt=8")
    }

    Label {
        id: label6
        anchors {top: button5.bottom; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 14
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.RichText
        platformInverted: true
        wrapMode: Text.WordWrap
        text: "Jos pidit sovelluksesta, käythän arvostelemassa sen Nokia Storessa!"


    }

    Button {
        id: button6
        anchors { top: label6.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
        text: "Avaa Nokia Store"
        platformInverted: true
        onClicked: Qt.openUrlExternally("http://store.ovi.com/content/275939")
    }

    Label {
        id: label7
        anchors {top: button6.bottom; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10 }
        font.pixelSize: 14
        font.family: "Nokia Pure Text"
        horizontalAlignment: Text.AlignHCenter
        text: "Kysyttävää, kommentteja, ehdotuksia, haukkuja? Lähetäthän palautetta."
        platformInverted: true
        wrapMode: Text.WordWrap


    }

    Button {
        id: button7
        anchors { top: label7.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
        text: "Kirjoita palaute"
        platformInverted: true
        onClicked: Qt.openUrlExternally("mailto:korva@ovi.com?subject=Alkoon/Palaute&body=Palautetta versiosta 1.0:")
    }


    ToolBarLayout {
        id: aboutTools
        visible: true
        ToolButton {
            iconSource: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
    }


}


