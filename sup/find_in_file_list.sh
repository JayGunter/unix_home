while [ 1 = 1 ]; do
    [ "$p" = "$PWD" ] && break
    [ -f file.list ] && {
	echo Searching $PWD/file.list ...
	grep $* file.list
	exit
    }
    p=$PWD
    cd ..
done
echo No file.list found
