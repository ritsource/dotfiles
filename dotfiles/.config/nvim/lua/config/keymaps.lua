-- Neovim 0.11+ Key Mappings
-- All key mappings converted to Lua

local map = vim.keymap.set
local cmd = vim.cmd
local g = vim.g

-- ============================================================================
-- LEADER KEY
-- ============================================================================
g.mapleader = ' ' -- Set space as leader key
g.maplocalleader = ' '

-- ============================================================================
-- ESCAPE REMAPPING
-- ============================================================================
map('i', 'jj', '<esc>', { desc = 'Exit insert mode' })

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================
map('n', '<leader><leader>', ':w<cr>', { desc = 'Quick save' })
map('n', '<leader>ev', ':e! ~/.config/nvim/init.lua<cr>', { desc = 'Edit init.lua' })
map('n', '<leader>eg', ':e! ~/.gitconfig<cr>', { desc = 'Edit gitconfig' })

-- ============================================================================
-- PASTE TOGGLE
-- ============================================================================
map('n', '<leader>v', ':set invpaste paste?<CR>', { desc = 'Toggle paste mode' })

-- ============================================================================
-- SEARCH
-- ============================================================================
map('n', '<leader>c', ':set hlsearch! hlsearch?<cr>', { desc = 'Toggle search highlighting' })
map('n', '<leader>l', ':set list!<cr>', { desc = 'Toggle invisible characters' })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================
map('n', '<leader>m', ':MaximizerToggle<cr>', { desc = 'Toggle window maximization' })
map('n', '<C-h>', '<Plug>WinMoveLeft', { desc = 'Move window left', silent = true })
map('n', '<C-j>', '<Plug>WinMoveDown', { desc = 'Move window down', silent = true })
map('n', '<C-k>', '<Plug>WinMoveUp', { desc = 'Move window up', silent = true })
map('n', '<C-l>', '<Plug>WinMoveRight', { desc = 'Move window right', silent = true })
map('n', '<leader>z', '<Plug>Zoom', { desc = 'Zoom window' })
map('n', '<leader>wc', ':wincmd q<cr>', { desc = 'Close window' })

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================
map('n', '<leader>.', '<c-^>', { desc = 'Switch between current and last buffer' })
map('n', '<leader>b', ':Bdelete<cr>', { desc = 'Close buffer but keep split' })

-- ============================================================================
-- SPELL CHECKING
-- ============================================================================
map('n', ';s', ':set invspell spelllang=en<cr>', { desc = 'Toggle spell checking' })

-- ============================================================================
-- WHITESPACE CLEANUP
-- ============================================================================
map('n', '<leader>,', ':%s/\\s\\+$<cr>', { desc = 'Remove trailing whitespace' })
map('n', '<leader>,,', ':%s/\\n\\{2,}/\\r\\r/g<cr>', { desc = 'Remove multiple blank lines' })

-- ============================================================================
-- VISUAL MODE
-- ============================================================================
-- Keep visual selection when indenting/outdenting
map('v', '<', '<gv', { desc = 'Indent and keep selection' })
map('v', '>', '>gv', { desc = 'Outdent and keep selection' })

-- Enable . command in visual mode
map('v', '.', ':normal .<cr>', { desc = 'Repeat last command' })

-- ============================================================================
-- TEXT OBJECTS
-- ============================================================================
-- Inner-line (exclude leading whitespace and newline)
map('x', 'il', '<c-u>normal! g_v^<cr>', { desc = 'Inner line', silent = true })
map('o', 'il', '<c-u>normal! g_v^<cr>', { desc = 'Inner line', silent = true })

-- Around line (include leading whitespace and newline)
map('v', 'al', '<c-u>normal! $v0<cr>', { desc = 'Around line', silent = true })
map('o', 'al', '<c-u>normal! $v0<cr>', { desc = 'Around line', silent = true })

-- ============================================================================
-- SURROUNDING TEXT
-- ============================================================================
-- Wrap visual selection with various delimiters
map('v', '$(', '<esc>`>a)<esc>`<i(<esc>', { desc = 'Wrap with parentheses' })
map('v', '$[', '<esc>`>a]<esc>`<i[<esc>', { desc = 'Wrap with brackets' })
map('v', '${', '<esc>`>a}<esc>`<i{<esc>', { desc = 'Wrap with braces' })
map('v', '$"', '<esc>`>a"<esc>`<i"<esc>', { desc = 'Wrap with double quotes' })
map('v', "$'", '<esc>`>a\'<esc>`<i\'<esc>', { desc = 'Wrap with single quotes' })
map('v', '$\\', '<esc>`>o*/<esc>`<O/*<esc>', { desc = 'Wrap with comment' })
map('v', '$<', '<esc>`>a><esc>`<i<<esc>', { desc = 'Wrap with angle brackets' })

-- ============================================================================
-- CURSOR LINE
-- ============================================================================
map('n', '<leader>i', ':set cursorline!<cr>', { desc = 'Toggle cursor line highlighting' })

-- ============================================================================
-- SCROLLING
-- ============================================================================
map('n', '<C-e>', '3<C-e>', { desc = 'Scroll down faster' })
map('n', '<C-y>', '3<C-y>', { desc = 'Scroll up faster' })

-- ============================================================================
-- MOVEMENT
-- ============================================================================
-- Note: Overriding 'j' and 'k' breaks normal Vim movement and can cause issues
-- Use 'gj' and 'gk' explicitly when needed, or use <leader>j/k for wrapped movement
-- Moving up and down work as expected (respect wrapped lines) - use leader prefix
map('n', '<leader>j', 'gj', { desc = 'Move down (respect wrapped lines)', silent = true })
map('n', '<leader>k', 'gk', { desc = 'Move up (respect wrapped lines)', silent = true })
map('n', '<leader>^', 'g^', { desc = 'Move to first non-blank (respect wrapped lines)', silent = true })
map('n', '<leader>$', 'g$', { desc = 'Move to end (respect wrapped lines)', silent = true })

-- ============================================================================
-- TAB SETTINGS HELPERS
-- ============================================================================
map('n', '\\t', ':set ts=4 sts=4 sw=4 noet<cr>', { desc = 'Set tabs (no expand)' })
map('n', '\\s', ':set ts=4 sts=4 sw=4 et<cr>', { desc = 'Set spaces (expand tabs)' })

-- ============================================================================
-- COMPLETION
-- ============================================================================
-- Navigate completion menu with Ctrl-j/k (fallback for non-LSP completion)
-- Note: These conflict with window movement in normal mode, but are fine in insert mode
map('i', '<C-j>', 'pumvisible() ? "\\<C-N>" : "\\<C-j>"', { expr = true, desc = 'Next completion item' })
map('i', '<C-k>', 'pumvisible() ? "\\<C-P>" : "\\<C-k>"', { expr = true, desc = 'Previous completion item' })
map('i', '<C-Space>', '<C-x><C-o>', { desc = 'Trigger omni-completion' })
map('i', '<C-@>', '<C-Space>', { desc = 'Alternative omni-completion trigger' })

-- ============================================================================
-- LINE MOVEMENT
-- ============================================================================
-- Move lines up and down (∆ is <A-j> on macOS, ˚ is <A-k> on macOS)
map('n', '∆', ':m .+1<cr>==', { desc = 'Move line down' })
map('n', '˚', ':m .-2<cr>==', { desc = 'Move line up' })
map('i', '∆', '<Esc>:m .+1<cr>==gi', { desc = 'Move line down in insert mode' })
map('i', '˚', '<Esc>:m .-2<cr>==gi', { desc = 'Move line up in insert mode' })
map('v', '∆', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '˚', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- ============================================================================
-- INTERESTING WORD MAPPINGS
-- ============================================================================
map('n', '<leader>0', '<Plug>ClearInterestingWord', { desc = 'Clear interesting word' })
map('n', '<leader>1', '<Plug>HiInterestingWord1', { desc = 'Highlight word 1' })
map('n', '<leader>2', '<Plug>HiInterestingWord2', { desc = 'Highlight word 2' })
map('n', '<leader>3', '<Plug>HiInterestingWord3', { desc = 'Highlight word 3' })
map('n', '<leader>4', '<Plug>HiInterestingWord4', { desc = 'Highlight word 4' })
map('n', '<leader>5', '<Plug>HiInterestingWord5', { desc = 'Highlight word 5' })
map('n', '<leader>6', '<Plug>HiInterestingWord6', { desc = 'Highlight word 6' })

-- ============================================================================
-- DELETE WITHOUT CUTTING
-- ============================================================================
-- Note: Overriding default 'd' and 'D' is very aggressive and breaks normal Vim workflow
-- Only override 'x' for single character deletion
-- For delete operations, use leader prefix to avoid yanking
map('n', 'x', '"_x', { desc = 'Delete character without yanking' })

-- Delete with yanking (default behavior preserved)
-- Use <leader>d for delete operations that should NOT yank
map('n', '<leader>dx', '"_d', { desc = 'Delete without yanking' })
map('n', '<leader>dX', '"_D', { desc = 'Delete to end of line without yanking' })
map('v', '<leader>dx', '"_d', { desc = 'Delete selection without yanking' })

-- ============================================================================
-- CODE FOLDING
-- ============================================================================
-- Fold everything from root (foldlevel = 0)
map('n', '<C-f><C-f>', function() vim.opt_local.foldlevel = 0 end, { desc = 'Fold everything', silent = true })

-- Unfold everything (foldlevel = 99)
map('n', '<C-f><C-u>', function() vim.opt_local.foldlevel = 99 end, { desc = 'Unfold everything', silent = true })

-- Fold to specific levels (1-6)
map('n', '<C-f>1', function() vim.opt_local.foldlevel = 1 end, { desc = 'Fold to level 1', silent = true })
map('n', '<C-f>2', function() vim.opt_local.foldlevel = 2 end, { desc = 'Fold to level 2', silent = true })
map('n', '<C-f>3', function() vim.opt_local.foldlevel = 3 end, { desc = 'Fold to level 3', silent = true })
map('n', '<C-f>4', function() vim.opt_local.foldlevel = 4 end, { desc = 'Fold to level 4', silent = true })
map('n', '<C-f>5', function() vim.opt_local.foldlevel = 5 end, { desc = 'Fold to level 5', silent = true })
map('n', '<C-f>6', function() vim.opt_local.foldlevel = 6 end, { desc = 'Fold to level 6', silent = true })

-- ============================================================================
-- WILDMENU NAVIGATION
-- ============================================================================
-- Note: Removed wildmenu arrow key remappings as they interfere with command history
-- Command history navigation (up/down arrows) now works normally
-- Wildmenu can still be navigated with Tab/Shift-Tab and arrow keys work normally there too

