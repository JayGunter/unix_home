awk '
    {
	gsub( ":", " " );
	if ( "" == $1 || "" == $2 ) next;
	if ( 0 == c[$2] ) {
	    c[$2]=$1
	} else {
	    x = c[$2] - $1;
	    if ( x < 0 ) x *= -1;
	    d += x
	    if ( x > 0 && DETAIL == "detail" ) print d, $2, x, $1, c[$2]
	}
    }
    END {
	print d
    }' DETAIL=$1
	    
