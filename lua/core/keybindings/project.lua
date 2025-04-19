-- Project Management Keybindings Module
-- Controls project-wide operations and management
-- Integrates with project.nvim and other project tools

local keybindings = require("core.keybindings")
local map = keybindings.map
local utils = require("core.utils")

local M = {}

function M.setup()
  -- Register project group
  keybindings.register_group("<leader>p", "Project", "", "#98C379") -- Project (bright green)
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Project Navigation                      │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Switch project
  map("n", "<leader>pp", function()
    local has_telescope, telescope = utils.has_plugin("telescope")
    local has_project, _ = utils.has_plugin("project_nvim")
    
    if has_telescope and has_project then
      -- Project.nvim integration via telescope
      telescope.extensions.projects.projects()
      return
    end
    
    -- Fallback to manual project list
    if vim.g.project_list then
      vim.ui.select(vim.g.project_list, {
        prompt = "Select project:",
        format_item = function(item)
          return vim.fn.fnamemodify(item, ":t")
        end,
      }, function(choice)
        if choice then
          vim.cmd("cd " .. choice)
          vim.notify("Switched to project: " .. vim.fn.fnamemodify(choice, ":t"), vim.log.levels.INFO)
        end
      end)
    else
      vim.notify("No project list available. Create one with <leader>pa", vim.log.levels.WARN)
    end
  end, { desc = "Switch project" })
  
  -- Add current directory to project list
  map("n", "<leader>pa", function()
    local current_dir = vim.fn.getcwd()
    
    -- Initialize project list if it doesn't exist
    if not vim.g.project_list then
      vim.g.project_list = {}
    end
    
    -- Check if project is already in the list
    for _, dir in ipairs(vim.g.project_list) do
      if dir == current_dir then
        vim.notify("Project already in list: " .. vim.fn.fnamemodify(current_dir, ":t"), vim.log.levels.INFO)
        return
      end
    end
    
    -- Add project to list
    table.insert(vim.g.project_list, current_dir)
    vim.notify("Added project: " .. vim.fn.fnamemodify(current_dir, ":t"), vim.log.levels.INFO)
    
    -- Save project list to file
    local config_dir = vim.fn.stdpath("config")
    local project_file = config_dir .. "/projects.lua"
    
    local file = io.open(project_file, "w")
    if file then
      file:write("vim.g.project_list = {\n")
      for _, dir in ipairs(vim.g.project_list) do
        file:write(string.format("  %q,\n", dir))
      end
      file:write("}\n")
      file:close()
      vim.notify("Saved project list to: " .. project_file, vim.log.levels.INFO)
    end
  end, { desc = "Add to projects" })
  
  -- Remove current directory from project list
  map("n", "<leader>pr", function()
    local current_dir = vim.fn.getcwd()
    
    -- Check if project list exists
    if not vim.g.project_list then
      vim.notify("No project list available", vim.log.levels.WARN)
      return
    end
    
    -- Remove project from list
    local found = false
    for i, dir in ipairs(vim.g.project_list) do
      if dir == current_dir then
        table.remove(vim.g.project_list, i)
        found = true
        break
      end
    end
    
    if found then
      vim.notify("Removed project: " .. vim.fn.fnamemodify(current_dir, ":t"), vim.log.levels.INFO)
      
      -- Save project list to file
      local config_dir = vim.fn.stdpath("config")
      local project_file = config_dir .. "/projects.lua"
      
      local file = io.open(project_file, "w")
      if file then
        file:write("vim.g.project_list = {\n")
        for _, dir in ipairs(vim.g.project_list) do
          file:write(string.format("  %q,\n", dir))
        end
        file:write("}\n")
        file:close()
      end
    else
      vim.notify("Project not in list: " .. vim.fn.fnamemodify(current_dir, ":t"), vim.log.levels.WARN)
    end
  end, { desc = "Remove from projects" })
  
  -- Find files in project
  map("n", "<leader>pf", function()
    local has_telescope, telescope = utils.has_plugin("telescope.builtin")
    if has_telescope then
      telescope.find_files()
    else
      vim.notify("Telescope not available", vim.log.levels.WARN)
    end
  end, { desc = "Find files in project" })
  
  -- Search in project
  map("n", "<leader>ps", function()
    local has_telescope, telescope = utils.has_plugin("telescope.builtin")
    if has_telescope then
      telescope.live_grep()
    else
      vim.notify("Telescope not available", vim.log.levels.WARN)
    end
  end, { desc = "Search in project" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Project Structure                       │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Create new project directory structure
  map("n", "<leader>pn", function()
    vim.ui.input({ prompt = "Project name: " }, function(name)
      if not name or name == "" then return end
      
      vim.ui.input({ prompt = "Project directory: ", default = vim.fn.getcwd() .. "/" .. name }, function(dir)
        if not dir or dir == "" then return end
        
        -- Create project directory
        vim.fn.mkdir(dir, "p")
        
        -- Ask for project type
        vim.ui.select({
          "python",
          "node",
          "web",
          "go",
          "rust",
          "empty"
        }, {
          prompt = "Project type:",
        }, function(choice)
          if not choice then return end
          
          -- Create project structure based on type
          if choice == "python" then
            vim.fn.mkdir(dir .. "/src", "p")
            vim.fn.mkdir(dir .. "/tests", "p")
            vim.fn.mkdir(dir .. "/docs", "p")
            
            -- Create basic files
            local files = {
              [dir .. "/README.md"] = "# " .. name .. "\n\nA Python project.\n",
              [dir .. "/.gitignore"] = "# Python\n__pycache__/\n*.py[cod]\n*$py.class\n.env\n.venv\nenv/\nvenv/\nENV/\n",
              [dir .. "/pyproject.toml"] = "[build-system]\nrequires = [\"setuptools>=42\", \"wheel\"]\nbuild-backend = \"setuptools.build_meta\"\n\n[project]\nname = \"" .. name .. "\"\nversion = \"0.1.0\"\ndescription = \"A Python project\"\n",
              [dir .. "/src/__init__.py"] = "",
              [dir .. "/src/main.py"] = "def main():\n    print(\"Hello, World!\")\n\nif __name__ == \"__main__\":\n    main()\n",
              [dir .. "/tests/__init__.py"] = "",
              [dir .. "/tests/test_main.py"] = "import unittest\n\nclass TestMain(unittest.TestCase):\n    def test_example(self):\n        self.assertTrue(True)\n\nif __name__ == \"__main__\":\n    unittest.main()\n",
            }
            
            for file, content in pairs(files) do
              local f = io.open(file, "w")
              if f then
                f:write(content)
                f:close()
              end
            end
            
          elseif choice == "node" then
            vim.fn.mkdir(dir .. "/src", "p")
            vim.fn.mkdir(dir .. "/test", "p")
            
            -- Create basic files
            local files = {
              [dir .. "/README.md"] = "# " .. name .. "\n\nA Node.js project.\n",
              [dir .. "/.gitignore"] = "# Node.js\nnode_modules/\nnpm-debug.log\nyarn-error.log\nyarn-debug.log\npackage-lock.json\n",
              [dir .. "/package.json"] = "{\n  \"name\": \"" .. name .. "\",\n  \"version\": \"1.0.0\",\n  \"description\": \"A Node.js project\",\n  \"main\": \"src/index.js\",\n  \"scripts\": {\n    \"test\": \"echo \\\"Error: no test specified\\\" && exit 1\",\n    \"start\": \"node src/index.js\"\n  }\n}\n",
              [dir .. "/src/index.js"] = "function main() {\n  console.log('Hello, World!');\n}\n\nmain();\n",
              [dir .. "/test/test.js"] = "// Add tests here\n",
            }
            
            for file, content in pairs(files) do
              local f = io.open(file, "w")
              if f then
                f:write(content)
                f:close()
              end
            end
            
          elseif choice == "web" then
            vim.fn.mkdir(dir .. "/css", "p")
            vim.fn.mkdir(dir .. "/js", "p")
            vim.fn.mkdir(dir .. "/img", "p")
            
            -- Create basic files
            local files = {
              [dir .. "/index.html"] = "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n  <meta charset=\"UTF-8\">\n  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n  <title>" .. name .. "</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <h1>Hello, World!</h1>\n  <script src=\"js/main.js\"></script>\n</body>\n</html>\n",
              [dir .. "/css/styles.css"] = "body {\n  font-family: Arial, sans-serif;\n  margin: 0;\n  padding: 20px;\n}\n",
              [dir .. "/js/main.js"] = "document.addEventListener('DOMContentLoaded', () => {\n  console.log('Hello, World!');\n});\n",
              [dir .. "/README.md"] = "# " .. name .. "\n\nA web project.\n",
              [dir .. "/.gitignore"] = "# Web\n.DS_Store\nnode_modules/\ndist/\n.cache/\n",
            }
            
            for file, content in pairs(files) do
              local f = io.open(file, "w")
              if f then
                f:write(content)
                f:close()
              end
            end
            
          elseif choice == "go" then
            vim.fn.mkdir(dir .. "/cmd", "p")
            vim.fn.mkdir(dir .. "/internal", "p")
            vim.fn.mkdir(dir .. "/pkg", "p")
            
            -- Create basic files
            local files = {
              [dir .. "/README.md"] = "# " .. name .. "\n\nA Go project.\n",
              [dir .. "/.gitignore"] = "# Go\n*.exe\n*.exe~\n*.dll\n*.so\n*.dylib\n*.test\n*.out\ngo.work\n",
              [dir .. "/go.mod"] = "module " .. name .. "\n\ngo 1.19\n",
              [dir .. "/cmd/main.go"] = "package main\n\nimport (\n\t\"fmt\"\n)\n\nfunc main() {\n\tfmt.Println(\"Hello, World!\")\n}\n",
            }
            
            for file, content in pairs(files) do
              local f = io.open(file, "w")
              if f then
                f:write(content)
                f:close()
              end
            end
            
          elseif choice == "rust" then
            -- Use cargo to create a new project
            if utils.command_exists("cargo") then
              keybindings.run_in_terminal("cargo new " .. dir)
            else
              vim.notify("Cargo not found. Please install Rust toolchain.", vim.log.levels.ERROR)
            end
            
          elseif choice == "empty" then
            -- Create just a README and .gitignore
            local files = {
              [dir .. "/README.md"] = "# " .. name .. "\n\nA new project.\n",
              [dir .. "/.gitignore"] = "# Project specific ignores\n",
            }
            
            for file, content in pairs(files) do
              local f = io.open(file, "w")
              if f then
                f:write(content)
                f:close()
              end
            end
          end
          
          -- Open the project
          vim.notify("Created project: " .. name, vim.log.levels.INFO)
          vim.cmd("cd " .. dir)
          
          -- Initialize git if available
          if utils.command_exists("git") then
            keybindings.run_in_terminal("git init")
          end
        end)
      end)
    end)
  end, { desc = "Create new project" })
  
  -- ╭──────────────────────────────────────────────────────────╮
  -- │                   Project Tasks                           │
  -- ╰──────────────────────────────────────────────────────────╯
  
  -- Run project tasks
  map("n", "<leader>pt", function()
    -- Check for common task files
    local task_files = {
      ["package.json"] = "npm run",
      ["Makefile"] = "make",
      ["build.gradle"] = "./gradlew",
      ["pom.xml"] = "mvn",
      ["Cargo.toml"] = "cargo",
      ["go.mod"] = "go",
      ["pyproject.toml"] = "poetry run",
      ["requirements.txt"] = "python -m",
    }
    
    local available_runners = {}
    
    for file, runner in pairs(task_files) do
      if utils.file_exists(vim.fn.getcwd() .. "/" .. file) then
        table.insert(available_runners, { file = file, runner = runner })
      end
    end
    
    if #available_runners == 0 then
      vim.notify("No task runners found", vim.log.levels.WARN)
      return
    end
    
    -- Select task runner
    if #available_runners == 1 then
      local runner = available_runners[1]
      
      -- Get available tasks based on file type
      local tasks = {}
      
      if runner.file == "package.json" then
        local content = vim.fn.readfile(vim.fn.getcwd() .. "/package.json")
        local package = vim.fn.json_decode(table.concat(content, "\n"))
        
        if package and package.scripts then
          for task, _ in pairs(package.scripts) do
            table.insert(tasks, task)
          end
        end
      elseif runner.file == "Makefile" then
        local content = vim.fn.readfile(vim.fn.getcwd() .. "/Makefile")
        for _, line in ipairs(content) do
          local task = line:match("^([%w-_]+):") 
          if task then
            table.insert(tasks, task)
          end
        end
      end
      
      -- If tasks found, prompt to select one
      if #tasks > 0 then
        vim.ui.select(tasks, { prompt = "Select task to run:" }, function(choice)
          if choice then
            keybindings.run_in_terminal(runner.runner .. " " .. choice)
          end
        end)
      else
        -- Otherwise ask for a task name
        vim.ui.input({ prompt = "Task to run with " .. runner.runner .. ":" }, function(task)
          if task and task ~= "" then
            keybindings.run_in_terminal(runner.runner .. " " .. task)
          end
        end)
      end
    else
      -- Select from multiple runners
      vim.ui.select(available_runners, {
        prompt = "Select task runner:",
        format_item = function(item)
          return item.file .. " (" .. item.runner .. ")"
        end,
      }, function(choice)
        if choice then
          vim.ui.input({ prompt = "Task to run with " .. choice.runner .. ":" }, function(task)
            if task and task ~= "" then
              keybindings.run_in_terminal(choice.runner .. " " .. task)
            end
          end)
        end
      end)
    end
  end, { desc = "Run project task" })
end

return M
