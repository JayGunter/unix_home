#!/bin/sh

# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode

/Applications/DiffMerge.app/Contents/MacOS/DiffMerge "$2" "$5" | cat
