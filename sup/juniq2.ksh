# like juniq (counts uniq words),
# but lumps forms of words together.
# e.g.
#   word
#   words
#   worded
#   wording
# gives output
#   word: 4
tr -d '\015' | \
awk '
    { a[$0]++ }
    END { 
	n=0
	sa[n++] = "es"
	sa[n++] = "s"
	sa[n++] = "ed"
	sa[n++] = "ing"
	sa[n++] = "ly"
	for (x in a) { 
	    for (s in sa) {
		#print x, a[x], x""sa[s], a[x""sa[s]]
		a[x] += a[x""sa[s]]; a[x""sa[s]] = 0;
	    }
	}
	for (x in a) { 
	    if ( 0 < a[x] ) printf("%4d: %s\n", a[x], x)
	}
    }
    ' | \
sort
