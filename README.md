# My programming notes

Here are my programming notes, in spanish, most of them are from online courses and have been updated over the years from stackoverflow questions, youtube videos and other sources.

I started taking notes years ago, therefore some notes could be outdated (For example: Django book), please be careful when using them. I don't take any responsability for any consequence you could experience by using these notes. 

The notes are in rst format, you can read them directly in github, or convert them to the format you're most comfortable with using pandoc or rst2 libraries. 

## Requisites

To convert the files you'll need to install [pandoc](https://pandoc.org/installing.html). Please refer to the *Makefile* file for detailed instructions

## Quickstart

### Convert all rst in the Cursos directory to a single epub file

This instruction will convert all rst files to epub, one epub file for each rst file, and place them into the output directory.

```
make create/epub
```

### Convert all rst in the Cursos directory to a single pdf file

This script will convert all rst files to pdf files, one pdf file for each rst file, and place them into the output directory.

```
make create/pdf
```


