"------------------------------------
" nomal(command) mode key binding custumize
"------------------------------------
" Insert line break by Enter in normal mode
augroup NormalModeBreak
  autocmd!
  autocmd NormalModeBreak BufWinEnter *
  \  if &modifiable
  \|   nnoremap <buffer> <CR> i<CR><ESC>
  \| else
  \|   nunmap <buffer> <CR>
  \| endif
augroup END

" add blank line
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
