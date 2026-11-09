return function(c, hl)
  local path = vim.fn.expand("~/.cache/matugen/nvim-colors.json")
  local ok, x = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok then return end

  local map = {
    { x.syn_cyan,   { "@function", "@function.call", "@function.method", "@function.method.call", "@lsp.type.function", "@lsp.type.method" } },
    { x.syn_yellow, { "@type", "@type.builtin", "@lsp.type.type", "@lsp.type.class", "@lsp.type.struct", "@lsp.type.enum", "@lsp.type.interface" } },
    { x.syn_green,  { "@string", "@lsp.type.string" } },
    { x.syn_orange, { "@number", "@number.float", "@boolean", "@constant", "@constant.builtin", "@lsp.type.number", "@lsp.type.enumMember" } },
    { x.syn_purple, { "@keyword", "@keyword.function", "@keyword.return", "@keyword.conditional", "@keyword.repeat", "@keyword.import", "@keyword.operator", "@keyword.modifier", "@keyword.exception", "@lsp.type.keyword" } },

  }
  for _, m in ipairs(map) do
    if m[1] then
      for _, g in ipairs(m[2]) do hl(g, { fg = m[1] }) end
    end
  end
end
