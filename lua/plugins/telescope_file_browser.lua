return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function ()
    require('telescope').setup({
      extensions = {
        file_browser = {
          hijack_netrw = true,
          use_fd = true,
          respect_gitignore = vim.fn.executable('fd') == 1,
          depth = 1,
          auto_depth = true,
        },
      },
    })
    require('telescope').load_extension('file_browser')
  end,
}
