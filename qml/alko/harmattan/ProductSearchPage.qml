import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait
    tools: infoTools

    property string category: "Tuoteryhmä: kaikki"
    property string food: "Ruokasuositus: kaikki"

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Titlebar {
        id: titleBar
        text: "Tuotehaku (esimerkkisivu)"
    }

    TextField {
        id: searchField
        anchors { top: titleBar.bottom; topMargin: 20; left: parent.left; leftMargin: 6; right: parent.right; rightMargin: 6}
        placeholderText: "Hakusana"
    }

    Button {
        id: categoryButton
        anchors { top: searchField.bottom; topMargin: 16; horizontalCenter: parent.horizontalCenter }
        width: searchField.width
        text: category
        iconSource: "image://theme/icon-m-common-combobox-arrow"

        onClicked: categorySelectionDialog.open()
    }

    Button {
        id: foodButton
        anchors { top: categoryButton.bottom; topMargin: 16; horizontalCenter: parent.horizontalCenter }
        width: searchField.width
        text: food
        //iconSource: "image://theme/icon-m-toolbar-down"
        iconSource: "image://theme/icon-m-common-combobox-arrow"
        platformStyle: ButtonStyle {  }

        onClicked: categorySelectionDialog.open()
    }

    Button {
        id: searchButton
        anchors { top: foodButton.bottom; topMargin: 40; horizontalCenter: parent.horizontalCenter}
        width: 300
        height: 100
        text: "Hae"

        onClicked: pageStack.push(Qt.resolvedUrl("ProductListPage.qml"))
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

    SelectionDialog {
         id: categorySelectionDialog
         titleText: "Valitse tuoteryhmä"
         selectedIndex: 1

         model: ListModel {
             ListElement { name: "Punaviinit" }
             ListElement { name: "Valkoviinit" }
             ListElement { name: "Oluet" }
         }
     }

    SelectionDialog {
         id: foodSelectionDialog
         titleText: "Minkä ruoan kanssa?"
         selectedIndex: 1

         model: ListModel {
             ListElement { name: "Pasta" }
             ListElement { name: "Lammas" }
             ListElement { name: "Juustot" }
         }
     }


}
