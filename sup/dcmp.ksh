[ 2 != $# ] && { 
    echo "usage dcmp dir1 dir2"
}

find $1 -type f | xargs $s/compare.ksh $2
