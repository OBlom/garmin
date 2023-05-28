import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;
import Flower;

class FlowerLapCounterView extends WatchUi.DataField {

    hidden var mValue as Numeric;
    hidden var mCounter as Number;
    hidden var _leafs as Leaf or Null;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
        mCounter = 0;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var width = dc.getWidth() as Number;
        var height = dc.getHeight() as Number;
        var centerW = width / 2 as Number;
        var centerH = height / 2 as Number;

        var size = (height > width ? width : height) as Number;
        self._leafs = new Flower.Leaf(0.6f, size, centerW,centerH);

    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        mCounter++;
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                mValue = info.currentHeartRate as Number;
            } else {
                mValue = 0.0f;
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        
        
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
        
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            dc.setColor(Graphics.COLOR_WHITE,getBackgroundColor());
        } else {
            dc.setColor(Graphics.COLOR_BLACK,getBackgroundColor());
        }
        dc.clear();
        
        var center = self._leafs.getCenterLeaf();
        if (mCounter % 20 < 10)
        {
            dc.fillPolygon(center);
        }
        else
        {
            for (var i = 1 as Number; i < center.size() ; i +=1)
            {
                dc.drawLine(center[i-1][0],center[i-1][1],center[i][0],center[i][1]);
            }
            
        }
        if (mCounter % 10 < 5)
        {
            var leafs = mCounter % 5 + 1;
            for (var l = 0 as Number; l < leafs; l += 1)
            {
                var leaf = self._leafs.getLeaf(l);
                dc.fillPolygon(leaf);
            }
        }
        else
        {
            var leafs = (mCounter % 5);
            for (var l = (mCounter % 5 + 1) as Number; l < 5; l += 1)
            {
                var leaf = self._leafs.getLeaf(l);
                dc.fillPolygon(leaf);
            }
        }
        
        
    }

    function  getLeaf(x as Number, y as Number, size as Number, startAngle as Float) as Array<Array<Numeric>>
    {
        var degOffset = Math.PI/45.0f as Float;
        var radiusOffset = 2.0 as Float;
        var cosStart = Math.cos(startAngle+degOffset) as Float;
        var cosEnd   = Math.cos(startAngle+Math.PI*0.4f-degOffset) as Float;
        var sinStart = Math.sin(startAngle+degOffset) as Float;
        var sinEnd   = Math.sin(startAngle+Math.PI*0.4f-degOffset) as Float;
        var r1 = size + radiusOffset;
        var r2 = size*3 - radiusOffset;
        
        var p1 = [Math.floor(r2*cosStart)+x,Math.floor(r2*sinStart)+y];
        var p2 = [Math.floor(r2*cosEnd)+x,Math.floor(r2*sinEnd)+y]; 
        var p3 = [Math.floor(r1*cosEnd)+x,Math.floor(r1*sinEnd)+y];
        var p4 = [Math.floor(r1*cosStart)+x,Math.floor(r1*sinStart)+y];    
        return [p1,p2,p3,p4,p1];
    }
    function  getLeaf2(x as Number, y as Number, size as Number, startAngle as Float) as Array<Array<Numeric>>
    {
        var degOffset = Math.PI/90.0f as Float;
        var radiusOffset = 3.0 as Float;
        var ratio = 1.0 as Float;
        var steps = 10 as Number;
        var leafPoints = new Array<Array<Numeric>>[steps*2+1];
        var radSteps = (Math.PI*0.4f-2*degOffset)/ (steps-1) as Float;
        var r1 = size + radiusOffset;
        var rMax = size * 3.0f as Float;
        var S = steps - 1.0f as Float;
        var a = 4.0f / (S * S) as Float;
        var b = -4.0f / S as Float;
        var dR = ratio * (rMax - r1) as Float;
        for (var i = 0 as Number; i < steps; i+= 1)
        {
            var r2 = rMax - (dR * ((a * i * i) + (b * i) + 1.0f) ) as Float;
            var v = i*radSteps+startAngle+degOffset as Float;
            leafPoints[i]       = [Math.floor(r2*Math.cos(v))+x,Math.floor(r2*Math.sin(v))+y];
            leafPoints[(steps*2-1)-i] = [Math.floor(r1*Math.cos(v))+x,Math.floor(r1*Math.sin(v))+y];
        }
        leafPoints[steps*2]=leafPoints[0];
        return leafPoints;
    }
}
