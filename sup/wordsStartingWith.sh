#!/bin/bash 
# I had this idea for a hover style on HTML links that would make them "sparkle" 
# with different words beginning with the letters in the link.
# For example, if the link text was Save, hovering would cause random words beginning with s, a, v and e to 
# appear in diagonals leading away from each respective letter, e.g.:  slimy, antithetical, valueless, excrement.
# It quickly became apparent that the more letters in the link text, the higher the probability
# for at least one undesirable word.  
# The thought of combing the word lists made this probably silly idea seem too time-consuming.
w=/j/words
d=$w/by.char
c=$w/by.char.counts
mkdir -p $d $c
for ch in $(echo $1 | sed 's,\(.\),\1 ,g'); do
    case $ch in
	[a-z]) 
	    x=$w/wordlist.no.names.txt
	    l=$d/wordlist.no.names.$ch
	    if [ ! -f $l -o ! -f $c/$ch ]; then
		grep ^$ch $x > $l
		wc -l $l | awk '{print $1}' > $c/$ch
	    fi
	    n=$(cat $c/$ch)
	    i=$(( $RANDOM % $n))
	    head -$i $l | tail -1
    esac
done
