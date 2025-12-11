return {
  "catppuccin/nvim", 
  name = "catppuccin", 
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        blink_cmp = {
          style = "bordered",
        }
      }
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}
