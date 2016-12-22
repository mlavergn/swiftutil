###############################################
#
# Makefile
#
###############################################

CFLAGS  := -Xswiftc -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include

LDFLAGS := -Xlinker -rpath -Xlinker /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks

all:
	swift build $(CFLAGS) $(LDFLAGS) -Xlinker -lswiftCore

test:
	swift test $(CFLAGS) $(LDFLAGS) -Xlinker -lswiftCore

clean:
	rm -rf .build
