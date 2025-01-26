# My programming notes

Here are my programming notes, in spanish, most of them are from online courses and have been updated over the years from stackoverflow questions, youtube videos and other sources as books or articles.

I started taking notes years ago, therefore some notes could be outdated (For example: Django book), please be careful when using them. I don't take any responsability for any consequence you could experience by using these notes. 

The notes are in Markdown format, you can read them directly in github, or convert them to the format you're most comfortable with using pandoc or other libraries. I'm using [Rust's library Crowbook](https://github.com/crowdagger/crowbook) to build files into PDF and EPUB files. 

## Build Requisites

For this to work we need Crowbook and Xelatex. Please refer to the *Makefile* file for detailed instructions

## Quickstart

### Install the required dependencies

``` bash
cargo install crowbook
apt install xelatex texlive-xetex
```

### Display available commands

Executing make will display the available commands.

``` bash
make
```

### Convert all Markdown files in the Notes directory to a single epub file

This command will convert all Markdown files inside the Notes folder into a single epub file, and place it inside the output directory.

``` bash
make create/epub
```

### Convert all Markdown in the Cursos directory to a single pdf file

This script will convert all Markdown files into a single pdf file, and place it inside the output directory. This could take a while depending on your computer's resources.

``` bash
make create/pdf
```


