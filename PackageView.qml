import QtQuick 2.11
import QtQuick.Controls.Material 2.2
import com.broadcaster.packagemanager 1.0
import com.broadcaster.packagemanifest 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.2
import QtMultimedia 5.9

Rectangle {
    anchors.fill: parent
    property color primaryColor: Material.color(Material.BlueGrey)
    property color accentColor: Material.color(Material.Teal)
    property var slideSources: ["ERROR"]

    color: Material.color(Material.BlueGrey, Material.Shade50)

    signal packageChanged
    signal loaded

    PackageManager {
        id: packageManager
        //onCurrentPackageNameChanged: packageManifest.packageName = currentPackageName
    }

    onPackageChanged: {
        title.text = packageManager.currentPackageTitle.length>0 ? packageManager.currentPackageTitle : packageManager.currentPackageName
        slideSources = packageManager.currentSlideSources
    }

    onSlideSourcesChanged: {
//        var index = 0
//        var length = slideSources.length
//        var sources = slideSources.sort()
//        while(index<length){
//            console.log(sources[index])
//            slideOverviewList.model.append({slideSource:sources[index]})
//            index++
//        }
        console.log("Updating repeater with "+slideSources.length+" images.")
        updateOverviewList()
        imagePreview.source=slideSources[0]
    }

    Rectangle{
        color: primaryColor
        width: parent.width
        height: 50
        id: titleRect

        Text{
            id: title
            text: "Package information unavailable."
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            minimumPointSize: 16
            font.pointSize: 200
            fontSizeMode: Text.Fit
            anchors.fill: parent
            anchors.margins: 5
        }
    }

    Component {
        id: slideListItem
        Item {
            width: parent.width
            height: 50

            Rectangle {
                radius: 5
                id: thumbRect
                anchors.left: parent.left
                anchors.margins: 5
                height: parent.height
                width: height
                Image {
                    source: sourceID.includes("ERROR") ? "/icons/error.svg" : sourceID
                    id: thumbImg
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    anchors.centerIn: parent
                    clip: true
                }
            }

            Column {
                id: column
                anchors.left: thumbRect.right
                Text { text: getShortName(sourceID); padding: 5; bottomPadding: 0 }
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
                    list.currentIndex = index;
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup()
                }
                Menu{
                    id: contextMenu

                    MenuItem {text: "Delete"; onClicked: {
                            packageManager.deleteSlideFromCurrent(getShortName(sourceID))
                            slideSourcesChanged()
                        }
                    }
                    MenuItem {text: "Edit"}
                }
            }
        }
    }

    Rectangle {
        id: slideOverview
        anchors.left: parent.left
        width: parent.width/5
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom

        Rectangle {
            id: overviewTitleRect
            color: accentColor
            anchors.top: parent.top
            width: parent.width
            height: 30
            Text {
                id: titleText
                padding: 5
                minimumPointSize: 10
                font.pointSize: 40
                anchors.top: parent.top
                anchors.left: parent.left
                fontSizeMode: Text.VerticalFit
                text: "SLIDES"
                color: "white"
                height: parent.height*3/5
            }
            ToolButton{
                id: addButton
                height: parent.height
                width: height
                anchors.right: refreshButton.left
                anchors.top: parent.top
                icon.source: "icons/add.svg"
                icon.color: "white"
                onClicked: slideFileDialog.open()
            }
            ToolButton{
                id: refreshButton
                height: parent.height
                width: height
                anchors.right: parent.right
                anchors.top: parent.top
                icon.source: "icons/refresh.svg"
                icon.color: "white"
                onClicked: {
                    slideSourcesChanged()
                    rotation+=360
                }
                Behavior on rotation {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        ScrollView{
            anchors.top: overviewTitleRect.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            id: scrollView
            background: Rectangle{
                anchors.fill: parent
                border.color: Material.color(Material.BlueGrey, Material.Shade100)
                border.width: 1
                color: Material.color(Material.BlueGrey, Material.Shade50)
            }

            ListView {
                id: list
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: 200
                model: SlideOverviewModel{}
                delegate: slideListItem
                highlight: Rectangle { color: Material.color(accent, Material.Shade100)}
                //onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
                highlightMoveDuration: 100
                clip: true
                Component.onCompleted: {
                    updateOverviewList()
                }

                onCurrentIndexChanged: {
                    var source = model.get(currentIndex).sourceID
                    if (source.toUpperCase().endsWith(".MP4") || source.toUpperCase().endsWith(".WAV") || source.toUpperCase().endsWith(".MOV")){
                        videoPreview.source=source
                    }
                    else if (source.toUpperCase().endsWith(".PNG") || source.toUpperCase().endsWith(".JPG") || source.toUpperCase().endsWith(".GIF") || source.toUpperCase().endsWith(".JPEG")){
                        imagePreview.source=source
                    }
                    else{
                        console.log("PackageView Error: unsupported file format.")
                    }
                }
            }
        }
    }

    Rectangle {
        id: slidePreview
        anchors.top: titleRect.bottom
        anchors.left: slideOverview.right
        anchors.right: parent.right
        height: parent.height/2
        color: "transparent"

        Image{
            id: blankTV
            source: "res/blankTV.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }

        Video {
            id: videoPreview
            anchors.fill: blankTV
            fillMode: VideoOutput.PreserveAspectFit
        }
        Image {
            id: imagePreview
            anchors.centerIn: blankTV
            width: blankTV.height*720/428*0.9625
            height: blankTV.height*0.9159

            fillMode: Image.Stretch
            asynchronous: true
        }
    }

    function updateOverviewList(){
        list.model.clear()
        var sources = slideSources.slice()
        for(var i = 0; i<sources.length; i++){
            list.model.append({sourceID: sources[i]})
        }
        loaded()
    }

    function getShortName(source){
        return source.split('/').pop()
    }

    FileDialog {
        id: slideFileDialog
        title: "Select the slides to add"
        folder: shortcuts.pictures
        selectMultiple: true
        onAccepted: {
            console.log(slideFileDialog.fileUrls)
            slideFileDialog.fileUrls.forEach(packageManager.addSlideToCurrent)
            slideSourcesChanged()
        }
    }

}
