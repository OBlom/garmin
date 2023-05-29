import Toybox.Lang;
import Toybox.Math;
module Flower{


class Leaf
{
    const  resolution = 8 as Number;
    const  numLeafs = 5 as Number;
    const  angleOffset = Math.PI / 90.0f as Float;
    const  centerRadieRatio = 1.0f / 6.0f as Float;
    const  radiusOffset = 3.0 as Float;
    const  startAngle = Math.PI*1.3f as Float;
    const  deltaAngleLeaf = (Math.PI * 2.0f / numLeafs) as Float;
    const  angleStep = (deltaAngleLeaf - (2 * angleOffset)) / (resolution -1.0f) as Float;
    
    protected var _centerLeaf as Array<Array<Number>>;
    protected var _leafs as Array<Array<Array<Number>>>;
    public function initialize(ratio as Float, diameter as Number,xpos as Number,ypos as Number)
    {
        var rc = diameter * self.centerRadieRatio as Float;
        var r1 = rc + radiusOffset as Float;
        var rMax = rc / (2.0f * centerRadieRatio) as Float;
        var S = resolution - 1.0f as Float;
        var a = 4.0f / (S * S) as Float;
        var b = -4.0f / S as Float;
        var dR = ratio * (rMax - r1) as Float;
        self._centerLeaf = new Array<Array<Number>>[resolution * numLeafs +1];
        self._leafs = new Array<Array<Array<Number>>>[numLeafs];
        for (var l = 0 as Number; l < numLeafs; l += 1)
        {
            self._leafs[l] = new Array<Array<Number>>[resolution*2+1];
            var vStart = startAngle + l * deltaAngleLeaf + angleOffset as Float;
            for (var i = 0 as Number; i < resolution; i += 1)
            {
                var r2 = rMax - (dR * ((a * i * i) + (b * i) + 1.0f) ) as Float;
                var v = vStart + i * angleStep as Float;
                var cosv = Math.cos(v) as Float;
                var sinv = Math.sin(v) as Float;
                self._centerLeaf[l*resolution + i]   = [(rc * cosv as Float).toNumber() + xpos, (rc * sinv as Float).toNumber() + ypos ];
                self._leafs[l][i]                    = [(r2 * cosv as Float).toNumber() + xpos, (r2 * sinv as Float).toNumber() + ypos ];
                self._leafs[l][(resolution*2-1) - i] = [(r1 * cosv as Float).toNumber() + xpos, (r1 * sinv as Float).toNumber() + ypos ];
            }
            self._leafs[l][resolution*2] = self._leafs[l][0];
        }

        self._centerLeaf[numLeafs*resolution] = self._centerLeaf[0];
    }
    public function getCenterLeaf() as Array<Array<Number>>
    {
        return self._centerLeaf;
    }
    public function getLeaf(id as Number) as Array<Array<Number>>
    {
        var i = id % numLeafs;
        return self._leafs[i];
    }
    public function getNumLeafs() as Number
    {
        return self.numLeafs;
    }
}
}
