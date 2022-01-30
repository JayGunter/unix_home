out=C:/_tmp/show_images_in_grid.html

echo "<html><body><table>" > $out

t=0
n=0
for f in $*; do
    [ ! -f $f ] && { echo "Not found: $f"; continue; }
    t=$((t+1))
    
    [ $n = 5 ] && { echo "</tr>" >> $out; n=0; }
    [ $n = 0 ] && { echo "<tr>" >> $out; }
    n=$((n+1))

    p=$PWD
    x=
    for d in `echo $f | sed 's,/, ,g'`; do
	if [ $d = ".." ]; then
	    p=${p%/*}
	else
	    [ -z $x ] && x=$p
	    x=$x/$d
	fi
    done

    echo "<td><img width=100 height=100 src="$x"><br>"$f"</td>" >> $out
done

if [ $t -gt 0 ]; then
    ie $out
else
    echo no files to show
fi
