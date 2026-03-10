return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VimEnter',
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    -- Color interpolation function
    local function interpolate_color(color1, color2, factor)
      local r1 = tonumber(color1:sub(2, 3), 16)
      local g1 = tonumber(color1:sub(4, 5), 16)
      local b1 = tonumber(color1:sub(6, 7), 16)
      local r2 = tonumber(color2:sub(2, 3), 16)
      local g2 = tonumber(color2:sub(4, 5), 16)
      local b2 = tonumber(color2:sub(6, 7), 16)
      
      local r = math.floor(r1 + (r2 - r1) * factor)
      local g = math.floor(g1 + (g2 - g1) * factor)
      local b = math.floor(b1 + (b2 - b1) * factor)
      
      return string.format("#%02x%02x%02x", r, g, b)
    end

    -- Apply border colors, then gradient to remaining chars
    local function apply_colors_then_gradient(text_lines, char_color, start_color, end_color)
      local shadow_chars = { ["╚"] = true, ["═"] = true, ["╝"] = true, 
                            ["║"] = true, ["╔"] = true, ["╗"] = true }
      local shadow_hl = "AlphaShadow"
      local total_lines = #text_lines
      local utf8_pattern = "[%z\1-\127\194-\244][\128-\191]*"
      
      vim.api.nvim_set_hl(0, shadow_hl, { fg = char_color })
      
      local result = {}
      for line_idx, line in ipairs(text_lines) do
        -- Calculate gradient color for this line
        local factor = (line_idx - 1) / math.max(1, total_lines - 1)
        local gradient_color = interpolate_color(start_color, end_color, factor)
        local gradient_hl = "AlphaGradient" .. line_idx
        vim.api.nvim_set_hl(0, gradient_hl, { fg = gradient_color })
        
        local segments = {}
        local current_text = ""
        local current_is_shadow = nil
        
        for char in line:gmatch(utf8_pattern) do
          local is_shadow = shadow_chars[char] ~= nil
          
          if current_is_shadow == nil then
            current_is_shadow = is_shadow
            current_text = char
          elseif current_is_shadow == is_shadow then
            current_text = current_text .. char
          else
            table.insert(segments, { 
              text = current_text, 
              hl = current_is_shadow and shadow_hl or gradient_hl 
            })
            current_is_shadow = is_shadow
            current_text = char
          end
        end
        
        if current_text ~= "" then
          table.insert(segments, { 
            text = current_text, 
            hl = current_is_shadow and shadow_hl or gradient_hl 
          })
        end
        
        table.insert(result, segments)
      end
      
      return result
    end

    -- Track last opened files
    local last_global_file = nil
    local last_dir_files = {}

    local function load_last_files()
      local global_file = vim.fn.stdpath('data') .. '/last_file.txt'
      if vim.fn.filereadable(global_file) == 1 then
        last_global_file = vim.fn.readfile(global_file)[1]
      end

      local dir_file = vim.fn.stdpath('data') .. '/dir_files.json'
      if vim.fn.filereadable(dir_file) == 1 then
        local content = vim.fn.readfile(dir_file)[1]
        local ok, decoded = pcall(vim.json.decode, content)
        if ok then
          last_dir_files = decoded
        end
      end
    end

    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*',
      callback = function()
        local file = vim.fn.expand('%:p')
        if file ~= '' and vim.fn.filereadable(file) == 1 then
          last_global_file = file
          vim.fn.writefile({file}, vim.fn.stdpath('data') .. '/last_file.txt')

          local cwd = vim.fn.getcwd()
          last_dir_files[cwd] = file
          vim.fn.writefile({vim.json.encode(last_dir_files)}, vim.fn.stdpath('data') .. '/dir_files.json')
        end
      end,
    })

    load_last_files()

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
    
    -- Apply colors: borders (#313244), then gradient (#cba6f7 to #f9e2af)
    local colored_lines = apply_colors_then_gradient(logo_lines, "#585b70", "#cba6f7", "#fab387")
    
    -- Convert to alpha format (byte positions for highlights)
    local header_val = {}
    for _, line_segments in ipairs(colored_lines) do
      local full_line = ""
      local hl_positions = {}
      local byte_pos = 0
      
      for _, segment in ipairs(line_segments) do
        local text_bytes = #segment.text
        table.insert(hl_positions, { segment.hl, byte_pos, byte_pos + text_bytes })
        full_line = full_line .. segment.text
        byte_pos = byte_pos + text_bytes
      end
      
      table.insert(header_val, {
        type = "text",
        val = full_line,
        opts = { hl = hl_positions, position = "center" },
      })
    end
    
    dashboard.section.header = {
      type = "group",
      val = header_val,
      opts = { position = "center", spacing = 0 },
    }

    -- Build buttons
    local buttons = {
      dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('f', '  Find file', ':Telescope find_files<CR>'),
      dashboard.button('r', '  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button('g', '  Find text', ':Telescope live_grep<CR>'),
    }

    if last_global_file then
      local name = vim.fn.fnamemodify(last_global_file, ':t')
      table.insert(buttons, dashboard.button('l', '  Last file (global): ' .. (name:len() > 30 and '...' .. name:sub(-27) or name), ':e ' .. vim.fn.fnameescape(last_global_file) .. '<CR>'))
    else
      table.insert(buttons, dashboard.button('l', '  Last file (global): <none>', ':echo "Open a file first!" | sleep 1<CR>'))
    end

    local last_dir_file = last_dir_files[vim.fn.getcwd()]
    if last_dir_file then
      local name = vim.fn.fnamemodify(last_dir_file, ':t')
      table.insert(buttons, dashboard.button('d', '  Last file (dir): ' .. (name:len() > 30 and '...' .. name:sub(-27) or name), ':e ' .. vim.fn.fnameescape(last_dir_file) .. '<CR>'))
    else
      table.insert(buttons, dashboard.button('d', '  Last file (dir): <none>', ':echo "Open a file in this dir first!" | sleep 1<CR>'))
    end

    table.insert(buttons, dashboard.button('q', '  Quit', ':qa<CR>'))
    dashboard.section.buttons.val = buttons

    dashboard.section.footer.val = '  ' .. os.date('%Y-%m-%d %H:%M:%S')

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
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaClosed',
      callback = function()
        vim.opt.showtabline = 2
        vim.opt.laststatus = 2
      end,
    })

    alpha.setup(dashboard.config)
  end,
}
