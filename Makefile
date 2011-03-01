
SHELL=/bin/bash

.PHONY: all clean
all: saidjah-a4.pdf saidjah-a5.pdf saidjah-libreto.pdf


revisio.tex: .svn
	@svn up >/dev/null
	date  --rfc-3339=date | tr -d "\n" > revisio.tex
	svn info |  grep Revision | awk '{print " r" $$2}' >> revisio.tex

saidjah-a5.tex: index.html Makefile ../latehxigu.xslt eo.sed  titolpag.tex revisio.tex
	xsltproc ../latehxigu.xslt $<  | sed -f eo.sed | konwert utf8-tex > $@

saidjah-a4.tex: index.html Makefile ../latehxigu.xslt eo.sed titolpag.tex revisio.tex
	xsltproc --stringparam geometry a4paper ../latehxigu.xslt $<  | sed -f eo.sed | konwert utf8-tex > $@

%.dvi: %.tex
	latex $<

%.signature.ps: %-a5.ps
	psbook -s28 $< $@

%.ps: %.dvi
	dvips $< -f > $@


saidjah-libreto.ps:  saidjah.signature.ps
	psnup -d -l -pa4 -Pa5 -2  $< $@


%.pdf: %.ps
	ps2pdf $<

%.pdf: %.tex
	pdflatex $<


%.ps.gz: %.ps
	gzip -f $<


clean:
	rm -f *.pdf *.log *.aux *.dvi profitulo-a4*  *.ps profitulo-a5*