-- Custom commands for enhanced functionality

-- Create the MasonInstallAll command
vim.api.nvim_create_user_command("MasonInstallAll", function()
  -- Show a message that installation is starting
  vim.notify("Installing Mason packages, please wait...", vim.log.levels.INFO)
  
  -- Get the list of ensure_installed packages from Mason settings
  local mason_settings = require("mason.settings").current
  local ensure_installed = mason_settings.ensure_installed or {}
  
  -- Get the list from mason-lspconfig settings too
  local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok then
    local lsp_settings = mason_lspconfig.get_settings()
    for _, pkg in ipairs(lsp_settings.ensure_installed or {}) do
      -- Avoid duplicates
      if not vim.tbl_contains(ensure_installed, pkg) then
        table.insert(ensure_installed, pkg)
      end
    end
  end
  
  -- Install all packages in the combined list
  local registry = require("mason-registry")
  local count = 0
  local total = #ensure_installed
  
  -- Refresh the registry to get the latest package information
  registry.refresh(function()
    for _, pkg_name in ipairs(ensure_installed) do
      local normalized_name = pkg_name:gsub("-", "_"):gsub("%.language_server", "_ls")
      
      -- Try multiple variants of the package name since Mason and LSP names can differ
      local variants = {
        pkg_name,                            -- Original name
        pkg_name:gsub("_", "-"),             -- Dash version
        pkg_name:gsub("-", "_"),             -- Underscore version
        pkg_name:gsub("_ls", ".language_server"), -- Full language server name
        normalized_name,                     -- Normalized name
      }
      
      local installed = false
      for _, variant in ipairs(variants) do
        pcall(function()
          if registry.is_available(variant) then
            local pkg = registry.get_package(variant)
            if not pkg:is_installed() then
              pkg:install()
              installed = true
              count = count + 1
              vim.notify(string.format("Installing %s (%d/%d)", variant, count, total), vim.log.levels.INFO)
            else
              count = count + 1
              vim.notify(string.format("%s already installed (%d/%d)", variant, count, total), vim.log.levels.INFO)
            end
          end
        end)
        
        if installed then break end
      end
      
      if not installed then
        vim.notify(string.format("Could not find package: %s", pkg_name), vim.log.levels.WARN)
      end
    end
    
    vim.notify("Mason package installation complete!", vim.log.levels.INFO)
  end)
end, {})
