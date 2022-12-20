
" init all settings
set all&
" init autocmd
autocmd!

"------------------------------------
" Open & Reload .vimrc
"------------------------------------
" set foldmethod=expr
" set modeline
" command! Evimrc  e $MYVIMRC

augroup source-vimrc
  autocmd!
  autocmd BufWritePost *vimrc source $MYVIMRC | set foldmethod=marker
  autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
augroup END

"------------------------------------
" general
"------------------------------------
set nocompatible  " vi vim を別物 プラグインの誤動作を防止
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,sjis
"set fileencodings=iso-2022-jp,enc-jp,enc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set shell=/bin/bash

"------------------------------------
" appearance settings
"------------------------------------
" cursor type
if has('vim_starting')
    let &t_EI .= "\e[2 q"   " normal mode
    let &t_SI .= "\e[6 q"   " insert mode
    let &t_SR .= "\e[4 q"   " replace mode
endif

" hilight line
" カーソル行を強調表示しない
set nocursorline
" 挿入モードの時のみ、カーソル行をハイライトする
autocmd InsertEnter,InsertLeave * set cursorline!

"------------------------------------
" clipboard settings
"------------------------------------
" ビジュアルモードで選択したテキストが、クリップボードに入るようにする。
" set guioptions+=a " GUI
set clipboard+=autoselect
" 無名レジスタに入るデータを、*レジスタにも入れる。
set clipboard+=unnamed

"------------------------------------
" editor settings
"------------------------------------
set autoindent
set expandtab  " tab to space
set tabstop=4   " num of char to convert tab to spaces when open
set softtabstop=4   " when keyboard input
set shiftwidth=4    " autoindent spaces
set showmatch  " 対応カッコをハイライト
set ruler
set title
set list  " 不可視文字を表示する
set listchars=tab:>-,trail:.  " タブを >--- 半スペを . で表示する
set number
set statusline=%F%m%r%h%w%=\ %{fugitive#statusline()}\ [%{&ff}:%{&fileencoding}]\ [%Y]\ [%04l,%04v]\ [%l/%L]\ %{strftime(\"%Y/%m/%d\ %H:%M:%S\")}


if has("autocmd")
  augroup tab_setting
    autocmd!
    "ファイルタイプの検索を有効にする
    filetype plugin on
    "ファイルタイプに合わせたインデントを利用
    filetype indent on
    "sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtabの略
    autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
    autocmd FileType sh          setlocal sw=2 sts=2 ts=2 et
    autocmd FileType bash        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType zsh         setlocal sw=2 sts=2 ts=2 et
    autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
    autocmd FileType json        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType scss        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType sass        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
  augroup END
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
"------------------------------------
" normal mode settings
"------------------------------------
" set ignorecase " with smartcase
set smartcase  " lower upperのみのときはignorecaseしない

"------------------------------------
" command line mode settings
"------------------------------------
set wildmenu    " tab 補完 C-l,C-i より直感的

"------------------------------------
" re-examination
"------------------------------------
" set softtabstop
" set hlsearch
" set cindent
" set showcmd
" set ignorecase
" set visualbell
" set backspace
" set clipboard  " yank to clipboard(not supported)
language C  " system laguage english
syntax enable
" set norestorescreen
" set fileformats=unix,dos,mac    " newline char auto reco
" " set script encoding
" scriptencoding utf-8

"------------------------------------
" plugins
"------------------------------------
if filereadable(expand("~/.vim/plugged"))
  call plug#begin()
    set helplang=ja,en
    Plug 'tpope/vim-fugitive'
    Plug 'vim-jp/vimdoc-ja'
  call plug#end()
endif

"------------------------------------
" finish loading vimrc if tiny or small version.
"------------------------------------
if !1 | finish | endif

"------------------------------------
" key binding memo
"------------------------------------
" " key bind list
" :help index.txt
" " user key bind
" :map
" :imap
" :nmap
" :vmap
" :verbose nmap
"------------------------------------
" Normal, Visual, Select, Operator-pendin mode key binding
"------------------------------------
noremap g<c-a> <ESC>ggvGV
noremap <Space>h ^
noremap <Space>l $
"------------------------------------
" nomal(command) mode key binding custumize
"------------------------------------
"(nmapは再帰的であるためループになる可能性があるのでnnoremap
" ソフトラップされた仮想的な行を含めて下にスクロール
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap ; :
nnoremap : ;
nnoremap <ESC><ESC> :nohl<CR>
nnoremap ZQ <Nop>
nnoremap <Space>/ *

augroup main
  autocmd!
augroup END

"" Insert line break by Enter in normal mode
autocmd main BufWinEnter *
  \  if &modifiable
  \|   nnoremap <buffer> <CR> i<CR><ESC>
  \| else
  \|   nunmap <buffer> <CR>
  \| endif

" move lines up, down  e.g 2[e = 2 lines up
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>
" add blank line
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" 保存して終了
nnoremap <C-s><C-s><C-s> :<C-u>wq<cr>

"------------------------------------
" insert mode key binding custumize
"------------------------------------
" normal への移行を楽に
inoremap <silent> jk <ESC>
" 保存して終了
inoremap <C-s><C-s> <ESC>:<C-u>wq<cr>

"------------------------------------
" command line mode key binding
"------------------------------------
cnoremap fuck q!

" emacs like
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

"------------------------------------
" visual and select mode key binding
"------------------------------------
vnoremap <C-c> :w !wl-copy<cr>  " wayland

" no create temp files
" set noswapfile
" set nobackup
" set noundofile
" set viminfo=

"  augroup highlightIdegraphicSpace
"    autocmd!
"    autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
"    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
"  augroup END  " visuble zenkaku space

" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2019 Jan 26
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup      " do not keep a backup file, use versions instead
else
  set backup        " keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile    " keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

"------------------------------------
" function
"------------------------------------
function! s:mkdir(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir, "p")
  endif
endfunction

"------------------------------------
" vim files
"------------------------------------
set nobackup
set noswapfile
set noundofile

set directory=$HOME/.vim/swap
call s:mkdir(&directory)
set swapfile

set backupdir=$HOME/.vim/backup
call s:mkdir(&backupdir)
set backup

if has('persistent_undo')
  set undodir=$HOME/.vim/undo
  call s:mkdir(&undodir)
  set undofile
endif

"------------------------------------
" 分岐処理いろいろ
"------------------------------------

if has("mac")
    set shell=/bin/bash
elseif has("unix")
    set shell=/bin/bash
elseif has("win64")
  if exists('*mkdir') && !isdirectory('~/user/appfiles/vim')
    call mkdir('~/user/appfiles/vim')
  endif
  " temp files export destination
  set directory=~/user/appfiles/vim
  set backupdir=~/user/appfiles/vim
  if has('persistent_undo')
    set undodir=~/user/appfiles/vim
    set undofile
  endif
  set viminfo+=n~/user/appfiles/vim/viminfo
  set shell=C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe\ -executionpolicy\ bypass
elseif has("win32unix")
    " Cygwin固有の設定
    set shell=/bin/bash
elseif has("win32")
    set shell=/bin/bash
elseif has("wsl")
    " wsl固有の設定 うまく動かないとの報告あり
    set shell=/bin/bash
endif


" if ( has('python') || has('python3') )
"     " python が必要な設定をここに書く
" else
"     " python がないときの設定
" endif
" if has('lua')
"     " lua が必要な設定
" else
"     " lua がないときの必要な設定
" endif

" vim version >= 8
if v:version >= 800|set breakindent|endif

" cryptmethod = blowfish2 if version >= 7.4 else zip
" if v:version >= 704 | set cm=blowfish2 | elseif | set cm=zip | endif

" if git installed
" if executable('git')
"     call dein#add("airblade/vim-gitgutter")
"     call dein#add("tpope/vim-fugitive")
" endif



" Windows Subsystem for Linux で、ヤンクでクリップボードにコピー
if system('uname -a | grep -i microsoft') != ''
  augroup myYank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe', @")
  augroup END
end
