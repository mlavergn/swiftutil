###############################################
#
# Makefile
#
###############################################

all: build

build:
	swift build

install: build
	swift 

test:
	swift test -Xlinker -lUtil

clean:
	swift build --clean
	rm -f Util.swift*

lint:
	swiftlint

SYS_PATH  := /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
INCL_PATH := $(SYS_PATH)/Developer/SDKs/iPhoneOS.sdk/usr/include
LIB_PATH  := $(SYS_PATH)/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks
SDK_PATH  := $(SYS_PATH)/Developer/SDKs/iPhoneOS.sdk
#TARGET    := armv7-apple-ios10.0
TARGET    := arm64-apple-ios10.0
MODULE    := Util

ios:
	# Test swiftc cross compile setup on OS X
	swiftc -I $(INCL_PATH) -F $(LIB_PATH) -target $(TARGET) -sdk $(SDK_PATH) -emit-module -module-name $(MODULE) -framework Foundation Sources/*.swift
