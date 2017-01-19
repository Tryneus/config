set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "custom"
hi Normal       gui=none
hi NonText      gui=none
hi comment      ctermfg=8
hi constant     ctermfg=42
hi identifier   ctermfg=9
hi statement    ctermfg=111
hi preproc      ctermfg=111
hi type         ctermfg=179
hi special      ctermfg=155
hi ErrorMsg     gui=none
hi WarningMsg   gui=none
hi Error        gui=none
hi Todo         gui=none
hi Cursor       gui=none
hi Search       ctermfg=white ctermbg=none cterm=bold
hi IncSearch    gui=none
hi LineNr       ctermbg=234
hi title        gui=none
hi StatusLineNC gui=none
hi StatusLine   gui=none
hi label        gui=none
hi operator     gui=none
hi Visual       term=reverse cterm=reverse gui=reverse
hi ColorColumn  ctermbg=234

