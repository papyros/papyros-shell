#! /usr/bin/env python3

# Generate a Qt Resource file from the contents of a list of directories
# qrc.py <dir1> <dir2> ...

import os, os.path
import sys

file_list = []

for directory in sys.argv[1:]:
	sub_list = []
	
	for root, dirs, files in os.walk(directory):
		sub_list += [os.path.join(root, filename) for filename in files]
		
	sub_list.sort()
	file_list += sub_list
		
contents = '<!DOCTYPE RCC>\n<RCC version="1.0">\n\n<qresource>\n'

for filename in file_list:
	contents += '\t<file>' + filename + '</file>\n'
	
contents += '</qresource>\n\n</RCC>\n'
		
print(contents)
