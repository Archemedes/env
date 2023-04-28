" Configuration I use both for vim and neovim

map <space> <leader>

set nofixeol   " Mimic IntelliJ, which doesnt add eols I think
set clipboard=unnamed  " Use system clipboard for yanks
set ignorecase " Search is case-insensitive by default
set smartcase  " Search becomes case-sensitive if anything is uppercase
set cursorline " Highlight the line on which the cursor lives.
set scrolloff=1 " Show some lines above/below the cursor.
set number         " Line numbers
set relativenumber " Relative line numbers

set autoindent
set smartindent

" Note nvim 0.9 supports .editorconfig which should override this
set tabstop=4
set expandtab
set shiftwidth=4

" Enable folding
set foldmethod=indent
set foldlevel=99
set foldminlines=4

set timeoutlen=500 " Mapping timeout
set ttimeoutlen=20 " Keychord timeout
set updatetime=100 " time vim writes to swapfile; quicker vim gutter updates

" Move between buffers, vimium-style
nnoremap J :bp<CR>
nnoremap K :bn<CR>

" Join Lines with new keybinding
nnoremap <leader>j J
nnoremap <leader>J :m-2<CR>J

nnoremap <leader><space> <C-^>

" Commands to more easily switch between splits 
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Terminal CTRL commands for line navigation
imap <C-a> <home>
imap <C-e> <end>
cmap <C-a> <home>
cmap <C-e> <end>

function! StartOfLine()
    let pos = getcurpos()[2]
    normal! ^
    if pos == getcurpos()[2]
        normal! 0
    endif
endfunction

nnoremap <silent> 0 :<C-U>call StartOfLine()<CR>

" Turn off search highlighting
nnoremap <leader>/ :nohl<CR>
"Easily exit buffer
nnoremap <leader>q :bd<CR>

" Moving lines up or down through other lines
nnoremap <M-J> :m .+1<CR>==
nnoremap <M-K> :m .-2<CR>==
vnoremap <M-J> :m '>+1<CR>gv=gv
vnoremap <M-K> :m '<-2<CR>gv=gv

function! JumpToNextWord(bw)
    for i in range(max([1,v:count]))
        if a:bw
            normal b
        else
            normal w
        endif
        while strpart(getline('.'), col('.')-1, 1) !~ '\w'
            if a:bw
                normal b
            else
                normal w
            endif
        endwhile
    endfor
endfunction

" Put macros on Q (stop butterfingering macro activate)
noremap Q q
" then put q for more inclusive w search
noremap <silent> <Tab> :<C-U>call JumpToNextWord(0)<CR>

function! FormatPython()
    silent exec "!isort -q %"
    " silent exec "!black %"
    silent exec "!autopep8 --in-place --ignore=E731 %"
    silent exec "!autoflake8 --in-place %"
    redraw!
    e!
endfunction

nnoremap <leader>cq :call FormatPython()<CR>
