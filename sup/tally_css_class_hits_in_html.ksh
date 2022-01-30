# Parse the CSS file named by $1
# and create a list of the HTML tags and CSS classes addressed.
grep '{' $1 | \
sed -e 's/^\.//' -e 's/^span\.//' -e 's/^p\.//' -e 's/^a\.//' -e 's/^a://' -e 's/{//' | \
sort | uniq > tmp.css.class.list

echo Tags and CSS classes handled in $1:
sed < tmp.css.class.list 's/^/    /'

echo ""

# Scan every HTML file for each tag and CSS class addressed by the CSS file.
# Report those that are unused in any HTML file.
echo "Unused tags and CSS classes (not found in any HTML files under"
echo "     $PWD)":
for p in `cat tmp.css.class.list`; do
#echo $p...
hits="`find . -name '*.htm' -o -name '*.html' | xargs egrep -i "(class=.$p|<$p)" 2>/dev/null | wc -l`"
if [ 0 = $hits ]; then
    echo Unused: $p | sed 's/^/    /'
fi
done
