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
	@	pandoc -f markdown -t epub3 -o output/epub/ApuntesCursos.epub "--from=markdown+rebase_relative_paths" $$(find Notes/ -depth -iregex '.*\.\(md\)' -printf "%p\n" | sort -V | tr '\n' ' ') --metadata title="Apuntes Cursos" --toc -s --toc-depth=1 --css=styles/pandoc_styles.css;


## create/pdf: Create a single pdf from all the notes included in the Cursos directory
.PHONY: create/pdf
create/pdf:
	@echo 'Converting Cursos folder into a single pdf'
	@	mkdir -p output;
	@	mkdir -p output/pdf;
	@	pandoc -N --template=templates/template.tex -s -o output/pdf/apuntes.pdf "--from=markdown+rebase_relative_paths" $$(find Notes/ -depth -iregex '.*\.\(md\)' -printf "%p\n" | sort -V | tr '\n' ' ') --css styles/pandoc_styles.css --pdf-engine=xelatex -f markdown-raw_tex;


