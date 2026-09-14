import QtQuick
import Quickshell

Rectangle {
    id: root
    property var stats: ({})
    property var cpuHistory: []
    property var netHistory: []
    property bool overview: false
    property date now: new Date()
    signal dismiss()
    color: "#060e15"
    function value(key, fallback) { return stats[key] === undefined || stats[key] === null ? fallback : stats[key] }
    function launch(command) { Quickshell.execDetached(command); dismiss() }
    Timer { interval: 1000; running: root.visible; repeat: true; onTriggered: root.now = new Date() }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var c=getContext("2d");c.reset();c.lineWidth=1;c.strokeStyle="#0c1d28";
            for(var x=0;x<width;x+=48){c.beginPath();c.moveTo(x,0);c.lineTo(x,height);c.stroke()}
            for(var y=0;y<height;y+=48){c.beginPath();c.moveTo(0,y);c.lineTo(width,y);c.stroke()}
        }
    }
    Item {
        id: composition
        width: 1400; height: 870
        anchors.centerIn: parent
        scale: Math.min((root.width-72)/width,(root.height-90)/height)
        transformOrigin: Item.Center

        HudText { x: 0; y: 0; text: "PERSONAL COMPUTING  /  COMMAND INTERFACE"; color: "#628b9d"; font.pixelSize: 10; font.letterSpacing: 2.8 }
        Text { x: -3; y: 25; text: "J.A.R.V.I.S."; color: "#e0f5fd"; font.family: "Adwaita Sans"; font.weight: Font.Light; font.pixelSize: 57; font.letterSpacing: 9 }
        Row {
            x: 3; y: 102; spacing: 9
            Rectangle { width: 5; height: 5; radius: 3; color: "#48dfad"; anchors.verticalCenter: parent.verticalCenter }
            HudText { text: "LOCAL SYSTEM LINK  /  " + root.value("host", "CONNECTING").toUpperCase(); color: "#7ca5b7"; font.pixelSize: 10; font.letterSpacing: 1.5 }
        }
        HudText { anchors.right: parent.right; y: 23; text: Qt.formatDateTime(root.now,"HH:mm"); font.pixelSize: 45; font.weight: Font.Light; color: "#d2ecf6" }
        HudText { anchors.right: parent.right; y: 82; text: Qt.formatDateTime(root.now,"ddd, dd MMM yyyy").toUpperCase(); color: "#638c9e"; font.pixelSize: 11; font.letterSpacing: 2 }
        Rectangle {
            x: 625; y: 77; width: 180; height: 32
            visible: root.overview
            color: closeMouse.containsMouse ? "#133644" : "#0a1d28"
            border.color: "#275567"
            HudText { anchors.centerIn: parent; text: "×  CLOSE OVERVIEW"; color: "#83bfce"; font.pixelSize: 10 }
            MouseArea { id: closeMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.dismiss() }
        }
        Rectangle { y: 140; width: parent.width; height: 1; color: "#21414f" }
        Rectangle { y: 140; width: 90; height: 2; color: "#00d9f5" }

        Column {
            x: 0; y: 177; spacing: 18
            HudCard {
                width: 310; height: 212; caption: "COMPUTE"; number: "01"
                HudText { x: 20; y: 49; text: Number(root.value("cpu",0)).toFixed(1); font.pixelSize: 42; color: "#e4f6fc" }
                HudText { x: 145; y: 71; text: "%  CPU"; color: "#00d9f5"; font.pixelSize: 11 }
                Sparkline { x: 20; y: 111; width: 270; height: 65; values: root.cpuHistory }
                HudText { x: 20; y: 188; text: "PROCESSOR ACTIVITY · LAST 60 S"; font.pixelSize: 9; color: "#567b8e" }
            }
            HudCard {
                width: 310; height: 145; caption: "MEMORY"; number: "02"
                HudText { x: 20; y: 48; text: root.value("memoryUsed","—") + " / " + root.value("memoryTotal","—"); font.pixelSize: 28; color: "#d8eff8" }
                HudText { x: 257; y: 61; text: "GiB"; color: "#709aac"; font.pixelSize: 11 }
                Rectangle { x: 20; y: 101; width: 270; height: 4; color: "#1c3643"; Rectangle { width: parent.width*root.value("memory",0)/100; height: 4; color: "#65adff" } }
                HudText { x: 20; y: 119; text: root.value("memory",0) + "% ALLOCATED"; font.pixelSize: 9; color: "#648c9e" }
            }
            HudCard {
                width: 310; height: 133; caption: "STORAGE"; number: "03"
                HudText { x: 20; y: 49; text: root.value("diskFree","—") + " GiB"; font.pixelSize: 28; color: "#d8eff8" }
                HudText { x: 20; y: 92; text: "FREE SPACE  /  " + root.value("disk",0) + "% USED"; font.pixelSize: 9; color: "#648c9e" }
            }
        }

        HudText { x: 370; y: 180; text: "REAL-TIME DIAGNOSTICS"; color: "#466f83"; font.pixelSize: 10; font.letterSpacing: 2.5 }
        HudText { x: 915; y: 180; text: "LIVE"; color: "#48dfad"; font.pixelSize: 10; font.letterSpacing: 2 }
        Reactor { x: 425; y: 225; width: 550; height: 440; load: root.value("cpu",0); memory: root.value("memory",0); temperature: root.value("temperature",null) === null ? "—" : root.stats.temperature+"°C"; second: root.now.getSeconds() }
        HudText { x: 403; y: 689; text: "01  CPU"; color: "#00d9f5"; font.pixelSize: 10; font.letterSpacing: 1.5 }
        HudText { x: 615; y: 689; text: "02  MEMORY"; color: "#65adff"; font.pixelSize: 10; font.letterSpacing: 1.5 }
        HudText { x: 851; y: 689; text: "03  CLOCK"; color: "#a7c4d2"; font.pixelSize: 10; font.letterSpacing: 1.5 }

        Column {
            x: 1090; y: 177; spacing: 18
            HudCard {
                width: 310; height: 151; caption: "POWER RESERVE"; number: "04"
                HudText { x: 20; y: 48; text: root.stats.battery ? root.stats.battery.percent + "%" : "AC"; font.pixelSize: 38; color: "#e4f6fc" }
                HudText { x: 150; y: 69; text: root.stats.battery ? root.stats.battery.status.toUpperCase() : "EXTERNAL POWER"; color: "#efb963"; font.pixelSize: 9 }
                Row { x: 20; y: 113; spacing: 4; Repeater { model: 27; Rectangle { required property int index; width: 6; height: 12; color: index < (root.stats.battery ? root.stats.battery.percent : 100)*.27 ? "#efb963" : "#25343a" } } }
            }
            HudCard {
                width: 310; height: 206; caption: "NETWORK I/O"; number: "05"
                HudText { x: 20; y: 50; text: "↓ " + root.value("rx",0); font.pixelSize: 27; color: "#d8eff8" }
                HudText { x: 210; y: 64; text: "KiB/s"; font.pixelSize: 11; color: "#7198aa" }
                Sparkline { x: 20; y: 96; width: 270; height: 55; values: root.netHistory }
                HudText { x: 20; y: 166; text: "↑ " + root.value("tx",0) + " KiB/s"; color: "#6f98aa"; font.pixelSize: 10 }
                HudText { anchors.right: parent.right; anchors.rightMargin: 20; y: 166; text: root.value("interface","OFFLINE"); color: "#48dfad"; font.pixelSize: 10; width: 130; horizontalAlignment: Text.AlignRight; elide: Text.ElideRight }
            }
            HudCard {
                width: 310; height: 133; caption: "SESSION"; number: "06"
                HudText { x: 20; y: 52; text: Math.floor(root.value("uptime",0)/3600) + "h " + Math.floor(root.value("uptime",0)%3600/60) + "m"; font.pixelSize: 28; color: "#d8eff8" }
                HudText { x: 20; y: 94; text: "UPTIME  /  OMARCHY · HYPRLAND"; font.pixelSize: 9; color: "#648c9e" }
            }
        }

        Row {
            x: 0; y: 759; spacing: 12
            Repeater {
                model: [
                    {label:"01 / TERMINAL", sub:"Open command line", command:["omarchy","launch","terminal"]},
                    {label:"02 / BROWSER", sub:"Open web browser", command:["omarchy","launch","browser"]},
                    {label:"03 / FILES", sub:"Browse workspace", command:["omarchy","launch","nautilus"]},
                    {label:"04 / MONITOR", sub:"Inspect processes", command:["omarchy","launch","tui","btop"]}
                ]
                Rectangle {
                    required property var modelData
                    width: 341; height: 72
                    color: actionMouse.containsMouse ? "#12303e" : "#0b1b25"
                    border.color: actionMouse.containsMouse ? "#00d9f5" : "#244453"
                    HudText { x: 19; y: 15; text: modelData.label; font.pixelSize: 11; font.letterSpacing: 1.5; color: "#8dc9dd" }
                    HudText { x: 19; y: 40; text: modelData.sub; font.pixelSize: 10; color: "#5e8598" }
                    HudText { anchors.right: parent.right; anchors.rightMargin: 18; y: 24; text: "↗"; font.pixelSize: 20; color: "#00d9f5" }
                    MouseArea { id: actionMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.launch(parent.modelData.command) }
                }
            }
        }
        HudText { x: 0; y: 853; text: "JARVIS / 1.0    •    LOCAL TELEMETRY / 2 SEC"; font.pixelSize: 9; color: "#3e687c"; font.letterSpacing: 1 }
        HudText { anchors.right: parent.right; y: 853; text: root.overview ? "ESC OR CLICK JARVIS TO RETURN TO DESKTOP" : "COMMAND OVERVIEW AVAILABLE IN TOP BAR"; font.pixelSize: 9; color: "#3e687c"; font.letterSpacing: 1 }
    }
}
