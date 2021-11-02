#!/usr/bin/env bash

mkdir -p output;
declare -a rstFiles

for folder in Platzi Udemy Nomadismo Libros; 
    do mkdir -p output/epub/$folder; 
    if [ "$folder" = "Platzi" ]; then
        for file in $folder/*.rst; 
            do
                rstFiles=(${rstFiles[*]} "$file")
            done;
        echo "Convirtiendo la carpeta Platzi en un único epub"
        pandoc -f rst -t epub3 -o output/epub/Platzi/ApuntesPlatzi.epub --metadata title="Apuntes Platzi" --epub-metadata=Platzi/metadata.xml --toc --toc-depth=1 --css=styles/pandoc_styles.css ${rstFiles[@]};   
    else
        for file in $folder/*.rst; 
            do echo "Convirtiendo $file en epub"; 
            pandoc -f rst -t epub -o output/epub/$file.epub  --toc --css=styles/pandoc_styles.css $file; 
            done; 
    fi
    done
