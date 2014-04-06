" echom "Welcome to the desert of the real."
" Some debugging notes:
"  Check called scripts with   -  :scriptnames
"  Check buffer syntax with    -  :setlocal syntax?
"  For a deeper look at syntax -  :syntax list
"  Also                        -  :verbose set ft?
"  ...and                      -  :e $VIMRUNTIMWE/ftplugin

filetype plugin indent on
syntax on
set hlsearch 
set incsearch

execute pathogen#infect()
call pathogen#incubate()
call pathogen#helptags()

" light only
" colorscheme default
" colorscheme delek
" dark only
colorscheme evening
colorscheme solarized
" colorscheme molokai

" Use when displaying bad whitespace
highlight BadWhitespace ctermbg=gray

" Turn off settings in 'formatoptions' relating to comment formatting.
" - c : do not automatically insert the comment leader when wrapping based on
"    'textwidth'
" - o : do not insert the comment leader when using 'o' or 'O' from command mode
" - r : do not insert the comment leader when hitting <Enter> in insert mode
" turn off auto-commenting when going to a new line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Erlang comment string for use with vim-commentary
autocmd FileType erlang set commentstring=%\ %s
" R comment string for use with vim-commentary
autocmd FileType r set commentstring=#\ %s
" AsciiDoc
autocmd FileType asciidoc set commentstring=//\ %s


" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h,*.cpp,*.cxx,*.pl,*.sh,*.js,*.hs set fileformat=unix
"
" Set the default file encoding to UTF-8: 
set encoding=utf-8

" Show matching brackets
set showmatch 

" automaitcally write before compiling. Undo with :set noautowrite
set autowrite

" Keep the last 200 commands (default is 20)
set history=200 
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" show me more of the command window (for HLint, etc.)
set cmdheight=2

" make backspace a more flexible
set backspace=indent,eol,start 

" nnoremap - ddp
" nnoremap + ddkP

" see http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
" You cannot copy and paste these commands?
" map {C-v}{Shift-Down} O{C-v}{Esc}j, etc.
"  This seems to work even w/o shift...nnoremap OB Oj

" nnoremap <Up> :set number!<cr>
" nnoremap <Down> Oj

" set the leader (and local leader?) for more complex mappings
let mapleader="-"
" let maplocalleader="-"

nnoremap <Up> ddkP
nnoremap <Down> ddp
nnoremap <Left> :bp<cr>  
nnoremap <Right> :bn<cr>

" mode specific mappings
inoremap <c-d> <esc>ddi
inoremap <c-u> <esc>viwUea
nnoremap <c-u> viwUe
inoremap jk <esc> 
inoremap <leader>zz <esc>zza
inoremap <leader>zt <esc>zta
inoremap <leader>zb <esc>zba

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel

" wrap the currently visually selected block in quotes
vnoremap <leader>" <esc>a"<esc>`<i"<esc>`>f"

" get a split of the previous buffer
nnoremap <leader>pb :execute "rightbelow vsplit " . bufname("#")<cr>

" automatically make searches magic
nnoremap <leader>/ /\v
nnoremap <leader>? ?\v

" show invisible characters since this is always forgotten
nnoremap <leader>inv :setlocal list!<cr>

" toggle line numbers conveniently
nnoremap <leader>n :setlocal number!<cr>

" foldcolumn toggle
nnoremap <leader>f :call <SID>FoldColumnToggle()<cr>

function! s:FoldColumnToggle()
  if &foldcolumn
    setlocal foldcolumn=0
  else
    setlocal foldcolumn=4
  endif
endfunction

" quickfix toggle - uses a global var!
nnoremap <leader>q :call <SID>QuickfixToggle()<cr>
" we have to initialzie the global var
let g:quickfix_is_open = 0

function! s:QuickfixToggle()
  if g:quickfix_is_open
    cclose
    let g:quickfix_is_open=0
    execute g:quickfix_return_to_window . "wincmd w"
  else
    let g:quickfix_return_to_window = winnr()
    copen
    let g:quickfix_is_open=1
  endif
endfunction

"""""""""""""""""""""""""""""
" regex's
" note: nnoremap interprets <cr> before exe does, so we need 
" to use <lt> as a literal < to get the regex to work.
nnoremap <leader>c :noh<cr>
nnoremap <leader>w :execute "normal! gg" . '/\v\s+$' . "\<lt>cr>"<cr>

"""""""""""""""""""""""""""""
" Status Line
set laststatus=2
set statusline=%f
set statusline+=\ -\ 
set statusline+=%c
set statusline+=\ -\ 
set statusline+=%l/%L
set statusline+=\ -\ 
set statusline+=%n
set statusline+=\ -\ 
set statusline+=%y

"""""""""""""""""""""""""""""
" Abbreviations

iabbrev wwbr pax<cr>Gabe


"""""""""""""""""""""""""""""
" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
set tabstop=2

" What to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
set shiftwidth=2
set expandtab
au BufRead,BufNewFile Makefile* set noexpandtab


"""""""""""""""""""""""""""""
" Autocmd groups

" HTML
augroup filetype_html
  autocmd!
  autocmd FileType html nnoremap <buff> <localleader>f Vatzf
  let g:html_indent_inctags = "html,body,head,tbody"
augroup END

" Python
"  Assume python-mode (:help pymode.txt)
augroup filetype_python
  autocmd!
  " nnoremap <leader>p3 :execute "let g:pymode_python = 'python3'"<cr>
  " let g:pymode_python = 'python3'
  " most of this is handled by python-mode...
  " autocmd FileType python setlocal tabstop=4
  " autocmd FileType python setlocal softtabstop=4
  " autocmd FileType python setlocal shiftwidth=4
  " autocmd FileType python setlocal expandtab
  " Display tabs at the beginning of a line in Python mode as bad.
  " autocmd FileType python match BadWhitespace /^\t\+/ 
  " Make trailing whitespace be flagged as bad in Python
  " autocmd FileType python match BadWhitespace /\s\+$/
  " Wrap after 79 characters - needed? isn't clear what python-mode does...
  autocmd FileType python setlocal textwidth=79
augroup END

augroup filetype_cpp
  autocmd!
  " Make trailing whitespace be flagged as bad in Python
  " autocmd BufWinEnter *.cpp,*.cxx,*.h match BadWhitespace /\s\+$/
augroup END

augroup filetype_asciidoc
  autocmd!
  autocmd FileType asciidoc colorscheme molokai
augroup END



"""""""""""""""""""""""""""""
" Folding
" Code folding - set method to indent. Don't fold in plain text...
augroup vimrc
  au BufReadPre *\(*.txt\)\@<! setlocal foldmethod=indent
  au BufWinEnter * normal zR
augroup END

" Re-map "za" to space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<cr>
vnoremap <Space> zf


"""""""""""""""""""""""""""""
" use this function and the one below to restore cursor position when restarting a session
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    normal! zz
    return 1
  endif
endfunction
" use this function and the one above to restore cursor position when restarting a session
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"""""""""""""""""""""""""""""
" syntastic
" Python handled by python-mode, no?
" let g:syntastic_python_checkers=['flake8']
" let g:syntastic_cpp_compiler = 'g++-4.2'
let g:syntastic_cpp_checkers=['cpplint','cppcheck','gcc']
" let g:syntastic_html_checkers=['jshint','tidy','validator','w3']
let g:syntastic_html_checkers=['jshint']

" just to keep things tidy...
noh
