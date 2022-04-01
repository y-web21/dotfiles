set nocompatible  " vi vim を別物 プラグインの誤動作を防止
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,sjis
"set fileencodings=iso-2022-jp,enc-jp,enc-jp,sjis,utf-8
set fileformat=unix
set expandtab  " tab 2 space
set tabstop=4
set shiftwidth=4
set softtabstop
set hlsearch
set showmatch  " 対応カッコをハイライト
set cindent
set showcmd
set ignorecase
set smartcase  " lower upperのみのときはignorecaseしない
set number
set ruler
set title
set visualbell
set backspace
" set clipboard  " yank to clipboard(not supported)
set list  " 不可視文字を表示する
set listchars=tab:>-,trail:.  " タブを >--- 半スペを . で表示する
language C  " system laguage english
syntax enable
set norestorescreen
set fileformats=unix,dos,mac    " newline char auto reco

" nomal mode key binding custumize
"(nmapは再帰的であるためループになる可能性があるのでnnoremap
" ソフトラップされた仮想的な行を含めて下にスクロール
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" nnoremap ; :
" nnoremap : ;

" command line key binding
cnoremap oden q!

" terminal key binding
" tnoremap x x

" no create temp files
" set noswapfile
" set nobackup
" set noundofile
" set viminfo=

"
" if exists('*mkdir') && !isdirectory('~/user/appfiles/vim')
"   call mkdir('~/user/appfiles/vim')
" endif

" temp files export destination
set directory=~/user/appfiles/vim
set backupdir=~/user/appfiles/vim
if has('persistent_undo')
  set undodir=~/user/appfiles/vim
  set undofile
endif
set viminfo+=n~/user/appfiles/vim/viminfo


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
set shell=/bin/bash


" 分岐処理いろいろ

if has("mac")
    " mac用の設定
elseif has("unix")
    " unix固有の設定
elseif has("win64")
    " 64bit_windows固有の設定
    set shell=C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe\ -executionpolicy\ bypass
elseif has("win32unix")
    " Cygwin固有の設定
elseif has("win32")
    " 32bit_windows固有の設定
elseif has("wsl")
    " wsl固有の設定 うまく動かないとの報告あり
endif

if ( has ('python') || has('python3') )
    " python が必要な設定をここに書く
else
    " python がないときの設定
endif
if has('lua')
    " lua が必要な設定
else
    " lua がないときの必要な設定
endif

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
