-- Neovim 0.11+ Options Configuration
-- All vim options converted to Lua

local opt = vim.opt
local g = vim.g
local cmd = vim.cmd

-- ============================================================================
-- ENCODING & BASIC SETUP
-- ============================================================================
-- Note: encoding option is deprecated in Neovim (always UTF-8)
-- No need to set it explicitly

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================

-- Abbreviations
cmd('iabbrev teh the')
cmd('iabbrev cosnt const')

-- File Management
opt.autoread = true -- Automatically detect when a file is changed outside vim
opt.backupdir = { '~/.vim-tmp', '~/.tmp', '~/tmp', '/var/tmp', '/tmp' }
opt.directory = { '~/.vim-tmp', '~/.tmp', '~/tmp', '/var/tmp', '/tmp' }

-- History
opt.history = 1000 -- Number of commands to remember

-- Text Width
opt.textwidth = 120 -- Maximum width of text

-- Line Numbers
opt.relativenumber = true -- Show relative line numbers
opt.number = true -- Show absolute line number for current line

-- Backspace Behavior
opt.backspace = { 'indent', 'eol', 'start' } -- Make backspace behave properly

-- Clipboard
if vim.fn.has('nvim') == 1 then
  opt.clipboard = 'unnamedplus' -- Use system clipboard in Neovim
else
  opt.clipboard = 'unnamed' -- Use system clipboard in Vim
end

-- Mouse Support
if vim.fn.has('mouse') == 1 then
  opt.mouse = 'a' -- Enable mouse in all modes
end

-- Neovim Specific
if vim.fn.has('nvim') == 1 then
  opt.inccommand = 'nosplit' -- Show substitution results without opening split
end

-- ============================================================================
-- SEARCH SETTINGS
-- ============================================================================
opt.ignorecase = true -- Case insensitive searching
opt.smartcase = true -- Case-sensitive if expression contains capital letter
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search
opt.magic = true -- Set magic on for regex

-- ============================================================================
-- BELL & ERROR SETTINGS
-- ============================================================================
opt.errorbells = false -- Disable error bells
opt.visualbell = true -- Use visual bell
-- Note: t_vb is not available in Neovim (it's a Vim-only option)
-- Neovim handles visual bell internally
opt.timeoutlen = 500 -- Timeout for key codes (tm in Vim)

-- ============================================================================
-- APPEARANCE SETTINGS
-- ============================================================================

-- Line Display
opt.wrap = true -- Turn on line wrapping
opt.wrapmargin = 8 -- Wrap lines when coming within n characters from side
opt.linebreak = true -- Set soft wrapping (break at word boundaries)
opt.showbreak = '↪' -- Show ellipsis at breaking point

-- Indentation
opt.autoindent = true -- Automatically set indent of new line

-- Performance
-- Note: ttyfast is deprecated in Neovim (always enabled)
opt.lazyredraw = false -- Don't redraw while executing macros

-- Diff Options
opt.diffopt:append({ 'vertical', 'iwhite', 'internal', 'algorithm:patience', 'hiddenoff' })

-- Status Line
opt.laststatus = 2 -- Show status line all the time

-- Scroll Offset
opt.scrolloff = 7 -- Set 7 lines to the cursor when moving vertically

-- Command Line
opt.wildmenu = true -- Enhanced command line completion
opt.wildmode = { 'longest:full', 'full' } -- Complete files like a shell
-- Note: wildcharm in Neovim expects a number (character code), not a string
-- <C-Z> is character code 26, but this option is rarely used in Neovim
-- opt.wildcharm = 26 -- Character for wildcard expansion (Ctrl+Z)
opt.cmdheight = 1 -- Command bar height
opt.showcmd = true -- Show incomplete commands
opt.showmode = false -- Don't show mode (disabled for lightline)

-- Buffer Management
opt.hidden = true -- Current buffer can be put into background

-- Terminal
opt.shell = os.getenv('SHELL') or '/bin/sh'
opt.title = true -- Set terminal title

-- Matching
opt.showmatch = true -- Show matching braces
opt.matchtime = 2 -- How many tenths of a second to blink

-- Update Time
opt.updatetime = 300 -- Time in milliseconds before triggering CursorHold events

-- Sign Column
opt.signcolumn = 'yes' -- Always show sign column

-- Messages
opt.shortmess:append('c') -- Don't show completion messages

-- ============================================================================
-- TAB & INDENTATION SETTINGS
-- ============================================================================
opt.smarttab = true -- Tab respects tabstop, shiftwidth, and softtabstop
opt.tabstop = 4 -- The visible width of tabs
opt.softtabstop = 4 -- Edit as if tabs are 4 characters wide
opt.shiftwidth = 4 -- Number of spaces for indent/unindent
opt.shiftround = true -- Round indent to multiple of shiftwidth
opt.expandtab = true -- Use spaces instead of tabs

-- ============================================================================
-- CODE FOLDING SETTINGS
-- ============================================================================
-- Enable folding globally
opt.foldenable = true

-- Start with all code unfolded
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Preserve manual folds
opt.foldcolumn = '1' -- Show fold column
opt.foldnestmax = 10 -- Deepest fold is 10 levels

-- Set folding method per-buffer (via autocmd in autocmds.lua)
-- Treesitter folding is set per-buffer when file is opened
-- Default to indent-based folding as fallback
opt.foldmethod = 'indent'

-- ============================================================================
-- INVISIBLE CHARACTERS
-- ============================================================================
opt.list = true -- Show invisible characters
opt.showbreak = '↪' -- Character to show at line breaks

-- IndentLine plugin configuration
g.indentLine_char_list = { '│', '│', '│', '│' }

-- ============================================================================
-- COLOR & TERMINAL SETTINGS
-- ============================================================================

-- Cursor Configuration
opt.guicursor = table.concat({
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}, ',')

-- Terminal Color Support
-- Note: These legacy hacks (t_ut, t_8f, t_8b) are Vim-only options
-- Neovim handles terminal colors internally and doesn't need these
-- t_ut (background color erase) is not available in Neovim
-- t_8f and t_8b are also Vim-only (Neovim handles truecolor internally)
-- If you experience color issues, check your terminal's truecolor support instead

-- 24-bit Color Support (True Color)
-- Ensure termguicolors is enabled for proper color rendering
-- Requires terminal with truecolor support (most modern terminals)
-- MUST be set early, before colorscheme loads
if vim.fn.has('termguicolors') == 1 then
  -- Only set escape sequences for Vim (not Neovim - it handles this internally)
  if vim.fn.has('nvim') == 0 then
    opt.t_8f = vim.api.nvim_replace_termcodes('<Esc>[38;2;%lu;%lu;%lum', true, false, true)
    opt.t_8b = vim.api.nvim_replace_termcodes('<Esc>[48;2;%lu;%lu;%lum', true, false, true)
  end
  opt.termguicolors = true -- Use 24-bit RGB color (required for proper colorscheme rendering)
else
  -- Fallback: try to enable anyway (Neovim usually supports it)
  opt.termguicolors = true
end

-- Note: 'term' option is not available in Neovim (it's Vim-only)
-- Neovim uses $TERM environment variable instead

-- Conflict Highlighting
cmd("match ErrorMsg '^\\(<\\|=\\|>\\)\\{7\\}\\([^=].\\+\\)\\?$'")

-- ============================================================================
-- SYNTAX & FILETYPE
-- ============================================================================
cmd('syntax on')
cmd('filetype plugin indent on')

