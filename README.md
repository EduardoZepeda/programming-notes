# My programming notes

Here are my programming notes, in spanish, most of them are from Platzi courses and a few ones are from Udemy. I started taking notes years ago, therefore some notes could be outdated (Example: Django book), please be careful when using them. I don't take responsability for any consequence you could experience by using this notes. 

The notes are in rst format, you can read them directly in github, or convert them to the format you're most comfortable with using pandoc or rst2 libraries. 

Sorry, most of my notes from books are highlighted I never digitalized them.

## Converting files

I included three bash scripts to convert the files from rst to epub and from rst to pdf. 

### Requisites

To convert the files you'll need to install [pandoc](https://pandoc.org/installing.html) and [rst2pdf](https://github.com/rst2pdf/rst2pdf), please refer to their respective installation instructions.

Also a folder with the required images, called img, is needed at the root of the project. Download it from [dropbox](https://www.dropbox.com/s/j0jdt3htbj30jho/img.zip?dl=0).

```
img/
  ├── cloudComputingAWS
  │   ├── BalanceadorDeCarga00.png
  │   ├── BalanceadorDeCarga01.png
  ...
```

### Convert all rst to epub

This script will convert all rst files to epub, one epub file for each rst file, and place them into the output directory.

```
./convert_all_rst_to_epub.sh
```

### Convert all rst to single epub

This script will convert all rst files in Platzi folder to one single epub, the rest of the rst files are converted individually.

```
./convert_all_rst_to_one_file_epub.sh
```

### Convert all rst to pdf

This script will convert all rst files to pdf files, one pdf file for each rst file, and place them into the output directory.

```
./convert_all_rst_to_pdf.sh
```

## Trouble shooting

Please make sure the scripts have the right permissions.

```
chmod +x *.sh
```
