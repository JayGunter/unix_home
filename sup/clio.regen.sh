#
function regen() {
    rm -rf out;
    mkdir out;
    java -cp $ew/Typesetter com.trueframe.Typeset base_dir="$A/sss" $* | tee oxx.out;
    #grep FOUND oxx.out > FOUND.out;
    #grep WARN oxx.out > WARN.out;
    #grep pagesSince oxx.out > FOUND.out
}

cd /Users/jay/sss

clio=clio.jay
mark=/tmp/clio.regen.mark
[ ! -f $mark ] && touch $mark

while [ 1 ]; do
    sleep 1
    [ $clio -nt $mark ] && {
	echo regen ...
	regen;
	touch $mark
	date
    }
done
