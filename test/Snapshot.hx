package test;

import Sys;
import hsluv.Hsluv;
import haxe.Json;
import haxe.ds.StringMap;


class Snapshot {

    static public function generateHexSamples () {
        var digits:String = "0123456789abcdef";
        var ret = [];
        for (i in 0...16) {
            var r = digits.charAt(i);
            for (j in 0...16) {
                var g = digits.charAt(j);
                for (k in 0...16) {
                    var b = digits.charAt(k);
                    var hex = "#" + r + r + g + g + b + b;
                    ret.push(hex);
                }
            }
        }
        return ret;
    }

    static public function generateSnapshot () {
        var ret:StringMap<StringMap<Array<Float>>> = new StringMap();
        var samples = Snapshot.generateHexSamples();
        var conv = new Hsluv();

        for (hex in samples) {
            conv.hex = hex;
            conv.hexToRgb();
            conv.rgbToXyz();
            conv.xyzToLuv();
            conv.luvToLch();
            conv.lchToHsluv();
            conv.lchToHpluv();

            var sample:StringMap<Array<Float>> = new StringMap();
            sample.set("rgb", [conv.rgb_r, conv.rgb_g, conv.rgb_b]);
            sample.set("xyz", [conv.xyz_z, conv.xyz_y, conv.xyz_z]);
            sample.set("luv", [conv.luv_l, conv.luv_u, conv.luv_v]);
            sample.set("lch", [conv.lch_l, conv.lch_c, conv.lch_h]);
            sample.set("hsluv", [conv.hsluv_h, conv.hsluv_s, conv.hsluv_l]);
            sample.set("hpluv", [conv.hpluv_h, conv.hpluv_p, conv.hpluv_l]);

            ret.set(hex, sample);
        }

        return ret;
    }

    #if sys
        static public function main () {
            var snapshot = Snapshot.generateSnapshot();
            Sys.stdout().writeString(Json.stringify(snapshot));
        }
    #end

}
