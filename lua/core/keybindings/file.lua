-- File Operation Keybindings Module
-- Controls file creation, saving, and manipulation
-- Provides consistent file operations across Neovim

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                    Basic File Operations                  │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Register file group
  keybindings.register_group("<leader>f", "File", "", "#9ECE6A") -- File (green)
  
  -- Save operations
  map("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
  map("n", "<leader>fS", ":wa<CR>", { desc = "Save all files" })
  map("n", "<leader>fW", ":noautocmd w<CR>", { desc = "Save without triggers" })
  
  -- New file in current directory
  map("n", "<leader>fn", function()
    local current_dir = vim.fn.expand("%:p:h")
    vim.ui.input({ prompt = "New file name: ", default = current_dir .. "/" }, function(name)
      if name and name ~= "" then
        vim.cmd("edit " .. name)
      end
    end)
  end, { desc = "New file" })
  
  -- Copy file path operations
  map("n", "<leader>fy", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("Copied full path: " .. path, vim.log.levels.INFO)
  end, { desc = "Copy full path" })
  
  map("n", "<leader>fY", function()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify("Copied relative path: " .. path, vim.log.levels.INFO)
  end, { desc = "Copy relative path" })
  
  -- File information
  map("n", "<leader>fi", function()
    local file = vim.fn.expand("%:p")
    if file == "" then
      vim.notify("No file in current buffer", vim.log.levels.WARN)
      return
    end
    
    local info = {}
    local stats = vim.loop.fs_stat(file)
    
    table.insert(info, "File: " .. vim.fn.expand("%:."))
    table.insert(info, "Size: " .. utils.format_size(stats.size))
    table.insert(info, "Type: " .. vim.bo.filetype)
    table.insert(info, "Modified: " .. os.date("%Y-%m-%d %H:%M:%S", stats.mtime.sec))
    table.insert(info, "Permissions: " .. string.format("%o", stats.mode))
    
    vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
  end, { desc = "File information" })
  
  -- Change file permissions
  map("n", "<leader>fp", function()
    local file = vim.fn.expand("%:p")
    if file == "" then
      vim.notify("No file in current buffer", vim.log.levels.WARN)
      return
    end
    
    vim.ui.input({ prompt = "Change permissions to: " }, function(perms)
      if perms and perms ~= "" then
        local cmd = "chmod " .. perms .. " " .. vim.fn.shellescape(file)
        local result = utils.execute_command(cmd)
        if result then
          vim.notify("Changed permissions to " .. perms, vim.log.levels.INFO)
        else
          vim.notify("Failed to change permissions", vim.log.levels.ERROR)
        end
      end
    end)
  end, { desc = "Change file permissions" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                    File Actions                           │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Rename current file
  map("n", "<leader>fr", function()
    local current_file = vim.fn.expand("%")
    local current_path = vim.fn.expand("%:p:h")
    
    if current_file == "" then
      vim.notify("No file in current buffer", vim.log.levels.WARN)
      return
    end
    
    vim.ui.input({ prompt = "New name: ", default = current_file }, function(new_name)
      if new_name and new_name ~= "" and new_name ~= current_file then
        -- Handle if new_name includes a directory path
        local new_path
        if vim.fn.fnamemodify(new_name, ":h") == "." then
          new_path = current_path .. "/" .. new_name
        else
          new_path = new_name
        end
        
        -- Create directory if it doesn't exist
        local new_dir = vim.fn.fnamemodify(new_path, ":h")
        if vim.fn.isdirectory(new_dir) == 0 then
          utils.execute_command("mkdir -p " .. vim.fn.shellescape(new_dir))
        end
        
        -- Save current file and rename
        vim.cmd("write")
        local ok, err = os.rename(vim.fn.expand("%:p"), new_path)
        
        if ok then
          vim.cmd("edit " .. new_name)
          vim.notify("Renamed to " .. new_name, vim.log.levels.INFO)
        else
          vim.notify("Failed to rename: " .. (err or "unknown error"), vim.log.levels.ERROR)
        end
      end
    end)
  end, { desc = "Rename file" })
  
  -- Delete current file
  map("n", "<leader>fd", function()
    local current_file = vim.fn.expand("%:p")
    
    if current_file == "" then
      vim.notify("No file in current buffer", vim.log.levels.WARN)
      return
    end
    
    vim.ui.input({ prompt = "Delete " .. vim.fn.expand("%:.") .. "? (y/n): " }, function(input)
      if input and input:lower() == "y" then
        local ok, err = os.remove(current_file)
        
        if ok then
          vim.cmd("bdelete!")
          vim.notify("Deleted " .. vim.fn.expand("%:."), vim.log.levels.INFO)
        else
          vim.notify("Failed to delete: " .. (err or "unknown error"), vim.log.levels.ERROR)
        end
      end
    end)
  end, { desc = "Delete file" })
  
  -- Create a file from a template
  local function create_file_from_template(template_file, target_file)
    if utils.file_exists(template_file) then
      local content = vim.fn.readfile(template_file)
      vim.fn.writefile(content, target_file)
      vim.cmd("edit " .. target_file)
      vim.notify("Created file from template", vim.log.levels.INFO)
    else
      vim.notify("Template file not found: " .. template_file, vim.log.levels.ERROR)
    end
  end
  
  -- Create a Python file from a template
  map("n", "<leader>ftp", function()
    local current_dir = vim.fn.expand("%:p:h")
    vim.ui.input({ prompt = "New Python file: ", default = current_dir .. "/" }, function(name)
      if name and name ~= "" then
        local template_file = vim.fn.stdpath("config") .. "/templates/python.py"
        create_file_from_template(template_file, name)
      end
    end)
  end, { desc = "New Python file from template" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                    File Finding                           │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- These mappings are intentionally duplicated from navigation.lua for better organization
  -- in the which-key menu and to keep file-specific operations in this module
  
  local function setup_file_finding()
    local has_telescope, telescope = utils.has_plugin("telescope.builtin")
    if not has_telescope then
      return false
    end
    
    -- File finding
    map("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
    map("n", "<leader>fg", telescope.live_grep, { desc = "Find in files (grep)" })
    map("n", "<leader>fb", telescope.buffers, { desc = "Find buffers" })
    map("n", "<leader>fr", telescope.oldfiles, { desc = "Recent files" })
    
    return true
  end
  
  setup_file_finding()
end

return M
