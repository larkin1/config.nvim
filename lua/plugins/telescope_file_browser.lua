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
          depth = 4,
          -- auto_depth = true,
          hidden = {file_browser = true, folder_browser = true},
                  },
      },
      defaults = {
        file_ignore_patterns = {
          -- VCS
          "/%.git/",

          -- Python
          "/%.venv/",
          "/%venv/",
          "/%__pycache__/",
          "/%.pytest_cache/",
          "/%.mypy_cache/",
          "/%.ruff_cache/",
          "/%.tox/",
          "/%.coverage$",
          "/%htmlcov/",

          -- Rust
          "/%target/",

          -- JS / TS
          "/%node_modules/",
          "/%dist/",
          "/%build/",
          "/%.next/",
          "/%.turbo/",
          "/%.parcel-cache/",
          "/%coverage/",

          -- Go
          "/%bin/",
          "/%out/",
          "/%.gocache/",
          "/%cover.out$",

          -- Generic build / cache
          "/%.cache/",
          "/%.idea/",
          "/%.vscode/",
          "/%.DS_Store",
          "/%Thumbs.db",
        },
      }
    })
    require('telescope').load_extension('file_browser')
  end,
}
