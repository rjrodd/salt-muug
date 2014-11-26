SRCS		= salt-muug.md
PDFOBJS		= $(SRCS:.md=.pdf)
SLIDEOBJS	= $(SRCS:.md=.html)
PANDOC		= pandoc
PFLAGS		= -t beamer

.PHONY: all clean slides pdf 

all: $(SLIDEOBJS)
	@echo Slides generated

%.pdf: %.md
	$(PANDOC) $(PFLAGS) $< -o $@

beamer: $(PDFOBJS)

%.html: %.md
#	pandoc -V theme=default -s -S -t revealjs --mathjax $< -o $@
	pandoc -V theme=sky --slide-level 2 -s -S -t revealjs --mathjax -V revealjs-url:https://secure.ciscodude.net/vendor/reveal.js $< -o $@

slides: $(SLIDEOBJS)

clean: cleanpdf cleanslides

cleanpdf:
	rm -f $(PDFOBJS)

cleanslides:
	rm -f $(SLIDEOBJS) 

gh-pages: slides 
	git add salt-muug.html
	git commit -m 'generate latest slides via Makefile'
	git push -u origin master
	git checkout gh-pages
	git checkout master -- salt-muug.html
	cp salt-muug.html index.html
	git add salt-muug.html index.html
	git commit -m 'pull in latest generated slides from master branch'
	git push -u origin gh-pages
	git checkout master
	@echo Slides generated and pushed to gh-pages branch
