#
#echo 1=$1
#echo 2=$2
#exit

echo "" >> $s/here_list.ksh

$s/mkhere.ksh $1
$s/mkhere.ksh $2

echo "alias v$1='v $j/Acadia/bug_notes/$2'" >> $s/here_list.ksh
echo "alias v$2='v $j/Acadia/bug_notes/$2'" >> $s/here_list.ksh

echo "alias e$1='ns http://bugs.beasys.com/CREdit?CR=$2'" >> $s/here_list.ksh
echo "alias e$2='ns http://bugs.beasys.com/CREdit?CR=$2'" >> $s/here_list.ksh

echo "alias $1#='echo $2'" >> $s/here_list.ksh
echo "alias $2#='echo $1'" >> $s/here_list.ksh
