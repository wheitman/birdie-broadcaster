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
    property bool activeCanary: tvManager.canaryType!='0'

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
                        canaryStack.push(whatSay)
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
                        canaryStack.push(whatSay)
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
                    placeholderText: "Title (ex: <i>Weather Alert</i>)"
                    maximumLength: 25
                    width: parent.width-10
                    onTextChanged: canaryDialog.msgTitle = text
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                }
                TextArea {
                    id: bodyField
                    width: parent.width-10
                    placeholderText: "Body (ex: <i>Sign out has been suspended due to severe weather. Follow instructions from staff.</i>)"
                    onTextChanged: canaryDialog.msgBody = text
                    anchors.leftMargin: 10
                    anchors.left: parent.left
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
                font.pointSize: 12
                anchors.top: reviewTitle.bottom
                width: parent.width
                wrapMode: Text.Wrap
                text: ""
                horizontalAlignment: Text.AlignHCenter
            }
            Button {
                id: sendButton
                Material.background: "#fff200"
                text: ""
                anchors.top: reviewText.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                onClicked: {
                    canaryDialog.accept()
                    tvManager.canaryType=canaryDialog.level
                    tvManager.canaryTitle=canaryDialog.msgTitle
                    tvManager.canaryBody=canaryDialog.msgBody
                    tvManager.broadcastCanary()

                    var ips = tvManager.getIpList()
                    for(var i = 0; i<ips.length; i++){
                        reviewPage.request('http://'+ips[i]+':8080/canary?type=1&body='+tvManager.canaryBody+'&level='+tvManager.canaryType, function (o){
                            var d = eval('new Object(' + o.responseText + ')');
                        });
                    }

                }
            }

            function request(url, callback){
                var request = new XMLHttpRequest();
                request.onreadystatechange = (function(myRequest) {
                    return function() {
                        callback(myRequest);
                    }
                })(request);
                request.open('GET', url, true);
                request.send('');
            }

            function updateReview(){
                reviewText.text = "<i>You are about to "
                if(canaryDialog.level=="Y"){
                    reviewText.text+= "override all tickers with your message, plus play a short alert tone.</i>"
                    sendButton.text+= "Broadcast Advisory"
                }
                if(canaryDialog.level=="T"){
                    reviewText.text+= "display a fullscreen message on all campus TVs, plus play a short alert tone.</i>"
                    sendButton.text+= "Broadcast Alert"
                }
                if(canaryDialog.level=="M"){
                    reviewText.text+= "display a fullscreen message on all campus TVs, plus play a continuous alarm tone.</i>"
                    sendButton.text+= "Broadcast Alarm"
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
        id: canaryLiftDialog
        height: window.height/3.5
        width: window.width/3.5
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Lift Canary Alert")

        standardButtons: Dialog.Ok | Dialog.Cancel

        property color primary: "#394648"
        property color accent: "#394648"
        property color highlight: "#fff200"

        Text {
            text: "Are you sure you want to lift the active alert?"
            font.pointSize: 14
            width: parent.width
            wrapMode: Text.Wrap
        }

        onAccepted: {
            var ips = tvManager.getIpList()
            for(var i = 0; i<ips.length; i++){
                request('http://'+ips[i]+':8080/canary?type=0', function (o){
                    var d = eval('new Object(' + o.responseText + ')');
                });
            }
            tvManager.canaryType='0'
        }

        function request(url, callback){
            var request = new XMLHttpRequest();
            request.onreadystatechange = (function(myRequest) {
                return function() {
                    callback(myRequest);
                }
            })(request);
            request.open('GET', url, true);
            request.send('');
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
            width: parent.width/6
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
                    Material.background: tvManager.canaryType=='0' ? "#fff200" : Material.color(Material.Red)
                    Material.accent: "#394648"
                    onClicked: if(!activeCanary){
                                   canaryDialog.open()
                               }
                               else{
                                   canaryLiftDialog.open()
                               }

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
                onLoaded: packageListView.loading=false
            }
        }
    }
}
