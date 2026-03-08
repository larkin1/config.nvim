return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    {
      "<leader>t",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Toggle diagnostics panel",
    },
  },
  config = function()
    require("trouble").setup({
      modes = {
        diagnostics = {
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
      },
    })
  end,
}
