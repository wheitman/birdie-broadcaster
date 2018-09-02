import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

Pane {
    property color highlightColor
    property color primaryColor: "gray"
    property string title: ""
    signal addButtonClicked
    padding: 0
    Component {
        id: tvDelegate
        Item {
            width: parent.width
            height: 40
            Column {
                Text { text: name; padding: 5; font.weight: Font.DemiBold}
                Text { text: "<i>"+source+"</i>"; leftPadding: 5}
            }
            MouseArea {
                anchors.fill: parent
                onClicked: list.currentIndex = index
            }
        }
    }

    Rectangle {
        id: titleRect
        color: primaryColor
        anchors.top: parent.top
        width: parent.width
        height: 30
        Text {
            padding: 5
            minimumPointSize: 10
            font.pointSize: 40
            anchors.fill: parent
            fontSizeMode: Text.VerticalFit
            text: title
            color: "white"
        }
    }

    ToolButton{
//        contentItem: Text {
//            text: "+"
//            color: "white"
//            anchors.fill: parent
//            opacity: enabled ? 1.0 : 0.3
//            font.pointSize: 100
//            minimumPointSize: 10
//            fontSizeMode: Text.VerticalFit
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//        }
        height: titleRect.height
        width: height
        anchors.right: parent.right
        anchors.top: parent.top
        icon.source: "icons/add.svg"
        icon.color: "white"
        //Material.background: "transparent"
        //Material.foreground: "white"
        onClicked: (addButtonClicked())
    }

    ScrollView{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom
        ListView {
            id: list
            anchors.fill: parent
            model: TvListModel{}
            delegate: tvDelegate
            highlight: Rectangle { color: highlightColor}
            focus: true
            //onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
            highlightMoveDuration: 100
            clip: true
        }
    }
}
