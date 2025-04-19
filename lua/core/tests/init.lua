-- Automated Test Framework
-- Provides testing utilities for configuration validation
-- Helps prevent regressions in critical configuration components

local M = {}

-- Test results storage
M.results = {
  passed = 0,
  failed = 0,
  tests = {},
}

-- Define a test
function M.test(name, fn)
  table.insert(M.results.tests, { name = name, fn = fn, result = nil, error = nil })
end

-- Run all defined tests
function M.run_tests()
  vim.notify("Running " .. #M.results.tests .. " tests...", vim.log.levels.INFO)
  
  M.results.passed = 0
  M.results.failed = 0
  
  for i, test in ipairs(M.results.tests) do
    local ok, result = pcall(test.fn)
    if ok and result then
      test.result = true
      test.error = nil
      M.results.passed = M.results.passed + 1
    else
      test.result = false
      test.error = ok and "Test returned false" or result
      M.results.failed = M.results.failed + 1
    end
    
    -- Output progress
    local status = test.result and "✓" or "✗"
    vim.notify(string.format("[%s] %s", status, test.name), 
               test.result and vim.log.levels.INFO or vim.log.levels.ERROR)
  end
  
  -- Output summary
  vim.notify(string.format("Tests completed: %d passed, %d failed", 
                         M.results.passed, M.results.failed),
           M.results.failed > 0 and vim.log.levels.WARN or vim.log.levels.INFO)
  
  return M.results.failed == 0
end

-- Create a test summary report
function M.generate_report()
  local lines = {
    "# Neovim Configuration Test Report",
    string.format("**Date:** %s", os.date("%Y-%m-%d %H:%M:%S")),
    string.format("**Results:** %d passed, %d failed", M.results.passed, M.results.failed),
    "",
    "## Test Details",
    ""
  }
  
  for i, test in ipairs(M.results.tests) do
    local status = test.result and "✓" or "✗"
    table.insert(lines, string.format("### %s %s", status, test.name))
    
    if not test.result and test.error then
      table.insert(lines, "")
      table.insert(lines, "**Error:**")
      table.insert(lines, "```")
      table.insert(lines, test.error)
      table.insert(lines, "```")
    end
    
    table.insert(lines, "")
  end
  
  -- Write report to file
  local report_path = vim.fn.stdpath("config") .. "/test_report.md"
  vim.fn.writefile(lines, report_path)
  
  vim.notify("Test report written to: " .. report_path, vim.log.levels.INFO)
  return report_path
end

-- Load all test modules
function M.load_test_modules()
  local test_dir = vim.fn.stdpath("config") .. "/lua/core/tests"
  local test_files = vim.fn.glob(test_dir .. "/*.lua", false, true)
  
  for _, file in ipairs(test_files) do
    local module_name = vim.fn.fnamemodify(file, ":t:r")
    if module_name ~= "init" then
      local ok, _ = pcall(require, "core.tests." .. module_name)
      if not ok then
        vim.notify("Failed to load test module: " .. module_name, vim.log.levels.ERROR)
      end
    end
  end
end

-- Initialize and run tests
function M.setup()
  -- Create command to run tests
  vim.api.nvim_create_user_command("RunConfigTests", function()
    M.load_test_modules()
    M.run_tests()
    M.generate_report()
  end, {})
  
  return true
end

return M
