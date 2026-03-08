return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  config = function()
    require('tiny-inline-diagnostic').setup({
      -- Show multiline diagnostics properly
      multilines = {
        enabled = true,
        always_show = false,
      },
      -- Don't break your layout
      virt_texts = {
        priority = 2048,
      },
    })
    -- Disable default virtual text to prevent conflicts
    vim.diagnostic.config({ virtual_text = false })
  end,
}
