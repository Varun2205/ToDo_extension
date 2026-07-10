import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell // Capital 'Q' fixes the error

FloatingWindow {
    id: root
    title: "QuickNotes"
    
    // Window Setup
    width: 350
    height: 500
    visible: true
    
    // Makes the window background transparent
    color: "transparent"
    
    // Main background styling (60% opacity)
    Rectangle {
        anchors.fill: parent
        color: "#1E1E1E" // Dark mode base
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

        // Header
        Text {
            text: "Reminders"
            font.pixelSize: 22
            font.bold: true
            color: "#FFFFFF"
            Layout.alignment: Qt.AlignLeft
        }

        // List View for Todo Items
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

                // 1. Circular checkbox
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10 // Perfect circle
                    color: "transparent"
                    border.color: model.text === "" ? "#555555" : "#0A84FF" // Apple blue Accent
                    border.width: 2
                    
                    // Inside fill for hover/visual feedback
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

                // 2. Text Input Area
                TextArea {
                    id: textInput
                    Layout.fillWidth: true
                    text: model.text
                    font.pixelSize: 15
                    color: "#FFFFFF"
                    background: null // Borderless like Apple Notes
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    
                    onTextChanged: model.text = text

                    // Feature: Press Enter to create a new todo item below
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            event.accepted = true; // Stop newline inside the current item
                            
                            var nextIndex = index + 1;
                            todoModel.insert(nextIndex, {"text": ""});
                            
                            // Small delay to let the item render, then focus it
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
