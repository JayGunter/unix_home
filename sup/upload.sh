#!/bin/bash

#curl -u w13a024:mypeZY97 -T out ftp://w13a024@ftp.trueframe.com/pub_html/clio/out

#passwd=mypeZY97 

ftp_site=ftp.trueframe.com
username=w13a024
passwd=uepr12495 
local=$1
remote=$2
cd $local
pwd
ftp -in <<EOF
open $ftp_site
user $username $passwd
mkdir $remote
cd $remote
mput *
close
bye
