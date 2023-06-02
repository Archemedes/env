set nocompatible
set encoding=UTF-8

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
Plug 'junegunn/fzf'              " Full path fuzzy search
Plug 'junegunn/fzf.vim'          " Need main plugin as well as vimhook

Plug 'tpope/vim-fugitive'        " Git integration
Plug 'tpope/vim-surround'        " Surround things with brackets
Plug 'tpope/vim-commentary'      " Commenting with gc
Plug 'tpope/vim-repeat'          " dot operator for plugins
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'airblade/vim-gitgutter'    " Show what is modified in a file
Plug 'machakann/vim-swap'        " Swapping function arguments
Plug 'machakann/vim-highlightedyank'

Plug 'rakr/vim-one'              " onedark / onelight themes
Plug 'bling/vim-bufferline'      " Buffers as tabs in the airline
Plug 'vim-airline/vim-airline'   " Status line plugin

Plug 'khaveesh/vim-fish-syntax'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvie/vim-flake8'           " Automatic flake8 on F7
call plug#end()

" Set up the color theme of the terminal
set termguicolors " Use 24-bit true colors

let g:one_allow_italics = 1 " Italics for comments
" let g:airline_theme='one'   " For the statusline at the bottom

" Airline Commands
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline_section_b = '%-0.30{airline#util#wrap(airline#extensions#branch#get_head(),15)}'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " When document is utf-8 doesn't show
let g:airline_section_x = ''
let g:airline_symbols = {}
let g:airline_symbols.notexists = '🔕'
let g:airline#extensions#coc#enabled = 0

let g:highlightedyank_highlight_duration = 150

" So that on inactive windows only the currently opened file + path is shown
function! Render_Only_File(...)
  let builder = a:1
  let context = a:2
  call builder.add_section('airline_b', '!! %F')
  return 1   " modify the statusline with the current contents of the builder
endfunction
silent! call airline#add_inactive_statusline_func('Render_Only_File')


let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'L',
    \ '': 'B',
    \ ''   : 'V',
    \ 's'  : 'S',
    \ }

let g:bufferline_echo = 0
let g:bufferline_modified = ' ✏️ '

set background=dark
silent! colorscheme one
highlight HighlightedyankRegion term=reverse ctermbg=17 guibg=#3e4452

let g:markbar_peekaboo_marks_to_display = '''.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:markbar_peekaboo_width= 50

" put method def under cursor
map <leader>m [mw


" Yank till end of line with Y
map Y yg_

" fix meta-keys which generate <Esc>a .. <Esc>z
" This lets alt+Letter commands work without also stalling <ESC>
let c='a'
while c <= 'z'
  exec "set <M-".toupper(c).">=\e".c
  exec "imap \e".c." <M-".toupper(c).">"
  let c = nr2char(1+char2nr(c))
endw

" To move around in insert mode
imap <A-J> <down>
imap <A-K> <up>
imap <A-H> <left>
imap <A-L> <right>

" Manually refresh file
nmap <F5> :e!<cr>

"Line Number Keybinds, wont work in insert
noremap <F9> :set relativenumber!<CR>
noremap <F8> :set number!<CR>

" Create textobjects using [z and ]z
vnoremap iz :<C-U>silent!normal![zV]z<CR>
onoremap iz :normal Viz<CR>

" Create textobjects for parts between underlines
vnoremap iu :<C-U>silent!normal!T_vt_<CR>
onoremap iu :normal viu<CR>
vnoremap au :<C-U>silent!normal!F_vf_<CR>
onoremap au :normal viu<CR>

" tnoremap <Esc> <C-\><C-n>
" tnoremap <C-v><Esc> <Esc>

" Toggle auto change directory
" map <F8> :set autochdir! autochdir?<CR>

set incsearch  " Start searching from the first keystroke
set hlsearch   " Highlight search matches in text

set backspace=indent,eol,start

set hidden         " Change buffer without having to save right away
set splitright     " Open vertical split to the right of current file
set lazyredraw     " Only redraws at end of macro/paste/nontyped command (for performance)
set wildmenu       " This shows suggestions in statusbar on tab
set undofile       " Persistent undos between vim sessions
set undodir=$HOME/.vim/undo//

" Automatically set directory to file being edited
" Version that respects plugin directory assumptions
autocmd BufEnter * silent! lcd %:p:h

" This gives you a bar cursor in insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" Draw a better cursor for insert mode
autocmd InsertEnter,InsertLeave * set cul!

" Restore last position of previously closed file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif 

" autocmd BufWritePost *.py call flake8#Flake8()

if has('terminal') "Terminal One-Dark colors.
    let g:terminal_ansi_colors = [
    \  '#282c34',
    \  '#e06c75',
    \  '#98c379',
    \  '#e5c07b',
    \  '#61afef',
    \  '#be5046',
    \  '#56b6c2',
    \  '#979eab',
    \  '#393e48',
    \  '#d19a66',
    \  '#56b6c2',
    \  '#e5c07b',
    \  '#61afef',
    \  '#be5046',
    \  '#56b6c2',
    \  '#abb2bf',
    \ ]
endif " Should make kitty -> vim integration smooth

" Substitute in line
vnoremap <leader>s "zy:s/<C-r>z//g<Left><Left>
nnoremap <leader>s "zyiw:s/<C-r>z//g<Left><Left>

" For coc.nvim completion options follow below

set shortmess+=c " don't give ins-completion-menu messages
set signcolumn=number " Merges error/warning column with the linenumber column

function! ToggleSignColumn()
    if &signcolumn == 'no'
      let &signcolumn='number'
    else
      let &signcolumn='no'
    endif
endfunction

" Hiding the hunks to show the line numbers better (if these are merged)
nnoremap <F12> :call ToggleSignColumn()<CR>
vnoremap <F12> :call ToggleSignColumn()<CR>

" Fugitive keybinds
nmap <leader>cm :G commit -m ""<left>
nmap <leader>ce :G amend -n<CR>

" Some FZF keybindings that are useful
nmap <leader>g :GFiles<CR>
nmap <leader>l :Lines<CR>
nmap <leader>b :Buffer<CR>

" Have the coc-settings.json file in .config
let g:coc_config_home = '~/.config/vim/'

" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" <Tab> accepts completion
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<C-g>u\<TAB>"

" Symbol renaming.
nmap <leader>cr <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>cp <Plug>(coc-format-selected)
nmap <leader>cp <Plug>(coc-format-selected)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
xmap <leader>ca  <Plug>(coc-codeaction-selected)
" Apply AutoFix to problem on the current line.
nmap <leader>cf  <Plug>(coc-fix-current)

nmap <leader>cd  :<C-u>CocList diagnostics<cr>
nmap <leader>co  :<C-u>CocList outline<cr>
nmap <leader>cc  :<C-u>CocList commands<cr>

" Use K to show documentation in preview window.
nnoremap <silent> <leader>i :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

augroup trailing_whitespace
    autocmd!
    autocmd FileType python,json autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd FileType python autocmd BufWritePre <buffer> silent! %s#\($\n\s*\)\+\%$##
augroup ENDC

augroup pythonconfig
    autocmd FileType python let b:coc_root_patterns = ['pyrightconfig.json']
    autocmd FileType python setlocal colorcolumn=120
augroup END

function! CreateTerminalInstance()
    execute "vertical terminal"
    let l:bufnr = bufnr('$')
    if l:bufnr
        call setbufvar(bufnr, "buflisted", 0)
    endif
endfunction

nnoremap <silent> <leader>t :<C-u>call CreateTerminalInstance()<CR>
" augroup open_term
"     autocmd!
"     autocmd TerminalOpen * setlocal nobuflisted
" augroup ENDC

function! FindImport()
    let wordUnderCursor = expand("<cword>")
    let @z = system('find-import ' . wordUnderCursor)
    if @z =~ '\[PYFLYBY\]'
        echo "Import not found: " . wordUnderCursor
    else
        normal! 1G"zPjx``
        echon "Resolved Import: " . @z
    endif
endfunction
