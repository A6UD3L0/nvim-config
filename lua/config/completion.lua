-- Advanced completion configuration with nvim-cmp
-- Full-featured code completion for backend development

local M = {}

function M.setup()
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    vim.notify("nvim-cmp not found. Autocompletion might not work.", vim.log.levels.WARN)
    return
  end

  local luasnip_status_ok, luasnip = pcall(require, "luasnip")
  if not luasnip_status_ok then
    vim.notify("LuaSnip not found. Snippet completion might not work.", vim.log.levels.WARN)
    return
  end

  -- Load snippets
  require("luasnip.loaders.from_vscode").lazy_load()

  -- Add filetype-specific snippets
  luasnip.filetype_extend("python", { "django", "pydoc", "sqlalchemy", "pytest" })
  luasnip.filetype_extend("go", { "godoc", "gomock", "gotests" })
  luasnip.filetype_extend("c", { "cdoc" })
  luasnip.filetype_extend("sql", { "pgsql", "mysql" })
  luasnip.filetype_extend("dockerfile", { "docker-compose" })
  luasnip.filetype_extend("yaml", { "kubernetes", "ansible", "docker-compose" })
  luasnip.filetype_extend("sh", { "bash" })
  luasnip.filetype_extend("json", { "jsonc" })

  -- Better completion UI appearance
  local window_bordered = cmp.config.window.bordered({
    border = "rounded",
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    scrollbar = false,
  })

  -- Define 'kind' icons
  local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰊄",
    Database = "󰆼",
    Package = "󰏖",
  }

  -- Configure nvim-cmp
  cmp.setup({
    -- Snippet engine configuration
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    -- Enhanced window appearance
    window = {
      completion = window_bordered,
      documentation = window_bordered,
    },

    -- Advanced keybindings with better navigation
    mapping = {
      -- Basic navigation 
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<Down>"] = cmp.mapping.select_next_item(),
      ["<Up>"] = cmp.mapping.select_prev_item(),
      
      -- Cancel and confirm
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
      
      -- Tab for both completion and snippet navigation
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, {"i", "s"}),
      
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {"i", "s"}),
      
      -- Complete common string
      ["<C-l>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.complete_common_string()
        else
          cmp.complete()
        end
      end),
      
      -- Access completions menu and force completion
      ["<C-Space>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end, {"i", "c"}),
    },

    -- Configure completion sources by priority
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "nvim_lsp_signature_help", priority = 800 },
      { name = "luasnip", priority = 750 },
      { name = "buffer", priority = 500 },
      { name = "path", priority = 250 },
    }),

    -- Better formatting for completion items
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        -- Show kind icons
        vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
        
        -- Show source
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lsp_signature_help = "[Signature]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
          cmdline = "[Cmd]",
        })[entry.source.name]
        
        -- Limit the width of items for better UI
        local label = vim_item.abbr
        local truncated_label = vim.fn.strcharpart(label, 0, 50)
        if truncated_label ~= label then
          vim_item.abbr = truncated_label .. "..."
        end
        
        return vim_item
      end,
    },
    
    -- Sort completion items by priority and locally typed characters
    sorting = {
      priority_weight = 2.0,
      comparators = {
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    
    -- Show completion even with only one item
    completion = {
      completeopt = "menu,menuone,noinsert",
      keyword_length = 1,
    },
    
    -- Add border to documentation
    experimental = {
      ghost_text = true,
    },
  })

  -- Set up special cmdline completions
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline" },
    }),
    formatting = {
      format = function(entry, vim_item)
        -- Simpler formatting for command line
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or "")
        return vim_item
      end,
    },
  })

  -- Set up completions for "/" search
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  
  -- Add auto-pairs for better completion
  local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
  if has_autopairs then
    -- Configure autopairs
    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = {"string", "source"},
        python = {"string", "source"},
        go = {"string", "source"},
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    })
    
    -- Make autopairs and completion work together
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )
  end
end

return M
