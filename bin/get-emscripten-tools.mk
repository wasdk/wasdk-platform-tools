build: init download rezip

init:
	mkdir -p ../tmp/
	mkdir -p ../all/
	rm -rf ../tmp/emscripten.zip ../tmp/emscripten/ ../all/emscripten-tools.zip

download:
	curl -L https://github.com/kripken/emscripten/archive/master.zip > ../tmp/emscripten.zip

rezip:
	unzip ../tmp/emscripten.zip -d ../tmp/emscripten
	cd ../tmp/emscripten/emscripten-master && zip -r ../../../all/emscripten-tools.zip tools/eliminator && cd ../../../bin

.PHONY: build init download rezip
