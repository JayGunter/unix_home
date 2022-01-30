echo "==========================================================="
cd "C:/Documents and Settings/Administrator"
cd "Local Settings/"
cd "Temporary Internet Files/"
cd "Content.IE5/"
pwd | sh $s/thisdir.ksh
rm -rf * 2>&1 | echo
ls

echo ""
echo "==========================================================="

cd "C:/Documents and Settings/Administrator"
cd "Cookies/"
pwd | sh $s/thisdir.ksh
rm -rf * 2>&1 | echo
ls

echo "==========================================================="
cd "C:/Program Files/Netscape/Users/jgunter/Cache"
pwd | sh $s/thisdir.ksh
rm -rf * 2>&1 | echo
ls

echo "==========================================================="
cd "C:/tmp/TMP"
pwd 
rm -rf * 2>&1 | echo
ls

echo ""
echo "==========================================================="

cd $j/jay/iii
sh ./prot.sh
