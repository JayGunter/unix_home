# TODO move git aliases from profile.ksh to here

# Clone a repo
gclone() { 
  git clone $*

  git config --global push.default current  # set remote repo to be upstream (should be an option to clone)
  # now use git push -u to push to remote repo
}

gdefb() { # show remote default branch
  git remote show origin | awk '/HEAD branch/ { print $NF }'
}

gnewb() { # create new branch and switch to it
  git checkout -b $*;
}

gbl() { # list branches
  git branch;
}

gdelb() { # delete branch
  git branch -d $*;
}

gco() { # checkout (switch to) a different branch
  git checkout $*;
}

gdefbco() { # checkout (switch to) default branch
  git checkout `gdefb`;
}

gssavemods() { # stash modified (but not untracked), "$*" is msg
  git stash save $* 
}

gssavefiles() { # stash named files (can precede with -m msg)
  git stash push $* 
}

gslist() { # args as for git log
  git stash list $* 
}

gsshow() { # show summary of stash # $1 (stash@{0} by default)
  git stash show $* 
}

gspop() { # restore stash # $1 (stash@{0} by default) and remove stash from list
  git stash pop $* 
}

# Should use this to handle local config currently setup in core clones using ~/pie/local_config/...
gsapply() { # restore stash # $1 (stash@{0} by default), but leave stash on list
  git stash apply $* 
}

gsdrop() { # remove stash # $1 (stash@{0} by default) from list
  git stash drop $* 
}

gsclear() { # restore all stashes from list
  git stash clear
}

gsbranch() { # creates new branch named $1 and restore stash $2 on to it
  git stash branch $1 $2
}

# Should use this to handle local config currently setup in core clones using ~/pie/local_config/...
gsapply() { # restore stash # $1 (stash@{0} by default), but leave stash on list
  git stash apply $* 
}

gpush() { # push commits to upstream repo
  git push -u
  # without doing 'git config --global push.default current' 
  # you need 'git push -u origin HEAD'
  # where 'origin' is the remote 
  # and 'HEAD' stands in for '<local-branch-name>:<remote-branch-name>'.  
  # git will assume you want the remote branch named the same as the local branch.
  # The -u makes the local branch be 'tracked'
}

geb() { # echo current branch name
  git status | sed -e '/On branch/s,On branch ,,' -e 'q'
}

glb() { # show local and remote branches with SHA1 and commit subject list for each head and relationship to upstream branch (if any).
  git branch -avv
}

gba() { # show # of commits branch 1 is behind/ahead of branch 2
  #git rev-list --left-right --count origin/dev...origin/AppleJDK-migration
  git rev-list --left-right --count origin/$1...origin/$2
}
gbac() { # show # of commits branch 1 is behind/ahead current local branch
  git rev-list --left-right --count origin/$1...origin/`geb`
}

# See what is changed but not yet staged
gdiff() { git diff $*; }

# See what is staged but not committed
gdiffs() { git diff --staged $*; }

# Undo unstaged changes to a file
# greset() { git reset HEAD $1...; }  # this did not work.
greset() { git checkout -- $1; } 

# Stage changes to a file
gadd() { git add $*; }

# Stage a new file
#gadd() { git add $*; }

# Unstage a file that was added to the stage area
gunadd() { git checkout -- $1...; }

# Commit staged changes with message
gcm() {  git commit -m"$*"; }

wip() { gcm wip; }

wipa() { sta; echo -n 'add . and push? '; read x; [ "$x" != y ] && return; gadd .; gcm wip; gpush; }

# Stage (add) all modified files and commit with message
gcam() {  git commit -am"$*"; }

# Remove a file from staging area and local 
grm() { git rm $*; }

# Remove a file accidentally staged
grms() { git rm --cached $*; }  # --cached is the same as --staged, I think

# Move/rename file
# same as mv $1 $2; git rm $1; git add $2
gmv() { git mv $*; }  

# Show 1-line log
glog1() { git log --pretty=oneline $*; }  # possible args:  -- path1 path2

# Show formatted log
glogf() { git log --pretty=format:"%h - %an, %ar %ad: %s" $*; } # possible args:  -- path1 path2

glogdw() { git log --pretty=format:"%ai %ae %h %f" $*; } # date, time, user, commit it, commit msg

# Show log graph
glogx() { git log --pretty=format:"%h %s" --graph $*; } # possible args:  -- path1 path2

# Show log of last N weeks
glogw() { git log --since=$1.weeks $*; }  # possible args:  -- path1 path2

# Show who added string
glogs() { git log -S "$*"; }

# Show commits with message containing string
glogm() { git log -=grep "$*"; }

gls() { git ls-files -v $*; } # show git flags (e.g. skip-worktree) for named/all files
glskip() { git ls-files -v|grep '^S'; } # checks for any files flagged w/ --skip-worktree alias
skip() {  for f in "$@"; do git update-index --skip-worktree "$f"; done;  git status; } # add --skip-worktree flag to file
unskip() {  git update-index --no-skip-worktree "$@";  git status; } # remove --skip-worktree flag from file
exclude() { for f in "$@"; do echo $f >> .git/info/exclude; done; }
