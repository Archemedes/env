" Configuration I use both for vim and neovim

map <space> <leader>

set nofixeol   " Mimic IntelliJ, which doesnt add eols I think
set clipboard=unnamed  " Use system clipboard for yanks
set ignorecase " Search is case-insensitive by default
set smartcase  " Search becomes case-sensitive if anything is uppercase
set cursorline " Highlight the line on which the cursor lives.
set noshowmode " Don't repeat the mode since airline shows it
set scrolloff=1 " Show some lines above/below the cursor.
set number         " Line numbers
set relativenumber " Relative line numbers

set autoindent
set smartindent

" Note nvim 0.9 supports .editorconfig which should override this
set tabstop=4
set expandtab
set shiftwidth=4

" Display different types of white spaces.
set list
set listchars=tab:!·,trail:•

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
nnoremap <C-c> <C-w>c

" Also for temrinal window
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

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

" This is substitute-in-word. Pretty useful
nnoremap S viwpyiw

" Turn off search highlighting
nnoremap <leader>/ :nohl<CR>
"Easily exit buffer
nnoremap <leader>q :bd<CR>
"Exit all EXCEPT this one
nnoremap <leader>Q :%bd\|e#\|bd#<CR>

" Deleting chars before cursor I never use, but delete line without polluting
" default register is very nice, so I make X that.
" My 'p' is sort of like an 'alternative' register
noremap X "pdd

" Custom register (p is easily combo'd) for commands I consider cut-only
noremap x "px
noremap c "pc
noremap cc "pcc
noremap C "pC
vnoremap p "pdP

" Moving lines up or down through other lines
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

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

function! JumpToNextUnderscore(bw)
    for i in range(max([1,v:count]))
        if a:bw
            " Search backwards for underscore followed by any character
            call search('[_-]\zs.', 'bW')
        else
            " Search forwards for underscore followed by any character
            call search('[_-]\zs.', 'W')
        endif
    endfor
endfunction

" Some useful word jumps
noremap <silent> <Tab> :<C-U>call JumpToNextWord(0)<CR>
noremap <silent> <S-Tab> :<C-U>call JumpToNextUnderscore(0)<CR>

" Put macros on Q (stop butterfingering macro activate)
noremap Q q


function! FormatPython()
    silent exec "!isort -q %"
    " silent exec "!black %"
    silent exec "!autopep8 --in-place --ignore=E731 %"
    silent exec "!autoflake8 --in-place %"
    redraw!
    e!
endfunction

nnoremap <leader>cq :call FormatPython()<CR>
