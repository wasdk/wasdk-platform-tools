default:
	rm -rf all windows linux mac
	$(MAKE) -C bin -f get-emscripten-tools.mk
	$(MAKE) -C bin -f get-wasmstat.mk

