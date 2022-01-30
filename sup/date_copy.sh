#! C:/mksnt/sh.exe
if [ "$1" == to_ipod ]; then
    x=/Jay/diag/
    for d in D Enumeration F G; do
	[ -d $d:/Jay/diag ] && break
    done
    [ ! -d $d:/Jay/diag ] && {
	echo Could not find /jay/diag on any drive
	exit
    }
else
    d=C
    x=/_Jay/jay/diag/
fi
target=$d:$x

pwd

dirs="$*"
#echo "dirs=$dirs"

[ -z "$dirs" ] && dirs="`ls -F | grep /`"
#echo "dirs=$dirs"

#exit

for dir in $dirs; do
    echo @@@ Fixing filenames in $dir ...
    java -cp $s NoSpacesInFilenames $dir
done

#echo "Renaming filenames containing spaces and parens"
## Google Chrome browser adds (#) to filenames on Save to avoid collisions.
##cd xx; fix_filenames; cd ..
#ls xx | grep ' ' | while read x; do
#    x=xx/$x
#    y=${x/ \(/_}
#    y=${y/\)/}
#    while [ -f $y ]; do
#	y=${y/.jpg/x.jpg}
#    done
#    echo mv -i \"$x\" $y ...
#    eval mv -i \"$x\" $y
#done
#
#exit

[ -n "`find xx -name 'xy*'`" ] && { 
    echo @@@ Moving files to xy/
    mv -i xx/xy*.* xy/
}

[ -n "`find xx -name 'wo*'`" ] && { 
    echo @@@ Moving files to wo/
    mv -i xx/wo*.* wo/
}

echo @@@ Moving movie files to mpg/
mv */*.mp4 */*.mpg */*.mpeg */*.wmv */*.avi mpg/

date=`date +%y%m%d`

for dir in $dirs; do
    [ ! -d $dir ] && {
	echo @@@ WARNING Not a directory: $dir
	continue;
    }

    #echo @@@ Processing files in $dir ...

    t=$target/$dir
    mkdir -p $t
    cd $dir

    #pwd
    if [ -z "`ls|head`" ]; then
	echo @@@@@@ No files in $dir
    else
	echo @@@@@@ Found files in $dir
	rm -f *Thumbs.db Piccer.thm

	for f in *jpeg; do
	    echo @@@ Renaming $f to ${f%.jpeg}.jpg
	    [ -f $f ] && mv $f ${f%.jpeg}.jpg
	done

	echo @@@ Prepending date to filenames ...
	for f in *; do
	    #mv $f `echo $f | sed 's,0922_,,'`
	    case $f in
		-*)	echo @@@ Renaming $f...; java FileUtil rename $f ${f#-} ; ;;
	    esac
	    case $f in
		${date}_*) echo @@@ Already dated: $f  ; ;;
		*)	    [ -f $f ] && mv $f ${date}_$f; ;;
	    esac
	done

	echo @@@ Moving files to $t ...
	mv -i * $t

	ls | awk '{print "Failed to move file: ", $0; exit(1)}'
	[ 1 = $? ] && exit

	# I'm not sure why I was copying, verifying and then removing files.

	#echo Copying to $t ...
	#cp -i * $t
	##cp * $t
	##ls *

	#echo Verifying copied files ...
	#for f in *; do
	    #cmp $f $t/$f
	    #[ 0 != $? ] && exit
	#done

	#echo Removing files in $PWD/...
	#rm *.jpg *.gif *.mpg *.mpeg *.wmv *.avi
    fi

    cd ..
done
