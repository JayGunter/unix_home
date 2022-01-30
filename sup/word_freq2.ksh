# word_freq.ksh
#
# usage:  word_freq.ksh [-a] [-=] [-c] [file...]
#
# -a	Causes alphabetical output (useful for comparing such reports).
#	Default: sorts words changed least ahead of words changed most.
#
# -h	Strips HTML tag names, attribute names and attribute values
#	(but does not strip attribute values that are paths,
#	like URLs and image paths).
#	Default: includes HTML tag names and attribute names and 
#	attribute values as words to tally. 
#
# -c	Enables case sensitivity (useful for detecting all changes).
#	Default:  case insensitive word comparisons.
#
s=~/_Jay/sup

xx=cat
[ "-a" == "$1" ] && {
    xx="sort +1 -2"
    shift
}

bracket_sed="s,@@@,@@@,"
eq_sed=""
#eq_grep="n_o_m_a_t_c_h"
eq_strip="/n_o_m_a_t_c_h/d"
attr_sed="s,@@@,@@@,"
[ "-h" == "$1" ] && {
    # sed -e 's, [a-zA-Z][a-zA-Z]*=["a-zA-Z0-9_]["a-zA-Z0-9_]*, ,g'
    #attr_sed="sed -e 's, [a-zA-Z][a-zA-Z]*=["'"'"a-zA-Z0-9_]["'"'"a-zA-Z0-9_]*, ,g'"
    attr_sed='s, [a-zA-Z][a-zA-Z]*=["a-zA-Z0-9_]["a-zA-Z0-9_]*, ,g'
    bracket_sed="s,<, <,g"
    eq_sed="<="
    eq_strip="/[=<]/d"
    #eq_grep="(=|<)"
    shift
}
#    echo HHHH=$attr_sed
#echo EQ_STRIP="$eq_strip"

case_cmd="tr '[:upper:]' '[:lower:]'"
[ "-c" == "$1" ] && {
    case_cmd="cat"
    shift
}

# pipe named files (or stdin) to
# a sed command that optionally (-h) strips HTML attributes (except paths)
# a case_cmd that optionally folds uppercase to lowercase, and pipe that to
# a sed command that
#    strips "12345" (because we have HTML tags with name="12345")
#    strips all punctuation (optionally preserving = and < 
#                            so we can then strip HTML attrs and tags)
#    optionally prepends a space to < chars (to turn HTML tags into words
#                                            that we can then strip using grep)
# and pipe that to a tr that puts each word on a separate line
# and use egrep to strip HTML attrs and tags (optionally preserving them)
# and perform an optional sort to achieve alphabetical output


cat $* | \
sed "$attr_sed" | \
$case_cmd | \
sed -e 's,[#"][0-9][0-9]*", ,g' -e 's,</,<,g' -e "s,[^_0-9a-zA-Z$eq_sed], ,g" -e "$bracket_sed" | \
tr ' \015' '\012' | \
sed "$eq_strip" | \
$s/juniq2.ksh | \
$xx

# egrep -v "$eq_grep" | \
