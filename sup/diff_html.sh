#!/bin/ksh
prog=$0

usage() {
    echo "usage: $prog dir1 dir2"
    exit
}

[ ! -d "$1" ] && {
    echo Directory not found: $1
    usage
}
dir1=$1
shift

[ ! -d "$1" ] && {
    echo Directory not found: $1
    usage
}
dir2=$1
shift

find $dir1 $dir2 -type f | \
sed -n '/\./s,.*\.,*.,gp' | \
sort | \
uniq | \
egrep -v '(html)' > exclude_list

dir1p="`echo $dir1 | sed 's,/,.,g'`"
dir2p="`echo $dir2 | sed 's,/,.,g'`"

TMP_DIR=./_tmp
mkdir -p $TMP_DIR

strip=$TMP_DIR/$prog.strip.awk
added=$TMP_DIR/$prog.added
deleted=$TMP_DIR/$prog.deleted

rm -f $strip $added $deleted

diff -X exclude_list -r $dir1 $dir2 | \
awk '/^Only in/	{   
		    only=1
		}
    /'$dir1p'/	{   
		    if ( only == 1 ) {
			gsub(":$","",$3)
			print $3"/"$4 > deleted
			only=0
			next
		    }
		}
    /'$dir2p'/	{   
		    if ( only == 1 ) {
			gsub(":$","",$3)
			print $3"/"$4 > added
			only=0
			next
		    }
		}
    /^diff/	{   
		    print " ";
		    #print "END OF CHANGES";
		    print "========= Changed: <",$5,"  >",$6;
		    next
		}
		{   
		    print
		}
    END		{   
		    #print "END OF CHANGES" 
		    print "====" 
		}
    ' added=$added deleted=$deleted 

[ -f $added ] && {
    echo 
    #echo "========= Added Files:"
    echo "========= Files found only under $dir1:"
    echo " #Words Filename"
    cat $added | while read file; do
	if [ -f $file ]; then
	    wc -w $file 2>/dev/null
	else
	    find $file -name '*.htm*' | while read file; do
		wc -w $file 2>/dev/null
	    done
	fi
    done
}

[ -f $deleted ] && {
    echo 
    #echo "========= Deleted Files:"
    echo "========= Files found only under $dir2:"
    echo " #Words Filename"
    cat $deleted | while read file; do
	if [ -f $file ]; then
	    wc -w $file 2>/dev/null
	else
	    find $file -name '*.htm*' | while read file; do
		wc -w $file 2>/dev/null
	    done
	fi
    done
}
