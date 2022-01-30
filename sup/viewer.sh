#!/bin/bash 
lsof -n -i:8080 | awk '/LISTEN/{print "Killing", $1, $2; system("kill " $2);}'
curl -s http://localhost:8080 > /dev/null
[ $? != 0 ] && {
    echo Starting http-server in ${1:-wo} ...
    cd /j/diag/${1:-wo}
    ( http-server -c-1 -s --cors 2>&1 \
    )&
}
    #| sed -e 's,[^/]*/,,' -e 's,".*,,' \
    #| rev | cut -c 1-10 | rev
    #| awk '{print "XXXXXXXXX";l=length($0); print substr($0,(l<10?0:l-10))}'
echo starting chrome ...
chrome.sh file:///$s/viewer.html
