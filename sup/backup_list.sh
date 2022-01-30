# backup specified files and dirs
[ 0 = $# ] && {
    echo usage:
#    echo "create           a backup list:  backup_list -c listname [arg...]"
    echo "add pwd or args to   backup list:  backup_list -a listname [arg...]"
    echo "rm  pwd or args from backup list:  backup_list -r listname [arg...]"
    echo "edit             a   backup list:  backup_list -e listname"
    echo "delete           a   backup list:  backup_list -d listname"
    echo "backup args in       backup list:  backup_list -b listname"
    echo "backup changes in    backup list:  backup_list -i listname"
    echo "list changes in      backup list:  backup_list -I listname"
    echo "list names of        backup lists: backup_list -l"
    echo "list all backup-related files:     backup_list -ll"
    echo "print entries in     backup lists: backup_list -p"
    exit 1
}
last_backup_ms=0


BACKUP_ARGS_DATA=/Users/Jay/data/backup_list
mkdir -p $BACKUP_ARGS_DATA/

cmd=$1
[ 0 != $# ] && shift

#echo cmd=$cmd

# (Windows) case treats -l the same as -L.  That's right, case ignores case!  Jesus.
case $cmd in
    -ll)  $s/ff.ksh $BACKUP_ARGS_DATA f l
	exit; 
	;;
    -l)  $s/ff.ksh $BACKUP_ARGS_DATA '*.list' l
	exit; 
	;;
    -p) [ -z "$(ls $BACKUP_ARGS_DATA)" ] && {
	    echo no listnames in $BACKUP_ARGS_DATA
	    exit
	}
	for list in $BACKUP_ARGS_DATA/*.list ; do
	    echo $list
	    echo ==========================================
	    #ls -ld $list
	    #ls -l `cat $list`
	    find `cat $list` -type f
	done
	exit
	;;
esac

listname=$1
[ -z "$listname" ] && {
    echo missing listname arg.
    exit
}
listfile=$BACKUP_ARGS_DATA/$listname.list
#[ "-c" = "$cmd" -a -e $listfile ] && {
    #echo backup list $listname already exists.
    #exit
#}
#[ "-c" != "$cmd" -a ! -e $listfile ] && {
    #echo backup list $listname does not exist.
    #exit
#}

tsfile=$BACKUP_ARGS_DATA/$listname.date
[ 0 != $# ] && shift

# remaining args are files and dirs, default is PWD
[ 0 = $# ] && set $PWD

OLDPWD=$PWD

case $cmd in
#    -c)	
#	;;
    # -a adds to list file
    -a)	for d in $*; do
	    grep "^$d"'$' $listfile
	    if [ $? != 0 ]; then
		echo adding $d to $listfile
		if [ -d $d ]; then
		    cd $d
		    echo $PWD >> $listfile
		    cd $OLDPWD
		else
		    echo $d >> $listfile
		fi
	    else
		echo $d already in $listfile
	    fi
	done
	;;
    # -r removes from list file
    -r)	for d in $*; do
	    cd $d
	    awk < $listfile > $listfile.new '{if($0!=d){print}}' d=$PWD
	    mv $listfile.new $listfile
	    cd $OLDPWD
	done
	;;
    # -e edits list file
    -e) $s/macvim.open.file.osa $listfile; # gvim $listfile
	;;
    # -d removes entire list file
    -d) echo Removing list:
	cat $listfile
	rm $listfile
	;;
    # -b makes backup of all entries in list file
    -b)	zipname=$BACKUP_ARGS_DATA/$listname.inc.`date +"%y%m%d"`.zip
	jar cvMf $zipname `cat $listfile`
	date > $tsfile
	echo
	ls -sk $zipname
	;;
    # -i makes inc backup of entries in list file that changed since last -i.
    -i)	[ ! -e $tsfile ] && echo 0 > $tsfile
	date > $tsfile.new
	ts1=`cat $tsfile`
	#echo ts1=$ts1.
	ts2=`cat $tsfile.new`
	#echo ts2=$ts2.
	diffms=`java JTime -ms "$ts1" "$ts2"`
	#echo d=$diffms.
	diffdays=$(( $diffms / 86400000 ))
	#echo d=$diffdays.
	[ 0 = $diffdays ] && diffdays=1
	difffile=$BACKUP_ARGS_DATA/$listname.diff
	rm $difffile
	touch $difffile
	for d in `cat $listfile`; do
	    find $d -type f -a -mtime -$diffdays >> $difffile
	done
	#echo DIFFFILE:
	#cat $difffile
	zipname=$BACKUP_ARGS_DATA/$listname.inc.`date +"%y%m%d"`.zip
	jar cvMf $zipname `cat $difffile`
	mv $tsfile.new $tsfile
	echo
	ls -sk $zipname
	;;
esac
