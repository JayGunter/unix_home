#
[ 1 != $# ] && {
    echo usage: here abbrev_for_current_dir
    exit
}
cat << END1 >> ~/sup/here_list.ksh
    alias $1='g "$PWD" '
    export $1="$PWD"
END1
