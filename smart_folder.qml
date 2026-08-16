import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    color: "transparent"

    // Layer positioning above wallpaper
    WlrLayershell.layer: WlrLayer.Bottom

    anchors {
        bottom: true
        right: true
    }
    margins {
        bottom: 30
        right: 225
    }

    // Grid configuration
    property int cellSize: 54
    property int padding: 12
    property int itemCount: appModel.count
    
    // Math logic to maintain a dynamic square layout
    property int cols: Math.max(1, Math.ceil(Math.sqrt(itemCount)))
    property int rows: Math.max(1, Math.ceil(itemCount / cols))

    // Dynamically scale panel window size based on items and layout math
    width: (cols * cellSize) + (padding * 2)
    height: (rows * cellSize) + (padding * 2)

    ListModel {
        id: appModel
        ListElement { icon: "user-home"; target: "/home/varun"; isApp: false }
        ListElement { icon: "librewolf"; target: "librewolf"; isApp: true }
        ListElement { icon: "com.mitchellh.ghostty"; target: "ghostty"; isApp: true }
        ListElement { icon: "vscodium"; target: "codium"; isApp: true }
        ListElement { icon: "anki"; target: "anki"; isApp: true }
        ListElement { icon: "Cider"; target: "Cider"; isApp: true }
        ListElement { icon: "com.rtosta.zapzap"; target: "com.rtosta.zapzap"; isApp: true }
        ListElement { icon: "steam"; target: "steam"; isApp: true }
        
    }

    // Gruvbox Dark Container
    Rectangle {
        anchors.fill: parent
        color: "#b3282828"      // Gruvbox Dark bg0 (~70% opacity)
        radius: 14
        border.color: "#fe8019" // Gruvbox Dark orange accent border
        border.width: 1

        Grid {
            anchors.centerIn: parent
            columns: root.cols
            rows: root.rows

            Repeater {
                model: appModel

                delegate: Item {
                    width: root.cellSize
                    height: root.cellSize

                    // Hover Highlight (Gruvbox bg2)
                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: mouseArea.containsMouse ? "#80504945" : "transparent"

                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }
                    }

                    // App/Folder Icon Lookup
                    IconImage {
                        anchors.centerIn: parent
                        width: 36
                        height: 36
                        source: Quickshell.iconPath(icon, "application-x-executable")
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (isApp) {
                                appLauncher.command = [target]
                                appLauncher.running = true
                            } else {
                                Qt.openUrlExternally("file://" + target)
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: appLauncher
    }
}