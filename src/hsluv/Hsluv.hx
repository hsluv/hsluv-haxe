package hsluv;

/**
	Human-friendly HSL conversion utility class.

	The math for most of this module was taken from:

	* http://www.easyrgb.com
	* http://www.brucelindbloom.com
	* Wikipedia

	All numbers below taken from math/bounds.wxm wxMaxima file. We use 17
	digits of decimal precision to export the numbers, effectively exporting
	them as double precision IEEE 754 floats.

	"If an IEEE 754 double precision is converted to a decimal string with at
	least 17 significant digits and then converted back to double, then the
	final number must match the original"

	Source: https://en.wikipedia.org/wiki/Double-precision_floating-point_format

	This class is designed to avoid heap allocation
 */
class Hsluv {
	// RGB
	public var hex:String;
	public var rgb_r:Float;
	public var rgb_g:Float;
	public var rgb_b:Float;

	// CIE XYZ
	public var xyz_x:Float;
	public var xyz_y:Float;
	public var xyz_z:Float;

	// CIE LUV
	public var luv_l:Float;
	public var luv_u:Float;
	public var luv_v:Float;

	// CIE LUV LCh
	public var lch_l:Float;
	public var lch_c:Float;
	public var lch_h:Float;

	// HSLuv
	public var hsluv_h:Float;
	public var hsluv_s:Float;
	public var hsluv_l:Float;

	// HPLuv
	public var hpluv_h:Float;
	public var hpluv_p:Float;
	public var hpluv_l:Float;

	// 6 lines in slope-intercept format: R < 0, R > 1, G < 0, G > 1, B < 0, B > 1
	public var r0s:Float;
	public var r0i:Float;
	public var r1s:Float;
	public var r1i:Float;

	public var g0s:Float;
	public var g0i:Float;
	public var g1s:Float;
	public var g1i:Float;

	public var b0s:Float;
	public var b0i:Float;
	public var b1s:Float;
	public var b1i:Float;

	public function new() {}

	private static var hexChars:String = "0123456789abcdef";

	private static var refY:Float = 1.0;

	private static var refU:Float = 0.19783000664283681;
	private static var refV:Float = 0.468319994938791;

	// CIE LUV constants
	private static var kappa:Float = 903.2962962962963;
	private static var epsilon:Float = 0.0088564516790356308;

	// Transformation matrix
	private static var m_r0:Float = 3.2409699419045214;
	private static var m_r1:Float = -1.5373831775700935;
	private static var m_r2:Float = -0.49861076029300328;

	private static var m_g0:Float = -0.96924363628087983;
	private static var m_g1:Float = 1.8759675015077207;
	private static var m_g2:Float = 0.041555057407175613;

	private static var m_b0:Float = 0.055630079696993609;
	private static var m_b1:Float = -0.20397695888897657;
	private static var m_b2:Float = 1.0569715142428786;

	// Used for rgb conversions
	private static function fromLinear(c:Float):Float {
		if (c <= 0.0031308) {
			return 12.92 * c;
		} else {
			return 1.055 * Math.pow(c, 1 / 2.4) - 0.055;
		}
	}

	private static function toLinear(c:Float):Float {
		if (c > 0.04045) {
			return Math.pow((c + 0.055) / (1 + 0.055), 2.4);
		} else {
			return c / 12.92;
		}
	}

	/*
		http://en.wikipedia.org/wiki/CIELUV
		In these formulas, Yn refers to the reference white point. We are using
		illuminant D65, so Yn (see refY in Maxima file) equals 1. The formula is
		simplified accordingly.
	 */
	public static function yToL(Y:Float):Float {
		if (Y <= epsilon) {
			return (Y / refY) * kappa;
		} else {
			return 116 * Math.pow(Y / refY, 1.0 / 3.0) - 16;
		}
	}

	public static function lToY(L:Float):Float {
		if (L <= 8) {
			return refY * L / kappa;
		} else {
			return refY * Math.pow((L + 16) / 116, 3);
		}
	}

	private static function rgbChannelToHex(chan:Float) {
		var c = Math.round(chan * 255);
		var digit2 = c % 16;
		var digit1 = Std.int((c - digit2) / 16);
		return hexChars.charAt(digit1) + hexChars.charAt(digit2);
	}

	private static function hexToRgbChannel(hex:String, offset:Int):Float {
		var digit1 = hexChars.indexOf(hex.charAt(offset));
		var digit2 = hexChars.indexOf(hex.charAt(offset + 1));
		var n = digit1 * 16 + digit2;
		return n / 255.0;
	}

	public function rgbToHex() {
		this.hex = "#";
		this.hex += rgbChannelToHex(this.rgb_r);
		this.hex += rgbChannelToHex(this.rgb_g);
		this.hex += rgbChannelToHex(this.rgb_b);
	}

	public function hexToRgb() {
		hex = hex.toLowerCase();
		this.rgb_r = hexToRgbChannel(this.hex, 1);
		this.rgb_g = hexToRgbChannel(this.hex, 3);
		this.rgb_b = hexToRgbChannel(this.hex, 5);
	}

	public function xyzToRgb() {
		this.rgb_r = fromLinear(m_r0 * this.xyz_x + m_r1 * this.xyz_y + m_r2 * this.xyz_z);
		this.rgb_g = fromLinear(m_g0 * this.xyz_x + m_g1 * this.xyz_y + m_g2 * this.xyz_z);
		this.rgb_b = fromLinear(m_b0 * this.xyz_x + m_b1 * this.xyz_y + m_b2 * this.xyz_z);
	}

	public function rgbToXyz() {
		var lr = toLinear(this.rgb_r);
		var lg = toLinear(this.rgb_g);
		var lb = toLinear(this.rgb_b);
		this.xyz_x = 0.41239079926595948 * lr + 0.35758433938387796 * lg + 0.18048078840183429 * lb;
		this.xyz_y = 0.21263900587151036 * lr + 0.71516867876775593 * lg + 0.072192315360733715 * lb;
		this.xyz_z = 0.019330818715591851 * lr + 0.11919477979462599 * lg + 0.95053215224966058 * lb;
	}

	public function xyzToLuv() {
		var divider:Float = (this.xyz_x + (15 * this.xyz_y) + (3 * this.xyz_z));
		var varU:Float = 4 * this.xyz_x;
		var varV:Float = 9 * this.xyz_y;

		// This divider fix avoids a crash on Python (divide by zero except.)
		if (divider != 0) {
			varU /= divider;
			varV /= divider;
		} else {
			varU = Math.NaN;
			varV = Math.NaN;
		}

		this.luv_l = yToL(this.xyz_y);
		if (this.luv_l == 0) {
			this.luv_u = 0;
			this.luv_v = 0;
		} else {
			this.luv_u = 13 * this.luv_l * (varU - refU);
			this.luv_v = 13 * this.luv_l * (varV - refV);
		}
	}

	public function luvToXyz() {
		if (this.luv_l == 0) {
			this.xyz_x = 0;
			this.xyz_y = 0;
			this.xyz_z = 0;
			return;
		}

		var varU:Float = this.luv_u / (13 * this.luv_l) + refU;
		var varV:Float = this.luv_v / (13 * this.luv_l) + refV;

		this.xyz_y = lToY(this.luv_l);
		this.xyz_x = 0 - (9 * this.xyz_y * varU) / ((varU - 4) * varV - varU * varV);
		this.xyz_z = (9 * this.xyz_y - (15 * varV * this.xyz_y) - (varV * this.xyz_x)) / (3 * varV);
	}

	public function luvToLch() {
		this.lch_l = this.luv_l;
		this.lch_c = Math.sqrt(this.luv_u * this.luv_u + this.luv_v * this.luv_v);

		// Greys: disambiguate hue
		if (this.lch_c < 0.00000001) {
			this.lch_h = 0;
		} else {
			var Hrad:Float = Math.atan2(this.luv_v, this.luv_u);
			this.lch_h = (Hrad * 180.0) / Math.PI;

			if (this.lch_h < 0) {
				this.lch_h = 360 + this.lch_h;
			}
		}
	}

	public function lchToLuv() {
		var Hrad:Float = this.lch_h / 180.0 * Math.PI;
		this.luv_l = this.lch_l;
		this.luv_u = Math.cos(Hrad) * this.lch_c;
		this.luv_v = Math.sin(Hrad) * this.lch_c;
	}

	/**
		For a given lightness, generate a list of 6 lines in slope-intercept
		form that represent the bounds in CIELUV, stepping over which will
		push a value out of the RGB gamut.
	 */
	public function calculateBoundingLines(l:Float) {
		var sub1:Float = Math.pow(l + 16, 3) / 1560896;
		var sub2:Float = sub1 > epsilon ? sub1 : l / kappa;

		var s1r = sub2 * (284517 * m_r0 - 94839 * m_r2);
		var s2r = sub2 * (838422 * m_r2 + 769860 * m_r1 + 731718 * m_r0);
		var s3r = sub2 * (632260 * m_r2 - 126452 * m_r1);

		var s1g = sub2 * (284517 * m_g0 - 94839 * m_g2);
		var s2g = sub2 * (838422 * m_g2 + 769860 * m_g1 + 731718 * m_g0);
		var s3g = sub2 * (632260 * m_g2 - 126452 * m_g1);

		var s1b = sub2 * (284517 * m_b0 - 94839 * m_b2);
		var s2b = sub2 * (838422 * m_b2 + 769860 * m_b1 + 731718 * m_b0);
		var s3b = sub2 * (632260 * m_b2 - 126452 * m_b1);

		this.r0s = s1r / s3r;
		this.r0i = s2r * l / s3r;
		this.r1s = s1r / (s3r + 126452);
		this.r1i = (s2r - 769860) * l / (s3r + 126452);

		this.g0s = s1g / s3g;
		this.g0i = s2g * l / s3g;
		this.g1s = s1g / (s3g + 126452);
		this.g1i = (s2g - 769860) * l / (s3g + 126452);

		this.b0s = s1b / s3b;
		this.b0i = s2b * l / s3b;
		this.b1s = s1b / (s3b + 126452);
		this.b1i = (s2b - 769860) * l / (s3b + 126452);
	}

	/*
		theta  -- angle of ray starting at (0, 0)
		m, b   -- slope and intercept of line
		x1, y1 -- coordinates of intersection
		len    -- length of ray until it intersects with line

		b + m * x1        = y1
		len              >= 0
		len * cos(theta)  = x1
		len * sin(theta)  = y1


		b + m * (len * cos(theta)) = len * sin(theta)
		b = len * sin(hrad) - m * len * cos(theta)
		b = len * (sin(hrad) - m * cos(hrad))
		len = b / (sin(hrad) - m * cos(hrad))
	 */
	private static function distanceFromOriginAngle(slope:Float, intercept:Float, angle:Float):Float {
		var d = intercept / (Math.sin(angle) - slope * Math.cos(angle));
		if (d < 0) {
			return Math.POSITIVE_INFINITY;
		} else {
			return d;
		}
	}

	private static function distanceFromOrigin(slope:Float, intercept:Float):Float {
		return Math.abs(intercept) / Math.sqrt(Math.pow(slope, 2) + 1);
	}

	private static function min6(f1:Float, f2:Float, f3:Float, f4:Float, f5:Float, f6:Float) {
		return Math.min(f1, Math.min(f2, Math.min(f3, Math.min(f4, Math.min(f5, f6)))));
	}

	/*
		For HPLuv, we simply see which bounding line is closest to the origin
		by measuring the length of its perpendicular. The shortest perpendicular
		determines maximum chroma.
	 */
	public function calcMaxChromaHpluv():Float {
		var r0 = distanceFromOrigin(this.r0s, this.r0i);
		var r1 = distanceFromOrigin(this.r1s, this.r1i);
		var g0 = distanceFromOrigin(this.g0s, this.g0i);
		var g1 = distanceFromOrigin(this.g1s, this.g1i);
		var b0 = distanceFromOrigin(this.b0s, this.b0i);
		var b1 = distanceFromOrigin(this.b1s, this.b1i);
		return min6(r0, r1, g0, g1, b0, b1);
	}

	/*
		For HSLuv, we draw a ray from origin with angle specified by the hue. 
		Multiple bounding lines may intercept this ray. The first one to intercept
		it determines maximum chroma.
	 */
	public function calcMaxChromaHsluv(h:Float):Float {
		var hueRad:Float = h / 360 * Math.PI * 2;
		var r0 = distanceFromOriginAngle(this.r0s, this.r0i, hueRad);
		var r1 = distanceFromOriginAngle(this.r1s, this.r1i, hueRad);
		var g0 = distanceFromOriginAngle(this.g0s, this.g0i, hueRad);
		var g1 = distanceFromOriginAngle(this.g1s, this.g1i, hueRad);
		var b0 = distanceFromOriginAngle(this.b0s, this.b0i, hueRad);
		var b1 = distanceFromOriginAngle(this.b1s, this.b1i, hueRad);
		return min6(r0, r1, g0, g1, b0, b1);
	}

	public function hsluvToLch() {
		// White and black: disambiguate chroma
		if (this.hsluv_l > 99.9999999) {
			this.lch_l = 100;
			this.lch_c = 0;
		} else if (this.hsluv_l < 0.00000001) {
			this.lch_l = 0;
			this.lch_c = 0;
		} else {
			this.lch_l = this.hsluv_l;
			this.calculateBoundingLines(this.hsluv_l);
			var max = this.calcMaxChromaHsluv(this.hsluv_h);
			this.lch_c = max / 100 * this.hsluv_s;
		}
		this.lch_h = this.hsluv_h;
	}

	public function lchToHsluv() {
		// White and black: disambiguate chroma
		if (this.lch_l > 99.9999999) {
			this.hsluv_s = 0;
			this.hsluv_l = 100;
		} else if (this.lch_l < 0.00000001) {
			this.hsluv_s = 0;
			this.hsluv_l = 0;
		} else {
			this.calculateBoundingLines(this.lch_l);
			var max = this.calcMaxChromaHsluv(this.lch_h);
			this.hsluv_s = this.lch_c / max * 100;
			this.hsluv_l = this.lch_l;
		}
		this.hsluv_h = this.lch_h;
	}

	public function hpluvToLch() {
		// White and black: disambiguate chroma
		if (this.hpluv_l > 99.9999999) {
			this.lch_l = 100;
			this.lch_c = 0;
		} else if (this.hpluv_l < 0.00000001) {
			this.lch_l = 0;
			this.lch_c = 0;
		} else {
			this.lch_l = this.hpluv_l;
			this.calculateBoundingLines(this.hpluv_l);
			var max = this.calcMaxChromaHpluv();
			this.lch_c = max / 100 * this.hpluv_p;
		}
		this.lch_h = this.hpluv_h;
	}

	public function lchToHpluv() {
		// White and black: disambiguate chroma
		if (this.lch_l > 99.9999999) {
			this.hpluv_p = 0;
			this.hpluv_l = 100;
		} else if (this.lch_l < 0.00000001) {
			this.hpluv_p = 0;
			this.hpluv_l = 0;
		} else {
			this.calculateBoundingLines(this.lch_l);
			var max = this.calcMaxChromaHpluv();
			this.hpluv_p = this.lch_c / max * 100;
			this.hpluv_l = this.lch_l;
		}
		this.hpluv_h = this.lch_h;
	}

	public function hsluvToRgb() {
		this.hsluvToLch();
		this.lchToLuv();
		this.luvToXyz();
		this.xyzToRgb();
	}

	public function hpluvToRgb() {
		this.hpluvToLch();
		this.lchToLuv();
		this.luvToXyz();
		this.xyzToRgb();
	}

	public function hsluvToHex() {
		this.hsluvToRgb();
		this.rgbToHex();
	}

	public function hpluvToHex() {
		this.hpluvToRgb();
		this.rgbToHex();
	}

	public function rgbToHsluv() {
		this.rgbToXyz();
		this.xyzToLuv();
		this.luvToLch();
		this.lchToHpluv();
		this.lchToHsluv();
	}

	public function rgbToHpluv() {
		this.rgbToXyz();
		this.xyzToLuv();
		this.luvToLch();
		this.lchToHpluv();
		this.lchToHpluv();
	}

	public function hexToHsluv() {
		this.hexToRgb();
		this.rgbToHsluv();
	}

	public function hexToHpluv() {
		this.hexToRgb();
		this.rgbToHpluv();
	}
}
