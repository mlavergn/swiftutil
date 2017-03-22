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

lint:
	swiftlint