echo '<html margin=0><BODY TOPMARGIN=0 LEFTMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0><table cellspacing=0px cellpadding=0px border=0><br/><br/><br/>'
w=0
dow=([0]=Mon [1]=Tue [2]=Wed [3]=Thu [4]=Fri [5]=Sat [6]=Sun)

while [ $w -lt 5 ]; do
	echo '<tr><td></td>'
	h=0
	am=am
	while [ $h -lt 24 ]; do
	    hh=$h
	    if [ $hh = 0 -o $hh = 24 ]; then
		hh=12; #hh=mid
	    elif [ $hh = 12 ]; then
		hh=$h; #hh=noon
		am=pm
	    elif [ $hh -gt 12 ]; then
		(( hh-=12 ))
		am=pm
	    fi
	    #echo '<td center colspan=2>'$hh'</td>'
	    echo '<td align=left colspan=1>'$hh'</td>'
	    (( h++ ))
	done
	echo '</tr>'
    d=0
    while [ $d -lt 7 ]; do
	echo '<tr>'
	echo '<td>'${dow[d]}'</td>'
	h=0
	while [ $h -lt 24 ]; do
	    echo '<td>'
	    echo '<table cellspacing=0px border=1px><tr>'
	    echo '<td height=20px width=50px></td>'
	    echo '<td height=20px width=50px></td>'
	    echo '</tr></table>'
	    echo '</td>'
	    (( h++ ))
	done
	echo '</tr>'
	(( d++ ))
    done
    (( w++ ))
done
echo '</table></body></html>'

