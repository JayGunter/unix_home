( echo $1 ; echo $2 ) | \
awk '	( pass==0 ) {
	    for ( i=1; i<=NF; i++ ) { p[i]=$i }
	    pass=1
	    next
	}
	( pass==1 ) {
	    for ( j=1; j<=NF && j<i; j++ ) if ( $j != p[j] ) break;
	    for ( k=j; k<i; k++ ) x=x"/.."
	    for ( ; j<=NF; j++ ) x=x"/"$j
	    print "x=",x
	}' FS=/


