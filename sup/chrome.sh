#!/bin/bash
echo gogo
x="$*"
[ -z "$x" ] && {
    x=.
    [ -e index.html ] && {
	echo -n "Browse index.html ? "
	read y
	[ y = "$y" ] && x=index.html
    }
}

case "$x" in
    goo*)	shift
		url='http://www.google.com'
		[ 0 != $# ] && {
		    url="$url/search?hl=en&ie=ISO-8859-1&q="
		    plus=
		    while [ "" != "$1" ]; do
			if [ "$1" == *" "* ]; then
			    url="$url$plus%22${1// /+}%22"
			else
			    url="$url$plus$1"
			fi
			shift
			plus=+
		    done
		}
		;;


    dict*)	url="http://www.bennetyee.org/http_webster.pl?$2" ;;

    http:*)	url="$x" ;;
    file:*)	url="$x" ;;

    *)	if [ ! -e "$x" ]; then
	    echo Not found: "$x"
	    exit
	else
	    case "$x" in
		[a-zA-Z]:*) url=file:///"$x" ;;
		/*)	    url=file:///${PWD%%/*}"$x" ;;
		*)	    url=file:///$PWD/"$x" ;;
	    esac
	fi
	;;
esac
echo url=$url

cmd=/tmp/chrome.cmd
cat << END > $cmd
tell application "Google Chrome"
make new window
activate
tell window 0 to make new tab with properties {URL:"$url"}
end tell
END
osascript $cmd
