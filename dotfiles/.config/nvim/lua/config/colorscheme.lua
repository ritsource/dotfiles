-- Neovim 0.11+ Colorscheme Configuration
-- Visual layer: colorscheme, highlights, and appearance overrides
-- Uses native Lua APIs (vim.api.nvim_set_hl) for highlight customization

local g = vim.g

-- ============================================================================
-- COLORSCHEME SETUP
-- ============================================================================
-- This must be called AFTER lazy.nvim loads plugins (via LazyDone event)
-- Only sets colorscheme and applies highlight overrides

-- Ensure termguicolors is enabled (should already be set in options.lua, but double-check)
vim.opt.termguicolors = true

-- Load colorscheme
if vim.fn.filereadable(vim.fn.expand('~/.vimrc_background')) == 1 then
  g.base16colorspace = 256
  vim.cmd('source ~/.vimrc_background')
else
  -- Set ayu color scheme (mirage variant)
  g.ayucolor = 'mirage' -- Options: "light", "mirage", "dark"
  vim.cmd('colorscheme ayu')
end

-- ============================================================================
-- HIGHLIGHTING CUSTOMIZATION (Native Lua API)
-- ============================================================================
-- Recreate subtle highlight tweaks that make it feel "identical"
-- Using vim.api.nvim_set_hl() instead of :highlight commands
-- These must be set AFTER colorscheme loads

-- Make the highlighting of tabs and other non-text less annoying
-- Note: In Neovim, use 'fg' and 'bg' instead of 'guifg'/'ctermfg' and 'guibg'/'ctermbg'
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#333333' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#333333' })

-- Make comments and HTML attributes italic
vim.api.nvim_set_hl(0, 'Comment', { italic = true })
vim.api.nvim_set_hl(0, 'htmlArg', { italic = true })
vim.api.nvim_set_hl(0, 'xmlAttrib', { italic = true })

-- Transparent background (works with terminal transparency)
-- Source: https://stackoverflow.com/a/37720708/9406420
-- This must override the colorscheme's Normal highlight
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })

