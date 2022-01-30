echo $PWD
exit
p="$PWD"
#echo PWD=$PWD
x=`echo $PWD | sed 's, ,.,g'`
y=""
rem=""
while [ 1 = 1 ]; do
#echo x=$x
#grep "chdir.*$x"'[ "]' $s/here_list.ksh
    a=`grep "chdir.*$x"'[ "]' $s/here_list.ksh`
    #a=`grep "chdir.*$x " $s/here_list.ksh`
#echo A=$a
    #[ $? = 0 ] && { 
    [ "$a" != "" ] && { 
	rem=`echo $p | sed "s,$x,,"`
#echo rem=$rem
	break
    }
    y=${x%/*}
    [ "$x" = "$y" ] && break;
    x=$y
done
#echo a=$a
if [ "" != "$a" ]; then
    v=${a%%=*}
    v=${v#* }
#echo v=$v
    echo $v$rem
else
#echo PPPP
    echo $PWD
fi

