return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  priority = 1000,
  build = ':TSUpdate',
  config = function()
    -- Register VHS parser (third-party)
    require('nvim-treesitter.parsers').vhs = {
      install_info = {
        url = 'https://github.com/charmbracelet/tree-sitter-vhs',
        files = { 'src/parser.c' },
        branch = 'main',
        queries = 'queries',
      },
    }
    
    -- Auto-install core parsers + VHS on startup
    vim.defer_fn(function()
      require('nvim-treesitter').install({
        'go', 'lua', 'python', 'rust', 'javascript', 'typescript', 'json', 'yaml', 'toml', 'vhs'
      })
    end, 100)
    
    -- Enable treesitter highlighting for configured languages
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'go', 'lua', 'python', 'rust', 'javascript', 'typescript', 'json', 'yaml', 'toml', 'vhs' },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
