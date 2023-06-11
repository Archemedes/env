-- Suposedly makes <Tab> and <C-I> differentiable for nvim 0.7 and kitty terminals
if vim.env.TERM == 'xterm-kitty' then
  vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
  vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
  vim.keymap.set('n', '<c-i>', '<c-i>')  -- Redundant to actually split the two keybinds
end

vim.cmd("source " .. vim.fn.expand('~') .. '/.config/vim/common.vim')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')

-- Folding based on TreeSitter; shoud be slightly better for python
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

vim.cmd [[hi lualine_c_normal gui=bold guifg=#dddddd]]
vim.cmd [[hi CursorLineNR gui=bold guifg=#dddddd]]

vim.cmd "autocmd BufEnter * silent! lcd %:p:h" -- Automatically set directory to file being edited
vim.cmd "autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='MatchParen', timeout=250}" -- Highlighted yank text
