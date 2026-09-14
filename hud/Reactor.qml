import QtQuick
Item {
    id: root
    property real load: 0
    property real memory: 0
    property string temperature: "—"
    property int second: 0
    property bool animate: visible
    Item {
        id: disc
        width: Math.min(root.width,root.height); height: width
        anchors.centerIn: parent
        Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
            id: base
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onPaint: {
                var c=getContext("2d");c.reset();var x=width/2,y=height/2,r=width*.39;
                var g=c.createRadialGradient(x,y,10,x,y,width*.5);g.addColorStop(0,"#18234f60");g.addColorStop(1,"#00000000");c.fillStyle=g;c.fillRect(0,0,width,height);
                for(var i=0;i<90;i++){var a=i*4*Math.PI/180,inner=r+(i%5===0?18:23);c.beginPath();c.moveTo(x+inner*Math.sin(a),y-inner*Math.cos(a));c.lineTo(x+(r+30)*Math.sin(a),y-(r+30)*Math.cos(a));c.lineWidth=i%5===0?1.5:1;c.strokeStyle=i%5===0?"#367b91":"#19465c";c.stroke()}
                function arc(rad,color,line){c.beginPath();c.arc(x,y,rad,0,Math.PI*2);c.strokeStyle=color;c.lineWidth=line;c.stroke()}
                arc(r+7,"#1b536b",1);arc(r-48,"#0e3b4d",7);arc(r-68,"#1b536a",1);
                c.fillStyle="#cf06141d";c.beginPath();c.arc(x,y,r-69,0,Math.PI*2);c.fill();
                c.strokeStyle="#28697f";c.lineWidth=1;
                [[22,45,1,1],[width-22,45,-1,1],[22,height-45,1,-1],[width-22,height-45,-1,-1]].forEach(function(p){c.beginPath();c.moveTo(p[0],p[1]);c.lineTo(p[0]+26*p[2],p[1]);c.lineTo(p[0]+38*p[2],p[1]+12*p[3]);c.stroke()});
            }
        }
        Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
            id: orbit
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onPaint: {
                var c=getContext("2d");c.reset();var x=width/2,y=height/2,r=width*.39;
                function arc(a,b,radius,col,w){c.beginPath();c.arc(x,y,radius,a*Math.PI/180,b*Math.PI/180);c.strokeStyle=col;c.lineWidth=w;c.stroke()}
                c.shadowColor="#008fae";c.shadowBlur=5;
                arc(3,91,r,"#00aaca",2);arc(114,132,r,"#2fe4ff",3);arc(171,244,r,"#08788e",2);arc(280,346,r,"#00bad6",2);
                arc(25,39,r+5,"#59eeff",2);
                c.fillStyle="#8af5ff";c.beginPath();c.arc(x+r,y,3,0,Math.PI*2);c.fill();
            }
            NumberAnimation on rotation { from: 0; to: 360; duration: 32000; loops: Animation.Infinite; running: root.animate }
        }
        Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onPaint: {
                var c=getContext("2d");c.reset();var x=width/2,y=height/2,r=width*.39-16;
                c.strokeStyle="#247087";c.lineWidth=6;
                [[0,24],[31,55],[130,177],[210,251],[291,305]].forEach(function(s){c.beginPath();c.arc(x,y,r,s[0]*Math.PI/180,s[1]*Math.PI/180);c.stroke()});
                c.strokeStyle="#285d70";c.lineWidth=1;
                for(var i=0;i<100;i++){var a=i*Math.PI/50;c.beginPath();c.arc(x,y,r-10,a,a+.018);c.stroke()}
            }
            NumberAnimation on rotation { from: 0; to: -360; duration: 22000; loops: Animation.Infinite; running: root.animate }
        }
        Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onPaint: {
                var c=getContext("2d");c.reset();var x=width/2,y=height/2,r=width*.39-28;
                c.fillStyle="#1400dfff";c.beginPath();c.moveTo(x,y);c.arc(x,y,r,-Math.PI/2,-Math.PI/5);c.closePath();c.fill();
                c.strokeStyle="#2231dfff";c.lineWidth=1;c.beginPath();c.moveTo(x,y);c.lineTo(x,y-r);c.stroke();
            }
            NumberAnimation on rotation { from: 0; to: 360; duration: 9000; loops: Animation.Infinite; running: root.animate }
        }
        Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
            id: activity
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onPaint: {
                var c=getContext("2d");c.reset();var x=width/2,y=height/2,r=width*.39-48,fill=Math.max(0,Math.min(100,root.load));
                c.strokeStyle="#00dfff";c.lineWidth=5;c.lineCap="round";c.shadowColor="#00cfff";c.shadowBlur=11;
                if(fill>0){c.beginPath();c.arc(x,y,r,-Math.PI/2,-Math.PI/2+fill*Math.PI/50);c.stroke()}
                c.shadowBlur=0;c.strokeStyle="#3a839b";c.lineWidth=1;
                c.beginPath();c.moveTo(x-110,y-48);c.lineTo(x-95,y-63);c.lineTo(x-75,y-63);c.stroke();
                c.beginPath();c.moveTo(x+110,y+57);c.lineTo(x+95,y+72);c.lineTo(x+75,y+72);c.stroke();
            }
            Connections { target: root; function onLoadChanged(){activity.requestPaint()} }
        }
        Column {
            anchors.centerIn: parent; anchors.verticalCenterOffset: 5; spacing: 10
            HudText { anchors.horizontalCenter: parent.horizontalCenter; text: "COMPUTE ACTIVITY"; displayFace: true; font.pixelSize: 9; font.letterSpacing: 2.4; color: "#54869a" }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 3
                HudText { text: root.load.toFixed(0); displayFace: true; font.pixelSize: 75; weight: Font.Bold; color: "#00dfff" }
                HudText { text: "%"; displayFace: true; font.pixelSize: 25; color: "#00dfff"; anchors.bottom: parent.bottom; anchors.bottomMargin: 12 }
            }
            Rectangle { width: 64; height: 1; color: "#285369"; anchors.horizontalCenter: parent.horizontalCenter }
            HudText { anchors.horizontalCenter: parent.horizontalCenter; text: "PROCESSOR LOAD"; font.pixelSize: 14; font.letterSpacing: 1.7; color: "#77a5b8" }
            HudText { anchors.horizontalCenter: parent.horizontalCenter; text: root.temperature + "   /   CPU"; displayFace: true; font.pixelSize: 10; color: "#e5aa62" }
        }
    }
}
