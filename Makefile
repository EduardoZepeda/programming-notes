## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## create/epub: Create a single epub from all the notes included in the Cursos directory
.PHONY: create/epub
create/epub:
	@echo 'Converting Cursos folder into a single epub'
	@	mkdir -p output;
	@	mkdir -p output/epub;
	@	crowbook apuntes.book --to epub --output output/epub/apuntes_de_programacion_by_ed.pdf --verbose;
	@echo 'Epub was created at output/epub/apuntes_de_programacion_by_ed.epub'

## create/pdf: Create a single pdf from all the notes included in the Cursos directory
.PHONY: create/pdf
create/pdf:
	@echo 'Converting Cursos folder into a single pdf'
	@	mkdir -p output;
	@	mkdir -p output/pdf;
	@   crowbook apuntes.book --create $$(find Notes/ -depth -iregex '.*\.\(md\)' -printf "%p\n" | sort -V | tr '\n' ' ');
	@   crowbook apuntes.book --to pdf --output output/pdf/apuntes_de_programacion_by_ed.pdf --verbose;
	@echo 'Pdf was created at output/pdf/apuntes_de_programacion_by_ed.pdf'


