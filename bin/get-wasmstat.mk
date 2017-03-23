BINARYEN_FILES_WINDOWS = \
	bin/asm2wasm.exe \
	bin/s2wasm.exe \
	bin/wasm-dis.exe \
	bin/wasm-as.exe \
	bin/wasm-opt.exe \
	bin/wasm.js \
	src \
	$(NULL)

BINARYEN_FILES_MAC_LINUX = \
	bin/asm2wasm \
	bin/s2wasm \
	bin/wasm-dis \
	bin/wasm-as \
	bin/wasm-opt \
	bin/wasm.js \
	src \
	$(NULL)

default: init windows linux mac

init:
	rm -rf ../tmp/wasm-stat-* ../tmp/wasm-binaries-*
	rm -rf ../wasm/binaryen-*-latest.*

get-windows:
	./find-archived.sh windows
	curl `cat ../tmp/wasm-stat-windows.url` > ../tmp/wasm-binaries-windows.zip

get-linux:
	./find-archived.sh linux
	curl `cat ../tmp/wasm-stat-linux.url` > ../tmp/wasm-binaries-linux.tbz2

get-mac:
	./find-archived.sh mac
	curl `cat ../tmp/wasm-stat-mac.url` > ../tmp/wasm-binaries-mac.tbz2

unpack-windows:
	mkdir -p ../tmp/wasm-binaries-windows; unzip ../tmp/wasm-binaries-windows.zip -d ../tmp/wasm-binaries-windows
	mkdir -p ../tmp/wasm-binaries-windows/binaryen/bin ../tmp/wasm-binaries-windows/binaryen/src
	cd ../tmp/wasm-binaries-windows/wasm-install; $(foreach file, $(BINARYEN_FILES_WINDOWS),cp -R $(file) ../binaryen/$(dir $(file));)

unpack-linux:
	mkdir -p ../tmp/wasm-binaries-linux; cd ../tmp/wasm-binaries-linux; tar -jxvf ../wasm-binaries-linux.tbz2
	mkdir -p ../tmp/wasm-binaries-linux/binaryen/bin ../tmp/wasm-binaries-linux/binaryen/src
	cd ../tmp/wasm-binaries-linux/wasm-install; $(foreach file, $(BINARYEN_FILES_MAC_LINUX),cp -R $(file) ../binaryen/$(dir $(file));)

unpack-mac:
	mkdir -p ../tmp/wasm-binaries-mac; cd ../tmp/wasm-binaries-mac; tar -jxvf ../wasm-binaries-mac.tbz2
	mkdir -p ../tmp/wasm-binaries-mac/binaryen/bin ../tmp/wasm-binaries-mac/binaryen/src
	cd ../tmp/wasm-binaries-mac/wasm-install; $(foreach file, $(BINARYEN_FILES_MAC_LINUX),cp -R $(file) ../binaryen/$(dir $(file));)

build-windows:
	mkdir -p ../windows
	cd ../tmp/wasm-binaries-windows/binaryen; zip -r ../../../windows/binaryen-win-latest.zip *

build-linux:
	mkdir -p ../linux
	cd ../tmp/wasm-binaries-linux/binaryen; tar -czf ../../../linux/binaryen-linux-latest.tar.gz .

build-mac:
	mkdir -p ../mac
	cd ../tmp/wasm-binaries-mac/binaryen; tar -czf ../../../mac/binaryen-mac-latest.tar.gz .

windows: get-windows unpack-windows build-windows

linux: get-linux unpack-linux build-linux

mac: get-mac unpack-mac build-mac

.PHONY: init windows linux mac

