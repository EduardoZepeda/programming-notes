#!/usr/bin/env bash

mkdir -p output;
declare -a rstFiles

bold=$(tput bold)
normal=$(tput sgr0)

if [ "$1" == "" ]; then
    printf "No output mode detected. Please use one of the following options: \n [${bold}S${normal}]ingle Epub: for convering all Platzi rst folder into a single epub\n [${bold}P${normal}]df: for convering each rst file into a pdf.\n [${bold}E${normal}]pub: for converting each rst file into an epub.\nExample ./convert_rst_to_epub.sh ${bold}S${normal}\n"
    exit 0
fi

if ! [[ -d "img" ]]
then
    echo "Checking if img/ directory exist at the root of the notes."
    echo "img folder wasn't found, creating it"
    echo "Using wget to download images from dropbox";
    wget "https://www.dropbox.com/s/j0jdt3htbj30jho/img.zip" -O temp.zip;
    echo "Finished downloading images"
    unzip temp.zip;
    echo "Trying to unzip img.zip file"
    rm temp.zip;
    printf "Deleting temporary zip file"
else
    printf "img/ directory already exist\n"
fi

if [ "$1" == "S" ]; then
    echo "Using styles/pandoc_styles.css pandoc as stylesheet and Platzi/metadata.xml as metadata source"
    for folder in Platzi Udemy Nomadismo Libros; 
        do mkdir -p output/epub/$folder; 
        if [ "$folder" = "Platzi" ]; then
            for file in $folder/*.rst; 
                do
                    rstFiles=(${rstFiles[*]} "$file")
                done;
            echo "Converting Platzi folder into a single epub"
            pandoc -f rst -t epub3 -o output/epub/Platzi/ApuntesPlatzi.epub --metadata title="Apuntes Platzi" --epub-metadata=Platzi/metadata.xml --toc --toc-depth=1 --css=styles/pandoc_styles.css ${rstFiles[@]};   
        else
            for file in $folder/*.rst; 
                do echo "Converting $file to epub"; 
                pandoc -f rst -t epub -o output/epub/$file.epub  --toc --css=styles/pandoc_styles.css $file; 
                done; 
        fi
        done

elif [ "$1" == "P" ]; then
    mkdir -p output;
    echo "Using styles/pandoc_styles.css pandoc as stylesheet"
    for folder in Platzi Udemy Nomadismo Libros; 
        do mkdir -p output/pdf/$folder; 
        for file in $folder/*.rst; 
            do echo "Converting $file to pdf"; 
            pandoc -s -o output/pdf/$file.pdf $file --pdf-engine=xelatex --css styles/pandoc_styles.css;
            done; 
        done

elif [ "$1" == "E" ]; then
    echo "Using styles/pandoc_styles.css pandoc as stylesheet"
    for folder in Platzi Udemy Nomadismo Libros; 
        do mkdir -p output/epub/$folder; 
        for file in $folder/*.rst; 
            do echo "Converting $file to epub"; 
            pandoc -f rst -t epub -o output/epub/$file.epub --toc --css=styles/pandoc_styles.css $file; 
            done; 
        done

else
    printf "Please use one of the following options: \n [S]ingle Epub: for convering all Platzi rst folder into a single epub\n [P]df: for convering each rst file into a pdf.\n [E]pub: for converting each rst file into an epub.\nExample ./convert_rst_to_epub.sh S"
fi