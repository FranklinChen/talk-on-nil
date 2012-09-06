# Line numbers distracting
LANDSLIDE = landslide -i -l no

html:	nil.html

# TODO: pdf coming out wrong
pdf:	nil.pdf

all:	html pdf

nil.html:	nil.md
	$(LANDSLIDE) -d $@ $<

nil.pdf:	nil.md
	$(LANDSLIDE) -d $@ $<

.PHONY:	all html pdf
