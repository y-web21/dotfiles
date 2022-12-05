
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
"
"------------------------------------
set nocompatible  " vi vim を別物 プラグインの誤動作を防止
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,sjis
"set fileencodings=iso-2022-jp,enc-jp,enc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set shell=/bin/bash

"------------------------------------
" editor settings
"------------------------------------
set tabstop=4
set shiftwidth=4
set expandtab  " tab 2 space
set showmatch  " 対応カッコをハイライト
set ruler
set title
set list  " 不可視文字を表示する
set listchars=tab:>-,trail:.  " タブを >--- 半スペを . で表示する
set number
set statusline=%F%m%r%h%w%=\ %{fugitive#statusline()}\ [%{&ff}:%{&fileencoding}]\ [%Y]\ [%04l,%04v]\ [%l/%L]\ %{strftime(\"%Y/%m/%d\ %H:%M:%S\")}

"------------------------------------
" normal mode settings
"------------------------------------
" set ignorecase " with smartcase
set smartcase  " lower upperのみのときはignorecaseしない

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
" finish loading vimrc if tiny or small version.
"------------------------------------
if !1 | finish | endif


"------------------------------------
" nomal mode key binding custumize
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


"------------------------------------
" command line key binding
"------------------------------------
cnoremap fuck q!

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
