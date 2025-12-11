return {
  "XXiaoA/atone.nvim",
  event = "BufReadPost",
  opts = {
    -- Optional: customize window position/size
    window = {
      position = "left",
      width = 30,
    },
    -- Optional: diff settings
    diff = {
      enabled = true,
      wrap = false,
    },
  },
  keys = {
    { "<leader>u", "<cmd>Atone toggle<cr>", desc = "Toggle undo tree" },
  },
}
