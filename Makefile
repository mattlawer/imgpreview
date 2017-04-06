CC=clang
FRAMEWORKS= -framework Foundation -framework AppKit
LIBRARIES= -lobjc

PRODUCT=imgpreview
SRC=imgpreview.m

CFLAGS=-Wall -g
LDFLAGS=$(LIBRARIES) $(FRAMEWORKS)

#iOS
IOS_ARCHS=armv7 armv7s arm64
SDKVERSION=
SDKMINVERSION=7.0
SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(SDKVERSION).sdk

build-ios-arch=$(CC) $(SRC) -fobjc-arc $(CFLAGS) $(LDFLAGS) -isysroot $(SYSROOT) -mios-version-min=$(SDKMINVERSION) $(FRAMEWORKS) -arch $(1) -o $(PRODUCT)_$(1)


.PHONY: all ios clean install

all : imgpreview clean

ios : imgpreview_ios clean

imgpreview : $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) $(SRC) -fobjc-arc -o $(PRODUCT)

imgpreview_ios : $(SRC)
	rm -f $(PRODUCT)_fat
	$(foreach arch,$(IOS_ARCHS),$(call build-ios-arch,$(arch));)
	lipo -create $(addprefix ${PRODUCT}_,${IOS_ARCHS}) -output $(PRODUCT)_ios

clean :
	rm -rf ./*.o ./*.dSYM

install :
	sudo cp $(PRODUCT) /usr/local/bin/

	