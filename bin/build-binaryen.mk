GIT_REPO=https://github.com/WebAssembly/binaryen.git
BUILD_DIR=../tmp/build-binaryen
SRC_DIR=$(BUILD_DIR)/src
BINARIES_DIR=$(BUILD_DIR)/build
PACKAGE_DIR=$(BUILD_DIR)/package

PLATFORM_NAME ?= $(error "Specify PLATFORM_NAME variable as 'windows', 'mac' or 'linux'")

ifeq ($(PLATFORM_NAME),windows)
	EXE_SUFFIX=.exe
else
	EXE_SUFFIX=
endif

BINARYEN_FILES_BUILT = \
	bin/asm2wasm \
	bin/s2wasm \
	bin/wasm-dis \
	bin/wasm-as \
	bin/wasm-opt \
	$(NULL)

BINARYEN_FILES_COMMON = \
	bin/wasm.js \
	src \
	$(NULL)

build: clean get-source config build-bin package

package:
	mkdir -p $(PACKAGE_DIR)/bin
	cd $(BINARIES_DIR); $(foreach file, $(BINARYEN_FILES_BUILT),cp -R $(file)$(EXE_SUFFIX) ../package/$(dir $(file));)
	cd $(SRC_DIR); $(foreach file, $(BINARYEN_FILES_COMMON),cp -R $(file) ../package/$(dir $(file));)
	mkdir -p ../$(PLATFORM_NAME)
ifeq ($(PLATFORM_NAME),windows)
	cd $(PACKAGE_DIR); zip -r ../../../$(PLATFORM_NAME)/binaryen-win-latest.zip *
else
	cd $(PACKAGE_DIR); tar -czf ../../../$(PLATFORM_NAME)/binaryen-$(PLATFORM_NAME)-latest.tar.gz .
endif

build-bin:
	cmake --build $(BINARIES_DIR)
	
clean:
	rm -rf $(BUILD_DIR)

config:
	mkdir -p $(BINARIES_DIR)
	cd $(BINARIES_DIR); cmake ../src

get-source:
	mkdir -p $(BUILD_DIR)
	git clone $(GIT_REPO) $(SRC_DIR)

.PHONY: clean build build-bin package config get-source
