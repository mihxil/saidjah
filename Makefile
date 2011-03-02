
PDFLATEX=pdflatex

.PHONY: all clean
all: saidjah-a4.pdf saidjah-a5.pdf saidjah-libreto.pdf


revisio.tex: .svn
	-svn up >/dev/null 2> /dev/null
	date  --rfc-3339=date | tr -d "\n" > revisio.tex
	svn info |  grep Revision | awk '{print " r" $$2}' >> revisio.tex

saidjah-a5.tex: index.html Makefile ../latehxigu.xslt eo.sed  titolpag.tex revisio.tex
	xsltproc -novalid ../latehxigu.xslt $<  | sed -f eo.sed -f ../utf8-tex.sed > $@

saidjah-a4.tex: index.html Makefile ../latehxigu.xslt eo.sed titolpag.tex revisio.tex
	xsltproc -novalid --stringparam geometry a4paper ../latehxigu.xslt $<  | sed -f eo.sed  -f ../utf8-tex.sed > $@

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
	-$(PDFLATEX) $<


%.ps.gz: %.ps
	gzip -f $<


clean:
	rm -f *.pdf *.log *.aux *.dvi profitulo-a4*  *.ps profitulo-a5*