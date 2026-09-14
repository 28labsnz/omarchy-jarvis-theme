import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

BarWidget {
    id: root
    moduleName: "jase.jarvis"
    readonly property bool active: String(Color.accent).toLowerCase() === "#00d9f5"
    visible: active
    implicitWidth: active ? 132 : 0
    implicitHeight: barSize
    Row {
        anchors.centerIn: parent
        spacing: 9
        Rectangle { width: 5; height: 5; radius: 3; color: "#48dfad"; anchors.verticalCenter: parent.verticalCenter }
        Text { text: "J.A.R.V.I.S."; color: "#00d9f5"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.letterSpacing: 1.5 }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: Quickshell.execDetached(["omarchy-shell", "jarvis", "toggle"])
        onEntered: if (root.bar) root.bar.showTooltip(root, "Jarvis command overview · Esc to close")
        onExited: if (root.bar) root.bar.hideTooltip(root)
    }
}
