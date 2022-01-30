# check every file against every other file
# because vids often have the same sizes (especially from the same source)

mkdir dups2

ls | while read a; do
    [ ! -f $a ] && continue
    echo checking $a...
    ls | while read b; do
	[ ! -f $b ] && continue
	#echo === $a against $b...
	[ $a = $b ] && continue
	cmp $a $b 2>&1 > /dev/null
	[ $? = 0 ] && {
	    echo mv $b dups2/
	    mv $b dups2/
	}
    done
done
