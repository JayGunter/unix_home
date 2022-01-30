w=`wc -w < $1`

echo "Total words / uniq words"
a=`$s/word_freq.ksh < $1 | wc -l`
echo $w $a | awk '{ print $1, "/", $2, "=", $1 / $2 }'

echo "Total words / uniq words (grouping forms of words)"
a=`$s/word_freq2.ksh $1 | wc -l`
echo $w $a | awk '{ print $1, "/", $2, "=", $1 / $2 }'

