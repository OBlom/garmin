import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;
import Flower;

class FlowerLapCounterView extends WatchUi.DataField {

    hidden var mValue as Numeric;
    hidden var mCounter as Number;
    hidden var mCounterActive as Boolean;
    hidden var _leafs as Leaf or Null;
    //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
    const drawCenter = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2] as Array<Number>;
    const drawLeaf = [[0,0,0,0,0], // 0
                      [1,2,2,2,2], // 1
                      [1,1,2,2,2], // 2 
                      [1,1,1,2,2], // 3
                      [1,1,1,1,2], // 4
                      [1,1,1,1,1], // 5
                      [2,1,1,1,1], // 6
                      [2,2,1,1,1], // 7
                      [2,2,2,1,1], // 8
                      [2,2,2,2,1], // 9
                      [0,0,0,0,0], // 10
                      [1,2,2,2,2], // 11
                      [1,1,2,2,2], // 12 
                      [1,1,1,2,2], // 13
                      [1,1,1,1,2], // 14
                      [1,1,1,1,1], // 15
                      [2,1,1,1,1], // 16
                      [2,2,1,1,1], // 17
                      [2,2,2,1,1], // 18
                      [2,2,2,2,1]] // 19
                      as Array<Array<Number>>;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
        mCounter = 0;
        mCounterActive = false;
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
                if ( info.elapsedTime > 0){
                    mCounterActive = true;
                    mCounter = ((info.elapsedDistance + 0.5) / 50.0 as Float).toNumber();                  
                }
            }
        }
        if (!mCounterActive)
        {
            mCounter++; // Draw flower while waiting for start
        }
        
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        
        
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
        
        if (mCounter % 20 < 10) {
            dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_WHITE);   
        } else {
            dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_BLACK);
        }
        dc.clear();
        
        var center = self._leafs.getCenterLeaf();
        var drawType = drawCenter[mCounter % drawCenter.size()] as Number;
        if (drawType == 1)
        {
            dc.fillPolygon(center); 
        }
        else if(drawType == 2)
        {
            for (var i = 1 as Number; i < center.size() ; i +=1)
            {
                dc.drawLine(center[i-1][0],center[i-1][1],center[i][0],center[i][1]);
            }
        }
        else{
            //Don't draw
        }
        
        
        var drawLeafType = drawLeaf[(mCounter % drawLeaf.size())] as Array<Number>;

        for (var l = 0 as Number; l < 5; l += 1)
        {   
            var leaf = self._leafs.getLeaf(l) as Array<Array<Number>>;       
            if (drawLeafType[l] == 1)
            {
                
               dc.fillPolygon(leaf); 
            }
            else if (drawLeafType[l] == 2)
            {
                for (var i = 1 as Number; i < leaf.size() ; i +=1)
                {
                    dc.drawLine(leaf[i-1][0],leaf[i-1][1],leaf[i][0],leaf[i][1]);
                }
            }
            else
            {
                // Don't draw
            }

        }
        if (!mCounterActive && dc.getHeight()>3*Graphics.getFontHeight(Graphics.FONT_SMALL))
        {
            var demoDistance = mCounter%20 * 50 as Number;
            if (demoDistance == 0 && mCounter != 0)
            {
                demoDistance = 1000;
            }
            
            var message =  demoDistance.format("%d") + "m" as String;
            
            dc.drawText(
            dc.getWidth() / 2,                      // gets the width of the device and divides by 2
            dc.getHeight()-Graphics.getFontHeight(Graphics.FONT_SMALL),                     // gets the height of the device and divides by 2
            Graphics.FONT_SMALL,                    // sets the font size
            message,                                // the String to display
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
                    );
            dc.drawText(
            dc.getWidth() / 2,                      // gets the width of the device and divides by 2
            0,                     // gets the height of the device and divides by 2
            Graphics.FONT_SMALL,                    // sets the font size
            "demo:",                                // the String to display
            Graphics.TEXT_JUSTIFY_CENTER           // sets the justification for the text
                    );
            
        }
 
    }

}
