#!/bin/sh

SRC_ARCHIVE := less-481.tar.gz

.PHONY: install
install: build
	sudo $(MAKE) install
	rm -rf $(SRC_ARCHIVE) src

.PHONY: build
build: patch
	cd src; ./configure
	$(MAKE) -C src -j

.PHONY: patch
patch: download
	patch -d src -p1 < 0001-less-mouse-support.patch

.PHONY: download
download:
	rm -rf $(SRC_ARCHIVE) src
	wget http://www.greenwoodsoftware.com/less/$(SRC_ARCHIVE)
	tar --transform='s,^less-[0-9]*/,src/,' -xf $(SRC_ARCHIVE)
	chmod u+w -R src
