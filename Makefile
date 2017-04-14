###############################################
#
# Makefile
#
###############################################

SWIFTC_OPTS := 
LINKER_OPTS := -Xlinker -lUtil

all: build

build:
	swift build $(SWIFTC_OPTS) $(LINKER_OPTS) 

test:
	swift test $(SWIFTC_OPTS) $(LINKER_OPTS) 

clean:
	swift package clean
	rm -rf .build
	rm -rf iosBuild iosBuild.swiftdoc

lint:
	swiftlint

xc:
	swift package generate-xcodeproj

SYS_PATH  := /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
INCL_PATH := $(SYS_PATH)/Developer/SDKs/iPhoneOS.sdk/usr/include
LIB_PATH  := $(SYS_PATH)/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks
SDK_PATH  := $(SYS_PATH)/Developer/SDKs/iPhoneOS.sdk
#TARGET    := armv7-apple-ios10.0
TARGET    := arm64-apple-ios10.0
MODULE    := Util

ios:
	rm -rf iosBuild iosBuild.swiftdoc
	mkdir -p iosBuild
	swiftc -I $(INCL_PATH) -F $(LIB_PATH) -target $(TARGET) -sdk $(SDK_PATH) -emit-module  -emit-module-path iosBuild -module-name $(MODULE) -framework Foundation -framework AVFoundation Sources/*.swift
