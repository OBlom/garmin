import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

class FlowerLapCounterView extends WatchUi.DataField {

    hidden var mValue as Numeric;
    hidden var mCounter as Number;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
        mCounter = 0;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
        }

         (View.findDrawableById("label") as Text).setText(Rez.Strings.label);
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
        
        // Set the background color
        

        // Set the foreground color and value
       // var value = View.findDrawableById("value") as Text;
      //  if (getBackgroundColor() == Graphics.COLOR_BLACK) {
     //       value.setColor(Graphics.COLOR_WHITE);
     //   } else {
     //       value.setColor(Graphics.COLOR_BLACK);
     //   }
     //   value.setText(mCounter.format("%d"));

    //dc.fillRectangle(100, 100, 100, 100);
    
        
        
        
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
        
        if (mCounter % 4 == 0)
        {
           dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
       else{
            dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_WHITE );
        }
        dc.clear();
        var width = dc.getWidth() as Number;
        var height = dc.getHeight() as Number;
        var centerW = width / 2 as Number;
        var centerH = height / 2 as Number;

        var size = (height > width ? width : height) / 6 as Number;
        

        dc.fillCircle(centerW,centerH,size);
        var leaf = getLeaf2(centerW,centerH,size,Math.PI*1.5f);
        dc.fillPolygon(leaf);
        var leaf2 = getLeaf2(centerW,centerH,size,Math.PI*1.9f);
        dc.fillPolygon(leaf2);
        var leaf3 = getLeaf2(centerW,centerH,size,Math.PI*2.3f);
        dc.fillPolygon(leaf3);
        var leaf4 = getLeaf2(centerW,centerH,size,Math.PI*2.7f);
        dc.fillPolygon(leaf4);
        var leaf5 = getLeaf2(centerW,centerH,size,Math.PI*3.1f);
        dc.fillPolygon(leaf5);

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
        var radiusOffset = 5.0 as Float;
        var rReduce = 4.0 as Float;
        var steps = 8 as Number;

        var leafPoints = new Array<Array<Numeric>>[steps*2+1];
        var radSteps = (Math.PI*0.4f-2*degOffset)/ (steps-1) as Float;
        var r1 = size + radiusOffset;
        var a = (steps-1) / 2.0f as Float;
        for (var i = 0 as Number; i < steps; i+= 1)
        {
            var r2 = (size * 3.0f) - (rReduce * (i - a)*(i - a)) as Float;
            var v = i*radSteps+startAngle+degOffset as Float;
            leafPoints[i]       = [Math.floor(r2*Math.cos(v))+x,Math.floor(r2*Math.sin(v))+y];
            leafPoints[(steps*2-1)-i] = [Math.floor(r1*Math.cos(v))+x,Math.floor(r1*Math.sin(v))+y];
        }
        leafPoints[steps*2]=leafPoints[0];
        return leafPoints;
    }
}
