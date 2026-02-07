local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "LunarVim/lunar.nvim", priority = 1000, config = function() vim.cmd.colorscheme("lunar") end },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "javascript",
          "json",
          "lua",
          "python",
          "typescript",
          "tsx",
          "css",
          "rust",
          "java",
          "yaml",
        },
        highlight = { enable = true },
        autotag = { enable = true },
        indent = { enable = true, disable = { "typescript", "tsx" } },
      })
    end,
  },
  { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({})
    end,
  },
  { "mbbill/undotree" },
  { "williamboman/mason.nvim", config = function() require("mason").setup({}) end },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },
  { "stevearc/conform.nvim" },
  { "mfussenegger/nvim-lint" },
  { "jparise/vim-graphql" },
  { "kdheepak/lazygit.nvim" },
  {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init({
        symbol_map = { Supermaven = "" },
      })
      vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { "cpp" },
        color = { suggestion_color = "#A9A9A9", cterm = 244 },
        log_level = "info",
        disable_inline_completion = false,
        disable_keymaps = true,
        condition = function()
          return false
        end,
      })
    end,
  },
  {
    "f-person/git-blame.nvim",
    config = function()
      vim.g.gitblame_enabled = 0
    end,
  },
  { "editorconfig/editorconfig-vim" },
  { "neovim/nvim-lspconfig" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({}),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "supermaven" },
        }),
      })
    end,
  },
  { "folke/which-key.nvim", config = function() require("which-key").setup({}) end },
})
