return function(c, hl)
  local path = vim.fn.expand("~/.cache/matugen/nvim-colors.json")
  local ok, x = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok then return end

  local map = {
    { x.syn_purple, { "@keyword", "@keyword.function", "@keyword.return", "@keyword.conditional", "@keyword.repeat", "@keyword.import", "@keyword.operator", "@keyword.modifier", "@label", "@lsp.type.keyword" } },
    { x.syn_cyan,   { "@function", "@function.call", "@function.builtin", "@function.method", "@function.method.call", "@lsp.type.function", "@lsp.type.method" } },
    { x.syn_blue,   { "@variable.member", "@property", "@lsp.type.property" } },
    { x.syn_yellow, { "@type", "@type.builtin", "@type.definition", "@constructor", "@module", "@lsp.type.type", "@lsp.type.class", "@lsp.type.struct", "@lsp.type.enum", "@lsp.type.interface", "@lsp.type.typeParameter", "@lsp.type.namespace" } },
    { x.syn_green,  { "@string", "@lsp.type.string" } },
    { x.syn_orange, { "@number", "@number.float", "@boolean", "@constant", "@lsp.type.number", "@lsp.type.enumMember" } },
    { x.syn_orange, { "@variable.builtin", "@variable.parameter.builtin", "@constant.builtin", "@module.builtin" }, { italic = true } },
    { x.syn_cyan,   { "@function.macro", "@lsp.type.macro" }, { bold = true } },
    { x.syn_pink,   { "@attribute", "@attribute.builtin", "@lsp.type.decorator" } },
    { x.syn_purple, { "@keyword.exception" } },
    { x.syn_pink,   { "@string.escape", "@string.regexp", "@string.special", "@string.special.path", "@string.special.symbol", "@character.special", "@punctuation.special" } },
    { x.syn_pink,   { "@string.special.url" }, { underline = true } },
    { c.on_surface, { "@variable.parameter", "@lsp.type.parameter" }, { italic = true } },
  }
  for _, m in ipairs(map) do
    if m[1] then
      for _, g in ipairs(m[2]) do
        hl(g, vim.tbl_extend("force", { fg = m[1] }, m[3] or {}))
      end
    end
  end
end
