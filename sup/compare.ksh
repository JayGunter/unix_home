against=$1
shift
for f in $*; do
    cmp $f $against/${f##*/} 2>&1
done
