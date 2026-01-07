-- Main configuration entry point
-- Loads all configuration modules in proper order:
-- 1. Options (foundation)
-- 2. Keymaps
-- 3. Autocmds
-- 4. Plugins (lazy.nvim setup)
-- 5. LSP (after plugins load)
-- 6. Colorscheme (last)

-- Load options first (foundation)
require('config.options')

-- Load keymaps
require('config.keymaps')

-- Load autocmds
require('config.autocmds')

-- Load plugin configurations (lazy.nvim setup)
require('config.plugins')

-- Load LSP and colorscheme after plugins are loaded via lazy
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyDone',
  once = true,
  callback = function()
    -- Load LSP configuration
    require('config.lsp').setup()
    -- Load colorscheme after plugins are available
    require('config.colorscheme')
  end,
})

-- Fallback: Load colorscheme with a delay to ensure plugins are loaded
-- This handles cases where LazyDone might not fire immediately
vim.defer_fn(function()
  -- Only load if colorscheme hasn't been set yet
  if vim.g.colors_name == nil then
    require('config.colorscheme')
  end
end, 200)

-- Load external configuration if it exists
local extra_config = vim.fn.expand('~/.config/nvim/extra.vim')
if vim.fn.filereadable(extra_config) == 1 then
  vim.cmd('source ' .. extra_config)
end

