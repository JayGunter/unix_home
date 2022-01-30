# Count words in HTML files.
# Usage:
#    telnet bernal
#        ~jgunter/word_count.ksh [-h] [dir...]
#

bracket_sed="s,@@@,@@@,"
eq_sed=""
eq_grep="n_o_m_a_t_c_h"
attr_sed="s,@@@,@@@,"
[ "-h" == "$1" ] && {
    # sed -e 's, [a-zA-Z][a-zA-Z]*=["a-zA-Z0-9_]["a-zA-Z0-9_]*, ,g'
    #attr_sed="sed -e 's, [a-zA-Z][a-zA-Z]*=["'"'"a-zA-Z0-9_]["'"'"a-zA-Z0-9_]*, ,g'"
    attr_sed='s, [a-zA-Z][a-zA-Z]*=["a-zA-Z0-9_]["a-zA-Z0-9_]*, ,g'
    bracket_sed="s,<, <,g"
    eq_sed="<="
    eq_grep="(=|<)"
    shift
}

if [ 0 = $# ]; then
    cd /docroots/stage
    #dirs="workshop/docs81 wli/docs81 wli/docs70 wls/docs81 wls/docs70"
    dirs="wli/docs70 
    wli/docs81
    wlp/docs70
    wlp/docs81
    wls/docs70
    wls/docs81
    platform/docs70
    platform/docs81
    liquiddata/docs11
    liquiddata/docs81
    wljrockit/docs70
    wljrockit/docs81
    workshop/docs81/doc/en/integration
    workshop/docs81/doc/en/portal
    workshop/docs81/doc/en/workshop
    workshop/docs81/doc/en/liquiddata
    workshop/docs81/doc/en/partners
    workshop/docs81/doc/en/samplesrc
    workshop/docs81/doc/en/tour
    workshop/docs81/doc/en/tuxedo
    workshop/docs81/doc/en/wls
    "
dirs="wlp/docs81" 
else
    dirs="$*"
fi
for d in $dirs; do
    find $d -name '*.htm*' | \
    xargs cat | \
    sed "$attr_sed" | \
    sed -e 's,[#"][0-9][0-9]*", ,g' -e 's,</,<,g' -e "s,[^_0-9a-zA-Z$eq_sed], ,g" -e "$bracket_sed" | \
    tr ' \015' '\012' | \
    egrep -v "$eq_grep" | \
    wc -w 2>&1 | \
    awk '
	function comma(s){
	    o="";
	    l=length(s);
	    y=l+1;
	    for(i=l-2; i>1; i-=3) {
		b=substr(s,i,3);
		o=","b""o;
		y=i;
	    }
	    return substr(s,1,y-1)""o
	}

	{ prod=0 }
	/total/         {                 next }
	/\/sp2\//   {                 next }
	/\/sp[0-9]\//   {                 next }
	/integration\/com\/bea\//   {   xjf+=1; xj+=$1; next }
	/\/portal\/com\/bea\//	    {   pjf+=1; pj+=$1; next }
	/\/com\/bea/		    {   jf+=1; j+=$1; next }
	/\/javadoc\/.*\//	    {   ojf+=1; oj+=$1; next }
	/\/integration\//	    {   xf+=1; x+=$1; next }
	/\/portal\//		    {   pf+=1; p+=$1; next }
	{ hf+=1; h+=$1; }
	END {
	    print DIR; 
	    print "";
	    tf=hf+jf+xf+xjf+pf+pjf+ojf;
	    t=h+j+x+xj+p+pj+oj;
	    if (jf >0) print "   javadoc:              files=", comma(jf),  "words=", comma(j);
	    if (ojf >0) print "   3rd party javadoc:    files=", comma(ojf),  "words=", comma(oj);
	    if (xjf>0) print "   integration/ javadoc: files=", comma(xjf), "words=", comma(xj);
	    if (xf >0) print "   integration/ HTML:    files=", comma(xf),  "words=", comma(x);
	    if (pjf>0) print "   portal/ javadoc:      files=", comma(pjf), "words=", comma(pj);
	    if (pf >0) print "   portal/ HTML:         files=", comma(pf),  "words=", comma(p);
	    if (hf >0 && hf<tf)
		       print "   Other HTML:           files=", comma(hf),  "words=", comma(h);
	    print            "   Totals:               files=", comma(tf),  "words=", comma(t);
	    print "";
	}' DIR=$d | \
    sed -e 's, HTML,@HTML,' -e 's,/ javadoc,/@javadoc,' -e 's,3rd party javadoc,3rd@party@javadoc,' | \
    awk '(NF==1){print;next}
	 {printf("   %-24s %s %5s    %s %12s\n",$1,$2,$3,$4,$5)}' | \
    sed -e 's,@, ,g' 
done
