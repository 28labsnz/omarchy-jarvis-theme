import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root
    property var shell: null
    property var stats: ({})
    property var cpuHistory: []
    property var netHistory: []
    property bool overview: false
    readonly property bool active: stats.theme === "jarvis"
    onActiveChanged: if (!active) overview = false

    Process {
        command: ["python3", "-u", decodeURIComponent(Qt.resolvedUrl("telemetry.py").toString().replace("file://", ""))]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    var sample = JSON.parse(data);
                    root.stats = sample;
                    if (sample.cpu !== undefined) {
                        root.cpuHistory = root.cpuHistory.concat([sample.cpu]).slice(-30);
                        root.netHistory = root.netHistory.concat([sample.rx]).slice(-30);
                    }
                } catch (e) { console.warn("Jarvis telemetry: " + e) }
            }
        }
    }
    IpcHandler {
        target: "jarvis"
        function toggle(): void { if (root.active) root.overview = !root.overview }
        function close(): void { root.overview = false }
        function status(): string { return JSON.stringify({active: root.active, overview: root.overview, barHidden: root.shell && root.shell.bar ? root.shell.bar.barHidden : null, stats: root.stats}) }
    }
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData
            visible: root.active
            anchors { top: true; bottom: true; left: true; right: true }
            margins.top: root.shell && root.shell.bar && !root.shell.bar.barHidden && root.shell.bar.position === "top" ? root.shell.bar.barSize : 0
            margins.bottom: root.shell && root.shell.bar && !root.shell.bar.barHidden && root.shell.bar.position === "bottom" ? root.shell.bar.barSize : 0
            margins.left: root.shell && root.shell.bar && !root.shell.bar.barHidden && root.shell.bar.position === "left" ? root.shell.bar.barSize : 0
            margins.right: root.shell && root.shell.bar && !root.shell.bar.barHidden && root.shell.bar.position === "right" ? root.shell.bar.barSize : 0
            color: "#060e15"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "jarvis-hud"
            WlrLayershell.layer: root.overview ? WlrLayer.Top : WlrLayer.Bottom
            WlrLayershell.keyboardFocus: root.overview ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            Dashboard {
                anchors.fill: parent
                stats: root.stats
                cpuHistory: root.cpuHistory
                netHistory: root.netHistory
                overview: root.overview
                focus: root.overview
                onOverviewChanged: if (overview) forceActiveFocus()
                Keys.onEscapePressed: root.overview = false
                onDismiss: root.overview = false
            }
        }
    }
}
