local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

-- Lua Language Server
vim.lsp.config.lua_ls = {
  capabilities = capabilities,
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.git', 'init.lua', '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      semanticTokens = { enable = true },
    },
  },
}

vim.lsp.config.nixd = {
  capabilities = capabilities,
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  -- settings = {
  --   ['nil'] = {
  --     nix = {
  --       flake = {
  --         autoArchive = true,
  --         autoEvalInputs = true,
  --       },
  --     },
  --   },
  -- },
}

-- QML LS
vim.lsp.config.qmlls = {
  capabilities = capabilities,
  cmd = { 'qmlls', "-E" },
  filetypes = { 'qml' },
  root_markers = { '.git', 'CMakeLists.txt', 'qmldir', '.qmlls.ini' },
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
      procMacro = { enable = true },
      semanticTokens = { enable = true },
    },
  },
}

-- BasedPyright (enhanced pyright with semantic highlighting)
vim.lsp.config.basedpyright = {
  capabilities = capabilities,
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { '.git', 'pyproject.toml', 'setup.py', 'pyproject.toml' },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      semanticTokens = true,
      },
    },
  },
}

-- Gopls
vim.lsp.config.gopls = {
  capabilities = capabilities,
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { '.git', 'go.mod' },
  settings = {
    gopls = {
      semanticTokens = true,
    }
  }
}

-- Enable the servers
vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'basedpyright', 'gopls', 'qmlls', 'nills' })



-- Error messages (virtual_text disabled - handled by tiny-inline-diagnostic)
vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true
})
