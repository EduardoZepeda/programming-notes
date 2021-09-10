for file in *.rst; do echo $file;  done


mkdir -p output;
for folder in Platzi Udemy Nomadismo Libros; 
    do mkdir -p output/pdf/$folder; 
    for file in $folder/*.rst; 
        do echo $file; 
        rst2pdf $file output/pdf/$file.pdf -s styles/black_code.style;
        done; 
    done
