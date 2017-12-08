import json
from unidecode import unidecode
import re


import sys

if len(sys.argv) != 2:
    print("please specify filename, e.g. RS_2017-04")
    sys.exit()
    
fname = sys.argv[1]

garbage = ["&gt;","&lt;","&le;","&ge"]

print("Extracting plain text from " + fname)

out_file = open("comments/"+fname+'.all.txt','w')

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
            
            text = line_json["body"] + "\n"
            
            text = re.sub("[\(\[].*?[\)\]]", "", text) # remove everything in [] and () 
            
            text = unidecode(text)
            
            for g in garbage:
                text = text.replace(g, "")
            
            out_file.write(text)
            
        if linecount % 10000 == 0:
            print(str(linecount))
            
out_file.close()