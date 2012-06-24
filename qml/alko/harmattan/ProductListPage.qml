import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: productListPage
    orientationLock: PageOrientation.LockPortrait
    tools: productListTools

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Titlebar {
        id: titleBar
        text: "Hakutulokset (esimerkkisivu)"
    }

    ButtonRow {
        id: tabs
        height: 50
        anchors { top: titleBar.bottom; left: parent.left ; right: parent.right }

        style: TabButtonStyle { }

        TabButton {
            id: nameButton
            text: "Nimi"
            height: 50

            //onClicked: alko.sortByName()
        }

        TabButton {
            id: priceButton
            checked: true
            text: "Hinta"
            height: 50

            //onClicked: alko.sortByLocation()
        }
    }

    ListView {
        id: productListView
        anchors { top: tabs.bottom; left: parent.left ; right: parent.right ; bottom: parent.bottom }
        spacing: 4
        clip: true
        model: ListModel {
            id: productModel

//            004551;Caballo de Mendoza;Altia;0,75;6,47;8,49;;110;Punaviinit;;;;Argentiina;Mendoza;;;Mendoza;;Sangiovese, Malbec;Keskitäyteläinen, keskitanniininen, tumman marjainen, mausteinen, kevyen yrttinen;kiertopullo;Metallinen kierrekapseli;13;6;;;;;90
//            475977;Hereford Malbec Syrah Sangiovese;Andean Vineyards;0,75;6,64;8,72;;110;Punaviinit;;;;Argentiina;Mendoza;;2010;Mendoza;;Malbec, Syrah, Sangiovese;Keskitäyteläinen, keskitanniininen, marjainen, puolukkainen, kevyen mausteinen;kertapullo;Metallinen kierrekapseli;12,5;5,8;;;;;80
//            476397;Viento Latino Merlot Malbec;Trivento;0,75;6,66;8,75;;110;Punaviinit;;;;Argentiina;Mendoza;;2011;Mendoza;;Merlot (70 %), Malbec (30 %);Keskitäyteläinen, keskitanniininen, makean kirsikkainen, karpaloinen, mausteinen;kertapullo;Metallinen kierrekapseli;13;5;6;;;;80
//            755824;Kuohu Vahva Amber;Mallaskosken panimo;0,33;2,01;5,64;;600;Oluet;IV A -oluet;;Lager;Suomi;;;;;;;Meripihkanruskea, keskitäyteläinen, voimakkaasti humaloitu, pehmeän maltainen, aromaattinen, hennon karamellinen, maukas;tölkki;Metallipakkaus;5,5;;;12,7;36,2;30;50


            ListElement { name: "Caballo de Mendoza"; price: "6,47 €"; bottle: "0.75 l" }
            ListElement { name: "Hereford Malbec Syrah Sangiovese"; price: "6,64 €"; bottle: "0.75 l" }
            ListElement { name: "Viento Latino Merlot Malbec"; price: "6,66 €"; bottle: "0.75 l" }
            ListElement { name: "Kuohu Vahva Amber"; price: "2,01 €"; bottle: "0.33 l" }

        }

        delegate: ProductListDelegate { }
    }

    ScrollDecorator {
        id: decorator
        flickableItem: productListView
    }

    ToolBarLayout {
        id: productListTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }

        ToolIcon {
            iconId: "icon-m-toolbar-home"
            onClicked: pageStack.pop(null, false)
        }
    }


}
