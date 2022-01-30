#!/bin/tcsh
# by Anton Kast

set uuid=`/usr/bin/uuidgen`
set temp=/tmp/${uuid}

echo "On client, not on server:"
/usr/bin/find . -type f > $temp
p4 -x $temp fstat |& grep "no such"
rm $temp

echo "On server, not on client:"
p4 diff -sa ./... |& grep -v 'not opened' > $temp
p4 diff -sd ./... >> $temp
foreach i (`cat $temp`)
    if ( ! -e $i ) echo $i
end
rm $temp

echo "Files on both server and client that differ:"
p4 diff -sa ./... |& grep -v 'not opened' > $temp
p4 diff -se ./... >> $temp
foreach i (`cat $temp`)
    if ( -e $i ) echo $i
end
rm $temp


