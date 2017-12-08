#!/bin/bash

filenames=""
filelines=`cat $filename`

for line in $filelines ; do

    var=$(echo $line | cut -f 1 -d '.') &&

    aria2c -x 16 "https://files.pushshift.io/reddit/comments/$var.bz2" &&

    # extract bz2 archive, removing source file (2.5G)
    bzip2 -d "$var.bz2" &&

    # run plain text extractor on reddit json (~17G)
    python3 plaintextextract_comments.py $var &&
    
    #convert to ascii
    iconv -f UTF8 -t US-ASCII//TRANSLIT "comments/$var.all.txt" > "comments/$var.all_ascii.txt" &&
    
    rm comments/$var.all.txt &&

    #remove reddit json
    rm $var;
done

