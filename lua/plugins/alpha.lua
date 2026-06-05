return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VimEnter',
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    local function build_header(lines, border_color, start_color, end_color)
      local border_chars = { ["╚"]=true, ["═"]=true, ["╝"]=true, ["║"]=true, ["╔"]=true, ["╗"]=true }
      local utf8 = "[%z\1-\127\194-\244][\128-\191]*"
      local n = #lines

      local function lerp_color(c1, c2, t)
        local function hex(s, i) return tonumber(s:sub(i, i+1), 16) end
        local r = math.floor(hex(c1,2) + (hex(c2,2) - hex(c1,2)) * t)
        local g = math.floor(hex(c1,4) + (hex(c2,4) - hex(c1,4)) * t)
        local b = math.floor(hex(c1,6) + (hex(c2,6) - hex(c1,6)) * t)
        return string.format("#%02x%02x%02x", r, g, b)
      end

      vim.api.nvim_set_hl(0, "AlphaBorder", { fg = border_color })

      local val = {}
      for i, line in ipairs(lines) do
        local hl_name = "AlphaGrad" .. i
        vim.api.nvim_set_hl(0, hl_name, { fg = lerp_color(start_color, end_color, (i-1) / math.max(1, n-1)) })

        local full, positions, byte = "", {}, 0
        -- group consecutive chars of the same type into segments
        local seg_text, seg_hl = "", nil
        local function flush()
          if seg_text ~= "" then
            table.insert(positions, { seg_hl, byte, byte + #seg_text })
            byte = byte + #seg_text
            full = full .. seg_text
            seg_text, seg_hl = "", nil
          end
        end
        for char in line:gmatch(utf8) do
          local hl = border_chars[char] and "AlphaBorder" or hl_name
          if hl ~= seg_hl then flush() end
          seg_text, seg_hl = seg_text .. char, hl
        end
        flush()

        table.insert(val, { type = "text", val = full, opts = { hl = positions, position = "center" } })
      end

      return { type = "group", val = val, opts = { position = "center", spacing = 0 } }
    end

    -- ASCII logo with gradient and shadow colors
    local logo_lines = {
      "                                                      ",
      "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                      ",
    }

    dashboard.section.header = build_header(logo_lines, "#585b70", "#cba6f7", "#fab387")

    -- Build buttons
    dashboard.section.buttons.val = {
      dashboard.button('n', '󰈔  New', ':ene <BAR> startinsert <CR>'),
      dashboard.button('f', '󰝒  Find file', ':Telescope file_browser<CR>'),
      dashboard.button('r', '󱈖  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button('g', '󱎸  Find text', ':Telescope live_grep<CR>'),
      dashboard.button('q', '󰜺  Quit', ':qa<CR>'),
    }

    dashboard.section.footer.val = 'Current time: ' .. os.date('%H:%M')

    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      dashboard.section.header,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      { type = 'padding', val = 2 },
      dashboard.section.footer,
    }

    -- Hide/show UI elements on dashboard
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function()
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
        vim.opt.ruler = false
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaClosed',
      callback = function()
        vim.opt.showtabline = 2
        vim.opt.laststatus = 2
        vim.opt.ruler = true
      end,
    })

    -- Disable some keys
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.fillchars = { eob = " " }
        local nops = { "i", "a", "o", "O", "s", "S", "v", "V", "<C-v>" }
        for _, key in ipairs(nops) do
          vim.keymap.set("n", key, "<Nop>", { buffer = true, silent = true })
        end
      end,
    })

    alpha.setup(dashboard.config)
  end,
}
