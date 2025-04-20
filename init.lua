-- Load custom modular config
require('custom.settings')
require('custom.plugins')
require('custom.lualine')
require('custom.treesitter')
require('custom.mason')
require('custom.lsp')
require('custom.null-ls')
require('custom.repl')
require('custom.test-debug')
require('custom.docker')
require('custom.sql')
require('custom.ui')
-- require('custom.keymaps') -- (legacy, now consolidated in whichkey_mece.lua)
require('custom.whichkey_mece')

-- Backend & Machine Learning Neovim Config
-- Portable, modern, and robust

-- 1. Dynamic config root for portability
local init_file = debug.getinfo(1, "S").source:sub(2)
local config_dir = vim.fn.fnamemodify(init_file, ":h")
vim.opt.runtimepath:prepend(config_dir)
package.path = table.concat({
  config_dir.."/lua/?.lua",
  config_dir.."/lua/?/init.lua",
  package.path,
}, ";")

-- 2. Editor settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- 3. Plugin manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "c", "go", "sql", "bash", "json", "yaml" },
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = true },
      })
    end,
  },

  -- LSP, Mason, nvim-cmp
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },

  -- DAP (debugging)
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "mfussenegger/nvim-dap-python" },
  { "leoluz/nvim-dap-go" },

  -- Testing
  { "vim-test/vim-test" },
  { "hkupty/iron.nvim" },

  -- Terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- Git
  { "lewis6991/gitsigns.nvim", config = true },
  { "TimUntersberger/neogit" },
  { "kdheepak/lazygit.nvim" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- WhichKey
  { "folke/which-key.nvim", event = "VimEnter", config = true },
})

-- 4. LSP and completion setup
local lspconfig = require("lspconfig")
local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "clangd", "gopls", "sqls", "bashls" },
})

local servers = {
  pyright = {},
  clangd = {},
  gopls = {},
  sqls = {},
  bashls = {},
}
for server, opts in pairs(servers) do
  lspconfig[server].setup({
    capabilities = capabilities,
    settings = opts,
  })
end

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- 5. DAP setup
local dap = require("dap")
-- local dapui = require("dapui") -- removed, nvim-dap-ui not installed
-- dapui.setup()
require("dap-python").setup("python")
require("dap-go").setup()

vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })

-- 6. Testing
vim.g["test#python#runner"] = "pytest"
vim.g["test#go#runner"] = "gotests"
vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "Test: Nearest" })
vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Test: File" })

-- 7. Terminal/Containers
require("toggleterm").setup()
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- 8. Git
vim.keymap.set("n", "<leader>gs", ":Neogit<CR>", { desc = "Git: Status" })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git: Commit" })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git: Push" })
vim.keymap.set("n", "<leader>gl", ":Git pull<CR>", { desc = "Git: Pull" })

-- 9. Telescope
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Help Tags" })

-- 10. Onboarding & health
vim.api.nvim_create_user_command("SetupHelp", function()
  vim.cmd("edit SETUP.md")
end, { desc = "Open onboarding/setup instructions" })
