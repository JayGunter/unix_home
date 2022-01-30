#
s=~/_Jay/sup

jd="cat"
[ "-j" == "$1" ] && {
    jd="sed -e '\@javadoc@d' -e '\@com@d'"
    shift
}

[ 2 != $# ] && {
    echo "ERROR: usage: [-j] dir1 dir2"
    exit
}
d1=$1
d2=$2
[ ! -d "$d1" ] && {
    echo "ERROR: dir not found: $d1"
    exit
}
[ ! -d "$d2" ] && {
    echo "ERROR: dir not found: $d2"
    exit
}

t=/tmp/wfc
mkdir -p $t

#echo $d1
#echo $d2
( find $d1 -name '*.htm*' | eval $jd | xargs cat | $s/word_freq.ksh -a -h -c ; \
  find $d2 -name '*.htm*' | eval $jd | xargs cat | $s/word_freq.ksh -a -h -c ) | \
$s/word_diff_count.ksh 
