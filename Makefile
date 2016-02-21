.PHONY: pack dist clean all ui

all: hfit.exe
	@hfit.exe

hfit.exe: main.hs utils.hs
	ghc -threaded -rtsopts -with-rtsopts=-N -o hfit.exe main.hs

pack: hfit.exe
	strip hfit.exe
	upx --ultra-brute hfit.exe

dist: hfit.exe
	tar cvfz hfit-1.0.0.tgz hfit.exe ui.tcl wish.*

clean:
	-rm *.hi *.o hfit.exe

ui:
	wish ui.tcl
