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
	@	pandoc -f markdown -t epub3 -o output/epub/ApuntesCursos.epub $$(find Notes/ -depth -iregex '.*\.\(md\)' -printf "%p\n" | sort -V | tr '\n' ' ') --metadata title="Apuntes Cursos" --toc -s --toc-depth=1 --css=styles/pandoc_styles.css;


## create/pdf: Create a single pdf from all the notes included in the Cursos directory
.PHONY: create/pdf
create/pdf:
	@echo 'Converting Cursos folder into a single pdf'
	@	mkdir -p output;
	@	mkdir -p output/pdf;
	@	pandoc -f markdown -t pdf -N --template=templates/template.tex -s -o output/pdf/apuntes.pdf  $$(find Notes/ -depth -iregex '.*\.\(md\)' -printf "%p\n" | sort -V | tr '\n' ' ') --css styles/pandoc_styles.css --pdf-engine=xelatex -f markdown-raw_tex;

## update/toc: Update TOC table for every index file
.PHONY: update/toc
update/toc:
	@echo 'Generating new TOC for every file'
	@	python3 utils/script.py --toc;
	@echo 'Done'


