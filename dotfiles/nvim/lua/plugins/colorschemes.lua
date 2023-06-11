onedark = {
    "navarasu/onedark.nvim",
    lazy=true,
    init = function() vim.cmd"colorscheme onedark" end,
    opts= { style = "deep" }
}



return {onedark}
