" unmap default keybind
" :unmap <C-k>
if exists('g:vscode')
  map <C-k> <Nop>
  map <C-j> <Nop>
  map <C-d> <Nop>
endif

" too slow and not work in penguin
" augroup wayland_clipboard
"     au!
"     au TextYankPost * call system("wl-copy", @")
" augroup END
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

nnoremap <CR> i<Return><Esc>^k
"" Insert line break by Enter in normal mode
" autocmd main BufWinEnter *
"  \  if &modifiable
"  \|   nnoremap <buffer> <CR> i<CR><ESC>
"  \| else
"  \|   nunmap <buffer> <CR>
"  \| endif

