local mason_bin = vim.fn.stdpath('data') .. '/mason/bin/'
vim.env.PATH = mason_bin .. vim.env.PATH

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

-- Lua Language Server
vim.lsp.config.lua_ls = {
  capabilities = capabilities,
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.git', 'init.lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
    },
  },
}

-- Rust Analyzer
vim.lsp.config.rust_analyzer = {
  capabilities = capabilities,
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { '.git', 'Cargo.toml' },
  settings = {
    ['rust-analyzer'] = {
      check = { command = 'clippy' },
      cargo = { loadOutDirsFromCheck = true },
    },
  },
}

-- Pyright
vim.lsp.config.pyright = {
  capabilities = capabilities,
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { '.git', 'pyproject.toml', 'setup.py' },
  settings = {
    python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } },
  },
}

-- Enable the servers
vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'pyright' })

-- Error messages
vim.diagnostic.config({
  virtual_text = {
    prefix = '|',
    source = 'if_many',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true
})
