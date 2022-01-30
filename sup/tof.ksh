fr=$j/jay/iii
to=f:/diag

now="`date +%m%d`"

cd $fr
for d in *; do
    echo d=$d
    [ -d $d ] && {
	mkdir -p $to/$d
	cd $d
	pwd
	for f in *; do
	    echo f=$f
	    [ $f == "*Thumbs.db" ] && continue
	    [ -f $f ] && {
		 mv -i $f $to/$d/$now"_"$f
	    }
	done
    }
    cd $fr
done

