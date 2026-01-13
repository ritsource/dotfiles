-- Neovim 0.11+ Autocmds Configuration

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- CONFIG GROUP
-- ============================================================================
local config_group = augroup('configgroup', { clear = true })

-- Automatically resize panes on window resize
autocmd('VimResized', {
  group = config_group,
  callback = function()
    vim.cmd('normal! <c-w>=')
  end,
})

-- Automatically reload config when saved
autocmd('BufWritePost', {
  group = config_group,
  pattern = { '.vimrc', '.vimrc.local', 'init.vim', 'init.lua', 'lua/config/*.lua' },
  callback = function()
    vim.cmd('source %')
  end,
})

-- Make quickfix windows take all the lower section of the screen
autocmd('FileType', {
  group = config_group,
  pattern = 'qf',
  callback = function()
    vim.cmd('wincmd J')
    vim.keymap.set('n', 'q', ':q<cr>', { buffer = true })
  end,
})

-- Set folding method per-buffer: prefer Treesitter, fallback to indent
-- Treesitter provides better semantic folding based on AST
-- Note: When nvim-treesitter has fold.enable = true, it automatically sets up folding
-- This autocmd ensures foldlevel is set and provides a fallback
autocmd({ 'BufReadPost', 'FileType' }, {
  group = config_group,
  callback = function()
    -- Check if Treesitter is available and can provide folding
    local buf = vim.api.nvim_get_current_buf()
    local has_parser = pcall(function()
      return vim.treesitter.get_parser(buf) ~= nil
    end)
    
    if has_parser then
      -- Treesitter parser is available, use Treesitter folding
      -- (nvim-treesitter config with fold.enable = true should handle this automatically)
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    else
      -- Fallback to indent-based folding if Treesitter parser is not available
      vim.opt_local.foldmethod = 'indent'
    end
    -- Ensure foldlevel is set to 99 (unfolded) for new buffers
    vim.opt_local.foldlevel = 99
  end,
})

-- ============================================================================
-- NERDTREE GROUP
-- ============================================================================
local nerdtree_group = augroup('nerdtree', { clear = true })

autocmd('FileType', {
  group = nerdtree_group,
  pattern = 'nerdtree',
  callback = function()
    vim.opt_local.list = false -- Turn off whitespace characters
    vim.opt_local.cursorline = false -- Turn off line highlighting for performance
  end,
})

-- Auto-open NERDTree on startup if no file specified
autocmd('VimEnter', {
  group = nerdtree_group,
  callback = function()
    -- Only open NERDTree if no file was specified and NERDTree plugin is available
    if vim.fn.argc() == 0 and vim.fn.exists(':NERDTreeToggle') == 2 then
      vim.cmd('NERDTreeToggle')
      vim.cmd('wincmd p') -- Move focus to main window
    end
  end,
})

-- ============================================================================
-- STARTIFY GROUP
-- ============================================================================
autocmd('User', {
  pattern = 'Startified',
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

