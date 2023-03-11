"unmap default keybind
":unmap <C-k>
if exists('g:vscode')
  exec 'source ' . $HOME . '/.config/nvim/vscode.vim'
else
  exec 'source ' . $HOME . '/.config/nvim/mappings.vim'
  set statusline=%F%m%r%h%w%=\ %{fugitive#statusline()}\ [%{&ff}:%{&fileencoding}]\ [%Y]\ [%04l,%04v]\ [%l/%L]\ %{strftime(\"%Y/%m/%d\ %H:%M:%S\")}
endif

"------------------------------------
" Open & Reload .vimrc
"------------------------------------
command! Evimrc edit $MYVIMRC

augroup source-vimrc
  autocmd!
  autocmd BufWritePost *vimrc source $MYVIMRC | set foldmethod=marker
  autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
augroup END

"------------------------------------
" vim files
" note: xdg sample https://blog.joren.ga/vim-xdg
"------------------------------------
" nvim
set directory=$XDG_STATE_HOME/vim/swap
set backupdir=$XDG_STATE_HOME/vim/backup
set undodir=$XDG_STATE_HOME/vim/undo
set viewdir=$XDG_STATE_HOME/vim/view
set viminfofile=$XDG_STATE_HOME/vim/viminfo
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after
set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after
let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)

"------------------------------------
" input mode settings
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

"------------------------------------
" normal mode settings
"------------------------------------
set ignorecase
set smartcase " require ignorecase

"------------------------------------
" Normal, Visual, Select, Operator-pendin mode key binding
"------------------------------------
noremap g<c-a> <ESC>ggvGV
noremap <Space>h ^
noremap <Space>l $

" test
nnoremap "" /""<CR>l
nnoremap '' /''<CR>l
nnoremap NN /<\([^>/]\+\)><\/\1><CR>/<<CR>
nnoremap MM ?<<CR>h?<\([^>/]\+\)><\/\1><CR>/<<CR>

"------------------------------------
" nomal(command) mode key binding custumize
"------------------------------------
" move lines up, down  e.g 2[e = 2 lines up
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>

"  nnoremap <CR> i<Return><Esc>^k

" wsl ヤンクでクリップボードにコピー
if system('uname -a | grep -i microsoft') != ''
  augroup myYank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe', @")
  augroup END
end
