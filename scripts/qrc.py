#! /usr/bin/env python3

# Generate a Qt Resource file from the contents of a list of directories
# qrc.py <dir1> <dir2> ...

import os
import os.path
import sys


def create_qrc(dirname, prefix=None, basename=None):
    if not basename:
        basename = os.path.basename(dirname)

    file_list = []

    for root, dirs, files in os.walk(dirname):
        file_list += [os.path.relpath(os.path.join(root, filename), dirname)
                      for filename in files]

    file_list.sort()

    contents = '<!DOCTYPE RCC>\n<RCC version="1.0">\n\n'

    if prefix:
        contents += '<qresource prefix="/{}">\n'.format(prefix)
    else:
        contents += '<qresource>\n'

    for filename in file_list:
        if (filename.endswith('.js') or filename.endswith('.qml') or
                filename.endswith('.otf') or filename.endswith('.ttf') or
                filename.endswith('.png') or
                filename == 'qmldir'):
            contents += '\t<file>' + filename + '</file>\n'

    contents += '</qresource>\n\n</RCC>\n'

    with open(os.path.join(dirname, basename + '.qrc'), 'w') as f:
        f.write(contents)


if __name__ == '__main__':
    create_qrc(sys.argv[1], None, sys.argv[2])
