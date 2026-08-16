import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Bottom 
    
    focusable: true
    anchors {
        top: true
        right: true
    }
    margins {
        top: 100 
        right: 100  
    }
    implicitWidth: 350
    implicitHeight: 500
    color: "transparent"

    property bool isLoading: false
    property int focusIndex: -1

    // Persistence handler
    Settings {
        id: settings
        property string savedTodos: "[]"
    }

    function saveReminders() {
        if (isLoading) return
        var items = []
        for (var i = 0; i < todoModel.count; i++) {
            var txt = todoModel.get(i).text
            if (txt.trim() !== "") {
                items.push({ "text": txt })
            }
        }
        settings.savedTodos = JSON.stringify(items)
    }

    function loadReminders() {
        isLoading = true
        todoModel.clear()
        try {
            var items = JSON.parse(settings.savedTodos)
            for (var i = 0; i < items.length; i++) {
                todoModel.append(items[i])
            }
        } catch (e) {
            console.log("Error loading saved todos:", e)
        }
        
        if (todoModel.count === 0) {
            todoModel.append({ "text": "" })
        }
        isLoading = false
    }

    Component.onCompleted: loadReminders()

    // Background 
    Rectangle {
        anchors.fill: parent
        color: "#1E1E1E" 
        opacity: 0.60
        radius: 12
        border.color: "#333333"
        border.width: 1
    }

    // App Content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Text {
            text: "TO DO STUFF ..."
            font.pixelSize: 22
            font.bold: true
            color: "#FFFFFF"
            Layout.alignment: Qt.AlignLeft
        }

        ListView {
            id: todoListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            clip: true

            model: ListModel {
                id: todoModel
            }

            delegate: RowLayout {
                id: delegateRow
                width: todoListView.width
                spacing: 10

                property alias textInputItem: textInput

                // Circular checkbox
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: "transparent"
                    border.color: model.text === "" ? "#555555" : "#98971a"
                    border.width: 2
                    
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        radius: 6
                        color: '#98971a'
                        visible: mouseArea.containsMouse
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            todoModel.remove(index)
                            if (todoModel.count === 0) {
                                todoModel.append({"text": ""})
                            }
                            root.saveReminders()
                        }
                    }
                }

                TextArea {
                    id: textInput
                    Layout.fillWidth: true
                    text: model.text
                    font.pixelSize: 15
                    color: "#FFFFFF"
                    background: null
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    
                    onTextChanged: {
                        if (model.text !== text) {
                            model.text = text
                            root.saveReminders()
                        }
                    }

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            event.accepted = true;
                            
                            var nextIndex = index + 1;
                            root.focusIndex = nextIndex;
                            todoModel.insert(nextIndex, {"text": ""});
                            root.saveReminders();
                            
                            Qt.callLater(function() {
                                todoListView.positionViewAtIndex(nextIndex, ListView.Contain);
                                var nextItem = todoListView.itemAtIndex(nextIndex);
                                if (nextItem && nextItem.textInputItem) {
                                    nextItem.textInputItem.forceActiveFocus();
                                }
                            });
                        }
                    }
                    
                    Component.onCompleted: {
                        if (root.focusIndex === index || (index === todoModel.count - 1 && text === "" && todoModel.count === 1)) {
                            forceActiveFocus();
                            root.focusIndex = -1;
                        }
                    }
                }
            }
        }
    }
}