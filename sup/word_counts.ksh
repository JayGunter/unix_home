cd /docroots/stage

#echo 'workshop/docs81 (all HTML)'

#find workshop/docs81 -name '*.htm*' | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}'

#echo 'workshop/docs81 (doc/en content only)'

#find workshop/docs81/doc/en -name '*.htm*' | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}'

cd /docroots/stage/workshop/docs81/doc/en

for d in * ; do

    [ ! -d $d ] && continue


echo "`find $d  -name '*.htm*' | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}' | ksh ~/comma_integer.ksh`" workshop/docs81/doc/en/$d


echo "`find $d -name '*.htm*' | egrep -v com/bea | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}' | ksh ~/comma_integer.ksh`" workshop/docs81/doc/en/$d without javadoc

done

exit

echo 'workshop/docs81 (doc/en/integration content only)'

find workshop/docs81/doc/en/integration -name '*.htm*' | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}'

echo 'workshop/docs81 (doc/en/integration content only, without javadoc)'

find workshop/docs81/doc/en/integration  -name '*.htm*' | egrep -v com/bea | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}'

echo 'workshop/docs81 (doc/en/portal content only)'

find workshop/docs81/doc/en/portal  -name '*.htm*' | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}'

echo 'workshop/docs81 (doc/en/portal content only, without javadoc)'

find workshop/docs81/doc/en/portal  -name '*.htm*' | egrep -v com/bea | xargs wc -w 2>&1 | grep total | awk '{s += $1}END{print s}'
