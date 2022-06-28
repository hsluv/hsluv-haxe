package test;

import hsluv.HsluvConverter;

class RunTests {
	private static inline var MAXDIFF:Float = 0.0000000001;
	private static inline var MAXRELDIFF:Float = 0.000000001;

	static function assertFalse(b:Bool) {
		if (b) {
			throw new haxe.Exception("Could not load");
		}
	}

	static function assertEquals(a:String, b:String) {
		if (a != b) {
			throw new haxe.Exception("Not equals");
		}
	}

	/**
	 * modified from
	 * https://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/
	 */
	static function assertAlmostEqualRelativeAndAbs(a:Float, b:Float) {
		// Check if the numbers are really close -- needed
		// when comparing numbers near zero.
		var diff:Float = Math.abs(a - b);
		if (diff <= MAXDIFF) {
			return;
		}

		a = Math.abs(a);
		b = Math.abs(b);
		var largest:Float = (b > a) ? b : a;

		if (diff > largest * MAXRELDIFF) {
			throw new haxe.Exception("Not equals");
		}
	}

	static function assertClose(expected:HsluvConverter, actual:HsluvConverter) {
		assertEquals(expected.hex, actual.hex);
		assertAlmostEqualRelativeAndAbs(expected.rgb_r, actual.rgb_r);
		assertAlmostEqualRelativeAndAbs(expected.rgb_g, actual.rgb_g);
		assertAlmostEqualRelativeAndAbs(expected.rgb_b, actual.rgb_b);
		assertAlmostEqualRelativeAndAbs(expected.xyz_x, actual.xyz_x);
		assertAlmostEqualRelativeAndAbs(expected.xyz_y, actual.xyz_y);
		assertAlmostEqualRelativeAndAbs(expected.xyz_z, actual.xyz_z);
		assertAlmostEqualRelativeAndAbs(expected.luv_l, actual.luv_l);
		assertAlmostEqualRelativeAndAbs(expected.luv_u, actual.luv_u);
		assertAlmostEqualRelativeAndAbs(expected.luv_v, actual.luv_v);
		assertAlmostEqualRelativeAndAbs(expected.lch_l, actual.lch_l);
		assertAlmostEqualRelativeAndAbs(expected.lch_c, actual.lch_c);
		assertAlmostEqualRelativeAndAbs(expected.lch_h, actual.lch_h);
		assertAlmostEqualRelativeAndAbs(expected.hsluv_h, actual.hsluv_h);
		assertAlmostEqualRelativeAndAbs(expected.hsluv_s, actual.hsluv_s);
		assertAlmostEqualRelativeAndAbs(expected.hsluv_l, actual.hsluv_l);
		assertAlmostEqualRelativeAndAbs(expected.hpluv_h, actual.hpluv_h);
		assertAlmostEqualRelativeAndAbs(expected.hpluv_p, actual.hpluv_p);
		assertAlmostEqualRelativeAndAbs(expected.hpluv_l, actual.hpluv_l);
	}

	static function testHsluv() {
		var file = haxe.Resource.getString("snapshot-rev4");
		if (file == null) {
			trace("Couldn't load the snapshot file snapshot-rev4, make sure it's present in test/resources.");
		}
		assertFalse(file == null);
		var object = haxe.Json.parse(file);
		var conv = new HsluvConverter();

		for (fieldName in Reflect.fields(object)) {
			var field = Reflect.field(object, fieldName);
			var sample = new HsluvConverter();
			sample.hex = fieldName;
			sample.rgb_r = field.rgb[0];
			sample.rgb_g = field.rgb[1];
			sample.rgb_b = field.rgb[2];
			sample.xyz_x = field.xyz[0];
			sample.xyz_y = field.xyz[1];
			sample.xyz_z = field.xyz[2];
			sample.luv_l = field.luv[0];
			sample.luv_u = field.luv[1];
			sample.luv_v = field.luv[2];
			sample.lch_l = field.lch[0];
			sample.lch_c = field.lch[1];
			sample.lch_h = field.lch[2];
			sample.hsluv_h = field.hsluv[0];
			sample.hsluv_s = field.hsluv[1];
			sample.hsluv_l = field.hsluv[2];
			sample.hpluv_h = field.hpluv[0];
			sample.hpluv_p = field.hpluv[1];
			sample.hpluv_l = field.hpluv[2];

			// forward functions

			conv.hex = fieldName;
			conv.hexToRgb();
			conv.rgbToXyz();
			conv.xyzToLuv();
			conv.luvToLch();
			conv.lchToHpluv();
			conv.lchToHsluv();
            assertClose(conv, sample);

			// backward functions

            conv.hsluv_h = sample.hsluv_h;
            conv.hsluv_s = sample.hsluv_s;
            conv.hsluv_l = sample.hsluv_l;
            conv.hsluvToLch();
            conv.lchToLuv();
            conv.luvToXyz();
            conv.xyzToRgb();
            conv.rgbToHex();
            assertClose(conv, sample);

            conv.hpluv_h = sample.hpluv_h;
            conv.hpluv_p = sample.hpluv_p;
            conv.hpluv_l = sample.hpluv_l;
            conv.hpluvToLch();
            conv.lchToLuv();
            conv.luvToXyz();
            conv.xyzToRgb();
            conv.rgbToHex();
            assertClose(conv, sample);
		}
	}

	static public function main() {
		testHsluv();
		trace("OK");
	}
}
