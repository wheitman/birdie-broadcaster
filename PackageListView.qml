import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4
import com.broadcaster.tvmanager 1.0
import com.broadcaster.packagemanager 1.0

Pane {
    property color accentColor
    property color primaryColor: "gray"
    property string title: ""
    signal addButtonClicked
    signal refresh
    signal packageSelected
    property bool highlighted: false
    padding: 0
    Component {
        id: tvDelegate
        Item {
            width: parent.width
            height: title.length>0 ? 40 : 25
            Column {
                id: column
                Text { text: title; padding: 5; bottomPadding: 0; font.weight: Font.Bold; visible: title.length>0}
                Text { text: name; padding: 5; font.italic: true}
            }
            Rectangle {
                color: Material.color(Material.BlueGrey,Material.Shade100)
                width: parent.width
                height: 1
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    list.currentIndex = index
                    highlighted = true
                    packageManager.currentPackageName = list.model.get(list.currentIndex).name
                    packageSelected()
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup()
                }
                Menu{
                    id: contextMenu

                    PackageManager{
                        id: manager
                    }

                    MenuItem {text: "Delete"; onClicked: {
                            manager.removePackage(list.model.get(list.currentIndex).name)
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

    PackageManager {
        id: packageManager
    }

    function updatePackageModel(){
        packageManager.resetPackages()
        var packs = packageManager.getPackageFilenames()
        list.model.clear()
        if(packs.length===0){
            list.model.append({name:"No packages were found.\nTo add a package, use the plus button above."})
            list.enabled=false
        }
        else{
            list.enabled=true
            for(var i in packs){
                list.model.append({title:packageManager.getPackageTitle(packs[i]),name:packs[i]})
            }
        }
    }

    ScrollView{
        width: parent.width
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
