
#[ ! -d dups/ ] && mkdir dups/

while [ 0 ]; do

    ls -l | awk '/^-.*\./{print $5, $NF}' | sort > sizes

    awk < sizes '(x==$1){print "cmp ",n,$NF}{x=$1;n=$NF}' > comp

    #echo '<html><body><table>' > dup_images
    #awk < sizes '(x==$1){print "<tr><td><img height=100px width=100px src="n"><td><img height=100px width=100px src="$NF"></tr>"}{x=$1;n=$NF}' >> dup_images
    #echo '</table></body></html>' >> dup_images

    #exit

    #ls -l sizes comp
    echo Number of files in sizes file: `cat sizes | wc -l` 

    rm -f found_dup
    cat comp | while read line; do
	set $line
	shift
	[ ! -f $1 ] && continue
	cmp $1 $2 2>&1 > /dev/null
	[ $? = 0 ] && {
	    #echo mv $2 dups/
	    #mv -i $2 dups/
	    echo Removing dup $2
	    rm $2
	    touch found_dup
	}
    done

    [ ! -f found_dup ] && exit

    echo ""
    echo Checking again...
    echo ""

done
