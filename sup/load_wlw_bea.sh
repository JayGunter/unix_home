# This script downloads and unzips a bea.zip file from
# the QADrops area on the 'ewok' machine.
#
# This script requires the MKS toolkit be installed on your machine.
#
# To see the QADrops directories available, run
#
#	sh load_wlw_bea.sh
#
# Among the directories listed will be some with names like
#
#	09_27_2002_fri_qa     09_30_2002_mon_qa    10_01_2002_tue_qa
#
# To download and unzip a particular build, first kill any running
# instances of WLW, and kill all the associated DOS command windows
# that are started along with WLW.
# Then, pick a day that you know has a good build and run
#
#	sh load_wlw_bea.sh 09_27
#
# You need specify only enough of the date to uniquely identify
# a particular directory.
# Enter "n<Enter>" to abort.  
# Enter "y<Enter>" to confirm your choice.  
#
# The following assumes you entered "y":
#
# The QADrops directory name is written to the file CURRENT_LOAD.txt
# for future reference, e.g. while entering a bug in Radar.
#
# The bea.zip file in your chosen QADrops directory
# will immediately be unzipped into the directory specified
# by the 't' variable (see below).
# The unzipping typically takes about 5 minutes.
# When the unzipping is done, the amount of time spent is shown.
#
# After the unzipping is done, this script automatically launches WLW.
# If you don't like that, delete the "./workshop" line at the end of the script.
#
# The variable 't' is set to the directory where bea.zip will be unzipped.
# This is typically "C:/wlw/bea".
#
# The variable 'd' is set to the QADrops directory on the "ewok" machine.
# On my machine I have this directory mapped to "W:/QADrops".
#
t=C:/wlw/bea
d=W:/QADrops

# List the available bea.zip files under QADrops.
echo bea.zip files found under $d:
echo ""
cd $d
ls -lt */bea.zip | sed -e 's,.*\( [A-Z][a-z][a-z] .*\),\1,' -e 's,\(:[0-9][0-9] \),\1    ,'

# Prompt for a choice.
while [ 1 = 1 ]; do
    echo ""
    echo "To choose a directory like 09_26_2002_thu_qa, enter 09_26."
    echo "Enter your choice (just hit Return to abort): \c"
    read a
    [ "" = "$a" ] && exit

    x=`echo $d/*$a*/bea.zip`
    echo ""
    echo Your choice matches:
    ls -1d $x | sed 's,^,   ,'
    echo ""

    set $x
    if [ 1 == $# ]; then
	break
    else
	echo Your choice did not uniquely identify a directory.
    fi
done
    
# If given an argument like "9_27" try to find a matching QADrops directory.
#x=`echo $d/*$a*/bea.zip`
#echo x=$x

if [ -f "$x" ]; then
    echo Found bea.zip.
else
    echo "Dir $@ not found in $d"
    ls $d
    exit
fi

# If a matching directory was found, prompt the user to confirm the choice.

echo ""
echo "Extract $x into $t ? [y/n] \c"
read a
[ y != "$a" ] && exit

# Record this chosen directory name.
# When entering a bug in Radar, you are asked for the build date,
# and can consult the file $t/CURRENT_LOAD.txt.

echo $x > CURRENT_LOAD.txt
cd $t
echo In `pwd`
echo jar xvf $x ...
time jar xvf $x 
echo Starting workshop...
cd weblogic710/workshop
./workshop
