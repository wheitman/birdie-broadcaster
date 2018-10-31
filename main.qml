import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

import com.broadcaster.tvmanager 1.0
import com.broadcaster.packagemanager 1.0

ApplicationWindow {
    visible: true
    id: window

    width: 1280
    height: 720

    property int accent: Material.Teal
    property int primary: Material.BlueGrey

    Material.theme: Material.Light
    Material.primary: primary
    Material.accent: accent

    TvManager {
        id: tvManager
    }

    PackageManager {
        id: packageManager
    }

    Timer {
        id: refreshTimer
        interval: 60000 //refresh every minute
        onTriggered: tvListView.refresh()
        running: true
        repeat: true
    }

    Dialog {
        id: canaryDialog
        height: window.height/3*2
        width: window.width/3*2
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Canary Alert")

        property color primary: "#394648"
        property color accent: "#394648"
        property color highlight: "#fff200"

        property string level: ""
        property string msgTitle: ""
        property string msgBody: ""

        background: Rectangle{
            anchors.fill: parent
            color: "#394648"
        }

        StackView {
            anchors.fill: parent
            id: canaryStack
            initialItem: whichLevel
        }

        Item {
            id: whichLevel
            anchors.fill: parent
            visible: false
            Label {
                id: levelTitle
                text: "Which level?"
                color: "#edeeee"
                font.pointSize: 200
                minimumPointSize: 12
                fontSizeMode: Text.Fit
                width: parent.width
                anchors.top: parent.top
                height: 36
                horizontalAlignment: Text.AlignHCenter
            }
            Column {
                anchors.top: title.bottom
                anchors.bottom: title.bottom
                anchors.left: title.left
                anchors.right: title.right
                anchors.centerIn: parent

                Button {
                    text: "Send an <b>advisory</b>"
                    width: parent.width
                    anchors.leftMargin: 30
                    anchors.rightMargin: 30
                    Material.background: "#fff200"
                    onClicked: {
                        canaryDialog.level = "Y"
                        canaryStack.push(whatSay)
                    }
                }

                Text {
                    text: "<b>Advisories</b> are simple notifications override news tickers. Slides are still visible. Useful for minor emergencies, like heavy rain.<br/>"
                    color: "white"
                    anchors.bottomMargin: 20
                }

                Button {
                    text: "Send an <b>alert</b>"
                    width: parent.width
                    anchors.leftMargin: 30
                    anchors.rightMargin: 30
                    Material.background: "#fff200"
                    onClicked: {
                        canaryDialog.level = "T"
                    }
                }

                Text {
                    text: "<b>Alerts</b> are fullscreen messages designed to catch the eye. Useful for moderate emergencies, like tornado warnings.<br/>"
                    color: "white"
                    anchors.bottomMargin: 20
                }

                Button {
                    text: "Send an <b>alarm</b>"
                    width: parent.width
                    anchors.leftMargin: 30
                    anchors.rightMargin: 30
                    Material.background: "#fff200"
                    onClicked: {
                        canaryDialog.level = "M"
                    }
                }

                Text {
                    text: "<b>Alarms</b> are alerts, plus a constant alarm tone. Useful for serious emergencies, like active shooters.<br/>"
                    color: "white"
                    anchors.bottomMargin: 20
                }
            }
        }

        Item {
            id: whatSay
            anchors.fill: parent
            visible: false
            Label {
                id: typeTitle
                text: "Which type?"
                color: "#edeeee"
                font.pointSize: 200
                minimumPointSize: 12
                fontSizeMode: Text.Fit
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 36
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle{
                anchors.top: typeTitle.bottom
                anchors.bottom: reviewButton.top
                width: parent.width
                color: "white"
            }

            Column {
                id: col
                anchors.top: typeTitle.bottom
                anchors.bottom: parent.bottom
                width: parent.width-10
                anchors.leftMargin: 10
                TextField {
                    id: titleField
                    placeholderText: "ex: Weather Alert"
                    maximumLength: 25
                    width: parent.width
                    onTextChanged: canaryDialog.msgTitle = text
                }
                TextArea {
                    id: bodyField
                    width: parent.width
                    placeholderText: "ex: Sign out has been suspended due to severe weather. Follow instructions from staff."
                    onTextChanged: canaryDialog.msgBody = text
                }
            }
            Button {
                id: reviewButton
                Material.background: "#fff200"
                text: "Review >"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                onClicked: {
                    reviewPage.updateReview()
                    canaryStack.push(reviewPage)
                }
            }

        }

        Item {
            id: reviewPage
            anchors.fill: parent
            visible: false
            Label {
                id: reviewTitle
                text: "One last thing."
                color: "#edeeee"
                font.pointSize: 200
                minimumPointSize: 12
                fontSizeMode: Text.Fit
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 36
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                id: reviewText
                color: "#edeeee"
                font.pointSize: 18
                anchors.top: reviewTitle.bottom
                width: parent.width
                wrapMode: Text.Wrap
                text: "You are about to "
            }
            DelayButton {
                id: sendButton
                Material.background: "#fff200"
                text: "Broadcast "
                anchors.top: reviewText.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }

            function updateReview(){
                reviewText.text = ""
                if(canaryDialog.level=="Y"){
                    reviewText.text+= "override all tickers with your message, plus play a short alert tone."
                    sendButton.text+= "Advisory"
                }
                if(canaryDialog.level=="T"){
                    reviewText.text+= "display a fullscreen message on all campus TVs, plus play a short alert tone."
                    sendButton.text+= "Alert"
                }
                if(canaryDialog.level=="M"){
                    reviewText.text+= "display a fullscreen message on all campus TVs, plus play a continuous alarm tone."
                    sendButton.text+= "Alarm"
                }
                reviewText.text+="<br/>Title: "+canaryDialog.msgTitle+"<br/>Body: "+canaryDialog.msgBody
            }
        }

        ToolButton {
            icon.source: "icons/add.svg"
            icon.color: "white"
            rotation: 45
            height: 50
            width: 50
            y: -10
            anchors.right: parent.right
            onClicked: canaryDialog.close()
        }

        ToolButton {
            icon.source: "icons/back.svg"
            icon.color: canaryStack.depth>1?"white" : "gray"
            height: 50
            width: 50
            y: -10
            anchors.left: parent.left
            onClicked: canaryStack.pop()
            enabled: canaryStack.depth>1

        }

        header.visible: false

        modal: true
    }

    Dialog {
        id: alertConfirmation
        height: 400
        width: 600
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Canary Alert")
        background: Rectangle{
            anchors.fill: parent
            color: Material.color(Material.Yellow)
        }
        header.visible: false
        Label{
            text: "This will broadcast a Canary alert across campus. Are you sure?"
        }
        RowLayout{
            anchors.centerIn: parent
            anchors.bottom: parent.bottom
            Button {
                id: alertConfirm
                onClicked: {
                    canaryDialog.close()
                    alertConfirmation.accept()
                }
                text: "Send Alert"
            }
            Button {
                text: "Cancel"
                onClicked: {
                    canaryDialog.close()
                    alertConfirmation.reject()
                }
            }
        }
    }

    Dialog {
        id: addTvDialog
        height: 400
        width: 600
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Add a TV")

        ColumnLayout{
            anchors.centerIn: parent
            anchors.left: parent.left
            anchors.right: parent.right
            TextField {
                id: nameField
                placeholderText: "Name (i.e. \"Main entrance\")"
            }
            TextField {
                id: ipField
                placeholderText: "IP address (i.e. \"192.168.1.240\")"
            }
        }
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            tvManager.addTv(nameField.text,ipField.text)
            nameField.clear()
            ipField.clear()
            tvListView.updateTvModel()
        }
        onRejected: {
            nameField.clear()
            ipField.clear()
        }
    }

    Dialog {
        id: addPackageDialog
        height: 400
        width: 600
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Add a package")

        ColumnLayout{
            anchors.centerIn: parent
            anchors.left: parent.left
            anchors.right: parent.right
            TextField {
                id: packNameField
                placeholderText: "File name (i.e. \"student_news\")"
            }
            TextField {
                id: packTitleField
                placeholderText: "Title (optional, i.e. \"Student News\")"
            }
        }
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            if(packTitleField.text.length==0)
                packageManager.addPackage(packNameField.text)
            else
                packageManager.addPackage(packNameField.text,packTitleField.text)
            tvListView.updateTvModel()
            packNameField.clear()
            packageListView.updatePackageModel()
        }
        onRejected: {
            packNameField.clear()
        }
    }

    SplitView{
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle{
            id: sidebar
            width: parent.width/4
            color: Material.color(primary,Material.Shade50)

            SplitView{
                anchors.fill: parent
                anchors.bottom: sidebarOptions.top
                property int bottomPadding: 0
                orientation: Qt.Vertical
                PackageListView{
                    id: packageListView
                    height: parent.height/3
                    width: parent.width
                    onHighlightedChanged: {
                        if(packageListView.highlighted===true){
                            tvListView.highlighted = false
                            packageView.visible = true
                            welcomeView.visible = false
                        }
                    }
                    accentColor: Material.color(accent, Material.Shade100)
                    primaryColor: Material.color(accent)
                    title: "PACKAGES"
                    onAddButtonClicked: addPackageDialog.open()
                    onPackageSelected: packageView.packageChanged()
                }
                TvListView{
                    anchors.top: packageListView.bottom
                    id: tvListView
                    height: parent.height/3
                    width: parent.width
                    onHighlightedChanged: {
                        if(tvListView.highlighted===true)
                            packageListView.highlighted=false
                    }

                    accentColor: Material.color(accent)
                    primaryColor: Material.color(accent)
                    title: "TVs"
                    bottomPadding: sidebarOptions.height
                    onAddButtonClicked: addTvDialog.open()
                }
            }
            Rectangle{
                id: sidebarOptions
                color: Material.color(primary)
                anchors.bottom: parent.bottom
                height: (parent.height/20)<canaryButton.implicitHeight ? canaryButton.implicitHeight : parent.height/20
                width: parent.width
                Button {
                    id: canaryButton
                    text: "Send Canary Message"
                    anchors.centerIn: parent
                    Material.background: "#fff200"
                    Material.accent: "#394648"
                    onClicked: canaryDialog.open()
                }
            }
        }
        Rectangle{
            color: Material.color(primary, Material.Shade50)
            WelcomeView{
                id: welcomeView
                anchors.fill: parent
            }
            PackageView{
                id: packageView
                visible: false
            }
        }
    }
}
