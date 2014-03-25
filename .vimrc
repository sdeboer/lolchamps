set nocompatible

call pathogen#infect()
syntax on
filetype plugin indent on

set encoding=utf-8
set laststatus=2
set visualbell
set ignorecase
set incsearch
set hlsearch
set visualbell
set wildmenu
set lazyredraw
set ruler
set hidden
set backspace=eol,indent,start
set showmatch
set matchtime=2
set foldmethod=syntax
set foldlevelstart=99
set foldminlines=0

set autoindent
set smartindent
set smarttab
set noexpandtab
set shiftwidth=2
set tabstop=2
"set softtabstop=2
"set list
set listchars=tab:»·,trail:·,eol:¶
set relativenumber
set number

set guioptions-=T
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions+=c
set guioptions-=m
set splitright
set sidescrolloff=5
set complete-=i
set nrformats-=octal
set shiftround
set display+=lastline
set equalalways
" if has("transparency") set transparency=12 endif

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

if has('win32')
	set lines=45 columns=140
	autocmd! bufwritepost _vimrc source ~/_vimrc
	set guifont=Consolas:h9
else
	autocmd! bufwritepost .vimrc source ~/.vimrc
endif

let s:dir = has('win32') ? '~/Application Data/Vim' : '~/.vimtmp'
if isdirectory(expand(s:dir))
  if &directory =~# '^\.,'
    let &directory = expand(s:dir) . '/swap//,' . &directory
  endif
  if &backupdir =~# '^\.,'
    let &backupdir = expand(s:dir) . '/backup//,' . &backupdir
  endif
  if exists('+undodir') && &undodir =~# '^\.\%(,\|$\)'
    let &undodir = expand(s:dir) . '/undo//,' . &undodir
  endif
endif
if exists('+undofile')
  set undofile
endif

"set guifont=Monospace\ 9
"set guifont=ProFontWindows\ 12
"set guifont=Inconsolata\ 9
"set guifont=Inconsolata\ 11

"au WinEnter * set cursorcolumn
"au WinLeave * set nocursorcolumn

"au WinEnter * set foldcolumn=1
"au WinLeave * set foldcolumn=0

" Abbreviations
func! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

let g:mustache_abbreviations = 1

autocmd BufNewFile,BufRead *.god setl filetype=ruby
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent
au BufNewFile,BufReadPost *.haml setl foldmethod=indent
au BufNewFile,BufReadPost *.sass setl foldmethod=indent
au BufNewFile,BufReadPost *.template setl filetype=html foldmethod=indent
au BufNewFile,BufReadPost *.groovy setl filetype=groovy

" function! CleverTab()
" if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
" return "\<Tab>"
" else
" return "\<C-N>"
" endfunction
" inoremap <Tab> <C-R>=CleverTab()<CR>

function! SimonInfect(...)
  let sub = a:0 ? a:1 : '/app'
  let current = getcwd() . sub
  call pathogen#runtime_prepend_subdirectories(current)
  let js = current . '/assets/javascripts'
  echo js
  call pathogen#runtime_prepend_subdirectories(js)
  let sass = current . '/assets/stylesheets'
  echo sass
  call pathogen#runtime_prepend_subdirectories(sass)
endfunction

" Settings for rails.vim
let g:rails_gnu_screen=1

function! SetBig()
  set guifont=Monospace\ 11
endfunction

function! SetSmall()
  set guifont=Inconsolata\ 10
endfunction

function! SetTiny()
  set guifont=Inconsolata\ 9
endfunction

function! SetSize(n1, n2)
  set lines=a:n1
  set columns=a:n2
endfunction

" Highlight the word under the cursor by hitting enter in 
" command mode
let g:highlighting = 0
function! Highlighting()
  if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
    let g:highlighting = 0
    return ":silent nohlsearch\<CR>"
  endif
  let @/ = '\<'.expand('<cword>').'\>'
  let g:highlighting = 1
  return ":silent set hlsearch\<CR>"
endfunction
nnoremap <silent> <expr> <CR> Highlighting()

if has("autocmd")
  " Restore cursor position
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif

" If you don't want the handy line finders remove these
" for additional speed
" nnoremap ; :
" let mapleader = ","
let mapleader = "-"
nmap <space> /
nmap <leader>b :e#<cr>
nmap <leader>q :q<cr>
nmap <leader>w :wa<cr>
nmap <leader>d :bd!<cr>

nmap <leader>fb  :call SetBig()<cr>
nmap <leader>fs  :call SetSmall()<cr>
nmap <leader>ft  :call SetTiny()<cr>
nmap <leader>fw  :call SetSize(60, 160)<cr>
nmap <leader>fn  :call SetSize(30, 80)<cr>

nmap <leader>hs :syntax sync fromstart<cr>
nmap <leader>nt :NERDTreeToggle<cr>
nmap <leader>nf :NERDTreeFind<cr>
nmap <leader>pi  :call SimonInfect()<cr>

nmap <leader>tc :tabclose<cr>
nmap <leader>te :tabedit<space>
nmap <leader>tn :tabnew %<cr>

let g:EclimDefaultFileOpenAction = 'edit'
let g:EclimLocateFileScope = 'workspace'
"let g:EclimLocateFileDefaultAction = 'edit'
"let g:EclimJavaSearchSingleResult = 'edit'
let g:EclimProjectKeepLocalHistory = 1
let g:EclimJavascriptValidate = 0 
nmap <leader>ea :JavaCallHierarchy<cr>
nmap <leader>ec :JavaSearchContext<cr>
nmap <leader>ef :JavaFormat<cr>
nmap <leader>el :LocateFile<cr>
nmap <leader>eh :JavaHierarchy<cr>
nmap <leader>ei :JavaImpl<cr>
nmap <leader>et :vs<bar>JavaSearchContext<cr>
nmap <leader>ev :vs<bar>LocateFile<cr>
nmap <leader>ep :ProjectProblems<cr>
nmap <leader>ez :%JavaFormat<cr>
nmap <leader>er :ProjectRefreshAll<cr>

nmap <leader>ll :set list!<cr>
nmap <leader>ln :set number!<cr>
nmap <leader>lr :set relativenumber!<cr>
nmap <leader>li :set foldcolumn=0<cr>
nmap <leader>lc :set foldcolumn=1<cr>
nmap <leader>lv :set cursorcolumn!<cr>

" MAVEN
autocmd Filetype java set makeprg=mvn\ compile\ -q\ -f\ pom.xml
autocmd Filetype java set errorformat=\[ERROR]\ %f:[%l\\,%v]\ %m
autocmd Filetype groovy set makeprg=mvn\ compile\ -q\ -f\ pom.xml
autocmd Filetype groovy set errorformat=\[ERROR]\ %f:[%l\\,%v]\ %m

autocmd BufEnter * setl relativenumber number
autocmd BufLeave * setl norelativenumber nonumber
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"autocmd vimenter * if !argc() | NERDTree | endif

cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>
nnoremap Y y$

" LIGHT
" color autumnleaf
" color chela_light
" color eclipse
" color gaea
" color tolerable
color earendel
" color zenesque

"  DARK
" color murphy
" color dw_orange
" color dante
" color elflord
" color railcasts
" color asu1dark
" color golden
" color vividchalk
" color Tomorrow-Night-Bright
" color xoria256
" color desert256
" color matrix
" color jellybeans
" color moria

set background=dark

Helptags
