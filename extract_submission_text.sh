#!/bin/bash

# pass here the name of the archive, i.e. "RS_2017-04" (without .bz2)

aria2c -x 16 "https://files.pushshift.io/reddit/submissions/$1.bz2"

# extract bz2 archive, removing source file (2.5G)
echo "Extracting archive..."
bzip2 -d "$1.bz2"

# run plain text extractor on reddit json (~17G)  > ~ 2 Gb text file
echo "Extracting plain text..."
python3 plaintextextract.py $1

#remove reddit json
rm $1

#unescape html
echo "Fixing escaped html..."
cat "$1.all.txt" | python3 -c 'import html, sys; [print(html.unescape(l), end="") for l in sys.stdin]' > "$1.all.escaped.txt"

rm $1.all.txt

#convert to ascii
echo "Converting to ASCII..."
iconv -f UTF8 -t US-ASCII//TRANSLIT "$1.all.escaped.txt" > "submissions/$1.all_ascii.txt" 

rm "$1.all.escaped.txt"

echo "Cleaning bad characters..."

# produces out.txt

javac CharFilter.java 

java CharFilter "submissions/$1.all_ascii.txt" 

rm "submissions/$1.all_ascii.txt" 

# remove long sequences of unknown shit
sed -E -i 's/(\s*[^a-zA-Z]+\s*){7,}/\1/g' out.txt

mv out.txt "submissions/$1.all_ascii_cleaned.txt" 




