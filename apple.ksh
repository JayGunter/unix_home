
# Apple stuff

bustud() {
  stud
  jar cMf ~/stud.backup.0514.zip README.md .npmrc deploy/ public/ pa
}

buj() {
  g
  #jar cMf ~/backups/jay.`date +%y%m%d`.zip _vimrc apple.ksh apple.notes js mac.config.sh npm_test profile.ksh studio_design sup todo 
  jar cMf ~/backups/jay.`date +%y%m%d`.zip _vimrc apple.ksh js mac.config.sh npm_test profile.ksh sup todo 
}

dbp() { 
  psql $* -d projects
}
jl() { 
  if [ $# == 1 ]; then
    e "select * from project where id = $1;" | dbp -qt
  else
    e 'select * from project;' | dbp
  fi
}
jpi() { 
  e "select pipeline_info from project where id=$1;" | dbp -q -t
}
jpn() { 
  e "select pipeline_info from project where name='$1';" | dbp -q -t
}
jn() {
  eval echo `jp $1 | jq .nodes`  | jq .
}
jca() {
  eval echo `jp $1 | jq .common_attrs`  
}
ji() { 
  num=${1:-10}
  name=${2:-test}
  
  for i in `seq 1 $num`; do 
    curl -X POST -s http://127.0.0.1:3030/api/projects --data "name=${name}_$i&description=${name} $i description&username=jay_gunter&pipeline_info={\"refAttrs\":{\"attrs\":[]},\"common_attrs\":{\"num_problems\":0, \"attrs\":[{\"name\":\"\",\"value\":\"\",\"problem\":\"\"}]},\"nodes\":[],\"edges\":[]}"
  done
}
jd() { 
  curl -X DELETE -s http://127.0.0.1:3030/api/projects/$1
}
jda() { 
  e 'delete from project;' | dbp
}

jours() {  # show journal_fields json_paths in default.json files found underneath ./
  find . -name default.json | while read f; do
    echo $f
    jour $f
  done
}
jour() {  # show journal_fields json_paths in a default.json file
  #jq < ${1} '.__meta.journal_fields[].json_path'
  jq < ${1} '.__meta.journal_fields[].name'
}

export rdauth=""
# Set rdauth variable for use in $tt scripts.  Using cat to avoid ~/.inputrc causing shell to interpret jk as Esc.
auth() { 
  echo Paste the auth_token value seen in the request header of a redorbit api request, hit return and then ^D.
  export rdauth="`cat`"
  echo rdauth=$rdauth
}
