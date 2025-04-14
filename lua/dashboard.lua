-- Dashboard configuration with beautiful welcome screen
local M = {}

-- Configure the dashboard startup screen
function M.setup()
  -- Define the dashboard options
  local dashboard = require("alpha.themes.dashboard")
  
  -- Custom header with Neovim ASCII art
  dashboard.section.header.val = {
    [[                                                       ]],
    [[                                                       ]],
    [[   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ]],
    [[   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ]],
    [[   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ]],
    [[   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
    [[   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
    [[   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
    [[                                                       ]],
    [[      ⟦ Ultimate ALL Development Environment ⟧          ]],
    [[                                                       ]],
  }
  
  -- Define the menu buttons
  dashboard.section.buttons.val = {
    dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
    dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("g", "  Find word", ":Telescope live_grep <CR>"),
    dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
    dashboard.button("p", "  Plugins", ":e ~/nvim-config/lua/plugins/backend-essentials.lua <CR>"),
    dashboard.button("t", "  Terminal", ":ToggleTerm direction=float<CR>"),
    dashboard.button("y", "  Python Environment", ":VenvSelect<CR>"),
    dashboard.button("m", "  Key Mappings", ":e ~/nvim-config/lua/mappings.lua <CR>"),
    dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
  }
  
  -- Footer with quote
  local function footer()
    local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
    local version = vim.version()
    local nvim_version = "  v" .. version.major .. "." .. version.minor .. "." .. version.patch
    
    return datetime .. " " .. nvim_version
  end
  
  dashboard.section.footer.val = footer()
  
  -- Customize colors and layout
  dashboard.section.header.opts.hl = "AlphaHeader"
  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.section.footer.opts.hl = "AlphaFooter"
  
  dashboard.opts.layout = {
    { type = "padding", val = 2 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 2 },
    dashboard.section.footer,
  }
  
  -- Load alpha with our dashboard configuration
  require("alpha").setup(dashboard.opts)

  -- Create autocmd to open dashboard when Neovim starts with no arguments
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
        require("alpha").start()
      end
    end,
  })
  
  -- Create highlight groups for the dashboard
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      -- Get colors from current colorscheme
      local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
      local fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
      local accent = vim.api.nvim_get_hl(0, { name = "String" }).fg
      local muted = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
      
      -- Apply dashboard highlights
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = accent, bg = bg })
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = fg, bg = bg })
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = muted, bg = bg })
    end,
  })
end

return M
