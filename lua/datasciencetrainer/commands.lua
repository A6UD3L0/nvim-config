-- DataScienceTrainer command module
-- Registers Neovim commands for the data science training game

local M = {}

-- Setup commands
function M.setup()
  -- Create the main command
  vim.api.nvim_create_user_command("DataScienceTrainer", function(opts)
    local dst = require("datasciencetrainer")
    local category = opts.fargs[1]
    dst.start_game(category)
  end, {
    nargs = "?",
    complete = function()
      local challenges = require("datasciencetrainer.challenges")
      return challenges.categories
    end,
    desc = "Start the DataScienceTrainer game",
  })
  
  -- Alias as DST for quicker access
  vim.api.nvim_create_user_command("DST", function(opts)
    local dst = require("datasciencetrainer")
    local category = opts.fargs[1]
    dst.start_game(category)
  end, {
    nargs = "?",
    complete = function()
      local challenges = require("datasciencetrainer.challenges")
      return challenges.categories
    end,
    desc = "Alias for DataScienceTrainer",
  })
  
  -- Create individual category commands for quicker access
  local challenges = require("datasciencetrainer.challenges")
  for _, category in ipairs(challenges.categories) do
    local upper_category = category:sub(1,1):upper() .. category:sub(2)
    local cmd_name = "DST" .. upper_category
    
    vim.api.nvim_create_user_command(cmd_name, function()
      local dst = require("datasciencetrainer")
      dst.start_game(category)
    end, {
      desc = "Start DataScienceTrainer with " .. category .. " category",
    })
  end
end

return M
