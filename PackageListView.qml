import QtQuick 2.11

Rectangle {
    Component {
        id: packageDelegate
        Item {
            width: parent.width
            height: 40
            Column {
                Text { text: name; padding: 5}
                Text { text: "<i>"+source+"</i>"; leftPadding: 5}
            }
            MouseArea {
                anchors.fill: parent
                onClicked: list.currentIndex = index
            }
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        model: PackageListModel{}
        delegate: packageDelegate
        highlight: Rectangle { color: "lightsteelblue"; radius: 2 }
        focus: true
        onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
    }
    clip: true

}
