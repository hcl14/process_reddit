import json
from unidecode import unidecode
import re


import sys

if len(sys.argv) != 2:
    print("please specify filename, e.g. RS_2017-04")
    sys.exit()
    
fname = sys.argv[1]

print("Extracting plain text from " + fname)

out_file = open(fname+'.all.txt','w')

linecount = 0;
with open(fname, 'r') as input_file:
    for line in input_file:
        linecount += 1
        line_json = None
        try:
            line_json = json.loads(line)
        except:
            print("Error on line " + str(linecount))
        
        if line_json is not None:
            
            text = line_json["title"] + "\n" + line_json["selftext"] + "\n"
            
            text = re.sub("[\(\[].*?[\)\]]", "", text) # remove everything in [] and () 
            
            out_file.write(unidecode(text))
            
        if linecount % 10000 == 0:
            print(str(linecount))
            
out_file.close()