echo gogo
x="$*"
[ -z "$x" ] && {
    x=.
    [ -e index.html ] && {
	echo "Browse index.html ? \c"
	read y
	[ y = "$y" ] && x=index.html
    }
}

case "$x" in
    con)	url="http://iepro/docbuild/console.jsp" ;;
    con.)	ie_proj="${PWD##$ap/}"
		if [ "$PWD" != "$ie_proj" ]; then
		    ie_proj="${ie_proj%%/*}"
		    url="http://iepro/docbuild/console.jsp?proj_name=$ie_proj"
		else
		    ie_proj="${PWD##$Ap/}"
		    if [ "$PWD" != "$ie_proj" ]; then
			ie_proj="${ie_proj%%/*}"
			url="http://iepro/docbuild/console.jsp?proj_name=$ie_proj" 
		    else
			echo "Unknown project"
			exit
		    fi
		fi
		;;

    wli)	url="http://iepro/wli/docs81" ;;
    wli/)	url="file:///$iepro1/wli/docs81" ;;
    wla)	url="http://iepro/wladapters" ;;
    wla/)	url="file:///$iepro1/wladapters" ;;

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

    rad*)	url="http://radar.beasys.com/netui/showbug.jsp?bugid="$2 ;;

    dict*)	url="http://www.bennetyee.org/http_webster.pl?$2" ;;
    jd)		url="http://java.sun.com/j2se/1.3/docs/api/index.html" ;;
    jds)	url="http://java.sun.com/products/servlet/2.2/javadoc/index.html" ;;

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

c:/Program\ Files/internet\ explorer/iexplore.exe $url &
