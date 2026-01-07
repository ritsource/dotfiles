-- Neovim 0.11+ Plugin Configuration with lazy.nvim
-- All plugins are declared here using lazy.nvim

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  return -- Lazy will be bootstrapped in init.lua
end

require('lazy').setup({
  -- ============================================================================
  -- COLORSchemes
  -- ============================================================================
  { 'chriskempson/base16-vim' },
  { 'joshdick/onedark.vim' },
  { 'ayu-theme/ayu-vim' },
  { 'arcticicestudio/nord-vim' },
  { 'NLKNguyen/papercolor-theme' },
  { 'iCyMind/NeoSolarized' },

  -- ============================================================================
  -- UI & STATUS LINE
  -- ============================================================================
  {
    'itchyny/lightline.vim',
    config = function()
      vim.g.lightline = {
        colorscheme = 'ayu',
        active = {
          left = { { 'mode', 'paste' }, { 'gitbranch' }, { 'readonly', 'filetype', 'filename' } },
          right = { { 'percent' }, { 'lineinfo' }, { 'fileformat', 'fileencoding' }, { 'gitblame', 'currentfunction', 'linter_errors', 'linter_warnings' } },
        },
        -- component_expand must be a dictionary, not an empty table
        -- Only include if you have components that need expansion
        component_type = {
          readonly = 'error',
          linter_warnings = 'warning',
          linter_errors = 'error',
        },
        component_function = {
          fileencoding = 'helpers#lightline#fileEncoding',
          filename = 'helpers#lightline#fileName',
          fileformat = 'helpers#lightline#fileFormat',
          filetype = 'helpers#lightline#fileType',
          gitbranch = 'helpers#lightline#gitBranch',
          currentfunction = 'helpers#lightline#currentFunction',
          gitblame = 'helpers#lightline#gitBlame',
        },
        tabline = {
          left = { { 'tabs' } },
          right = { { 'close' } },
        },
        tab = {
          active = { 'filename', 'modified' },
          inactive = { 'filename', 'modified' },
        },
        separator = { left = '', right = '' },
        subseparator = { left = '', right = '' },
      }
    end,
  },
  { 'nicknisi/vim-base16-lightline' },
  { 'Yggdroot/indentLine' },
  { 'szw/vim-maximizer' },

  -- ============================================================================
  -- GENERAL FUNCTIONALITY
  -- ============================================================================
  { 'tpope/vim-abolish' },
  { 'wincent/ferret' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-ragtag' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'editorconfig/editorconfig-vim' },
  { 'AndrewRadev/splitjoin.vim' },
  { 'tpope/vim-endwise' },
  { 'tpope/vim-sleuth' },
  { 'moll/vim-bbye' },
  { 'sickill/vim-pasta' },

  -- ============================================================================
  -- FILE NAVIGATION
  -- ============================================================================
  {
    'scrooloose/nerdtree',
    cmd = { 'NERDTreeToggle', 'NERDTreeFind' },
    config = function()
      vim.g.WebDevIconsOS = 'Darwin'
      vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
      vim.g.DevIconsEnableFoldersOpenClose = 1
      vim.g.DevIconsEnableFolderExtensionPatternMatching = 1
      -- Unicode characters for NERDTree arrows (non-breaking space)
      vim.g.NERDTreeDirArrowExpandable = '\194\160' -- U+00A0 (non-breaking space)
      vim.g.NERDTreeDirArrowCollapsible = '\194\160' -- U+00A0 (non-breaking space)
      vim.g.NERDTreeNodeDelimiter = '\226\152\186' -- U+263A (smiling face)
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeGitStatusIndicatorMapCustom = {
        Modified = '•',
        Staged = '✚',
        Untracked = '✭',
        Renamed = '➜',
        Unmerged = '═',
        Deleted = '✖',
        Dirty = '✗',
        Clean = '✔︎',
        Ignored = '☒',
        Unknown = '?',
      }

      local function toggle_nerdtree()
        if vim.fn.empty(vim.fn.expand('%')) == 0 and vim.fn.match(vim.fn.expand('%'), 'Startify') == -1 then
          if vim.fn.exists('g:NERDTree') == 0 or (vim.g.NERDTree.ExistsForTab() and not vim.g.NERDTree.IsOpen()) then
            vim.cmd('NERDTreeFind')
          else
            vim.cmd('NERDTreeToggle')
          end
        else
          vim.cmd('NERDTreeToggle')
        end
      end

      vim.keymap.set('n', '<leader>n', toggle_nerdtree, { desc = 'Toggle NERDTree', silent = true })
      vim.keymap.set('n', '<leader>y', ':NERDTreeFind<cr>', { desc = 'Find file in NERDTree', silent = true })
    end,
  },
  { 'Xuyuanp/nerdtree-git-plugin' },
  { 'tiagofumo/vim-nerdtree-syntax-highlight' },
  { 'ryanoasis/vim-devicons' },
  {
    'junegunn/fzf',
    -- Build creates a symlink to system fzf (from Homebrew) if available
    -- This is the recommended approach - uses system fzf when found
    build = './install --bin',
  },
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    config = function()
      -- Ensure system fzf (Homebrew) is in PATH so fzf.vim can find it
      -- The plugin will prefer system fzf if it's in PATH
      local homebrew_bin = '/opt/homebrew/bin'
      if vim.fn.isdirectory(homebrew_bin) == 1 then
        local current_path = vim.env.PATH or ''
        if vim.fn.match(current_path, homebrew_bin) == -1 then
          vim.env.PATH = homebrew_bin .. ':' .. current_path
        end
      end
      vim.g.fzf_layout = { down = '~25%' }
      -- Enable case-insensitive search by default
      vim.env.FZF_DEFAULT_OPTS = (vim.env.FZF_DEFAULT_OPTS or '') .. ' --case-insensitive'
      
      -- Note: Checking .git directory at config time won't work correctly
      -- Use a function to check at runtime instead
      vim.keymap.set('n', '<leader>t', function()
        if vim.fn.isdirectory('.git') == 1 then
          vim.cmd('GitFiles --cached --others --exclude-standard')
        else
          vim.cmd('Files')
        end
      end, { desc = 'Git files or file finder', silent = true })
      vim.keymap.set('n', '<leader>s', ':GFiles?<cr>', { desc = 'Git status files', silent = true })
      vim.keymap.set('n', '<leader>r', ':Buffers<cr>', { desc = 'Buffer list', silent = true })
      vim.keymap.set('n', '<leader>e', ':Files<cr>', { desc = 'File finder', silent = true })
      -- Use <leader>ff for file finder to avoid conflict with <leader>f (formatting)
      vim.keymap.set('n', '<leader>ff', ':Files<cr>', { desc = 'File finder (case insensitive)', silent = true })
    end,
  },
  { 'kien/ctrlp.vim' },

  -- ============================================================================
  -- GIT INTEGRATION
  -- ============================================================================
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', ':Gstatus<cr>', { desc = 'Git status', silent = true })
      vim.keymap.set('n', '<leader>ge', ':Gedit<cr>', { desc = 'Git edit' })
      vim.keymap.set('n', '<leader>gr', ':Gread<cr>', { desc = 'Git read (checkout)', silent = true })
      vim.keymap.set('n', '<leader>gb', ':Gblame<cr>', { desc = 'Git blame', silent = true })
    end,
  },
  { 'tpope/vim-rhubarb' },
  { 'junegunn/gv.vim' },
  { 'sodapopcan/vim-twiggy' },

  -- ============================================================================
  -- STARTUP SCREEN
  -- ============================================================================
  {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_files_number = 5
      vim.g.startify_change_to_dir = 0
      vim.g.startify_custom_header = {}
      vim.g.startify_relative_path = 1
      vim.g.startify_use_env = 1
      vim.g.startify_lists = {
        { type = 'dir', header = { 'Files ' .. vim.fn.getcwd() } },
        { type = 'sessions', header = { 'Sessions' } },
        { type = 'bookmarks', header = { 'Bookmarks' } },
        { type = 'commands', header = { 'Commands' } },
      }
      vim.g.startify_commands = {
        { up = { 'Update Plugins', ':Lazy update' } },
      }
      vim.g.startify_bookmarks = {
        { c = '~/.config/nvim/init.lua' },
        { g = '~/.gitconfig' },
        { z = '~/.bash_profile' },
      }
      vim.keymap.set('n', '<leader>st', ':Startify<cr>', { desc = 'Open Startify' })
    end,
  },

  -- ============================================================================
  -- WRITING MODE
  -- ============================================================================
  {
    'junegunn/goyo.vim',
    config = function()
      vim.g.goyo_height = '100%'
      vim.g.goyo_width = 122
      vim.keymap.set('n', '<leader>a', ':Goyo<cr>', { desc = 'Toggle Goyo', silent = true })
    end,
  },

  -- ============================================================================
  -- LSP & COMPLETION (Native Neovim)
  -- ============================================================================
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = true,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
  },
  { 'neovim/nvim-lspconfig' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },
  },

  -- ============================================================================
  -- LSP ENHANCEMENTS
  -- ============================================================================
  { 'nvim-lua/plenary.nvim' },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    -- Config is handled in lsp.lua after lazy loads
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufWritePost' },
    -- Config is handled in lsp.lua after lazy loads
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    -- Config is handled in lsp.lua after lazy loads
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Config is handled in lsp.lua after lazy loads
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  -- ============================================================================
  -- TREESITTER (Syntax Parsing & Folding)
  -- ============================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- Safely require and configure Treesitter
      local ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
      if not ok then
        -- Plugin not installed yet, will be configured on next load
        return
      end
      treesitter_configs.setup({
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        -- List of parsers to ignore installing
        ignore_install = {},
        highlight = {
          enable = true,
          -- Disable if nvim-treesitter causes issues
          disable = {},
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        -- Enable Treesitter-based folding
        -- This provides better semantic folding than indent-based folding
        fold = {
          enable = true,
        },
      })
    end,
  },

  -- ============================================================================
  -- SNIPPETS
  -- ============================================================================
  {
    'SirVer/ultisnips',
    config = function()
      vim.g.UltiSnipsExpandTrigger = '<C-l>'
      vim.g.UltiSnipsJumpForwardTrigger = '<C-j>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<C-k>'
    end,
  },

  -- ============================================================================
  -- LANGUAGE SUPPORT
  -- ============================================================================
  -- HTML/Templates
  { 'mattn/emmet-vim', ft = 'html' },
  { 'gregsexton/MatchTag', ft = 'html' },
  { 'othree/html5.vim', ft = 'html' },
  { 'mustache/vim-mustache-handlebars' },
  { 'digitaltoad/vim-pug', ft = { 'jade', 'pug' } },
  { 'lepture/vim-jinja', ft = 'njk' },

  -- JavaScript/TypeScript
  { 'othree/yajs.vim', ft = { 'javascript', 'javascript.jsx', 'html' } },
  { 'pangloss/vim-javascript' },
  { 'moll/vim-node', ft = 'javascript' },
  { 'ternjs/tern_for_vim', ft = { 'javascript', 'javascript.jsx' }, build = 'npm install' },
  { 'MaxMEllon/vim-jsx-pretty' },
  { 'leafgarland/typescript-vim', ft = { 'typescript', 'typescript.tsx' } },

  -- Styles
  { 'wavded/vim-stylus', ft = { 'stylus', 'markdown' } },
  { 'groenewege/vim-less', ft = 'less' },
  { 'hail2u/vim-css3-syntax', ft = 'css' },
  { 'cakebaker/scss-syntax.vim', ft = 'scss' },
  { 'stephenway/postcss.vim', ft = 'css' },

  -- Markdown
  {
    'tpope/vim-markdown',
    ft = 'markdown',
    config = function()
      vim.g.markdown_fenced_languages = { 'tsx=typescript.tsx' }
      vim.keymap.set('n', '<leader>md', ':MarkedOpen!<cr>', { desc = 'Open in Marked' })
      vim.keymap.set('n', '<leader>mdq', ':MarkedQuit<cr>', { desc = 'Quit Marked' })
      vim.keymap.set('n', '<leader>*', '*<c-o>:%s///gn<cr>', { desc = 'Count occurrences' })
    end,
  },
  { 'itspriddle/vim-marked', ft = 'markdown', cmd = 'MarkedOpen' },

  -- JSON
  {
    'elzr/vim-json',
    ft = 'json',
    config = function()
      vim.g.vim_json_syntax_conceal = 0
    end,
  },

  -- Go
  {
    'fatih/vim-go',
    ft = 'go',
    config = function()
      vim.g.go_term_mode = 'split'
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_parameters = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_variable_declarations = 1
      vim.g.go_highlight_variable_assignments = 1
      vim.g.go_fmt_command = 'goimports'
    end,
  },

  -- Rust
  { 'rust-lang/rust.vim' },

  -- Other Languages
  { 'timcharper/textile.vim', ft = 'textile' },
  { 'lambdatoast/elm.vim', ft = 'elm' },
  { 'ekalinin/Dockerfile.vim' },

  -- ============================================================================
  -- UTILITIES
  -- ============================================================================
  { 'kshenoy/vim-signature' },
}, {
  -- Lazy.nvim options
  install = {
    colorscheme = { 'ayu' },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  -- Disable luarocks/hererocks support since no plugins require it
  -- This removes the warnings from :checkhealth
  rocks = {
    enabled = false,
  },
})
