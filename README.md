[![Run the test suite](https://github.com/hsluv/hsluv-haxe/actions/workflows/test.yml/badge.svg)](https://github.com/hsluv/hsluv-haxe/actions/workflows/test.yml)
[![haxelib](https://img.shields.io/badge/haxelib-blue.svg)](https://lib.haxe.org/p/hsluv)

# HSLuv - Haxe implementation

## Usage
Once imported, use the library by importing HSLuv. Here's an example:

```haxe
package;
import hsluv.Hsluv;

public class Main {
    public static function main() {
        var conv = new Hsluv();
        conv.rgb_r = 1;
        conv.rgb_g = 1;
        conv.rgb_b = 1;
        conv.rgbToHex();
        trace(conv.hex); // Will print "#FFFFFF"
    }
}
```

### Color values ranges

- RGB values are ranging in [0;1]
- HSLuv and HPLuv values have different ranging for their components
    - H : [0;360]
    - S and L : [0;100]
- LUV has different ranging for their components
    - L* : [0;100]
    - u* and v* : [-100;100]
- LCh has different ranging for their components
    - L* : [0;100]
    - C* : [0; ?] Upper bound varies depending on L* and H*
    - H* : [0; 360]
- XYZ values are ranging in [0;1]

### API functions

The API is designed in a way to avoid heap allocation. The `HSLuv` class defines the following public fields:

- RGB: `hex:String`, `rgb_r:Float`, `rgb_g:Float`, `rgb_r:Float`
- CIE XYZ: `xyz_x:Float`, `xyz_y:Float`, `xyz_z:Float`
- CIE LUV: `luv_l:Float`, `luv_u:Float`, `luv_v:Float`
- CIE LUV LCh: `lch_l:Float`, `lch_c:Float`, `lch_h:Float`
- HSLuv: `hsluv_h:Float`, `hsluv_s:Float`, `hsluv_l:Float`
- HPLuv: `hpluv_h:Float`, `hpluv_p:Float`, `hpluv_l:Float`

To convert between color spaces, simply set the properties of the source color space, run the
conversion methods, then read the properties from the target color space.

Use the following methods to convert to and from RGB:

- HSLuv: `hsluvToRgb()`, `hsluvToHex()`, `rgbToHsluv()`, `hexToHsluv()`
- HPLuv: `hpluvToRgb()`, `hpluvToHex()`, `rgbToHpluv()`, `hexToHpluv()`

Use the following methods to do step-by-step conversion:

- Forward: `hsluvToLch()` (or `hpluvToLch()`), `lchToLuv()`, `luvToXyz()`, `xyzToRgb()`, `rgbToHex()`
- Backward: `hexToRgb()`, `rgbToXyz()`, `xyzToLuv()`, `luvToLch()`, `lchToHsluv()` (or `lchToHpluv()`)

## Development

Recommended editor: VS Code with [vshaxe](https://github.com/vshaxe/vshaxe/wiki) extension.

## Generate snapshot

```sh
haxe -cp src -cp test -main test.Snapshot --interp > snapshot.json
```

## Testing

Prefered way : Haxe's builtin interpreter. Doesn't require any external libs to execute the tests:

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
