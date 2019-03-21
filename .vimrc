execute pathogen#infect()
syntax on

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
"set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

function! SetColorColumn()
  set virtualedit=all
  norm! g$
  let &colorcolumn=join(range(81,max([81,virtcol('.')])),",")
  set virtualedit=
endfunction

augroup setColorColumn
  autocmd!
  autocmd BufWinEnter * call SetColorColumn()
  autocmd VimResized * call SetColorColumn()
augroup END

set expandtab
set autoindent
set cindent
set number
set hlsearch

set tabstop=4
set softtabstop=4
set shiftwidth=4

colorscheme custom

"Make search results appear in the center of the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

nmap <F1> :TagbarToggle<CR>

set backspace=indent,eol,start
set clipboard=unnamed
set laststatus=2
set noshowmode
set ttimeoutlen=10
set tags=./tags,tags;$HOME
"let g:airline_powerline_fonts=1

filetype indent on

autocmd Filetype make setlocal noexpandtab
autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype coffee setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype python setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype json setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype c,cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype go setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype text setlocal nocindent nosmartindent indentexpr=
autocmd Filetype bash,sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype proto setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype markdown setlocal tabstop=2 softtabstop=2 shiftwidth=2

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
