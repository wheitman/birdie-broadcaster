import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4
import com.broadcaster.tvmanager 1.0

Pane {
    property color accentColor
    property color primaryColor: "gray"
    property string title: ""
    signal addButtonClicked
    signal refresh
    property bool highlighted: false
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
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    list.currentIndex = index
                    highlighted = true
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup()
                }
                Menu{
                    id: contextMenu

                    TvManager{
                        id: manager
                    }

                    MenuItem {text: "Delete"; onClicked: {
                            manager.removeTv(list.model.get(list.currentIndex).source)
                            refresh()
                        }
                    }
                    MenuItem {text: "Edit"}
                }
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
            id: addButton
            height: parent.height*.5
            width: height
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            icon.source: "icons/add.svg"
            icon.color: "white"
            onClicked: addButtonClicked()
        }
        ToolButton{
            id: refreshButton
            height: parent.height*.5
            width: height
            anchors.left: addButton.right
            anchors.bottom: parent.bottom
            icon.source: "icons/refresh.svg"
            icon.color: "white"
            onClicked: {
                refresh()
            }
            Behavior on rotation {
                NumberAnimation {
                    duration: 600
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    onRefresh: {
        updatePackageModel()
        refreshButton.rotation+=360
    }

    function updatePackageModel(){
        var tvs = tvManager.getTvList()
        var ips = tvManager.getIpList()
        list.model.clear()
        for(var i in tvs){
            list.model.append({name:tvs[i],source:ips[i]})
        }
    }

    ScrollView{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom
        id: scrollView
        ListView {
            id: list
            anchors.fill: parent
            model: PackageListModel{}
            delegate: tvDelegate
            highlight: Rectangle { color: highlighted ? Material.color(accent, Material.Shade100) : "transparent"}
            //onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
            highlightMoveDuration: 100
            clip: true
            Component.onCompleted: updatePackageModel()
            keyNavigationEnabled: true
        }
    }
}
