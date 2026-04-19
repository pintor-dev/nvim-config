local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- comment out if encounter errors
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]
-- comment out if encounter errors

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

------------------------------------------------------
------------------------------------------------------
--     ____  _    _   _  ____ ___ _   _ ____        --
--    |  _ \| |  | | | |/ ___|_ _| \ | / ___|       --
--    | |_) | |  | | | | |  _ | ||  \| \___ \       --
--    |  __/| |__| |_| | |_| || || |\  |___) |      --
--    |_|   |_____\___/ \____|___|_| \_|____/       --
------------------------------------------------------
------------------------------------------------------

-- Install your plugins here
return packer.startup(function(use)

-- Basic
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

-- nvim-tree
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  -- Bufferline
--  use "akinsho/bufferline.nvim"
--  use "moll/vim-bbye"

-- Colorschemes
  use "lunarvim/darkplus.nvim"
  use "folke/tokyonight.nvim"

-- CMP (completion)
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"

  -- Snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

-- LSP (language server protocol)
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "nvimtools/none-ls.nvim"
  use "RRethy/vim-illuminate"

-- Telescope
  use "nvim-telescope/telescope.nvim"
--  use 'nvim-telescope/telescope-media-files.nvim' -- not working great

-- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("user.plugins.treesitter")
    end,
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
