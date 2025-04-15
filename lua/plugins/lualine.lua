-- Lualine config for rose-pine-moon theme
require('lualine').setup {
  options = {
    theme = 'rose-pine',
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
