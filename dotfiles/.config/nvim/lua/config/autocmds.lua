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

