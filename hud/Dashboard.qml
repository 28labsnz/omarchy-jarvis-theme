pragma ComponentBehavior: Bound
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
    color: "#030b12"
    function value(key, fallback) { return stats[key] === undefined || stats[key] === null ? fallback : stats[key] }
    function launch(command) { Quickshell.execDetached(command); dismiss() }
    FontLoader { source: Qt.resolvedUrl("fonts/Orbitron-Variable.ttf") }
    FontLoader { source: Qt.resolvedUrl("fonts/Rajdhani-Regular.ttf") }
    FontLoader { source: Qt.resolvedUrl("fonts/Rajdhani-Medium.ttf") }
    FontLoader { source: Qt.resolvedUrl("fonts/Rajdhani-SemiBold.ttf") }
    Timer { interval: 1000; running: root.visible; repeat: true; onTriggered: root.now = new Date() }
    Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
        anchors.fill: parent
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            var c=getContext("2d");c.reset();var g=c.createRadialGradient(width*.5,height*.4,0,width*.5,height*.4,width*.55);
            g.addColorStop(0,"#082b3d");g.addColorStop(.5,"#061723");g.addColorStop(1,"#030b12");c.fillStyle=g;c.fillRect(0,0,width,height);
        }
    }
    Item {
        id: composition
        width: 1380; height: 900
        anchors.centerIn: parent
        scale: Math.min((root.width-90)/width,(root.height-90)/height)
        transformOrigin: Item.Center
        HudText { x: 0; y: 0; text: "STARK / DESKTOP OS"; displayFace: true; color: "#477a8d"; font.pixelSize: 10; font.letterSpacing: 2.3 }
        HudText { x: -2; y: 31; text: "J.A.R.V.I.S."; displayFace: true; weight: Font.DemiBold; color: "#35e5ff"; font.pixelSize: 43; font.letterSpacing: 4 }
        HudText { x: 0; y: 95; text: "PERSONAL COMMAND SYSTEM"; displayFace: true; color: "#608999"; font.pixelSize: 9; font.letterSpacing: 2.4 }
        Row {
            x: 570; y: 49; spacing: 9
            Rectangle {
                width: 5; height: 5; radius: 3; color: "#00efb0"; anchors.verticalCenter: parent.verticalCenter
                SequentialAnimation on opacity { loops: Animation.Infinite; running: root.visible; NumberAnimation { to: .35; duration: 1200 } NumberAnimation { to: 1; duration: 1200 } }
            }
            HudText { text: "LIVE LINK  /  " + root.value("host","CONNECTING").toUpperCase(); displayFace: true; color: "#5dc4bd"; font.pixelSize: 9; font.letterSpacing: 1.2 }
        }
        HudText { anchors.right: parent.right; y: 29; text: Qt.formatDateTime(root.now,"HH:mm"); displayFace: true; font.pixelSize: 34; color: "#9ec3d2" }
        HudText { anchors.right: parent.right; y: 85; text: Qt.formatDateTime(root.now,"ddd, dd MMM yyyy").toUpperCase(); displayFace: true; color: "#507d91"; font.pixelSize: 9; font.letterSpacing: 1.4 }
        ActionOrb { x: 891; y: 31; width: 90; visible: root.overview; compact: true; label: "CLOSE"; symbol: "×"; onActivated: root.dismiss() }
        Rectangle {
            id: separator
            y: 131; width: parent.width; height: 1; clip: true
            gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0; color: "#286479" } GradientStop { position: 1; color: "#071a26" } }
            Rectangle {
                width: 100; height: 1; color: "#42e5ff"
                SequentialAnimation on x { loops: Animation.Infinite; running: root.visible; NumberAnimation { from: -100; to: separator.width; duration: 8500 } }
            }
        }
        Column {
            x: 0; y: 177; spacing: 30
            HudCard {
                width: 282; height: 178; caption: "COMPUTE"; number: "01"
                HudText { x: 4; y: 50; text: Number(root.value("cpu",0)).toFixed(1) + "%"; displayFace: true; font.pixelSize: 29; color: "#a5e9f5" }
                HudText { anchors.right: parent.right; y: 65; text: "CPU LOAD"; displayFace: true; font.pixelSize: 8; font.letterSpacing: 1; color: "#548799" }
                Sparkline { x: 4; y: 99; width: 274; height: 51; values: root.cpuHistory; ink: "#00dfff" }
                HudText { x: 4; y: 160; text: "PROCESSOR ACTIVITY  /  LAST 60 S"; font.pixelSize: 11; font.letterSpacing: 1; color: "#497b8e" }
            }
            HudCard {
                width: 282; height: 155; caption: "MEMORY"; number: "02"
                MiniDial { x: 0; y: 47; width: 102; height: 102; amount: root.value("memory",0) }
                HudText { x: 119; y: 65; text: root.value("memoryUsed","—") + " GiB"; displayFace: true; font.pixelSize: 24; color: "#a5e9f5" }
                HudText { x: 120; y: 104; text: "OF " + root.value("memoryTotal","—") + " GiB ALLOCATED"; font.pixelSize: 12; font.letterSpacing: .8; color: "#6798ac" }
            }
            HudCard {
                width: 282; height: 155; caption: "STORAGE"; number: "03"
                MiniDial { x: 0; y: 47; width: 102; height: 102; amount: root.value("disk",0); ink: "#5ac5da" }
                HudText { x: 119; y: 65; text: root.value("diskFree","—"); displayFace: true; font.pixelSize: 26; color: "#a5e9f5" }
                HudText { x: 120; y: 105; text: "GiB FREE  /  HOME VOLUME"; font.pixelSize: 12; color: "#6798ac" }
            }
        }
        HudText { x: 410; y: 177; width: 560; horizontalAlignment: Text.AlignHCenter; text: "SYSTEM REACTOR"; displayFace: true; font.pixelSize: 11; font.letterSpacing: 3; color: "#598ea2" }
        HudText { x: 410; y: 205; width: 560; horizontalAlignment: Text.AlignHCenter; text: "Memory " + root.value("memory",0) + "%  ·  " + (root.stats.battery ? "Battery " + root.stats.battery.percent + "%" : "External power"); font.pixelSize: 16; color: "#6c9eaf" }
        Reactor { x: 415; y: 218; width: 550; height: 500; load: root.value("cpu",0); memory: root.value("memory",0); temperature: root.value("temperature",null) === null ? "—" : root.stats.temperature+"°C"; second: root.now.getSeconds() }
        HudText { x: 460; y: 719; width: 460; horizontalAlignment: Text.AlignHCenter; text: "LOCAL TELEMETRY  /  ONLINE"; displayFace: true; font.pixelSize: 9; font.letterSpacing: 2.1; color: "#00bfaf" }
        Column {
            x: 1098; y: 177; spacing: 30
            HudCard {
                width: 282; height: 155; caption: "POWER RESERVE"; number: "04"
                MiniDial { x: 0; y: 47; width: 102; height: 102; amount: root.stats.battery ? root.stats.battery.percent : 100; label: root.stats.battery ? root.stats.battery.percent + "%" : "AC"; ink: "#efac55" }
                HudText { x: 120; y: 74; text: root.stats.battery ? root.stats.battery.status.toUpperCase() : "EXTERNAL POWER"; font.pixelSize: 16; font.letterSpacing: 1; color: "#e4b57b" }
                HudText { x: 120; y: 105; text: root.stats.battery ? "BATTERY CAPACITY" : "POWER CONNECTED"; font.pixelSize: 11; font.letterSpacing: 1; color: "#6b8e9e" }
            }
            HudCard {
                width: 282; height: 178; caption: "NETWORK I/O"; number: "05"
                HudText { x: 4; y: 49; text: "↓ " + root.value("rx",0); displayFace: true; font.pixelSize: 28; color: "#a5e9f5" }
                HudText { anchors.right: parent.right; y: 66; text: "KiB/s"; font.pixelSize: 14; color: "#548799" }
                Sparkline { x: 4; y: 100; width: 274; height: 44; values: root.netHistory; ink: "#00dfff" }
                HudText { x: 4; y: 159; text: "↑ " + root.value("tx",0) + " KiB/s"; color: "#6798ac"; font.pixelSize: 13 }
                HudText { anchors.right: parent.right; y: 159; text: root.value("interface","OFFLINE"); color: "#00cba7"; font.pixelSize: 12; width: 128; horizontalAlignment: Text.AlignRight; elide: Text.ElideRight }
            }
            HudCard {
                width: 282; height: 155; caption: "SESSION"; number: "06"
                HudText { x: 5; y: 60; text: Math.floor(root.value("uptime",0)/3600) + "h " + Math.floor(root.value("uptime",0)%3600/60) + "m"; displayFace: true; font.pixelSize: 30; color: "#a5e9f5" }
                HudText { x: 5; y: 109; text: "UPTIME  /  OMARCHY · HYPRLAND"; font.pixelSize: 12; font.letterSpacing: 1; color: "#6798ac" }
            }
        }
        Row {
            x: 395; y: 763; spacing: 23
            Repeater {
                model: [
                    {label:"TERMINAL", sub:"Command line", icon:"\uf489", command:["omarchy","launch","terminal"]},
                    {label:"BROWSER", sub:"Explore the web", icon:"\uf0ac", command:["omarchy","launch","browser"]},
                    {label:"FILES", sub:"Your workspace", icon:"\uf07b", command:["omarchy","launch","nautilus"]},
                    {label:"MONITOR", sub:"System processes", icon:"\uf080", command:["omarchy","launch","tui","btop"]}
                ]
                ActionOrb {
                    required property var modelData
                    width: 130; height: 128
                    label: modelData.label; subtitle: modelData.sub; symbol: modelData.icon
                    onActivated: root.launch(modelData.command)
                }
            }
        }
        HudText { x: 0; y: 868; text: "JARVIS / 2.0"; displayFace: true; font.pixelSize: 9; font.letterSpacing: 2; color: "#376175" }
        HudText { anchors.right: parent.right; y: 868; text: root.overview ? "ESC TO RETURN" : "OPEN JARVIS FROM THE TOP BAR"; displayFace: true; font.pixelSize: 8; font.letterSpacing: 1; color: "#376175" }
    }
}
