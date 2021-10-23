for file in *.rst; do echo $file;  done


mkdir -p output;
for folder in Platzi Udemy Nomadismo Libros; 
    do mkdir -p output/pdf/$folder; 
    for file in $folder/*.rst; 
        do echo $file; 
        pandoc -s -o output/pdf/$file.pdf $file --css styles/pandoc_styles.css;
        done; 
    done
