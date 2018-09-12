import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

Pane {
    property color accentColor
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
        height: 50
        Text {
            id: titleText
            padding: 5
            minimumPointSize: 10
            font.pointSize: 40
            anchors.top: parent.top
            anchors.left: parent.left
            fontSizeMode: Text.VerticalFit
            text: title
            color: "white"
            height: parent.height*3/5
        }
        ToolButton{
            height: parent.height*.5
            width: height
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            background: Rectangle{
                color:"white"
                height: parent.height*.75
                width: height
                radius: height/2
                anchors.centerIn: parent
            }
            icon.source: "icons/add.svg"
            icon.color: primaryColor
            onClicked: addButtonClicked()
        }
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
            highlight: Rectangle { color: Material.color(accent, Material.Shade100)}
            focus: true
            //onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
            highlightMoveDuration: 100
            clip: true
        }
    }
}
