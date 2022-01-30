export LC_ALL=C

A=$HOME; export A
alias A='g $A'
s=$A/sup; export s

#echo PATH=$PATH
alias a=alias
#function a() { alias $*; }

set -o vi
#bind '"jk":"\e"'  # replaced by "jk" entry in .inputrc

#set -o tabcomplete
#set -o noerrorbells

setPrompt() {
    d=$(date +"%H:%M:%S")
    g=""
    heredir "$PWD"
    # https://misc.flogisoft.com/bash/tip_colors_and_formatting
    #PS1="\[\033[41;1;33m\]$d \[\033[1;37m\]$heredir \[\033[1;37m\]$g\[\033[1;36m\]\[\033[0m\] "
    # 1 = bold/bright
    # 2 = dim
    # 3 = italics
    # 4 = underscore
    # 5 = 
    # 6 = 
    # 7 = reverse fg & bg colors
    # 30..37, 90..97 = fg color     30 black, 31 red, 32 green, 33 yellow, 34 blue, 35 purple, 36 cyan, 37 white
    # 38;5;n = use fg 256-color n (0..255)
    # 40..47, 100..107 = bg color
    # 48;5;n = use bg 256-color n (0..255)

    abb=${heredir%%/*}
    sub=${heredir#*/}
    if [ "$abb" = "$sub" ]; then
      sub=
    else
      sub=/$sub
    fi

    #PS1="\e[1;32;40m\] \\! \e[1;48;5;37;38;5;226m\] $d \e[97m\]$heredir `gprompt` \e[0m\] "
    PS1="\[\e[1;32;100m\] \\! \[\e[33m\]$d \[\e[97m\]$abb\[\e[36m\]$sub `gprompt` \[\e[0m\] "
    #PS1="\[\e[1;32;40m\] \\!  $d $heredir `gprompt` \[\e[0m\] "
    #PS1=" \\!  $d $heredir `gprompt` "
    #PS1="############################################################# "
}
PROMPT_COMMAND=setPrompt

export IGNOREEOF=5  # must hit ^D 5 times before terminal closes
exit() {
    read -t5 -n1 -p "Do you really wish to exit? [yN] " should_exit || should_exit=y
    case $should_exit in
        [Yy] ) builtin exit $1 ;;
        * ) printf "\n" ;;
    esac
}

heredir() {
	CWD=$PWD
	heredir=`awk < ~/sup/here_list.ksh '
		BEGIN {
			sz=10000;
		}
		/export/{
			gsub(".*export ","");
			gsub("=\""," ");
			gsub("//","/");
			gsub("\"","");
			a=$1
			p=$2
			$0=PWD
			gsub(p,a);
			if (length($0) < sz) {
				best=$0
				sz=length($0)
			}
		}
		END {
			print best;
		}
	' PWD="$PWD"`
return


#echo args=$*
    old_PS1="$PS1"
    old_heredir="$heredir"
    [ -z "$heredir" ] && old_heredir="$PWD"
    n=$#
    rem=
    case $n in
	0)  newdir=/; ;;
	*)  case $1 in
		[a-zA-Z]:/*)	newdir="$1"; shift; ;;
		/*)		newdir="$1"; shift; ;;
		*)		newdir="$PWD" ;;
	    esac
	    for x in $*; do
		while [ 1 ]; do
echo x=$x
		    case $x in
			chdir)	break; ;;
			..*)    x=${x##..}; x=${x##/}
				if [ -z "$rem" ]; then
				    newdir="${newdir%/*}"
				else
				    rem=${rem%/*}
				fi
				;;
			./*)    x=${x##./}; ;;
			*)	break; ;;
		    esac
		done
		[ chdir = "$x" ] && {
		    rem=$2
		    break
		}
		[ -n "$x" ] && {
		    if [ -z "$rem" ]; then
			rem=$x
		    else
			rem=$rem/$x
		    fi
		}
	    done
	    ;;
    esac
echo rem=$rem
echo newdir=$newdir
    newdir="$newdir/$rem"
    case "$newdir" in
	[a-zA-Z]:/*) ;;
	/*) newdir="${PWD%%/*}/$newdir" ;;
	*)  newdir="$PWD/$newdir" ;;
    esac
echo newdir=$newdir

    # When using the VPN, 
    # piped commands run slowly when PWD is on a remote machine.
    # Cd'ing to my hard drive makes the pipe env|grep run fast.
    old_PWD=$PWD
    cd /

    size=999
    var=
    rem="$newdir"
    drive="${newdir%%:/*}:/"
    echo $newdir > /tmp/heredir.out
#date
#i=0
    env | grep $drive 2>&1 | while read nv; do
#[ $i = 0 ] && { date; i=1; }
#echo nv=$nv
	val=${nv#*=}
	r="${newdir#*$val}"
	[ "$newdir" = "$r" ] && continue
	[ $size -gt ${#r} ] && {
	    var=${nv%%=*}
	    rem="$r"
#echo $var$rem 
	    echo $var$rem > /tmp/heredir.out
	    size=${#rem}
	    [ 0 = $size ] && break
	}
    done
#date

    # 070524: make it easier to cd to dir containing filename of recent command 
	heredir="`cat /tmp/heredir.out`"
#echo heredir=$heredir
    if [ ! -d "$newdir" -a "$heredir" != "${heredir#*.}" ]; then
#echo lkjsdf
	newdir=${newdir%/*}  # if 'g /a/b/x.java/', change to 'g /a/b/x.java'
	heredir=${heredir%/*}
	if [ ! -d "$newdir" ]; then
	    newdir=${newdir%/*}  # if 'g /a/b/x.java',  change to 'g /a/b'
	    heredir=${heredir%/*}
	fi
    fi

#echo newdir=$newdir
    if [ -d "$newdir" ]; then
	#heredir="`cat /tmp/heredir.out`"
	cd "$newdir"


	#[ -f $jumpdir ] && {
	    #x="`$jumpdir -reverse`"
	    #[ "${#x}" != 0 -a "${#x}" -lt "${#heredir}" ] && heredir=$x
	#}

	LWD2="$LWD1"
	LWD1="$PWD"
    else
	echo "BAD DIRECTORY:"
	echo "$newdir"
	#echo $newdir
	heredir=$old_heredir
	cd "$old_PWD"
    fi
    #PS1="$HISTCMD $heredir > "
    #PS1='\e[7m\! $heredir \e[m '
} # end heredir

alias ehl='v $s/here_list.ksh '
shl() {
	. $s/here_list.ksh
}
shl

#a here='$s/mkhere.ksh; shl'
here() { 
  type $1 2>/dev/null
  [ $? = 0 ] && return
  ~/sup/mkhere.ksh $1;
  shl;
  eval $1;
}
bug() { ~/sup/mkbug.ksh $*; shl; eval $1; }

# Sadly, atom can take >5 secs to open a single file because it examines the dir (project) the file is in.
#git config --global core.editor "atom --wait"
#git config --global core.editor "vi"
add() {
    git add $*
}
glog() {
  git log --pretty=oneline $*
}
cwb() { # current working branch (ala cwd)
  git rev-parse --abbrev-ref HEAD
}
gup() { # status, add, commit, push
  sta
	echo -n 'Add these? [n] '
	read go
	[ yy != y$go ] && return
  git add .
  sta
	echo -n 'Commit message: '
	read go
  git commit -m "$go"
	echo -n 'Push? [n] '
	read go
	[ yy != y$go ] && return
  git push
}
acp() { # add, commit, push with no questions asked (presumably I did a sta beforehand)
  git add .
  git commit -m "$*"
  git push
}
gaa() {
  git add `pbpaste`
}
st() {
    git status -s | grep -v '^??'
}
sta() {
    git status -s
}
gcom() {
  git commit -m "$*"
}
gcodr() {
    git commit --dry-run $*
}
gcomp() {
  git commit -m "$*"
  git push
}
coma() {
    git commit -a -m " $*"
}
coa() {
    git commit -a 
}
push() {
    git push $* 
}
pull() {
    git pull $* 
}
gadg() { # gui to browse all diffs of $1 per commit that changed it
  gitk $1
}
gad() { # all diffs: show all diffs of file $1, per commit that changed it
  git log -p $1
}
gld() { # last diff: show diff of file $1 against last commit which changed that file (avoiding gd- 1; gd- 2; gd- 3; ...)
  git log -p -1 $1
}
gd-() {
    # usage:  gd- 14 15 file (-14 vs. -15)
    # usage:  gd-    15 file (now vs. -15)
    # usage:  gd-    15	 
    # usage:  gd-       file (now vs. -1)
    gui=
    to=0
    from=1
    unset fromset
    file=
    for x in $*; do
	if [ v = "$x" ]; then
	    gui=gui
	elif [ -f $x ]; then
	    file=$x
	elif [ -z $fromset ]; then
	    from=$x
	    fromset=fromset
	else
	    to=$x
	fi
    done
	
    ( 
	[ -z $gui ] && export GIT_EXTERNAL_DIFF=$s/git-diff-wrapper-diff.sh;
	git diff HEAD~$from HEAD~$to $file 
    )
}
unset GIT_EXTERNAL_DIFF
gd() {
    # usage:  gd file 1 d 4 h      (now vs. 1 day 4 hours ago)
    gui=
    f=""
    x=""
    for a in $*; do
	if [ -f "$a" ]; then
	    f=$a
	else
	    case "$a" in 
		v)	gui=gui ;;
		m)	x="$x minute" ;;
		h)	x="$x hour" ;;
		d)	x="$x day" ;;
		*)	x="$x $a" ;;
	    esac
	fi
    done

    ( 
	[ -z $gui ] && export GIT_EXTERNAL_DIFF=$s/git-diff-wrapper-diff.sh;
	git diff "HEAD@{$x ago}" $f
    )
}
gprompt() {
    # PS1="\e[1;32;40m\] \\! \e[1;48;5;37;38;5;226m\] $d \e[97m\]$heredir `gprompt` \e[0m\] "
    #/Your branch is up to date with / { utd="\\e[0m\\]\\e[1;37;40m\\] =" }
  git status 2>/dev/null | awk '
    /^On branch / { 
      if ($NF == "prod")        br="\\[\\e[1;37;41m\\] "$NF
      else if ($NF == "master") br="\\[\\e[1;37;41m\\] "$NF
      else                      br="\\[\\e[1;33;40m\\] "$NF
    }
    /Your branch is up to date with / { utd="=" }
    /modified:/ { mod++ }
    /Untracked files/ { ut=1 }
    /^\t/ { if (ut==1) utf++ }
    END { print utd""br""(mod > 0 ? " m"mod : "")""(utf > 0 ? " u"(utf) : "") }
  '
}
sg() { # snapshot git modified and untracked files
  #echo `date +%y%m%d-%H%m`.zip `git status | sed 's,modified:  *,,' | gr '^\t'`
  jar cvMf ~/backups/sg.`cwd`.`date +%y%m%d-%H%m`.zip `git status | gv 'deleted:' | gv 'bundle.*js$' | sed 's,modified:  *,,' | gr '^\t'`
}

export PREV_PWD=$PWD
g() { 
#echo 1=$1
#echo 2=$2
    d=$1
    [ -n "$2" ] && d=$d/$2
    [ ! -d $d ] && d=${d%/*}
#echo d=$d;
	PREV_PWD=$PWD
    cd $d; 
    echo "$PWD" > ~/tmp/recent.PWD
#    heredir "$PWD"; 
}
gg() { 
    g $PREV_PWD/$1;
    # heredir $PWD; 
}
go() { 
    g `cat ~/tmp/recent.PWD`
}

alias ag='a|grep '
ga() {
    a | grep $*
    functions | awk '/^'"$*"'/{p=1}(p==1){print}/}$/{p=0}'
}
ae() { alias | grep "^""$*"; }
alias eg='env|grep '
#alias cd="PS1='\$PWD > '; cd "
cl() { PS1='\$PWD > '; cd $*; ls -F; }
#a cl="_cl"
#_cl() { cd $*; l; }
#a g='cd'
alias b='g ../'
alias bb='g ../../'
alias bbb='g ../../../'
alias bbbb='g ../../../../'
alias bbbbb='g ../../../../../'
alias bl='cl ..'
alias bbl='cl ../..'
alias bbbl='cl ../../..'
alias bbbbl='cl ../../../..'
alias bbbbbl='cl ../../../../..'

# MKS 'more' annoyingly clears the screen with or without a -c.
# MKS 'pg' doesn't clear the screen, but has no 'b' command, use -<CR> instead.
alias x='more'
alias X='more'
#a xx='pg -np "--page %d (use -<CR> to scroll back)-- "'

vd()  { 
	x=$1; 
	y=$2; 
	[ -d "$y" ] && y=$y/$x; 
	vdiff32 $x $y & 
}
dx()  { diff $* | x; }
dxx() { diff $* | xx; }

c() { 
    if [ 1 = $# ] ; then
	ll $1
    else
	cp $*
    fi
}
.d() { cp -i $1 $1.`date +%h%d`; }

alias cp='cp -i'
alias mv='mv -i'

alias cr="tr ' \015' '\012'"

alias 80=" echo '         1         2         3         4         5         6         7         ' ; echo 1234567890123456789012345678901234567890123456789012345678901234567890123456789 ;"

alias e='echo'
alias md='mkdir -p'
alias l='ls -F'
alias la='ls -FA'
#triml()	{ cut -c1-10,45-999 | sed 's,^\(..........\)[^ ][^ ]*\(.*\),\1  \2,'; }
#triml()	{ cut -c1-10,34-999 ; }
#triml()	{ cut -c1-10,44-999 ; }
triml()	{ cat; }
alias jls=ls
export CLICOLOR=1
#export CLICOLOR_FORCE=1  # make colors appear when ls is piped to something
if [ "$ITERM_PROFILE" = 'light' ]; then
  export LSCOLORS=exfxcxdxbxegedabagacad  # default from ls man page
else
  export LSCOLORS=GxfxcxdxBxegedabagacad
fi
ll()	{ jls -l	    $* ; }
#ll()	{ jls -l	    $* | triml; }
lld()	{ jls -ld    $*; }
lla()	{ jls -lA    $*; }
lt()	{ jls -lt    $*; }
llt()	{ jls -lt    $*; }
llat()	{ jls -lAt   $*; }
k()	{ jls -lt    $* | grep -v '^d' ; }
ka()	{ jls -lAt   $* | grep -v '^d' ; }
kk()	{ jls -lt    $* | grep -v '^d' | head; }
kkk()	{ jls -lt    $* | grep -v '^d' | head -25; }
kx()	{ jls -lt    $* | grep -v '^d' | x; }
kka()	{ jls -lAt   $* | grep -v '^d' | head; }

#alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
alias gvim='/Applications/Vim.app/Contents/MacOS/Vim -g'

w()	{ gvim -R -o $* & }
vu()	{ gvim -c "set fileformat=unix" -o $* & }
v()	{
#    if [ -d "$*" ]; then
#	g $*
#    else
# 	#/Applications/MacVim.app/Contents/MacOS/MacVim $* 
# 	gvim $* 
#    fi
  for x in $*; do
    #x=$1
    case $x in /*) ;; *) x=$PWD/$x ;; esac
    echo x=$x
    #$s/macvim.open.file.osa $x
		[ ! -f $x ] && touch $x
    open -a MacVim $x
  done
}
alias ev='v ~/_vimrc'
vg() { 
	#set -o history -o histexpand
	#fc -e -
	#!! > /tmp/prev.command.out
	#cat /tmp/prev.command.out | sed 's,:.*,,' | uniq
	echo unimplemented 
}

fire()	{ echo $*; $*; }

alias ek='v $A/profile.ksh '
alias sk='.  $A/profile.ksh'
alias hg='history | gi'

alias em='v $A/mac.notes '

mo() {
    cal $(date +"%m %Y" | awk '{m=$1-1;y=$2;if(m<0){m=12;y++}print m,y}')
    cal
    cal $(date +"%m %Y" | awk '{m=$1+1;y=$2;if(m>12){m=1;y++}print m,y}')
}

PST() { paths_set=true; }
PSF() { paths_set=false; }
alias skp='PSF; export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin; . $A/profile.ksh'

oneshot=false;

in_there="false"
in_there() # usage:  in_there CLASSPATH new_path
{
    eval orig='$'$1
    new_path=`echo $2 | sed -e 's,[/\\],.,g' -e 's,^$,e_m_p_t_y,'`
    echo $orig | grep $new_path > /dev/null
    if [ 0 = $? ]; then
	in_there="true"
    else
	in_there="false"
    fi
}

add_to_path() { # usage:  add_to_path prepend CLASSPATH new_path
	[ "$paths_set" != "true" -o "$oneshot" = "true" ] && {
		in_there $2 $3
		if [ . = "$3" -o $in_there = "false" ]; then
		    #echo $1ing $2 $3 ...
		    if [ "$1" = "prepend" ]; then
			export PATH=$3":"$PATH
		    else  # append to path
			export PATH=$PATH":"$3
		    fi
		fi
	}
	oneshot=false;
}

prepend_classpath() { add_to_path prepend CLASSPATH $1; }
pC() { oneshot=true;  add_to_path prepend CLASSPATH $1; }
append_classpath() {  add_to_path append  CLASSPATH $1; }
aC() { oneshot=true;  add_to_path append  CLASSPATH $1; }

prepend_path() {      add_to_path prepend PATH $1; }
pP() { oneshot=true;  add_to_path prepend PATH $1; }
append_path() {       add_to_path append  PATH $1; }
aP() { oneshot=true;  add_to_path append  PATH $1; }

prepend_path() {      add_to_path prepend PATH $1; }

append_path $sup
append_path /Applications/MacVim.app/Contents/bin
prepend_path /usr/local/bin
append_path /usr/local/git/bin
append_path /usr/local/mysql/bin
append_path /Applications/Meld.app/Contents/MacOS

export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
#export JAVA_HOME="$(/usr/libexec/java_home)"
#export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/Current/"

export SPARK_HOME=/usr/local/Cellar/apache-spark/2.2.1/libexec
export PYTHONPATH="/usr/local/Cellar/apache-spark/2.2.1/libexec/python/:$PYTHONPATH"

export SCALA_HOME="~/scala-2.11.12"
append_path $SCALA_HOME/bin

#append_path ~/Downloads/eclipse
append_path .
append_path /usr/local/homebrew/bin

prepend_classpath $ewt

# for $wds/devenv
#export JAVAHOME_ctl=$JAVA_HOME
#a dev='pushd $wds; devenv JC=javac; popd'
#alias dev='pushd $wds; . devenv.sh; popd'

PST

alias jtoc="cat $b1/JAR.TOC | grep "

alias cleanup='sh $sup/cleanup.sh'
alias ffl='sh $sup/find_in_file_list.sh'
#a ffll='ll `ffl $*|grep -v "^Searching "`'
ffll() {
    ll `ffl $*|grep -v "^Searching "`
}
ffk() {
    k `ffl $*|grep -v "^Searching "`
}
ffkk() {
    kk `ffl $*|grep -v "^Searching "`
}
ffv() {
    v `ffl $*|grep -v "^Searching "`
}

alias wj='vi -R $db/tmp/*/_*.java'

#alias gr=' sh $A/sup/grepper'
#alias gi=' sh $A/sup/grepper -i'
#alias gv=' sh $A/sup/grepper -v'
#alias gvi=' sh $A/sup/grepper -vi'
#alias gl=' sh $A/sup/grepper -l'
#alias gli='sh $A/sup/grepper -li'
#alias gn=' sh $A/sup/grepper -n'
#alias gni='sh $A/sup/grepper -ni'
#
alias gr='egrep --color'
alias gi='egrep --color -i'
alias gv='egrep --color -v'
alias gvi='egrep --color -vi'
alias gl='egrep --color -l'
alias gli='egrep --color -li'
alias gn='egrep --color -n'
alias gni='egrep --color -ni'

dotc='*.java *.jsp *.jwf *.ctrl *.jbc *.jbcx'
g.c()   { sh $sup/grepper     $* $dotc; }
gi.c()  { sh $sup/grepper -i  $* $dotc; }
gl.c()  { sh $sup/grepper -l  $* $dotc; }
gli.c() { sh $sup/grepper -li $* $dotc; }
gn.c()  { sh $sup/grepper -n  $* $dotc; }
gni.c() { sh $sup/grepper -ni $* $dotc; }

g.h()   { sh $sup/grepper     $* *.htm*; }
gi.h()  { sh $sup/grepper -i  $* *.htm*; }
gl.h()  { sh $sup/grepper -l  $* *.htm*; }
gli.h() { sh $sup/grepper -li $* *.htm*; }
gn.h()  { sh $sup/grepper -n  $* *.htm*; }
gni.h() { sh $sup/grepper -ni $* *.htm*; }

g.x()   { sh $sup/grepper     $* *.xml; }
gi.x()  { sh $sup/grepper -i  $* *.xml; }
gl.x()  { sh $sup/grepper -l  $* *.xml; }
gli.x() { sh $sup/grepper -li $* *.xml; }
gn.x()  { sh $sup/grepper -n  $* *.xml; }
gni.x() { sh $sup/grepper -ni $* *.xml; }

vgr()  { v -c "/$1" `sh $A/sup/grepper -l  $*`; }
vgi()  { v -c "/$1" `sh $A/sup/grepper -li $*`; }
vgl()  { v -c "/$1" `sh $A/sup/grepper -l  $*`; }
vgli() { v -c "/$1" `sh $A/sup/grepper -li $*`; }
vgn()  { v -c "/$1" `sh $A/sup/grepper -n  $*`; }
vgni() { v -c "/$1" `sh $A/sup/grepper -ni $*`; }

vg.c()   { v -c "/$1" `sh $A/sup/grepper -l  $* $dotc`; }
vgi.c()  { v -c "/$1" `sh $A/sup/grepper -li $* $dotc`; }
vgl.c()  { v -c "/$1" `sh $A/sup/grepper -l  $* $dotc`; }
vgli.c() { v -c "/$1" `sh $A/sup/grepper -li $* $dotc`; }
vgn.c()  { v -c "/$1" `sh $A/sup/grepper -n  $* $dotc`; }
vgni.c() { v -c "/$1" `sh $A/sup/grepper -ni $* $dotc`; }

vg.x()   { v -c "/$1" `sh $A/sup/grepper -l  $* *.xml`; }
vgi.x()  { v -c "/$1" `sh $A/sup/grepper -li $* *.xml`; }
vgl.x()  { v -c "/$1" `sh $A/sup/grepper -l  $* *.xml`; }
vgli.x() { v -c "/$1" `sh $A/sup/grepper -li $* *.xml`; }
vgn.x()  { v -c "/$1" `sh $A/sup/grepper -n  $* *.xml`; }
vgni.x() { v -c "/$1" `sh $A/sup/grepper -ni $* *.xml`; }

xg() { xargs -0 egrep --color -n $*; }
xgi() { xg -i $*; }
xgl() { xg -l $*; }
xgli() { xg -li $*; }
ft() { 
  #find . \( \( -name node_modules -o -name build \) -prune \) -o -type f -a \! -name '*.[0-9]' -print0; 
  find . \( \( -name node_modules -o -name .git -o -name build \) -prune \) -o -type f -a \! -name '*.[0-9]' -a \! -name '*.bin' -a \! -name '*.log' -a \! -name '*[0-9]*.bundle.*js' -print0; 
  #find . \( \( -name node_modules -o -name build \) -prune \) -o -type f -a \! -name '*.[0-9]' -exec file {} + | grep -w text-print0; 
}
logg() { find . -name '*.log' -print0 | xg $*; }
ffg() { ft | xg $*; }
ffgi() { ft | xgi $*; }
ffgl() { ft | xgl $*; }
ffgli() { ft | xgli $*; }
fn() { 
	x='\('
	or=""
	for a in $*; do 
#echo a=$a
		x="$x $or -name '$a'"
		or="-o"
	done
	x="$x \)"
	set -o noglob
	echo find . '\( -name node_modules -prune \)' -o -type f `echo ${x//%/*}` -print > /tmp/fn.sh
	set +o noglob
	. /tmp/fn.sh
}

# list functions used from a library; e.g. lff recompose
lff() { 
  ffg $* | sed -e 's,.*{,,' -e 's,}.*,,' -e 's, ,,g'| tr , \\012 | sort | uniq
}

ffgc() { # 'ffgc pattern' shows counts per file 
  ffg $* | sed 's,:.*,,' | awk '
    {a[$1]++}
    END{
      for(i in a) {
        printf("%4d %s\n",a[i],i);
        t += a[i]
      }
      if (do_total) {
        printf("%4d Total\n",t);
      }
    }' do_total=${do_total}
}
ffgct() { # 'ffgc pattern' shows counts per file and total
  do_total=1 ffgc $*
}

#unalias lc
lc() {
	wc -l $* 2>&1 | grep -v Is.a.directory
}
alias oc='od -c'

alias wh=which

alias ff='sh $s/ff.ksh'
fff() {
    set -f
    echo $@
    sh -f $s/ff.ksh $@
}


aa() {
    echo which:	` which $* `
    echo alias: ` alias $* | grep -v alias:`
    echo funct: ` functions | awk "/^$*\(\)/{x=1}(x){print}/^}/{x=0}" `
}

hitfile_conf="$A/sup/hitfile.conf"
# hitfile "cmd" [filecodes]
hitfile() {
    x=$1
    shift
    for f in $*; do
	sed < $hitfile_conf -n "/^$f /s/^[^ ][^ ]* //p" > /tmp/hitfile
	case `wc -l < /tmp/hitfile | sed 's, ,,g'` in
	    0)  echo hitfile: no match on $f ;;
	    1)  echo $x `cat /tmp/hitfile`
		$x `cat /tmp/hitfile` ;;
	    # searching for /^$f / so should never get >1 hit 
	esac
    done
}
editfile() {
    case $# in
	0)  v $hitfile_conf ;;
	1)  hitfile v $1 ;;
	2)  echo $1 $PWD/$2 >> $hitfile_conf
	    v $hitfile_conf ;;
	*)  echo "usage: editfile [filecode [filename]]" ;;
    esac
}
alias f=editfile
alias fd="hitfile g"
alias fs="hitfile sv"
alias fss="hitfile 'sv ls'"
alias fl="hitfile ll"

slash1() {
    slash1_path=${1//\/\///}
    slash1_path=${slash1_path//\/\///}
    echo ${slash1_path//\/\///}
}


vxx() {
    sss
	v clio.jay
return
    v -c ":set lines=9999" -c ":set columns=9999" \
	-c ":set lines=9999" -c ":set columns=9999" \
	-c ":set guioptions-=T" -c ":set guioptions+=l" \
	-c ":vert topleft split" \
	-o clio.jay Chandler_meshing.jay gap_notes.jay todo_limo.jay todo_peg.jay 
    return
    v -c ":set lines=9999" -c ":set columns=9999" \
	-c ":set guioptions-=T" \
	-c ":set guioptions+=l" \
	-c ":vert topleft split" \
	-o clio.jay todo_limo.jay todo_peg.jay &
}
alias jxx="javac $ewt/Typeset.java"
up2xx() {
    # UNTESTED!!!!
    cd $sss/out
    find . -name 'page_*' | while read f; do
	if [ ! -f ../to_trueframe/$f ]; then
	    $s/upload1.sh $f /pub_html/clio/out
	else
	    cmp $f ../to_trueframe/$f > /dev/null
	    [ $? != 0 ] && {
		$s/upload1.sh $f /pub_html/clio/out
	    }
	fi
    done
}
upxx() {
    $s/upload.sh $sss/out /pub_html/clio/out
}

upres() {
    echo curl -u jaygunte@gunter.io:'Hspr!2495' -T ~/gunter.io/public_html/jay/resume/Jay_Gunter_resume.doc ftp://jaygunte@gunter.io/public_html/jay/resume/Jay_Gunter_resume.doc
    curl -u jaygunte@gunter.io:'Hspr!2495' -T ~/gunter.io/jay/resume/Jay_Gunter_resume.doc ftp://jaygunte@gunter.io/public_html/jay/resume/Jay_Gunter_resume.doc
}
upwww() {
    echo curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/public_html/
    curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/public_html/ --ftp-create-dirs
}
upba() {
    echo curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/backup/android/
    curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/backup/android/
}
upb() {
    echo curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/backup/
    curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/backup/
}
uplc() {
    echo curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/public_html/test/life_clock
    giolc
    #for f in main.js word*.js style.css images/* index.html; do
    for f in circles.html; do
    #for f in main.js ; do
	curl -u jaygunte@gunter.io:'Hspr!2495' -T $f ftp://jaygunte@gunter.io/public_html/test/life_clock/$f --ftp-create-dirs
    done
}
upbounce() {
    echo curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/public_html/bounce
    bounce
    #for f in main.js word*.js style.css images/* index.html; do
    for f in style.css main.js index.html ; do
    #for f in main.js ; do
	curl -u jaygunte@gunter.io:'Hspr!2495' -T $f ftp://jaygunte@gunter.io/public_html/bounce/$f --ftp-create-dirs
    done
}
upclio() {
    #echo FIX THIS TO WRITE TO gunter.io/aaa_config/ AND /aaa/
#return
    # usage:  cd $sss/out; upclio "page_[0-100].html"
    #curl -u w13a024:uepr12495 -T "$*" ftp://w13a024@ftp.trueframe.com/pub_html/clio/out/
    echo curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/public_html/jay/clio/out/
    curl -u jaygunte@gunter.io:'Hspr!2495' -T "$*" ftp://jaygunte@gunter.io/public_html/jay/clio/out/
}
oxx() {
    sss
    rm -rf out
    mkdir out
    #java -cp $ew/Typesetter com.trueframe.Typeset base_dir="$A/sss" $* | cat | tee oxx.out
    java -cp $sss/java com.trueframe.Typeset base_dir="$A/sss" $* | cat | tee oxx.out
    grep FOUND oxx.out > FOUND.out
    grep WARN oxx.out > WARN.out
    grep pagesSince oxx.out > FOUND.out
}
alias joxx='jxx; oxx'
alias o='time oxx'
alias regen='$s/clio.regen.sh'
alias ixx="sss; ie out/page_0_1.html"
alias fxx="sss; fx out/page_0_1.html"
alias nxx="sss; nn out/page_0_1.html"
alias xx0="sss; v  out/page_0_1.html"
alias nfix="sss; grep -c FIX clio.jay; $s/clio_tally_needed_fixes.sh"
pgaps() {
    lines=${1:-1000}
    awk < $sss/clio.jay '/^=/{if(NR-n>LINES){print n,NR};n=NR}' FS=: LINES=$lines
}
cgaps() {
    lines=${1:-1000}
    awk < $sss/clio.jay '/^\[c/{if(NR-n>LINES){print n,NR};n=NR}' FS=: LINES=$lines
}
dgaps() {
    lines=${1:-1000}
    awk < $sss/clio.jay '/^\[d/{if(NR-n>LINES){print n,NR};n=NR}' FS=: LINES=$lines
}
shorttails() {
    sss
    awk < clio.jay '/jjj/{exit}/^[a-zA-Z"({]/{if(length() < 15)print NR,$0}' 
}
mxx() {
    sss; gn ^# clio.jay; gr ^# clio.jay | sort
}
dxx() {
    sss
    v  out/page_$*"_"*
}
bxx() {
    fs x
    fs t
    fs tj
    #bxx0=d:/jay/story/save
    #[ -d f:/jay/story/save ] && bxx0=f:/jay/story/save
    #[ -d d:/story/save ] && bxx0=d:/story/save
    #[ -d f:/story/save ] && bxx0=f:/story/save
    #sss 
    #cpk
    #echo cp save/`ls -t save|grep clio|head -1` $bxx0
    #cp save/`ls -t save|grep clio|head -1` $bxx0
    #s
    #cpk
    #echo cp save/`ls -t save|grep Typeset|head -1` $bxx0
    #cp save/`ls -t save|grep Typeset|head -1` $bxx0
    #kk $bxx0
    sss
    jar cvMf save/anovel.`date +"%y%m%d"`.zip clio.jay timeline.jay config/ typesetting_templates/ index.html -C $s Typeset.java

}
gxx() {
    # Grep the source for specified string.
    sss
    egrep -n $* clio.jay
}
gout() {
    # Grep the generated pages for specified string.
    sss out
    grep $* page_*_*.html
}
sxx() {
    # print counts of certain phrases
    for p in	"seemed to" \
		"seem to" \
		"seemingly" \
		"obviously" \
		"apparently" \
		"clearly" \
		"her eyes" \
		"looked like" \
		"looked as" \
		"looked at" \
		"turned to" \
		"fuck" \
		"jesus" \
		"invisible" \
		"twenty" \
		"growl" \
		"almost" \
		"stress" \
		"occassionally" \
		"in the trunk" \
		"on the floor" \
		"divorce paper" \
	    ; do
	gr "$p" clio.jay | lc | awk '{printf("%4d  %s\n", $0, p)}' p="$p"
    done
}
cxx() {
    #head -1  clio.jay| tr 'A-Z' a-z | head 
    cat clio.jay | \
    tr A-Z a-z | \
    sed -e "s,[^A-Za-z'], ,g" |  \
    awk '{for (i=1;i<=NF;i++) {a[$i]++}} END {for (x in a) printf("%05d %s\n", a[x], x);print t}' | \
    #cat
    sort | tee /tmp/cxx.out
    #head -20
    #awk '{t+=split($0,w);for (x in w) {a[w[x]]++}} END {for (x in a) printf("%05d %s\n", a[x], x);print t}' | \
    #awk '{t+=split($0,w);for (x in w) {print "w[",x,"]=",w[x];a[w[x]]++}} END {for (x in a) printf("%05d %s\n", a[x], x);print t}' | \
    #sort | tee /tmp/cxx.out
}

# backup files accessed via editfile
kbuf() {
    owd=$PWD
    cd /
    x=tmp/kbuf.`date +"%y%m%d"`.zip
    jar cvMf $x profile.ksh sup/*.java sup/*sh  sup/vi_frags
    cd $owd
}
bue() { # bu env
    owd="$PWD"
    cd ~
    jar cMf /tmp/bu.env.zip .bashrc .bash_profile .inputrc .vrapperrc _vimrc profile.ksh sup/*.java sup/*sh sup/vi_frags
    cd $owd
}
buf() {
    owd="$PWD"
    cd /
    jar cvMf /tmp/hitfile.zip `sed < $s/hitfile.conf -e 's,[^ ]* /,,'` 
    cd $A
    jar cvMf /tmp/sss.zip sss/*.jay
    jar cvMf /tmp/sup.zip sup/*.* sup/vi_frags
    jar cvMf /tmp/typesetter.zip eclipse_workspace/Typesetter/com/trueframe/*.java
    jar cvMf /tmp/gunter.io.react.zip $rg/src
    jar cvMf /tmp/home.zip \
	profile.ksh \
	.vim \
	game/ 
    cd /tmp
    x=/tmp/buf.`date +"%y%m%d"`.zip
#    jar cvMf $x `sed < $s/hitfile.conf -e 's,[^ ]* ,,'` \
    jar cvMf $x hitfile.zip sss.zip sup.zip typesetter.zip home.zip gunter.io.react.zip
	#-C $A sss/.git \
	#-C $A _trueframe \
    #echo encrypting $x...
    #crypt -e 6127712495 < $x > $x.oldest_phone.buf
    #curl -u w13a024:mypeZY97 -T $x ftp://w13a024@ftp.trueframe.com/private/backup/
#    curl -u w13a024:uepr12495 -T $x ftp://w13a024@ftp.trueframe.com/private/backup/
    upb $x
    cd "$owd"
}
butf() {
    owd="$PWD"
    cd /
    x=tmp/trueframe.`date +"%y%m%d"`.zip
    jar cvMf $x \
	_trueframe
    #echo encrypting $x...
    #crypt -e 6127712495 < $x > $x.oldest_phone.buf
    cd "$owd"
}
cbuf() {
    buf
    echo copying $x to e:/backups
    cp -i /$x e:/backups
    ls -l e:/backups/${x#*/}
}
unbuf() {
    x="$1"
    u=${x%.*}.unbuf
    if [ buf = "${x##*.}" ]; then
	echo decrypting $x...
	crypt -d 6127712495 < $x > $u
	echo table of contents...
	jar tvf $u
    else
	echo unbuf: filename must end in .buf
    fi
}

bu() {
    $s/backup_list.sh $*
}
bub() {
    # do a full backup of items in the specified list
    $s/backup_list.sh -b $*
}
bui() {
    # do an incremental backup of items in the specified list
    $s/backup_list.sh -i $*
}
bul() {
    # list names of backup lists
    $s/backup_list.sh -l
}
bull() {
    # list all files in backup area
    $s/backup_list.sh -ll
}
# warning, bup is already in use!

#alias ec='eclipse.exe &'
alias neon='$A/eclipse/java-neon/Eclipse.app/Contents/MacOS/eclipse &'

alias jcp='java jay.JCopy'

alias jc=javac
ck() {
    ck="`ls -t *.java | head -1`"
    if [ -f "$ck" ]; then
	echo ===================================== = javac "$ck"
	javac "$ck" $* 2>&1
    else
	echo no .java file found
    fi
}
alias jck=ck
rk() {
    rk="`ls -t *.class | head -1`"
    if [ -f "$rk" ]; then
	rk=${rk%.*}
	echo java "$rk"
	java "$rk" $*
    else
	echo no .class file found
    fi
}
crk() {
    crk="`ls -t *.java | head -1`"
    if [ -f "$crk" ]; then
	echo javac "$ck"
	javac "$ck" $*
	[ 0 = $? ] && rk
    else
	echo no .java file found
    fi
}
alias jrk=crk

# $(_B) is the last word of the previous command
_B() {
    local x=($(fc -l -1))
    echo ${x[${#x[@]}-1]}
}

lb() {
    ll $(_B)
}

_D() {	# last dir
    fc -lr | while read x; do
	_D=${x##* }
	[ -d "$_D" ] && { echo "$_D"; break; }
    done
}
lD() { l $(_D); }
gb() { _D=$(_D); [ -d "$_D" ] && g $_D; }

# last file named in a command becomes the value of $isk
isk() {
    #pat='(jpg|txt|java|jsp|jay|sh|ksh|env|html|htm|js)'
    pat='.'
    if [ 0 = $# ]; then
	isk="`ls -t | egrep "$pat"'$' | head -1`"
    else
	isk="`ls -t $* | head -1`"
	[ -d $1 ] && isk=$1/$isk
    fi
    if [ -f "$isk" ]; then
	return 0
    else
	echo isk="$isk"
	echo 'no files match pat='$pat
	isk=""
	return 1
    fi
}

lk() {
    isk $*
    [ 0 == $? ] && ll $isk
}

xk() {
    isk $*
    [ 0 == $? ] && x "$isk"
}

vk() {
    isk $*
    [ 0 == $? ] && v "$isk"
}

cpk() {
    isk $*
    sv $isk
}

rmk() {
    isk $*
    rm -i "$isk"
}

vdk() {
    isk $*
    vd $isk `ls -t save/$isk.* | head -1`
}

svk() {
    isk $*
    [ 0 == $? ] && sv "$isk"
}

# copy $1 to save/$1.timestamp
sv() {
    x=
    [ ls == "$1" ] && {
	x=ls
	shift
    }
    if [ 1 != $# ]; then
	echo usage: sv file
    else
	if [ ! -f $1 ]; then
	    echo sv: missing: $1
	else
	    ppwd=$PWD
	    d=${1%/*}
	    f=${1##*/}
	    #echo d=$d.
	    #echo f=$f.
	    [ "$d" = "$f" ] && d=.
	    cd $d
	    mkdir -p save
	    #to=save/$isk.`date +%m%d`
	    to=save/$f."`java FileModStamp $f`"
	    [ -f $to ] && ll $to $f
	    # if first arg was 'ls', only the ls was wanted, so don't copy
	    [ ls != "$x" ] && {
		# On BEA laptop 'jgunter' the MKS cp would sometimes hang
		# for 15 seconds (no CPU activity) before doing the copy.
		# Also seeing occassional hangs in the sed command used by ll.
		# Since Cygwin is free (versus $200-600 for MKS)
		# maybe I should just switch?
		# Must first check into cygwin's ksh support.
		#/cygwin/bin/cp -i $1 $to
		[ -f $to ] && {
		    cmp $f $to
		    if [ 0 = $? ]; then
			echo Identical: $f $to
			return
		    else
			diff $f $to | awk '/^</{new++}/^>/{old++}END{print "diff output shows ", new, " new lines, ", old, " old lines"}'
			echo 'See diffs? [n] \c'
			read go
			[ yy = y$go ] && {
			    diff $f $to
			}
		    fi
		}
		cp -i $f $to
		ll $to
		cd $ppwd
	    }
	fi
    fi
}

alias jtime='java JTime'

ffj() { grep $* jar.dump; }

got() {
    $s/gotxx.sh $*
}

prefix_prep() {
    nosp
    isk 2>/dev/null
}
prefix() {
    mv -i $2 $1$2
    k $1$2
}
prefix_all() {
    nosp
    ls -t | \
    while read n; do
	if [ $n != ${n#$1} ]; then
	    return
	else 
	    prefix $1 $n
	fi
    done
}
xy1() {
    prefix xy $1
}
xyk() {
    prefix_prep
    prefix xy $isk
}
xya() {
    prefix_all xy
}
wo1() {
    prefix wo $1
}
wok() {
    prefix_prep
    prefix wo $isk
}
woa() {
    prefix_all wo
}

jpgs_newer_than_file(){
    ls -t | sed -n -e "/$1/q" -E -e '/(jpg|gif)$/p'
}
recat_newer_jpgs() {
    echo mv -i `jpgs_newer_than_file $1` ../$2/
    mv -i `jpgs_newer_than_file $1` ../$2/
}
newest_jpg(){
    ls -t | sed -n -E '/(jpg|gif|webm)$/{p;q;}' 
}
recat_newest_jpg() {
    #echo mv -i `newest_jpg` ../$1/
    #mv -i `newest_jpg` ../$1/
    x="`newest_jpg`"
    echo mv -i "$x" $down/$1.${x##*.}
    mv -i "$x" $down/$1.${x##*.}
}
rmjk() {
    rm -i `newest_jpg`
}
wo2xx() {
    cd /j/diag/wo
    recat_newest_jpg xx
}
wo2xy() {
    cd /j/diag/wo
    recat_newest_jpg xy
}
xx2wo() {
    cd /j/diag/xx
    recat_newest_jpg wo
}
    
    
xx_sizes() {
    for xx in xx xy xy_1; do
	echo regenerating list of sizes for $xx...

    done
}

nosp() {
    java -cp $s NoSpacesInFilenames $*
}

bup() {
    #got
    #cd c:/_jay/jay/iii/xx
    #ls -rt | $s/alpha_counter.sh > /tmp/bup.alpha
    #cat /tmp/bup.alpha
    ##. /tmp/bup.alpha
    #echo END TEST
    #return
    cd ~/iii
    echo a="$*".
    $s/date_copy.sh $*
    xx_sizes
    echo removing dups from xx
    cd ~/diag/xx
    $s/rm_dup_images.ksh
    echo removing dups from xy
    cd ~/diag/xy
    $s/rm_dup_images.ksh
}

bap() {
    $s/backup-android-project.sh $*
}

alias pc="ping 192.168.2.1; ping /t google.com"

gw() {
    #egrep $* $jj/words/5desk.txt
    #egrep -v '^[A-Z]' /j/words/wordlist.txt | egrep $* 
    egrep $* /j/words/wordlist.no.names.txt
}
letter_freq() {
    gw . | \
    sed 's,\(.\),\1 ,g' | \
    tr -s " " "[\n*]" |  \
    awk '{a[$1]++}END{for(i in a)printf("%s %05d\n", i, a[i])}'  | \
    sort +1 -2 | \
    sed -e 's, 0,  ,' -e 's, 0 ,  ,' -e 's, 0,  ,' -e 's, 0,  ,' -e 's, 0,  ,'
}
starting_letters() {
    gw . | \
    sed 's,^\(.\).*,\1,' | \
    awk '{a[$1]++}END{for(i in a)printf("%s %05d\n", i, a[i])}'  | \
    sort +1 -2 | \
    sed -e 's, 0,  ,' -e 's, 0 ,  ,' -e 's, 0,  ,' -e 's, 0,  ,' -e 's, 0,  ,'
}

#alias myip='ipconfig getifaddr en1'

alias t=type

alias rehash='hash -r'

alias 777='chmod 777'
alias 777b='chmod 777 $(_B)'
alias +x='chmod +x'
alias +xb='chmod +x $(_B)'

alias ch='$s/chrome.sh'

sortLaunchpadIcons() {  # alphabetizes icons on pages after the first.
    defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
}    

#PS1='\e[7m\! \# \w\e[m > '
g .


rqbi() { # React Quickly Babel install (per chapter)
    npm i babel-cli@6.9.0 babel-preset-react@6.5.0 --save-dev  # recreates package.json
    ./node_modules/.bin/babel --version	   # installed by prev cmd
    npm run build   # 'build' is one of the scripts in package.json
    # the 'build' cmd uses -w to 'watch' for changes, and recompiles jsx to js
}

buj() {
  jar cMf ~/backups/jay.`date +'%y%m%d'`.zip _vimrc profile.ksh apple.ksh mac.config.sh
}

ccc() { # copy prev command to copy buffer
  fc -ln | tail -1 | pbcopy
}
ccp() { # paste copy buffer
  pbpaste
}
cce() { # eval contents of copy buffer
  eval `pbpaste`
}

vv() { 
  v `pbpaste`
}
gdd() { 
  git diff `pbpaste`
}

color_scheme_colors() {
  sed < ~/.vim/colors/jay_teal_2.vim -n -e '/guifg/s,.*guifg=\([^ ][^ ]*\).*,\1,p' | \
  sort | uniq | grep -v NONE | awk '
    BEGIN{print "<html><body style=\"background-color: black\">"}
    {print "<span style=\"background-color: "$1"\">"$1"</span><br>"}
    END{print "</body></html>"}'  > ~/colors.html
}

needs() {  # check a local backup of a file
  [ ! -f $* ] && { echo $* not found; return; }
  mostRecentSave="`ls -t1 $*.*[0-9] 2>/dev/null | head -1`"
echo mostRecentSave=$mostRecentSave
return
  if [ -f "$mostRecentSave" ]; then
    cmp $* $mostRecentSave >/dev/null
    [ $? = 0 ] && { echo $mostRecentSave is current.; return; }
    echo $mostRecentSave is behind.; 
    ls -l $* $mostRecentSave
  else
    echo $* has no backup
  fi
}

diffs() {  # diff a local backup of a file
  [ ! -f $* ] && { echo $* not found; return; }
  mostRecentSave="`ls -t1 $*.*[0-9] 2>/dev/null | head -1`"
#echo mostRecentSave=$mostRecentSave
  if [ -f "$mostRecentSave" ]; then
    diff $* $mostRecentSave 
  else
    echo $* has no backup
  fi
}

save() {  # make a local backup of a file
  [ ! -f $* ] && { echo $* not found; return; }
  mostRecentSave="`ls -t1 $*.*[0-9] 2>/dev/null | head -1`"
#echo mostRecentSave=$mostRecentSave
  if [ -f "$mostRecentSave" ]; then
    cmp $* $mostRecentSave >/dev/null
    [ $? = 0 ] && { echo $mostRecentSave is current.; return; }
    n=$(( ${mostRecentSave##*.} + 1 ))
  else
    n=0
  fi
  /bin/cp -i $* $*.$n
  echo  Backed up to $*.$n
}

bpv() { # bump version property in package.json file
  [ ! -f package.json ] && { echo package.json not found; return; }

  awk < package.json > package.json.bumped '
    /"version":/ {
      match($0, /\.[0-9]+",/) 
      n=substr($0, RSTART+1, RLENGTH-3)
      print substr($0, 0, RSTART)""n+1"\","
      next
    }
    {print}
  '

  lc=`diff package.json package.json.bumped | wc -l `
  if [ $lc = 4 ]; then
    diff package.json package.json.bumped
    mv package.json.bumped package.json
  else 
    echo Expected 4 lines to change in package.json, but got $lc
  fi
}

man() { # change colors to work on light background terminal 
    x=5
    [ $ITERM_PROFILE != 'Default' ] && x=5
    env \
    LESS_TERMCAP_mb=$(printf "\e[0;32m") \
    LESS_TERMCAP_md=$(printf "\e[0;34m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[$x;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[$x;35m") \
    man "$@"
}

ea() { 
  v ~/apple.ksh
}

#. ~/apple.ksh

a kc=kubectl
a kui=4A/sw/Kui/kubectl-kui
