#cat << END > /tmp/bumptest
#xyz_qrs_boo_foo
#xyz_q__rs.jpg
#xyz_q_rs_.jpg
#xyz_qrs
#END

#awk < /tmp/bumptest '
#awk < /tmp/xx.time '
#jj iii/xx
awk '
    BEGIN{ 
	i=1;
	a[i++]="A"; a[i++]="B"; a[i++]="C"; a[i++]="D" ; a[i++]="E";
	a[i++]="F"; a[i++]="G"; a[i++]="H"; a[i++]="I" ; a[i++]="J";
	a[i++]="K"; a[i++]="L"; a[i++]="M"; a[i++]="N" ; a[i++]="O";
	a[i++]="P"; a[i++]="Q"; a[i++]="R"; a[i++]="S" ; a[i++]="T";
	a[i++]="U"; a[i++]="V"; a[i++]="W"; a[i++]="X" ; a[i++]="Y";
	a[i++]="Z";
	i=j=k=1; 
	m=26; 
    }
    {	x=$1;
	gsub("_.*","",x);
	y=$1;
	gsub(x"_","",y);
	z=x"_"a[k]a[j]a[i]"_"y;
	gsub("__","_",z);
	gsub("_.jpg",".jpg",z);
	print "mv -i "$0" "z;
	if(++i > m) {
	    i=1;
	    if(++j > m) {
		j=1;
		if(++k > m) {
		    k=1;
		}
	    }
	}
    }
'
