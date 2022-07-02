package test;

import hsluv.ColorPicker2;
import hsluv0.ColorPicker;



class ColorPickerTest {

    static public function assertClose(a: Float, b: Float) {
        if (Math.abs(Math.abs(a) - Math.abs(b)) > 0.00000000001) {
            throw new haxe.Exception("not close");
        }
    }

    static public function main () {
        for (l in 1...100) {
            trace("Lightness: " + l);
            var g1 = ColorPicker.getPickerGeometry(l);
            var g2 = ColorPicker2.getPickerGeometry(l);
            if (g1.vertices.length != g2.vertices.length) {
                trace(g1.vertices.length);
                trace(g2.vertices.length);
                throw new haxe.Exception("vertices.length not equal");
            }

            var i = 0;
            while (i < g1.vertices.length) {
                assertClose(g1.vertices[i].x, g2.vertices[i].x);
                assertClose(g1.vertices[i].y, g2.vertices[i].y);
                i++;
            }
        }
        trace("OK");
    }
}
