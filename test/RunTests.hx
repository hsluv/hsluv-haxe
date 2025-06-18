package test;

import hsluv.Hsluv;

class RunTests {
	private static inline var EPSILON:Float = 0.00000000001;

	static function assertStringEquals(expected:String, actual:String) {
		if (expected != actual) {
			throw "Not equals";
		}
	}

	/**
	 * Note that comparing floating point numbers is not as simple as this:
	 * https://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/
	 *
	 * However, we are lucky to be comparing numbers with an exponent close to 0, so we can get away
     * with a naive implementation.
	 */
	static function assertFloatClose(expected:Float, actual:Float) {
		if (Math.abs(expected - actual) > EPSILON) {
			trace(expected);
			trace(actual);
			throw "Not equals";
		}
	}

	static function assertClose(expected:Hsluv, actual:Hsluv) {
		assertStringEquals(expected.hex, actual.hex);
		assertFloatClose(expected.rgb_r, actual.rgb_r);
		assertFloatClose(expected.rgb_g, actual.rgb_g);
		assertFloatClose(expected.rgb_b, actual.rgb_b);
		assertFloatClose(expected.xyz_x, actual.xyz_x);
		assertFloatClose(expected.xyz_y, actual.xyz_y);
		assertFloatClose(expected.xyz_z, actual.xyz_z);
		assertFloatClose(expected.luv_l, actual.luv_l);
		assertFloatClose(expected.luv_u, actual.luv_u);
		assertFloatClose(expected.luv_v, actual.luv_v);
		assertFloatClose(expected.lch_l, actual.lch_l);
		assertFloatClose(expected.lch_c, actual.lch_c);
		assertFloatClose(expected.lch_h, actual.lch_h);
		assertFloatClose(expected.hsluv_h, actual.hsluv_h);
		assertFloatClose(expected.hsluv_s, actual.hsluv_s);
		assertFloatClose(expected.hsluv_l, actual.hsluv_l);
		assertFloatClose(expected.hpluv_h, actual.hpluv_h);
		assertFloatClose(expected.hpluv_p, actual.hpluv_p);
		assertFloatClose(expected.hpluv_l, actual.hpluv_l);
	}

	static function main() {
		trace("Loading snapshot ...");
		var file = haxe.Resource.getString("snapshot-rev4");
		if (file == null) {
			throw "Couldn't load the snapshot file snapshot-rev4, make sure it's present in test/resources.";
		}
		var object = haxe.Json.parse(file);

		trace("Testing ...");
		var conv = new Hsluv();
		for (fieldName in Reflect.fields(object)) {
			var field = Reflect.field(object, fieldName);
			var sample = new Hsluv();
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
			conv.hexToHsluv();
            assertClose(conv, sample);

			// backward functions

            conv.hsluv_h = sample.hsluv_h;
            conv.hsluv_s = sample.hsluv_s;
            conv.hsluv_l = sample.hsluv_l;
            conv.hsluvToHex();
            assertClose(conv, sample);

            conv.hpluv_h = sample.hpluv_h;
            conv.hpluv_p = sample.hpluv_p;
            conv.hpluv_l = sample.hpluv_l;
            conv.hpluvToHex();
            assertClose(conv, sample);
		}

		trace("OK");
	}
}
