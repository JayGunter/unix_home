#
# nohang
#
# Executes a command with a time limit.
# If time limit is exceeded, command is killed.
#
# Usage:  nohang <seconds> <kill signal> <command and args>
#

function child_exit 
{
    echo "TIMED OUT while running command: $cmd"
    exit
}

trap child_exit INT

parent=$$
echo parent=$parent

#( sleep $1; kill -s SIGINT $parent; ) &
( echo PPID=$PPID; sleep $1 && echo KILLING $parent && kill $parent && echo KILLING $parent && kill $parent; ) &

child=$!
echo child =$child

shift

cmd="$*"

$*
echo xxx=$!

#kill -s SIGINT $child
sleep 1
kill $child
echo KILLED CHILD
kill $child
echo KILLED CHILD
