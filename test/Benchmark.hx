package test;

import hsluv.Hsluv;
import hsluv0.Hsluv as Hsluv0;



class Benchmark {

    static public function main () {
        for (h in 0...360) {
            for (s in 0...100) {
                for (l in 0...100) {
                    Hsluv0.hsluvToRgb([h, s, l]);
                }
            }
        }
    }

    static public function main1 () {
        var conv = new Hsluv();
        for (h in 0...360) {
            for (s in 0...100) {
                for (l in 0...100) {
                    conv.hsluv_h = h;
                    conv.hsluv_s = s;
                    conv.hsluv_l = l;
                    conv.hsluvToRgb();
                }
            }
        }
    }
}
