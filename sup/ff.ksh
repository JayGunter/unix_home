#
set -f
#echo args=$*

[ "$1" = ffl ] && {
    find . -type f > file.list
    ls -l file.list
    exit
}

dirs=
names=
o=
grep=
xargs=
ls=
type=
only_files=no
for a in $@; do
    if [ -d $a ] && [ x == x"$names" ]; then
	dirs="$dirs $a"
    elif [ v == $a ]; then
	verbose=yes
    elif [ h == $a ]; then
	names="$names $o -name *.html -o -name *.htm -o -name *.xml"
    elif [ j == $a ]; then
	names="$names $o -name *.java -o -name *.jsp -o -name *.js"
    elif [ f == $a ]; then
	type=f
    elif [ d == $a ]; then
	type=d
	#names="$names $o -type d"
    elif [ k == $a ]; then
	ls="ls -ldt"
    elif [ l == $a ]; then
	ls="ls -ld"
    elif [ g == $a ]; then
	grep="grep"
    elif [ gi == $a ]; then
	grep="grep -i"
    elif [ gl == $a ]; then
	grep="grep -l"
    elif [ gli == $a ]; then
	grep="grep -li"
    elif [ gn == $a ]; then
	grep="grep -n"
    elif [ gni == $a ]; then
	grep="grep -ni"
    elif [ "" != "$grep" ]; then
	grep="$grep $a"
    elif [ x == $a ]; then
	xargs="xargs "
    elif [ "" != "$xargs" ]; then
	xargs="$xargs $a"
    else
	names="$names $o -name $a"
    fi
    if [ "" != "$names" ]; then
	o=-o
    fi
done
[ "" = "$dirs" ] && dirs=.

#echo dirs=$dirs
#echo names=$names
#echo ls=$ls
#echo grep=$grep

#set -x
go() { 
    [ 0 = 1 ] && {
	echo 'Go? [y] \c'
	read go
	[ nn = n$go ] && exit
    }
}

if [ "" != "$type" ]; then
    if [ "" = "$names" ]; then
	names="-type $type"
    else
	names="-type $type -a ( "$names" ) "
    fi
fi

if [ d = "$type" -a "" != "$grep" ]; then
    echo CANNOT GREP DIRECTORIES
    exit
fi

if [ "" != "$grep" ]; then
    #if [ "" == "$names" ]; then
	#names="-type f"
    #else
	#names="-type f -a ( "$names" ) "
    #fi
    [ yes == "$verbose" ] && echo "find $dirs $names | xargs $grep" 
    go
    find $dirs $names | xargs $grep 2>&1 | grep -v 'grep: input lines'
elif [ "" != "$xargs" ]; then
    [ yes == "$verbose" ] && echo "find $dirs $names | $xargs "
    go
    find $dirs $names | $xargs 
elif [ "" != "$ls" ]; then
    [ yes == "$verbose" ] && echo "find $dirs $names | xargs $ls "
    go
    find $dirs $names | xargs $ls | cut -c1-10,45-999
else
    [ yes == "$verbose" ] && echo "find $dirs $names "
    go
    find $dirs $names
fi
