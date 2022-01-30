echo "" > jar.dump
#for j in `find . -name '*.jar'`; do
    #echo dumping $j...
    #for f in `jar tvf $j 2>&1 | awk '{print $NF}'`; do
	#echo $j : $f >> jar.dump
    #done
#done

find . -name '*.jar' | \
egrep 'jar$' | \
egrep -vi '(crystalrep|WEB-INF|APP-INF|sample)' | \
while read j; do
    echo dumping $j...
    jar tvf $j | sed -n "/[^/]$/s,.* ,$j: ,p" >> jar.dump
done
