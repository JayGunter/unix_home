# 
# z project_code rel_code subdir_code
#
# z e st     cd T:/docbuild/projects/ebooks_81sp4/stage/html
# z e 3 c    cd T:/docbuild/projects/ebooks_81sp3/control
# z e b      cd $flipdrive:/auto_convert/projects/ebooks_81sp3/build

#echo jumpdir args: $* .

path_only=0
[ "$1" = "-path_only" ] && {
    shift
    path_only=1
}

rels="15.81sp5 55.85sp5 5.8 9.9 4.81sp4 3.81sp3 25.25 21.21 0.10sp0 81.81GA"

projs=" \
a.adminhelp \
be.bestpract_81 \
bp.bp_help \
c.configwiz_help_9sp0 \
d.wli_process \
dd.dijon-docplan \
e.ebooks \
f.formatbuilder_help \
i.idehelp \
j.idehelp_javadoc \
ip.idehelp_pdf \
r.refxquery \
s.sol_samples_81 \
t.tuxedoWLWControl \
a7.wladapters70 \
a8.wladapters81 \
p.platform \
bc.wlibc_81GA \
pl.wlplugins70 \
xc.xbus_consolehelp \
xe.xbus_ebooks \
xf.xbus_fb_help \
xm.xbus_mapper_help \
xr.xbus_relnotes \
sr.alsr_20 \
w.wlibc \
z.zzz_test \
"

subdirs=" \
b.build \
be.build/wli/integration/rel*/src/ebooks \
bo.build/output_for_eclipse \
bi.build/wlw/doc/integration/src/idehelp \
bw.build/wlw/doc/integration/src/workshop \
bhi.build/depot/dev/8.1.x/help/ide/en/integration \
bhw.build/depot/dev/8.1.x/help/ide/en/workshop \
bhbi.build/depot/dev/8.1.x/help/build/doc/en/integration \
t.tmp \
c.control  \
l.logs  \
n.notes  \
sh.stage/html \
k.stage/html \
sp.stage/pdf \
shp.stage/html/pdf \
p.stage/html/pdf \
pdf.stage/html/pdf \
shz.stage/html/zip \
z.stage/html/zip \
shi.stage/html/build/doc/en/integration \
dh.deploy/html \
"


ap=$flipdrive:/auto_convert/projects
if [ krull = `hostname` ]; then
    Ap=C:/jay/docbuild/projects
else
    Ap=T:/docbuild/projects
    [ ! -d "$Ap" ] && {
	echo ERROR: drive T not mapped
	exit
    }
fi
#echo ap=$ap
#echo Ap=$Ap

if [ 0 == $# ]; then
    gvim $0 &
    exit
fi

if [ -reverse == "$1" ]; then
    beg="${PWD##$ap/}"
    [ "$PWD" = "$beg" ] && beg="${PWD##$Ap/}"
#echo PWD=$PWD
#echo beg=$beg
    if [ "$PWD" == "$beg" ]; then
	echo $PWD
    else
	code=
	x=$beg/
#echo x=$x

	pc=
	for p in $projs; do
	    pn=${p##*.}
#echo p=$p, pn=$pn
#echo x=$x, 2=${x##$pn}
	    [ "$x" != "${x##$pn}" ] && {
		pc=${p%%.*}
		code=$pc
		break
	    }
	done
	[ -z "$pc" ] && { pwd; exit; }
	x="${x##$pn}"
#echo x=$x

	rc=
	if [ -z "${x%%/*}" ]; then
	    # wladapters70 & wladapters81 have no underscore before version#,
	    # so handle then specially
	    x="${x#/}"
	else
	    for r in "" $rels; do
		rn=${r##*.}
		[ "" != "$rn" ] && rn="_"$rn/
#echo x=$x, rn=$rn
		[ "$x" != "${x##$rn}" ] && {
		    rc=${r%%.*}
		    code=$code$rc
#echo rc=$rc, code=$code
		    break
		}
	    done
	    [ -z "$rc" ] && { pwd; exit; }
	    x="${x##$rn}"
	fi
#echo x=$x

	for s in "" $subdirs; do
	    sn=${s##*.}
#echo x=$x, sc1=$sc1, sn=$sn
	    [ "$x" != "${x##$sn}" ] && {
		sc=${s%%.*}
		sc1=$sc
		sn1=$sn
	    }
	done
	if [ -z "$code" ]; then
	    pwd
	else
	    x="${x##$sn1}"
	    [ -n "$x" ] && x=/$x
	    code=$code$sc1
	    echo $code$x
	fi
    fi
    exit
fi

# not doing a -reverse lookup.
# map the code (e.g. 'z e 9 b') into the directory.

abbrev=
rel=
name=
for p in $projs; do
    code=${p%%.*}
    [ $code == $1 ] && {
	abbrev=$1
	p=${p#*.}
	name=${p##*.}
	break
    }
done
[ -z "$name" ] && { 
    if [ $path_only == 1 ]; then
	echo xno project name for code: $1 | sed 's, ,_,g'
    else
	echo no project name for code: $1
    fi
    exit
}

shift

rc_chosen=
rn_chosen=
rc_default=
rn_default=
[ ! -d $Ap/$name ] && {
    for r in "" $rels x.x; do
	[ "$r" = x.x ] && break
	rc=${r%%.*}
	rn=${r##*.}
	[ "" != "$rn" ] && rn="_"$rn/
	if [ $# -gt 0 -a "$rc" = "$1" ]; then
	    rc_chosen=$rc
	    rn_chosen=$rn
	    shift
	elif [ -z "$rc_default" -a -d $Ap/$name$rn ]; then
	    rc_default=$rc
	    rn_default=$rn
	fi
    done
    if [ -n "$rn_chosen" ]; then
	abbrev=$abbrev$rc_chosen
	name=$name$rn_chosen
    elif [ -n "$rn_default" ]; then
	abbrev=$abbrev$rc_default
	name=$name$rn_default
    else
	echo no release found
	exit
    fi
}

bernal_stage_dir="`cat $Ap/$name/control/real_post_to`"
bernal_release_dir=R:/${bernal_stage_dir#*:}
dir=$ap/$name

[ $# -gt 0 ] && {
    case "$1" in
    p4|po)
	code=p4
	abbrev=$abbrev"_"$1
	#dir=C:"`awk '/\/depot/{gsub("\.\.\.",""); print $1;exit}' < $Ap/$name/control/p4.clientspec.txt`"
	dir=C:"`awk '/\/depot/{gsub("/[^/][^/]*$","",$1); print $1;exit}' < $Ap/$name/control/p4.clientspec.txt`"
	;;
    pi)
	code=pi
	abbrev=$abbrev"_"$1
	#dir=C:"`awk '/\/depot/{gsub("\.\.\.",""); print $1;exit}' < $Ap/$name/control/p4.clientspec.txt`"
	dir=C:"`awk '/\/depot/{gsub("/[^/][^/]*$","",$1); print $1;exit}' < $Ap/$name/control/p4.clientspeccheckin.txt`"
	;;
    bs)
	code=bs
	dir=$bernal_stage_dir
	abbrev=$abbrev"_"$1
	;;
    bsp)
	code=bsp
	dir=$bernal_stage_dir/pdf
	abbrev=$abbrev"_"$1
	;;
    bsz)
	code=bsz
	dir=$bernal_stage_dir/zip
	abbrev=$abbrev"_"$1
	;;
    br)
	code=br
	dir=$bernal_release_dir
	abbrev=$abbrev"_"$1
	;;
    brp)
	code=brp
	dir=$bernal_release_dir/pdf
	abbrev=$abbrev"_"$1
	;;
    brz)
	code=brz
	dir=$bernal_release_dir/zip
	abbrev=$abbrev"_"$1
	;;
    *)
	for d in $subdirs; do
	    code=${d%%.*}
	    [ $code == $1 ] && {
		d=${d#*.}
		dir=$ap/$name/$d
		[ ! -d $dir ] && dir=$Ap/$name/$d
		[ ! -d $dir ] && { 
		    echo no subdir $d under $ap/name or $Ap/name
		    exit
		}
		abbrev=$abbrev$1
		break
	    }
	done
	;;
    esac
}

if [ $path_only == 1 ]; then
    echo $dir
else
    echo $dir $abbrev
fi
	
	
