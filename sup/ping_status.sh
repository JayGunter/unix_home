#!
ping -t cruzio.com | \
awk '($1 != x) { print | "date_msg.sh " NR " " $1; x=$1 }' 
#awk '($1 != x) { print | "echo " NR " " $1; x=$1 }' 
#awk '($1 != x) { print NR, $1; x=$1 }' 


