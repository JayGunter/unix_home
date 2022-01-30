# usage:  echo A A A | alpha_bumber.sh   prints "A A B AAB"
f=/tmp/alpha_bumper.data
[ ! -s $f ] && { 
    echo A A A AAA > $f
}
awk < $f > $f.new '
    BEGIN{ 
	i=1;
	a[i++]="A"; a[i++]="B"; a[i++]="C"; a[i++]="D" ; a[i++]="E";
	a[i++]="F"; a[i++]="G"; a[i++]="H"; a[i++]="I" ; a[i++]="J";
	a[i++]="K"; a[i++]="L"; a[i++]="M"; a[i++]="N" ; a[i++]="O";
	a[i++]="P"; a[i++]="Q"; a[i++]="R"; a[i++]="S" ; a[i++]="T";
	a[i++]="U"; a[i++]="V"; a[i++]="W"; a[i++]="X" ; a[i++]="Y";
	a[i++]="Z";
	for (j in a) {
	    b[a[j]] = j;
	    if (j == 26) 
		n[a[j]] = a[1];
	    else
		n[a[j]] = a[j+1];
	}
    }
    {	
	i=$1;
	j=$2;
	k=n[$3];
	if (k == "A") {
	    j=n[$2];
	    if (j == "A") {
		i=n[$1];
	    }
	}
	print i,j,k,i""j""k
    }
'
mv $f.new $f
cat $f
