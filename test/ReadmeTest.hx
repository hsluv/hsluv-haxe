package test;
import hsluv.Hsluv;

/*
    haxe -cp src -cp test -main test.ReadmeTest --interp
*/
class ReadmeTest {
    public static function main() {
        var conv = new Hsluv();
        conv.hsluv_h = 10;
        conv.hsluv_s = 75;
        conv.hsluv_l = 65;
        conv.hsluvToHex();
        trace(conv.hex); // Will print "#ec7d82"
    }
}
