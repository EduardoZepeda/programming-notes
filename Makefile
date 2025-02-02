## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## create/epub: Create a single epub from all the notes included in the Cursos directory
.PHONY: create/epub
create/epub:
	@echo 'Converting Cursos folder into a single epub using apuntes.book as config file'
	@	mkdir -p output;
	@	crowbook apuntes.book --to epub --verbose;
	@echo 'Epub was created at output/apuntes_de_programacion_by_ed.epub'

## create/pdf: Create a single pdf from all the notes included in the Cursos directory
.PHONY: create/pdf
create/pdf:
	@echo 'Converting Cursos folder into a single pdf using apuntes.book as config file'
	@	mkdir -p output;
	@   crowbook apuntes.book --to pdf --verbose;
	@echo 'Pdf was created at output/apuntes_de_programacion_by_ed.pdf'

## create/book: Create a book file at the root of the project. This config file is required to convert all the notes into epub or pdf
.PHONY: create/book
create/book:
	@echo 'Creating book file at apuntes.book'
	@   crowbook apuntes.book --create $$(find Notes/ -depth -iregex '.*\.\(md\)' -printf "%p\n" | sort -V | tr '\n' ' ');


