#!
#echo xxx $*
#exit
tmp=/tmp/last.date_msg
[ "$1" = "-r" ] && {
    rm $tmp
    shift
}

milli=`java JTime -m`
#now=$((milli / 1000))  # sh cannot handle long ints
now=`echo $milli | sed 's,\(.*\)...$,\1,'`
#echo $milli, $now

if [ -f $tmp ]; then
    was=`cat $tmp`
else
    was=$now
fi

echo $now > $tmp
secs=$((now - was))
echo `date +%H:%M:%S` $secs $*

