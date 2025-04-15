-- Lualine config with tokyonight fallback
return {
  name = "lualine_config",
  config = function()
    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
      vim.notify("lualine.nvim not found. Please install nvim-lualine/lualine.nvim", vim.log.levels.WARN)
      return
    end
    
    -- Set up lualine with a safe theme that should work
    lualine.setup {
      options = {
        -- Use a theme that's likely to exist or else 'auto' as fallback
        theme = 'auto',
        icons_enabled = true,
        section_separators = '',
        component_separators = '',
        globalstatus = true,
        disabled_filetypes = {}
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    }
  end
}
