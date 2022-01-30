books="aiover/
aiuser/
deploy/
design/
devadapt/
images/
interm/
javadoc/
manage/
overview/
pdf/
peoverview/
relnotes/
tpintro/
tptutorial/
upgrade/
wltutorial/
worklist/
zip/
"

#books=aiuser

for b in $books; do
    echo ==== $b
    x=stage/html/$b
    $s/word_diff_count_by_dir.ksh $Ap/ebooks_81sp3/$x $Ap/../old_projects/ebooks_81sp2/$x
done
