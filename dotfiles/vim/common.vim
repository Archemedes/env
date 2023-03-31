" Configuration I use both for vim and neovim

map <space> <leader>

" Join Lines with new keybinding
nnoremap <leader>j J
nnoremap <leader>J :m-2<CR>J

" Commands to more easily switch between splits 
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

function! StartOfLine()
    let pos = getcurpos()[2]
    normal! ^
    if pos == getcurpos()[2]
        normal! 0
    endif
endfunction

nnoremap <silent> 0 :<C-U>call StartOfLine()<CR>

" Some FZF keybindings that are useful
nmap <leader>g :GFiles<CR>
nmap <leader>l :Lines<CR>
nmap <leader>b :Buffer<CR>

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
    silent exec "!black %"
    " silent exec "!autopep8 --in-place --ignore=E731 %"
    " silent exec "!autoflake8 --in-place %"
    redraw!
    e!
endfunction

nnoremap <leader>cq :call FormatPython()<CR>
