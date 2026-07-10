import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Bottom 
    
    //Allow keyboard focus so you can click and type into the todo list
    focusable: true
    anchors {
        top: true
        right: true
    }
    

    margins {
        top: 100 
        right: 100  
    }
    
    // Widget Dimensions
    implicitWidth: 350
    implicitHeight: 500
    color: "transparent"
    
    // Main background styling (60% opacity)
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
            text: "Reminders"
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
                ListElement { text: "Click here to start typing..." }
            }

            delegate: RowLayout {
                width: todoListView.width
                spacing: 10

                // Circular checkbox
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: "transparent"
                    border.color: model.text === "" ? "#555555" : "#0A84FF"
                    border.width: 2
                    
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        radius: 6
                        color: "#0A84FF"
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
                        }
                    }
                }

                // Text Input Area
                TextArea {
                    id: textInput
                    Layout.fillWidth: true
                    text: model.text
                    font.pixelSize: 15
                    color: "#FFFFFF"
                    background: null
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    
                    onTextChanged: model.text = text

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            event.accepted = true;
                            
                            var nextIndex = index + 1;
                            todoModel.insert(nextIndex, {"text": ""});
                            
                            Timer.singleShot(10, function() {
                                todoListView.positionViewAtIndex(nextIndex, ListView.Contain);
                                var nextItem = todoListView.contentItem.children[nextIndex];
                                if (nextItem) {
                                    nextItem.children[1].forceActiveFocus();
                                }
                            });
                        }
                    }
                    
                    Component.onCompleted: {
                        if (index === todoModel.count - 1 && text === "") {
                            forceActiveFocus();
                        }
                    }
                }
            }
        }
    }
}
