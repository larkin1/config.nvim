-- Lazy
require("config.lazy")
require("config.lsp")
require("mason").setup()

-- Indents
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- Kebindings
vim.g.mapleader = ' '
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>")
