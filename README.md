[![Run the test suite](https://github.com/hsluv/hsluv-haxe/actions/workflows/test.yml/badge.svg)](https://github.com/hsluv/hsluv-haxe/actions/workflows/test.yml)
[![haxelib](https://img.shields.io/badge/haxelib-0.1.0-blue.svg)](https://lib.haxe.org/p/hsluv)

# HSLuv - Haxe implementation

## Usage
Once imported, use the library by importing HSLuv. Here's an example:

```haxe
import hsluv.Hsluv;

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
```

### API functions

The API is designed in a way to avoid heap allocation. The `HSLuv` class defines the following public fields:

- RGB: `hex:String`, `rgb_r:Float` [0;1], `rgb_g:Float` [0;1], `rgb_r:Float` [0;1]
- CIE XYZ: `xyz_x:Float`, `xyz_y:Float`, `xyz_z:Float`
- CIE LUV: `luv_l:Float`, `luv_u:Float`, `luv_v:Float`
- CIE LUV LCh: `lch_l:Float`, `lch_c:Float`, `lch_h:Float`
- HSLuv: `hsluv_h:Float` [0;360], `hsluv_s:Float` [0;100], `hsluv_l:Float` [0;100]
- HPLuv: `hpluv_h:Float` [0;360], `hpluv_p:Float` [0;100], `hpluv_l:Float` [0;100]

To convert between color spaces, simply set the properties of the source color space, run the
conversion methods, then read the properties from the target color space.

Use the following methods to convert to and from RGB:

- HSLuv: `hsluvToRgb()`, `hsluvToHex()`, `rgbToHsluv()`, `hexToHsluv()`
- HPLuv: `hpluvToRgb()`, `hpluvToHex()`, `rgbToHpluv()`, `hexToHpluv()`

Use the following methods to do step-by-step conversion:

- Forward: `hsluvToLch()` (or `hpluvToLch()`), `lchToLuv()`, `luvToXyz()`, `xyzToRgb()`, `rgbToHex()`
- Backward: `hexToRgb()`, `rgbToXyz()`, `xyzToLuv()`, `luvToLch()`, `lchToHsluv()` (or `lchToHpluv()`)

For advanced usage, we also export the [bounding lines](https://www.hsluv.org/math/) in slope-intercept
format, two for each RGB channel representing the limit of the gamut.

- R < 0: `r0s`, `r0i`
- R > 1: `r1s`, `r1i`
- G < 0: `g0s`, `g0i`
- G > 1: `g1s`, `g1i`
- B < 0: `b0s`, `b0i`
- B > 1: `b1s`, `b1i`

## Development

Recommended editor: VS Code with [vshaxe](https://github.com/vshaxe/vshaxe/wiki) extension.

Note that we have [automated Haxe transpilation to multiple targets](https://github.com/hsluv/hsluv-haxe/actions/workflows/transpile.yml).

## Testing

Prefered way: Haxe's builtin interpreter. Doesn't require any external libs to execute the tests:

```sh
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 --interp
```

Test using Haxe's [compiler targets](https://haxe.org/documentation/introduction/compiler-targets.html):

```sh
# CPP Linux
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -cpp bin/cpp -cmd bin/cpp/RunTests
# CPP Windows
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -cpp bin/cpp -cmd bin/cpp/RunTests.exe
# C# Linux
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -cs bin/cs -cmd "mono bin/cs/bin/RunTests.exe"
# C# Windows
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -cs bin/cs -cmd bin/cs/RunTests.exe
# Java
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -java bin/java -cmd "java -jar bin/java/RunTests.jar"
# PHP
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -php bin/php -cmd "php bin/php/index.php"
# NodeJS
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -js bin/js/RunTests.js -cmd "node bin/js/RunTests.js"
# Python
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -python bin/python/RunTests.py -cmd "python3 bin/python/RunTests.py"
# Lua
haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 -lua bin/lua/RunTests.lua -cmd "lua bin/lua/RunTests.lua"
```

## Generate snapshot

We only generate a new snapshot when we release a new revision of the color math. Then it can be used for testing this and other
implementations.

```sh
haxe -cp src -cp test -main test.Snapshot --interp > snapshot.json
```
