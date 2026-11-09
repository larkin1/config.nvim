-- Leader keys (must be set before lazy)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Filetype detection
vim.filetype.add({
  extension = {
    tape = 'vhs',
  },
})

-- Lazy
require("config.lazy")
require("config.lsp")
local helpers = require("helpers")

-- Indents
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- Kebindings

-- Run current file
vim.keymap.set("n", "<leader>r", helpers.run_current_file, {silent = true})

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "Browse" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })

-- Trouble (diagnostics panel)
vim.keymap.set("n", "<leader>t", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics panel" })

-- Atone (undo tree)
vim.keymap.set("n", "<leader>u", "<cmd>Atone toggle<CR>", { desc = "Toggle undo tree" })

-- Initial Config
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.updatetime = 250
