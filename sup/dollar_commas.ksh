( echo 54321; echo 303670; echo 1234567; echo 1234; echo 123; echo 12; echo 123456789; echo 1234567890;) | \
awk '
function comma(s){
    o=""
    s=$1;
    l=length(s);
    y=l+1
    for(x=l-2; x>1; x-=3) {
	b=substr(s,x,3);
	o=","b""o
	y=x
    }
    return substr(s,1,y-1)""o
}
{ print "x", comma($1) }
'
