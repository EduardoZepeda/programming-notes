## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## create/epub: Create a single epub with all the notes included
.PHONY: create/epub
create/epub:
	@echo 'Converting Cursos folder into a single epub'
		mkdir -p output;
		mkdir -p output/epub;
		pandoc -f markdown -t epub3 -o output/epub/ApuntesCursos.epub $$(echo Cursos/*.md) --metadata title="Apuntes Cursos" --epub-metadata=Cursos/metadata.xml --toc -s --toc-depth=1 --css=styles/pandoc_styles.css;


## create/pdf: Create a single pdf with all the notes included
.PHONY: create/pdf
create/pdf:
	@echo 'Converting Cursos folder into a single pdf'
		mkdir -p output;
		mkdir -p output/pdf;
		pandoc -s -o output/pdf/apuntes.pdf $$(echo Cursos/*.md) --pdf-engine=xelatex --css styles/pandoc_styles.css;

