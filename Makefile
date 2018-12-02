dirs=$(shell find . -maxdepth 1 -not -path '*/\.*' -type d \( ! -iname ".*" \))
zips=$(dirs:=.zip)

all: $(zips)

%.zip: %
	zip -r $@ $<

clean:
	rm -rf *.zip
