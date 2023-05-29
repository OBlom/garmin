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
    
        // See Activity.Info in the documentation for available information.
        if (info has :elapsedTime && info has :elapsedDistance)
        {
            if (info.elapsedTime != null && info.elapsedDistance != null){
                if ( info.elapsedTime > 100){
                    mCounter = ((info.elapsedDistance + 0.5) / 50.0 as Float).toNumber();
                }
                else{
                    mCounter++;
                }
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
        if (mCounter % 20 <  10)
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

}
