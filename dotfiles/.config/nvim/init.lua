-- Neovim 0.11+ Native Configuration
-- This is the foundation - all configuration is in Lua

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all configuration modules in proper order
-- Order: options -> keymaps -> autocmds -> plugins -> LSP -> colorscheme
require('config')

