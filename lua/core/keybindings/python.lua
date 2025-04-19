-- Python Keybindings Module
-- Comprehensive Python tooling integration
-- Features virtual environment management, package handling, and code execution

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- Register Python groups
  keybindings.register_group("<leader>p", "Python", "󰌠", "#3572A5") -- Python (blue)
  keybindings.register_group("<leader>pr", "Requirements", "", "#3572A5")
  keybindings.register_group("<leader>pv", "Virtualenv", "", "#3572A5")
  keybindings.register_group("<leader>pn", "Project", "", "#3572A5")
  keybindings.register_group("<leader>py", "Python Version", "", "#3572A5")
  keybindings.register_group("<leader>pt", "Tools", "", "#3572A5")
  keybindings.register_group("<leader>pu", "UV", "", "#3572A5")
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   UV.nvim Integration                     │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_uv_mappings()
    local has_uv, uv = utils.has_plugin("uv")
    if not has_uv then
      vim.notify("uv.nvim not available, Python tools integration disabled", vim.log.levels.DEBUG)
      return false
    end
    
    -- Requirements management
    map("n", "<leader>pr", function() uv.requirements.generate() end, 
        { desc = "Generate requirements.txt" })
    
    map("n", "<leader>pi", function() uv.requirements.install() end, 
        { desc = "Install from requirements.txt" })
    
    -- Package management
    map("n", "<leader>pp", function()
      vim.ui.input({ prompt = "Package to install: " }, function(package)
        if package and package ~= "" then
          uv.packages.install({ package })
        end
      end)
    end, { desc = "Install package" })
    
    map("n", "<leader>pu", function() uv.packages.update() end, 
        { desc = "Update all packages" })
    
    map("n", "<leader>px", function()
      vim.ui.input({ prompt = "Package to uninstall: " }, function(package)
        if package and package ~= "" then
          uv.packages.uninstall({ package })
        end
      end)
    end, { desc = "Uninstall package" })
    
    -- Virtual environment management
    map("n", "<leader>pv", function() uv.venv.create() end, 
        { desc = "Create virtual environment" })
    
    -- Project management
    map("n", "<leader>pni", function() uv.project.init() end, 
        { desc = "Initialize project" })
    
    map("n", "<leader>pna", function()
      vim.ui.input({ prompt = "Dependency to add: " }, function(dep)
        if dep and dep ~= "" then
          uv.project.add({ dep })
        end
      end)
    end, { desc = "Add project dependency" })
    
    map("n", "<leader>pnr", function()
      vim.ui.input({ prompt = "Dependency to remove: " }, function(dep)
        if dep and dep ~= "" then
          uv.project.remove({ dep })
        end
      end)
    end, { desc = "Remove project dependency" })
    
    map("n", "<leader>pns", function() uv.project.sync() end, 
        { desc = "Sync project dependencies" })
    
    map("n", "<leader>pnl", function() uv.project.lock() end, 
        { desc = "Lock project dependencies" })
    
    -- Python version management
    map("n", "<leader>pyl", function() uv.python.list() end, 
        { desc = "List Python versions" })
    
    map("n", "<leader>pyi", function()
      vim.ui.input({ prompt = "Python version to install: " }, function(version)
        if version and version ~= "" then
          uv.python.install(version)
        end
      end)
    end, { desc = "Install Python version" })
    
    map("n", "<leader>pyp", function()
      vim.ui.input({ prompt = "Python version to pin: " }, function(version)
        if version and version ~= "" then
          uv.python.pin(version)
        end
      end)
    end, { desc = "Pin Python version" })
    
    -- Python tools management
    map("n", "<leader>pti", function()
      vim.ui.input({ prompt = "Tool to install: " }, function(tool)
        if tool and tool ~= "" then
          uv.tools.install(tool)
        end
      end)
    end, { desc = "Install Python tool" })
    
    map("n", "<leader>ptr", function()
      vim.ui.input({ prompt = "Tool to run: " }, function(tool)
        if tool and tool ~= "" then
          uv.tools.run(tool)
        end
      end)
    end, { desc = "Run Python tool" })
    
    map("n", "<leader>ptl", function() uv.tools.list() end, 
        { desc = "List installed tools" })
    
    -- UV utility commands
    map("n", "<leader>puc", function() uv.cache.clean() end, 
        { desc = "Clean uv cache" })
    
    map("n", "<leader>puu", function() uv.self.update() end, 
        { desc = "Update uv" })
    
    return true
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │             Virtual Environment Selection                 │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_venv_mappings()
    -- VenvSelect integration
    map("n", "<leader>pa", function()
      -- Check for venv-selector plugin
      local has_venv_selector, _ = utils.has_plugin("venv-selector")
      if has_venv_selector then
        vim.cmd("VenvSelect")
        return
      end
      
      -- Fallback to manual venv activation
      local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
      if venv_path ~= "" then
        -- Determine activation command based on OS
        local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
        local activate_cmd
        if is_windows then
          activate_cmd = ".venv\\Scripts\\activate"
        else
          activate_cmd = "source .venv/bin/activate"
        end
        keybindings.run_in_terminal(activate_cmd)
        vim.notify("Activated virtual environment: " .. venv_path, vim.log.levels.INFO)
      else
        vim.notify("No virtual environment found in current project", vim.log.levels.WARN)
      end
    end, { desc = "Activate virtual environment" })
    
    map("n", "<leader>pc", function()
      -- Try to handle virtual environment caching via venv-selector
      local has_venv_selector, _ = utils.has_plugin("venv-selector")
      if has_venv_selector then
        vim.cmd("VenvSelectCached")
        return
      end
      
      vim.notify("venv-selector not available for cached environment activation", vim.log.levels.WARN)
    end, { desc = "Activate cached virtual environment" })
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Python Execution                        │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_execution_mappings()
    -- Run current Python file
    map("n", "<leader>pr", function()
      -- Get the path of the current buffer
      local current_file = vim.fn.expand("%:p")
      if vim.fn.filereadable(current_file) == 0 then
        vim.notify("Current buffer is not a file or cannot be read", vim.log.levels.ERROR)
        return
      end
      
      -- Get the file extension
      local ext = vim.fn.fnamemodify(current_file, ":e")
      if ext ~= "py" then
        vim.notify("Current file is not a Python file", vim.log.levels.ERROR)
        return
      end
      
      -- Run the file in a terminal
      local cmd = "python " .. vim.fn.shellescape(current_file)
      keybindings.run_in_terminal(cmd)
    end, { desc = "Run current Python file" })
    
    -- Run selected Python code
    map("v", "<leader>pr", function()
      -- Create a temporary file
      local temp_file = vim.fn.tempname() .. ".py"
      
      -- Get the selected text
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      local lines = vim.fn.getline(start_pos[2], end_pos[2])
      
      -- Adjust last line to selected columns
      if start_pos[2] == end_pos[2] then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
      else
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
      end
      
      -- Write to temp file
      vim.fn.writefile(lines, temp_file)
      
      -- Run in terminal
      local cmd = "python " .. vim.fn.shellescape(temp_file)
      keybindings.run_in_terminal(cmd)
      
      -- Schedule cleanup of temp file
      vim.defer_fn(function()
        os.remove(temp_file)
      end, 5000) -- Delete after 5 seconds
    end, { desc = "Run selected Python code" })
    
    -- IPython integration
    map("n", "<leader>ps", function()
      -- Check if IPython is available
      if utils.command_exists("ipython") then
        keybindings.run_in_terminal("ipython")
      else
        vim.notify("IPython not found. Please install it with 'pip install ipython'", vim.log.levels.WARN)
      end
    end, { desc = "Start IPython shell" })
  end
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                     Testing Integration                   │
  -- ╰──────────────────────────────────────────────────────────╯
  
  local function setup_testing_mappings()
    -- Check if pytest is available
    map("n", "<leader>pt", function()
      if not utils.command_exists("pytest") then
        vim.notify("pytest not found. Please install it with 'pip install pytest'", vim.log.levels.WARN)
        return
      end
      
      -- Get the path of the current buffer
      local current_file = vim.fn.expand("%:p")
      if vim.fn.filereadable(current_file) == 0 then
        keybindings.run_in_terminal("pytest")
        return
      end
      
      -- Get the file extension
      local ext = vim.fn.fnamemodify(current_file, ":e")
      if ext ~= "py" then
        keybindings.run_in_terminal("pytest")
        return
      end
      
      -- Run pytest for current file
      local cmd = "pytest " .. vim.fn.shellescape(current_file) .. " -v"
      keybindings.run_in_terminal(cmd)
    end, { desc = "Run pytest" })
    
    -- Run specific test
    map("n", "<leader>pT", function()
      vim.ui.input({ prompt = "Test pattern: " }, function(pattern)
        if pattern and pattern ~= "" then
          local cmd = "pytest " .. pattern .. " -v"
          keybindings.run_in_terminal(cmd)
        end
      end)
    end, { desc = "Run specific test" })
  end
  
  -- Set up all Python mappings
  setup_uv_mappings()
  setup_venv_mappings()
  setup_execution_mappings()
  setup_testing_mappings()
end

return M
