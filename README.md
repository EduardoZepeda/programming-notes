# My programming notes

Here are my programming notes, in spanish, most of them are from Platzi courses and a few ones are from Udemy. I started taking notes years ago, therefore some notes could be outdated (Example: Django book), please be careful when using them. I don't take responsability for any consequence you could experience by using these notes. 

The notes are in rst format, you can read them directly in github, or convert them to the format you're most comfortable with using pandoc or rst2 libraries. 

Unfortunately, most of my notes from books are highlighted but I never digitalized them, so only online courses for now.

## Converting files

I included a bash script (previously three scripts) to convert rst files into pdf and epub 

### Requisites

To convert the files you'll need to install [pandoc](https://pandoc.org/installing.html), [wget](https://www.gnu.org/software/wget/), and unzip please refer to their respective installation instructions.

Also a folder with the required images, called img, is needed at the root of the project. The script takes care of everything, you just need to execute it and it'll download the required imgs and unzip them to the root of the project.

As an alternative, you can download manually from [dropbox](https://www.dropbox.com/s/j0jdt3htbj30jho/img.zip?dl=0). 

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
./convert_rst_files.sh E
```

### Convert all rst to single epub

This script will convert all rst files in Platzi folder to one single epub, the rest of the rst files are converted individually.

```
./convert_rst_files.sh S
```

### Convert all rst to pdf

This script will convert all rst files to pdf files, one pdf file for each rst file, and place them into the output directory.

```
./convert_rst_files.sh P
```

### No mode

If you don't specify a valid option a warning will be issued

```
No output mode detected. Please use one of the following options: 
 [S]ingle Epub: for convering all Platzi rst folder into a single epub
 [P]df: for convering each rst file into a pdf.
 [E]pub: for converting each rst file into an epub.
Example ./convert_rst_to_epub.sh S
```

## Trouble shooting

Please make sure the script have the right set of permissions.

```
chmod +x *.sh
```
