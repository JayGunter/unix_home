p=+parade.html
rm $p
cat <<END1 > $p
<html><head><script language="Javascript">
function makeImage(f) {
this.nname=f;
}
var max=0;
var i=0;
function makeArray() {
END1
#for f in *; do
for f in `ls *.jpg *.gif | sort -r`; do
echo "this[i++]=new makeImage('"$f"');" >> $p
done
n=`ls | wc -l`
echo "this.length="n >> $p
cat <<END2 >> $p
max=i;
return this;
}
    //alert('werwer');
var n=0;
var aaa=makeArray();
var win=window.open("$f");
function bump() {
    //alert('max='+max+', n='+n);
    //alert('aaa[0].nname='+aaa[0].nname);
win.close();
win=window.open(aaa[n].nname);
if(++n >= max) n=0;
setTimeout('bump()',4000);
}
//setTimeout('bump()',15000);
</script></head><body onload='bump();'>xxaa
<img name='iii' src=$f>
</body></html>
END2

