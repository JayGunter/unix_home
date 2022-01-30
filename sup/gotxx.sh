unset CLICOLOR_FORCE

#d=C:/_Jay/Dowloads
ttt=/tmp
jj=/j
from=$j/Downloads
to=$jj/diag
xx=$to/xx
xy=$to/xy
wo=$to/wo
mpg=$to/mpg

#new_sizes=/tmp/new_sizes

mv_movies=/tmp/mv_movies

[ "$1" != skip ] && {
    for aaa in xx xy wo; do 
    echo Regenerating sizes file for $aaa...
    cd $to/$aaa
    ls -l | awk '(NR > 4){print $5, $NF}' > $to/$aaa/sizes
    #echo > $new_sizes'_'$aaa
    done
}


#show_matches=/tmp/show_matches
matches=/tmp/got.matches
msg=/tmp/got.msg

block=/tmp/gotxx.block
rm -f $block

function mvi {
    echo mv -i $*
    mv -i -- $*
}

cd $from

# remove vids not marked 'jjj'
#rm *.avi *.mpg *.mp4 *.wmv

oldsub=xy
sub=wo
while [ 1 ]; do
    sleep 2
    #[ -f $block ] && continue
    echo -n .
    rm $msg $matches
    touch $msg $matches
    #echo > $show_matches
    #rm $matches
    #touch $matches
    #for f in *.jpg *.gif *.avi *.mpg *.mp4 *.wmv; do
    #for f in *.jpg *.gif ; do
    #for f in *.jpg *.gif jjj*.avi jjj*.mpg jjj*.mp4 jjj*.wmv; do
    #for f in *.jpg *.gif jjj*.avi jjj*.mpg jjj*.mp4 jjj*.wmv *.JPG *.GIF jjj*.AVI jjj*.MPG jjj*.MP4 jjj*.WMV; do
    for f in *.jpeg *.JPEG; do
	[ -f "$f" ] && {
	    echo Renaming $f ${f%.*}.jpg
	    mv -- "$f" "${f%.*}.jpg"
	}
    done
    java -cp $s NoSpacesInFilenames 
    pref="jjj"
    for f in *.webm *.html *.jpg *.gif *.png $pref*.avi $pref*.mpg $pref*.mp4 $pref*.wmv *.JPG *.GIF $pref*.AVI $pref*.MPG $pref*.MP4 $pref*.WMV $pref*.webm; do
#echo f=$f
	[ ! -f "$f" ] && continue
	ts=`date +%y%m%d_%H%M%S`
	ff=$ts"_$f";
	good=1
	case "$f" in
	    #xy*) mvi $f $to/xy/$ff; ;;
	    #wo*) mvi $f $to/wo/$ff; ;;
	    #*.avi) mvi $f $to/mpg/$ff; ;;
	    #*.mpg) mvi $f $to/mpg/$ff; ;;
	    #*.mp4) mvi $f $to/mpg/$ff; ;;
	    #*.wmv) mvi $f $to/mpg/$ff; ;;
	    *.html) 
		echo GRABBED .html BY MISTAKE: $f >> $msg
		htmldir="${f%.html}"
		rm -rf "$f" "$htmldir"
		continue;
		;;
	    xx*) sub=xx; ;;
	    xy*) sub=xy; ;;
	    wo*) sub=wo; ;;
	    *.avi|*.mpg|*.mp4|*.wmv) dir=$mpg
	esac
	#ns=$new_sizes'_'$sub;
	ns=
	dir=$to/$sub
	case all in 
	    *) 
		[ "$olddir" = "$dir" ] && echo dir=$dir
		fsize=`ls -l $f | awk '{print $5}'`
#echo f=$f, fsize=$fsize
		for sizefile in $ns $dir/sizes; do
		    grep "^$fsize " $sizefile > $ttt/got.diag
		    n=`wc -l < $ttt/got.diag`
		    [ $n -gt 0 ] && {
			echo 
			echo Checking $n files of size $fsize...
			for d in `awk < $ttt/got.diag '{print $NF}'` ; do
#echo f=$f | od -c
#echo d=$d | od -c
			    dd=$dir/$d
#echo dd=$dd | od -c
			    echo Comparing $f to $dd
			    #cmp $f $dd 2>&1 | od -c
#echo aaaaaa
			    cmp $f $dd > /dev/null
#echo xxxxxxx
			    case $? in
				0)  echo MATCH: $f $d >> $msg
				    echo $f >> $matches
				    good=0
				    ;;
				1)  # files differ
				    ;;
				2)  # file not found
				    echo Error comparing $f and $dd >> $msg
				    cmp $f $dd >> $msg
				    good=0
				    ;;
			    esac
			    #cmpsaid=$?
			    #if [ 0 = $cmpsaid ]; then
				#echo echo MATCH: $f $d >> $show_matches
				#echo $f >> $matches
			    #fi
			done
		    }
		done
		#ls -l $matches
		#if [ ! -s $matches ]; then
		if [ $good = 1 ]; then
		    echo 
		    echo $sub : Moving $f to $dir/$ff
		    mv -- $f $dir/$ff
		    [ $? != 0 ] && {
			echo ERROR could not move $f to $dir/$ff >> $msg
			#echo ERROR could not move $f to $dir/$ff
			#exit
		    }
		    #echo $fsize $ff >> $ns
		    echo $fsize $ff >> $dir/sizes
		fi

		;;
	esac
    done
    if [ -s $msg ]; then
	osascript $s/got.msg
    fi
    if [ -s $matches ]; then
#echo MATCHES
#ls -l $matches
#cat $matches
#ls -l $show_matches
#cat $show_matches
	#echo "read line" >> $show_matches
	#echo "rm $block" >> $show_matches
	#touch $block
	#start sh $show_matches
	#cp $matches $show_matches
	echo
	echo REMOVING DUPLICATE FILES FROM $from:
	cat $matches
	rm `cat $matches`
    fi
    # Remove all videos more than 1 hour old.  The ones I wanted to keep I re-saved with $pref.
    for f in *.avi *.mpg *.mp4 *.wmv *.AVI *.MPG *.MP4 *.WMV; do
	#[ -f "$f" ] && {
	[ -n "`find . -mmin +60 -a -name $f`" ] && {
	    echo Removing $f
	    rm $f
	}
    done
done
