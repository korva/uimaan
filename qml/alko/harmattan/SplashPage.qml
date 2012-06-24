import QtQuick 1.1
import com.nokia.meego 1.0

Page {

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Image {
        id: logo
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        width: 300
        height: 300
        source: "qrc:/logo.png"


    }


//    Text {
//        id: titleText
//        text: alko.positionFound ? "Haetaan lähintä myymälää..." : "Haetaan sijaintia..."
//        font.family: "Nokia Pure Text"
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: logo.bottom
//        anchors.topMargin: 20
//        //font.pointSize: 22
//        font.pixelSize: 34
//        opacity: 0.0

//        onTextChanged: titleTextAnimation.restart()

//        SequentialAnimation {
//            id: titleTextAnimation
//            alwaysRunToEnd: true
//            running: false
//            loops: 1

//            NumberAnimation { target: titleText; property: "scale"; from: 1.0; to: 1.1; duration: 300 }
//            NumberAnimation { target: titleText; property: "scale"; from: 1.1; to: 1.0; duration: 300 }
//        }
//    }




}
