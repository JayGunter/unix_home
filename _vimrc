execute pathogen#infect()

filetype plugin indent on
syntax on

map <C-t> :NERDTreeToggle<CR>


:set directory=~/.vim/swapfiles//
set cursorline
set cursorcolumn

" Set leader key to trigger personal commands
"let maplocalleader = "\\"
"let mapleader = "\\"

" Edit profile.ksh
"nnoremap <leader>ek :tabnew ~/profile.ksh<CR>
" :tab drop switches to appropriate tab if file is already open, avoiding multiple tabs with same file.
nnoremap <leader>ek :tab drop ~/profile.ksh<CR>
"nnoremap <leader>ea :tabnew ~/apple.ksh<CR>
nnoremap <leader>ea :tab drop ~/apple.ksh<CR>

" Edit vimrc
"nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <leader>ev :tab drop $MYVIMRC<CR>
" Edit gvimrc
" MacVim only obeys certain GUI commands (like :highlight Cursor) when in .gvimrc.
" Oddly, colorscheme works fine in .vimrc.
"nnoremap <leader>eg :tabnew ~/.gvimrc<cr>
nnoremap <leader>eg :tab drop ~/.gvimrc<cr>
nnoremap <leader>j2 :tab drop ~/.vim/colors/jay_teal_2.vim<cr>
" Source vimrc and gvimrc
nnoremap <leader>sv :so ~/_vimrc<CR>:so ~/.gvimrc<CR>
nnoremap <leader>ss :colo jay_teal_2<CR>:so ~/_vimrc<CR>:so ~/.gvimrc<CR>

" open new tab and bring up file explorer
nnoremap <leader>ex :tabnew<CR>:Ex<CR>
nnoremap <F4> :tabnew<CR>:Ex<CR>

" Apple Pipeline Studio source files
nnoremap <leader>in :tab drop $studs/index.js<CR>
nnoremap <leader>se :tab drop $studs/selectors.js<CR>
nnoremap <leader>pr :tab drop $studs/reducers/project.js<CR>
nnoremap <leader>pa :tab drop $studs/actions/project.js<CR>
nnoremap <leader>co :tab drop $studs/actions/constants.js<CR>
nnoremap <leader>plp :tab drop $studs/components/app/projects/projectList/Projects.jsx<CR>
nnoremap <leader>pl :tab drop $studs/components/app/projects/projectList/ProjectList.jsx<CR>
nnoremap <leader>ni :tab drop $studs/components/app/projects/projectList/NodeItem.jsx<CR>
nnoremap <leader>pd :tab drop $studs/components/app/projects/projectDetails/ProjectDetails.jsx<CR>
nnoremap <leader>ca :tab drop $studs/components/app/projects/projectDetails/CommonAttrs.js<CR>
nnoremap <leader>cy :tab drop $studs/components/common/CytoscapeDAG.jsx<CR>
nnoremap <leader>na :tab drop $studs/components/app/projects/projectDetails/NodeAttrs.js<CR>
nnoremap <leader>ra :tab drop $studs/components/app/projects/projectDetails/RefAttrs.js<CR>
nnoremap <leader>np :tab drop $studs/components/app/projects/projectDetails/newProject/NewProject.jsx<CR>
nnoremap <leader>npa :tab drop $studs/components/app/projects/projectDetails/newProject/NewProjectActions.jsx<CR>
nnoremap <leader>npi :tab drop $studs/components/app/projects/projectDetails/newProject/NewProjectInputs.jsx<CR>

" Find next instance of 'ipeline' and change it to 'roject'
nnoremap <leader>pp /ipeline<CR>c2feroject<ESC>

" D- is the Mac Command key

" D-y opens a new tab and shows the Most Recently Used list
nnoremap <F3> :tabnew<CR>:MRU<CR>

" Show buffers, and prompt for buffer # (or partial text match) to switch to that buffer.
" Note:  to switch to the buffer you just left, hit C-6.
nnoremap <F5> :buffers<CR>:buffer<Space>

" BufExplorer can also be brought up by typing \be
" Use F1 for help.  hjkl to pick file, and enter to open.
nnoremap <F6> :BufExplorerHorizontalSplit<CR>

set nu
set ts=2 sts=2 sw=2 sts=2 expandtab
set list
set listchars=tab:▸\ 

set nocompatible
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin
"
" Type f^X^N to see a list of matching words in the file.  While holding CTRL, press ^N or ^P to go up and down in the list.
" Type xxx^X^L to see a list of matching lines in the file.
" Type xxx^X^F to attempt completion of filename xxxyyyzzz
set dictionary+=/usr/share/dict/words   " type "dict^X^K" to see a list of words starting with "dict"
set thesaurus+=/j/thesaurus/mthesaur.txt  " ^X^T is supposed to bring up a list of alternate words, but gives an error "Pattern not found"
"
"se guifont=Courier_New:h10:cANSI
":se guifont=Andale_Mono:h9:cANSI
"se guifont=Lucida_Console:h10:cANSv
set guifont=Menlo_Regular:h12
":colorscheme jay
":colorscheme darkblue
colorscheme jay_teal_2
" The next line had to be in ~/.gvimrc to work!
highlight Cursor guifg=black guibg=green


set laststatus=2
"set statusline=%t\ %r\ %y\ format:%{&ff};\ line:%l\ column:%c\ byte:%b
set statusline=%t       "tail of the filename
"set statusline=%10(%)
set statusline+=\ %r      "read only flag
set statusline+=\ %M      "modified flag
"set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=\ [%{&ff}] "file format
set statusline+=\ %y      "filetype
set statusline+=\%-30(\ line\ %l\ of\ %L\ %)   "cursor line/total lines
set statusline+=\%-12(\ column:%c\ %)     "cursor column
set statusline+=\%-15(\ byte:%b=0x%B\ %)     "cursor column
""
se nows
se ic
"se lines=60
"
se backupdir=/tmp
" automatically cd to the dir containing the file (for easy side-rev saves)
se autochdir
"
" ii exits insert mode
"imap ii <C-[>
inoremap jk <C-[>
inoremap kj <C-[>
"
" allow :W and :Q
" unfortunately, this disallows /search-for-capital-Q
"cmap Q q
"cmap W w
"
" Searching:  * (or #) will highlight all occurrences of the current word,
" and move the cursor to the next (or previous) occurrence.
" Use g* or g# to search for strings that start with the current word.
" Use ggn to jump to first occurrence, GN for last.
" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Press F8 to highlight all occurrences of the current word without jumping.
nnoremap <F8> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" Doing /<C-r><C-w> will put the current word into the search command
" so you can edit it before searching.
:set hlsearch 
"
"
" K moves the current word after the next word.
" lbdwwP
" map K F dt ep
nnoremap K lb"kdexep"kp
"
nnoremap n /
nnoremap N ?
"
nnoremap  :se ic
nnoremap  :se noic
"
"map <C-J> <C-W>j<C-W>_
"map <C-K> <C-W>k<C-W>_
"
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>
nnoremap <silent> <C-Up> :wincmd -<CR>
nnoremap <silent> <C-Down> :wincmd +<CR>
"
"map q :source! C:/_Jay/sup/vi_frags/
"map Q ?x
"map Q :se noai095lF rJ
"
map v o0<C-D>console.log('pa= ', pa)
"map v oSystem.out.println( "pa=" + pa );
"map V odebug += "pa=" + pa + "<br>";
"map v /<title>o<script src="../nav/nav.js"></script>
"map V /<table width=200d/youarehereo<script>showNav("@@","");</script>
"
" & creates empty comment-block
"map & O/*<C-J>*/<Esc>
"map & lbi%"<Esc>ea"%<Esc>
"
"map } 0f}%
"map { %
"
"map + 0i//
"map - 0xx
"
:function! ToggleJavaLineComment() 
	"s,^,//,
	"s,^////,,
    if getline('.') =~ '^//'
	s,^//,,
    else
	s,^,//,
    endif
:endfunction
nnoremap <C-C> :call ToggleJavaLineComment()<CR>
"
"nnoremap + I/* A */
"nnoremap - ^xxx$xxx
"nnoremap _ ^xxx$xxx
"
"ab <c <CODE>
"ab /c </CODE>
"
" MOVE THESE TO A PRIVATE COPY OF java.vim UNDER /vim/vimfiles/syntax
"ab pu public
"ab pr private
"
"ab o( System.out.println( "
"ab e( System.err.println( "
"
"ab S String
"ab St String
"ab .l .length()
"ab .t .toLowerCase()
"ab .e .equals(
"ab .i .indexOf(
"ab .l .lastIndexOf(
"ab .s .substring(
"
"ab ST StringTokenizer
"
"ab V Vector
"ab .a .addElement(
"ab .e .elementAt()
"ab .s .size()
"
"ab H Hashtable
"
"ab E Enumeration
"ab .h .hasMoreElements()
"ab .n .nextElement()
"
" MOVE THESE TO A PRIVATE COPY OF jay.vim UNDER /vim/vimfiles/syntax

