import QtQuick 2.11
import QtQuick.Controls 2.2

Rectangle {
    property color highlightColor
    property color primaryColor: "gray"
    property string title: ""
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

    ListView {
        id: list
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom
        model: TvListModel{}
        delegate: tvDelegate
        highlight: Rectangle { color: highlightColor}
        focus: true
        //onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
        highlightMoveDuration: 100
        clip: true
    }
}
