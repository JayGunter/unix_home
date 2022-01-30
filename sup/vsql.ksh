t1=C:/tmp/vsql.1
t2=C:/tmp/vsql.2

touch $t1
cp    $t1 $t2

gvim $t1 & 

while [ 1 ]; do
    sleep 1
    cmp $t1 $t2 2>&1 > /dev/null
    [ 0 != $? ] && {
	echo ==================================================================
	cat $t1 | sqlplus clfy_reader/readonly@CLFYPROD_clarify.bea.com | \
	sed -e '/Disconnected from/D' -e '/With the Partitioning/D' -e '/JServer Release/D' -e '/Oracle Corp/D' -e '/Connected to:/D' -e '/SQL.Plus/D' -e '/Oracle9i Enterprise/D' -e '/^$/D'
	cp $t1 $t2
    }
done
