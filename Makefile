SHELL=/bin/bash
.PHONY: all  \
        clean  \
		help Help
# Variablen nur zum Testen geändert
  MD_READ := $(shell if [ -z `cat Vars | awk -F';' '/^MD_READ/ {print $$2; exit}'` ]; \
     then m=`which ghostwriter`;echo $${m##*/}; \
     else echo `cat Vars | awk -F';' '/^MD_READ/ {print $$2; exit}'`; fi)
#
# Pseudoziele Erstellen
# alles erstellen
all:
	@echo "all"
# alles löschen
clean:
	@echo "clean"
#
help:
    # Info: Quelle -> Ziel
	@echo "Ziele:                                           "
	@echo "    make              all"
	@echo "    make all          alles erstellen, bedingt"
	@echo "    make clean        alles löschen"
	@echo "    make help         Diese Hilfe"
	@echo "    make Help         Ausführliche Hilfe für das Framework"
	@echo "                                                         "

Help:
	@if [ -z `which $(MD_READ)` ]; then more +/"2.1 Makefile" Framework/help.md; \
	else $(MD_READ) Framework/help.md; 	fi
	echo $(MD_READ)


