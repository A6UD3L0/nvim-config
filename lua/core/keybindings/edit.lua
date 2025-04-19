-- Editing Keybindings Module
-- Controls text editing, formatting, and manipulation
-- Provides consistent editing experience across Neovim

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- Register edit groups
  keybindings.register_group("<leader>c", "Code", "", "#61AFEF") -- Code (bright blue)
  keybindings.register_group("<leader>s", "Substitute", "", "#E5C07B") -- Substitute (yellow)
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Text Manipulation                     │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Select all text
  map("n", "<leader>sa", "ggVG", { desc = "Select all" })
  
  -- Format code
  map("n", "<leader>cf", function()
    -- Try LSP formatting first
    local has_lsp_format = pcall(vim.lsp.buf.format)
    if has_lsp_format then
      return
    end
    
    -- Fall back to built-in formatting if LSP not available
    vim.cmd("normal! gqip")
  end, { desc = "Format code" })
  
  -- Duplicate line/selection
  map("n", "<leader>dl", "yyp", { desc = "Duplicate line" })
  map("v", "<leader>dl", "y`>p", { desc = "Duplicate selection" })
  
  -- Join lines without moving cursor (moved to base keymaps)
  -- map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                      Search and Replace                   │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Search in current buffer
  map("n", "<leader>sb", function()
    local has_telescope, telescope = utils.has_plugin("telescope.builtin")
    if has_telescope then
      telescope.current_buffer_fuzzy_find()
      return
    end
    
    -- Fallback to built-in search
    vim.cmd("let @/=''")
    vim.cmd("call feedkeys('/')")
  end, { desc = "Search in buffer" })
  
  -- Search/replace in current buffer
  map("n", "<leader>sr", function()
    local current_word = vim.fn.expand("<cword>")
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(":%s/" .. current_word .. "//g<Left><Left>", true, false, true),
      "n", 
      false
    )
  end, { desc = "Search and replace" })
  
  -- Search/replace in visual selection
  map("v", "<leader>sr", "\"zy:%s/<C-r>z//g<Left><Left>", { desc = "Search and replace selection" })
  
  -- Search word under cursor
  map("n", "<leader>sw", function()
    local current_word = vim.fn.expand("<cword>")
    vim.cmd("/" .. current_word)
  end, { desc = "Search word under cursor" })
  
  -- Clear search highlighting (moved to base keymaps)
  -- map("n", "<leader>sc", ":nohlsearch<CR>", { desc = "Clear search highlight" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                      Code Actions                         │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Comment toggle
  local function setup_comment_mappings()
    local has_comment, comment = utils.has_plugin("Comment")
    if has_comment then
      map("n", "<leader>cc", function() comment.toggle.linewise.current() end, { desc = "Comment line" })
      map("v", "<leader>cc", function() 
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false)
        comment.toggle.linewise(vim.fn.visualmode()) 
      end, { desc = "Comment selection" })
      return true
    end
    
    -- Fallback to manual commenting using commentstring
    map("n", "<leader>cc", function()
      local comment_string = vim.bo.commentstring
      if comment_string == "" then
        vim.notify("No comment string defined for this filetype", vim.log.levels.WARN)
        return
      end
      
      -- Get the line and determine if it's already commented
      local line = vim.api.nvim_get_current_line()
      local comment_prefix = comment_string:gsub("%%s.*", ""):gsub("%s+$", "")
      
      if line:match("^%s*" .. vim.pesc(comment_prefix)) then
        -- Remove comment
        line = line:gsub("^(%s*)" .. vim.pesc(comment_prefix) .. "%s?", "%1")
      else
        -- Add comment
        line = line:gsub("^(%s*)(.*)", "%1" .. comment_prefix .. " %2")
      end
      
      vim.api.nvim_set_current_line(line)
    end, { desc = "Toggle comment" })
    
    return false
  end
  
  -- Code folding
  map("n", "<leader>cf", "za", { desc = "Toggle fold" })
  map("n", "<leader>cF", "zM", { desc = "Close all folds" })
  map("n", "<leader>cO", "zR", { desc = "Open all folds" })
  
  -- LSP code actions (if available)
  map("n", "<leader>ca", function()
    if vim.lsp.buf.code_action then
      vim.lsp.buf.code_action()
    else
      vim.notify("LSP not available for code actions", vim.log.levels.WARN)
    end
  end, { desc = "Code actions" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Snippet Support                       │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_snippet_mappings()
    -- LuaSnip integration
    local has_luasnip, luasnip = utils.has_plugin("luasnip")
    if has_luasnip then
      -- Jump forward in snippet
      map("i", "<C-j>", function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        end
      end, { desc = "Jump to next snippet placeholder" })
      
      -- Jump backward in snippet
      map("i", "<C-k>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "Jump to previous snippet placeholder" })
      
      return true
    end
    
    return false
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                    Whitespace Control                     │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Trim trailing whitespace
  map("n", "<leader>cw", function()
    local cursor_pos = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", cursor_pos)
    vim.notify("Trimmed trailing whitespace", vim.log.levels.INFO)
  end, { desc = "Trim trailing whitespace" })
  
  -- Convert tabs to spaces
  map("n", "<leader>ct", function()
    local cursor_pos = vim.fn.getpos(".")
    vim.cmd([[%s/\t/]] .. string.rep(" ", vim.bo.tabstop) .. [[/e]])
    vim.fn.setpos(".", cursor_pos)
    vim.notify("Converted tabs to spaces", vim.log.levels.INFO)
  end, { desc = "Convert tabs to spaces" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                      Text Objects                         │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_text_objects()
    -- Check for better text objects plugins
    local has_treesitter_textobjects, _ = utils.has_plugin("nvim-treesitter.configs")
    if has_treesitter_textobjects then
      -- These are configured through nvim-treesitter.configs, not mapped directly
      return true
    end
    
    -- Fallback to built-in text objects via mappings
    -- Entire buffer text object
    map("o", "ae", ":<C-u>normal! ggVG<CR>", { desc = "Entire buffer text object" })
    map("x", "ae", ":<C-u>normal! ggVG<CR>", { desc = "Entire buffer text object" })
    
    return false
  end
  
  -- Set up all editing mappings
  setup_comment_mappings()
  setup_snippet_mappings()
  setup_text_objects()
end

return M
