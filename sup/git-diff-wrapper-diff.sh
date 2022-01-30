#!/bin/sh

# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode

/usr/bin/diff "$2" "$5" 
# when diff has output, the exit code is non-zero, and git thinks the diff tool died.
exit 0

#/usr/bin/vimdiff "$2" "$5" 
