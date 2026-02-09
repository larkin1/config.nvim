return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },

  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
   keymap = { preset = 'default' },

    appearance = {
     nerd_font_variant = 'mono'
    },

    completion = { documentation = { auto_show = true } },

    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = {
      enabled = true,
      window = { show_documentation = true },
    },
  },
  opts_extend = { "sources.default" },
}
