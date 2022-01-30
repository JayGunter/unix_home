#!/bin/bash
script=/tmp/view.in.chrome.osascript
f=$1
[ ! -f "$f" ] && {
    echo view.in.chrome:  $f does not exist.
    exit 1
}
#echo f=$f
[ -n "${f%%/*}" ] && f=$PWD/$f
#echo f=$f
#exit
cat << END > $script
tell application "Google Chrome"
make new window
activate
tell window 0 to make new tab with properties {URL:"file://$f"}
end tell
END

osascript $script
