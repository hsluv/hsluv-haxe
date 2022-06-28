package hsluv;

import hsluv.HsluvConverter;


class Hsluv {

    /**
    * XYZ coordinates are ranging in [0;1] and RGB coordinates in [0;1] range.
    * @param tuple An array containing the color's X,Y and Z values.
    * @return An array containing the resulting color's red, green and blue.
    **/
    public static function xyzToRgb(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.xyz_x = tuple[0];
        conv.xyz_y = tuple[1];
        conv.xyz_z = tuple[2];
        conv.xyzToRgb();
        return [conv.rgb_r, conv.rgb_g, conv.rgb_b];
    }

    /**
    * RGB coordinates are ranging in [0;1] and XYZ coordinates in [0;1].
    * @param tuple An array containing the color's R,G,B values.
    * @return An array containing the resulting color's XYZ coordinates.
    **/
    public static function rgbToXyz(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.rgb_r = tuple[0];
        conv.rgb_g = tuple[1];
        conv.rgb_b = tuple[2];
        conv.rgbToXyz();
        return [conv.xyz_x, conv.xyz_y, conv.xyz_z];
    }

    /**
    * XYZ coordinates are ranging in [0;1].
    * @param tuple An array containing the color's X,Y,Z values.
    * @return An array containing the resulting color's LUV coordinates.
    **/
    public static function xyzToLuv(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.xyz_x = tuple[0];
        conv.xyz_y = tuple[1];
        conv.xyz_z = tuple[2];
        conv.xyzToLuv();
        return [conv.luv_l, conv.luv_u, conv.luv_v];
    }

    /**
    * XYZ coordinates are ranging in [0;1].
    * @param tuple An array containing the color's L,U,V values.
    * @return An array containing the resulting color's XYZ coordinates.
    **/
    public static function luvToXyz(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.luv_l = tuple[0];
        conv.luv_u = tuple[1];
        conv.luv_v = tuple[2];
        conv.luvToXyz();
        return [conv.xyz_x, conv.xyz_y, conv.xyz_z];
    }

    /**
    * @param tuple An array containing the color's L,U,V values.
    * @return An array containing the resulting color's LCH coordinates.
    **/
    public static function luvToLch(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.luv_l = tuple[0];
        conv.luv_u = tuple[1];
        conv.luv_v = tuple[2];
        conv.luvToLch();
        return [conv.lch_l, conv.lch_c, conv.lch_h];
    }

    /**
    * @param tuple An array containing the color's L,C,H values.
    * @return An array containing the resulting color's LUV coordinates.
    **/
    public static function lchToLuv(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.lch_l = tuple[0];
        conv.lch_c = tuple[1];
        conv.lch_h = tuple[2];
        conv.lchToLuv();
        return [conv.luv_l, conv.luv_u, conv.luv_v];
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100].
    * @param tuple An array containing the color's H,S,L values in HSLuv color space.
    * @return An array containing the resulting color's LCH coordinates.
    **/
    public static function hsluvToLch(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.hsluv_h = tuple[0];
        conv.hsluv_s = tuple[1];
        conv.hsluv_l = tuple[2];
        conv.hsluvToLch();
        return [conv.lch_l, conv.lch_c, conv.lch_h];
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100].
    * @param tuple An array containing the color's LCH values.
    * @return An array containing the resulting color's HSL coordinates in HSLuv color space.
    **/
    public static function lchToHsluv(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.lch_l = tuple[0];
        conv.lch_c = tuple[1];
        conv.lch_h = tuple[2];
        conv.lchToHsluv();
        return [conv.hsluv_h, conv.hsluv_s, conv.hsluv_l];
    }

    /**
    * HSLuv values are in [0;360], [0;100] and [0;100].
    * @param tuple An array containing the color's H,S,L values in HPLuv (pastel variant) color space.
    * @return An array containing the resulting color's LCH coordinates.
    **/
    public static function hpluvToLch(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.hpluv_h = tuple[0];
        conv.hpluv_p = tuple[1];
        conv.hpluv_l = tuple[2];
        conv.hpluvToLch();
        return [conv.lch_l, conv.lch_c, conv.lch_h];
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100].
    * @param tuple An array containing the color's LCH values.
    * @return An array containing the resulting color's HSL coordinates in HPLuv (pastel variant) color space.
    **/
    public static function lchToHpluv(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.lch_l = tuple[0];
        conv.lch_c = tuple[1];
        conv.lch_h = tuple[2];
        conv.lchToHpluv();
        return [conv.hpluv_h, conv.hpluv_p, conv.hpluv_l];
    }

    /**
    * RGB values are ranging in [0;1].
    * @param tuple An array containing the color's RGB values.
    * @return A string containing a `#RRGGBB` representation of given color.
    **/
    public static function rgbToHex(tuple:Array<Float>):String {
        var conv = new HsluvConverter();
        conv.rgb_r = tuple[0];
        conv.rgb_g = tuple[1];
        conv.rgb_b = tuple[2];
        conv.rgbToHex();
        return conv.hex;
    }

    /**
    * RGB values are ranging in [0;1].
    * @param hex A `#RRGGBB` representation of a color.
    * @return An array containing the color's RGB values.
    **/
    public static function hexToRgb(hex:String):Array<Float> {
        var conv = new HsluvConverter();
        conv.hex = hex;
        conv.hexToRgb();
        return [conv.rgb_r, conv.rgb_g, conv.rgb_b];
    }

    /**
    * RGB values are ranging in [0;1].
    * @param tuple An array containing the color's LCH values.
    * @return An array containing the resulting color's RGB coordinates.
    **/
    public static function lchToRgb(tuple:Array<Float>):Array<Float> {
        var conv = new HsluvConverter();
        conv.lch_l = tuple[0];
        conv.lch_c = tuple[1];
        conv.lch_h = tuple[2];
        conv.lchToLuv();
        conv.luvToXyz();
        conv.xyzToRgb();
        return [conv.rgb_r, conv.rgb_g, conv.rgb_b];
    }

    /**
    * RGB values are ranging in [0;1].
    * @param tuple An array containing the color's RGB values.
    * @return An array containing the resulting color's LCH coordinates.
    **/
    public static function rgbToLch(tuple:Array<Float>):Array<Float> {
        return luvToLch(xyzToLuv(rgbToXyz(tuple)));

    }

    // RGB <--> HPLuv

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100] and RGB in [0;1].
    * @param tuple An array containing the color's HSL values in HSLuv color space.
    * @return An array containing the resulting color's RGB coordinates.
    **/
    @:keep
    public static function hsluvToRgb(tuple:Array<Float>):Array<Float> {
        return lchToRgb(hsluvToLch(tuple));
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100] and RGB in [0;1].
    * @param tuple An array containing the color's RGB coordinates.
    * @return An array containing the resulting color's HSL coordinates in HSLuv color space.
    **/
    @:keep
    public static function rgbToHsluv(tuple:Array<Float>):Array<Float> {
        return lchToHsluv(rgbToLch(tuple));
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100] and RGB in [0;1].
    * @param tuple An array containing the color's HSL values in HPLuv (pastel variant) color space.
    * @return An array containing the resulting color's RGB coordinates.
    **/
    @:keep
    public static function hpluvToRgb(tuple:Array<Float>):Array<Float> {
        return lchToRgb(hpluvToLch(tuple));
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100] and RGB in [0;1].
    * @param tuple An array containing the color's RGB coordinates.
    * @return An array containing the resulting color's HSL coordinates in HPLuv (pastel variant) color space.
    **/
    @:keep
    public static function rgbToHpluv(tuple:Array<Float>):Array<Float> {
        return lchToHpluv(rgbToLch(tuple));
    }

    // Hex

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100] and RGB in [0;1].
    * @param tuple An array containing the color's HSL values in HSLuv color space.
    * @return A string containing a `#RRGGBB` representation of given color.
    **/
    @:keep
    public static function hsluvToHex(tuple:Array<Float>):String {
        var conv = new HsluvConverter();
        conv.hsluv_h = tuple[0];
        conv.hsluv_s = tuple[1];
        conv.hsluv_l = tuple[2];
        conv.hsluvToLch();
        conv.lchToLuv();
        conv.luvToXyz();
        conv.xyzToRgb();
        conv.rgbToHex();
        return conv.hex;
    }

    @:keep
    public static function hpluvToHex(tuple:Array<Float>):String {
        var conv = new HsluvConverter();
        conv.hpluv_h = tuple[0];
        conv.hpluv_p = tuple[1];
        conv.hpluv_l = tuple[2];
        conv.hpluvToLch();
        conv.lchToLuv();
        conv.luvToXyz();
        conv.xyzToRgb();
        conv.rgbToHex();
        return conv.hex;
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100] and RGB in [0;1].
    * @param tuple An array containing the color's HSL values in HPLuv (pastel variant) color space.
    * @return An array containing the color's HSL values in HSLuv color space.
    **/
    @:keep
    public static function hexToHsluv(s:String):Array<Float> {
        var conv = new HsluvConverter();
        conv.hex = s;
        conv.hexToRgb();
        conv.rgbToXyz();
        conv.xyzToLuv();
        conv.luvToLch();
        conv.lchToHsluv();
        return [conv.hsluv_h, conv.hsluv_s, conv.hsluv_l];
    }

    /**
    * HSLuv values are ranging in [0;360], [0;100] and [0;100] and RGB in [0;1].
    * @param hex A `#RRGGBB` representation of a color.
    * @return An array containing the color's HSL values in HPLuv (pastel variant) color space.
    **/
    @:keep
    public static function hexToHpluv(s:String):Array<Float> {
        var conv = new HsluvConverter();
        conv.hex = s;
        conv.hexToRgb();
        conv.rgbToXyz();
        conv.xyzToLuv();
        conv.luvToLch();
        conv.lchToHpluv();
        return [conv.hpluv_h, conv.hpluv_p, conv.hpluv_l];
    }
}
