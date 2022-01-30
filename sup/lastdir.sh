# echo the name of the dir most recently used as a final command argument
for a in `history -20 | sort -r | awk '{print $NF}'`; do
    [ -d $a ] && { echo $a; exit; }
done
echo ""

