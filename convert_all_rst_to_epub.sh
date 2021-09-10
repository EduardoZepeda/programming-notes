mkdir -p output;
for folder in Platzi Udemy Nomadismo Libros; 
    do mkdir -p output/epub/$folder; 
    for file in $folder/*.rst; 
        do echo $file; 
        pandoc -f rst -t epub -o output/epub/$file.epub --toc --css=styles/pandoc_styles.css $file; 
        done; 
    done
