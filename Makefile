CC=clang
FRAMEWORKS= -framework Foundation -framework AppKit
LIBRARIES= -lobjc

PRODUCT=imgpreview
SRC=imgpreview.m

CFLAGS=-Wall -g
LDFLAGS=$(LIBRARIES) $(FRAMEWORKS)

.PHONY: all ios clean install

all : imgpreview clean

imgpreview : $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) $(SRC) -fobjc-arc -o $(PRODUCT)

clean :
	rm -rf ./*.o ./*.dSYM

install :
	sudo cp $(PRODUCT) /usr/local/bin/
	
