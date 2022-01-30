#!/bin/bash
#cd $jj/diag
cd /j/diag

echo START $$

year=`date +%y`

mark=/tmp/backup_images_copying_to_drive
rm -rf $mark
mkdir -p $mark/Volumes

drives=""
[ 0 = 1 ] && {
for drive in E F G H I; do
    [ -d $drive:/diag/ ] && {
	drives=$drives" "$drive
	todir=$drive:/diag/
	for d in xx xy wo mpg; do
	    mkdir -p $todir/$d
	done
	mkdir -p $todir/xx$year
    }
done
}

for diag in /Volumes/*/diag; do
echo diag=$diag
    drive=${diag%/*}
    drives=$drives" "$drive
    mkdir -p $diag/xx10
    mkdir -p $diag/xx11
    mkdir -p $diag/xx12
done
echo drives=$drives

#echo drives=$drives
#exit

did1=""
#todir=g:/diag/
n=0
for d in xx xy wo mpg; do
    #mkdir -p $todir/$d
    #case $d in
	#xx)  mkdir -p $todir/$d"2"
    #esac

    find $d -type f -name '13*' -print | \
    #find $d -type f -print | \
    while read f; do
	#echo f=$f
	[ $n = 100 ] && { 
	    echo Checking $f...
	    n=0
	}
	n=$(( n + 1 ))
	ff=${f#*/}
	# starting with 2010, xx files are put in xx$year dirs
	# to avoid too many files in dir problems.
	case $f in
	    xx/1[0-9][0-1][0-9][0-3][0-9]_*) fyear=`echo $f | cut -c4,5` ;;
	    *)  fyear="" ;;
	esac

	fpath=/diag/$d$fyear/$ff

	copyto=""
	waitingfor=""
	for drive in $drives; do
	    #todir=$drive:/diag/$d$fyear
	    [ ! -f $drive/$fpath ] && { 
		copyto=$copyto" "$drive
		waitingfor=$waitingfor$drive
	    }
	done
	[ -n "$copyto" ] && {
	    echo -n @@@@@@@@ Copying $f # to $waitingfor 
#did1=x
	    for drive in $copyto; do
		touch $mark/$drive
		#echo cp $f $todir/$d$sub/$ff
		( cp $f $drive/$fpath; rm $mark/$drive ) &
	    done
	    while [ 1 ]; do
		waitingfor=""
		for drive in $copyto; do
		    echo boo > /dev/null
		    #count 1 1 > /dev/null
		    #sleep 1
		    [ -f $mark/$drive ] && {
			letter=`echo $drive | sed 's,/Volumes/\(.\).*,\1,'`
			waitingfor=$waitingfor$letter
		    }
		done
		if [ -n "$waitingfor" ]; then
		    #echo WW $waitingfor WW
		    echo -n $waitingfor
		else
		    echo
		    break
		fi
		sleep .1
	    done
[ -n "$did1" ] && {
echo breaking from loop $d
#echo BEFORE EXIT $$
break
#echo AFTER EXIT $$
}
	}

#[ -n "$did1" ] && {
    #echo DID1
    #exit
#}

    done
done
	
    
