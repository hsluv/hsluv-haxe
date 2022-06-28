.PHONY: test build

test:
	haxe -cp src -cp test -main test.RunTests -resource test/snapshot-rev4.json@snapshot-rev4 --interp

build:
	zip -r hsluv.zip src test README.md LICENSE haxelib.json

submit:
	haxelib submit hsluv.zip
