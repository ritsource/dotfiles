-- Neovim 0.11+ LSP Configuration
-- Native LSP setup using Mason, lspconfig, and cmp

local M = {}

function M.setup()
  -- Check if plugins are loaded
  local ok, mason = pcall(require, 'mason')
  if not ok then
    return
  end

  -- Initialize Mason
  require('mason').setup({
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  })

  -- Configure Mason to automatically install LSP servers
  require('mason-lspconfig').setup({
    ensure_installed = {
      'cssls',      -- CSS
      'jsonls',     -- JSON
      'tsserver',   -- TypeScript/JavaScript
      'eslint',     -- ESLint
      'bashls',     -- Bash
      'vimls',      -- Vim
      'emmet_ls',   -- Emmet
      'gopls',      -- Go
      'html',       -- HTML
      'lua_ls',     -- Lua
    },
    automatic_installation = true,
  })

  -- LSP key mappings
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Go to definition
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    -- Go to type definition
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)

    -- Go to implementation
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- Show references
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    -- Hover documentation
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    -- Rename symbol
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    -- Code actions
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Format document
    vim.keymap.set('n', '<leader>f', function()
      require('conform').format({ async = true })
    end, opts)
    vim.keymap.set('v', '<leader>f', function()
      require('conform').format({ async = true })
    end, opts)

    -- Diagnostics navigation
    vim.keymap.set('n', '[c', function()
      vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set('n', ']c', function()
      vim.diagnostic.goto_next()
    end, opts)

    -- Show diagnostics in a floating window
    -- Use <leader>dd to avoid conflict with <leader>d (delete with yanking)
    vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, opts)

    -- Signature help
    -- Note: <C-h> conflicts with window movement, but in insert mode it's fine
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
  end

  -- Configure LSP servers using vim.lsp.config (Neovim 0.11+ API)
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- CSS
  vim.lsp.config('cssls', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('cssls')

  -- JSON
  vim.lsp.config('jsonls', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('jsonls')

  -- TypeScript/JavaScript
  vim.lsp.config('tsserver', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('tsserver')

  -- ESLint
  vim.lsp.config('eslint', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('eslint')

  -- Bash
  vim.lsp.config('bashls', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('bashls')

  -- Vim
  vim.lsp.config('vimls', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('vimls')

  -- Emmet
  vim.lsp.config('emmet_ls', {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  })
  vim.lsp.enable('emmet_ls')

  -- Go
  vim.lsp.config('gopls', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('gopls')

  -- HTML
  vim.lsp.config('html', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable('html')

  -- Lua (for Neovim config)
  vim.lsp.config('lua_ls', {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
  vim.lsp.enable('lua_ls')

  -- Configure diagnostics
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  -- Signs for diagnostics
  local signs = { Error = '✗', Warn = '⚠', Hint = '➤', Info = 'ℹ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Setup nvim-cmp
  local ok, cmp = pcall(require, 'cmp')
  if ok then
    local luasnip = require('luasnip')

    -- Load snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      }),
    })

    -- Command line completion
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })
  end

  -- Setup nvim-autopairs
  local ok_ap, npairs = pcall(require, 'nvim-autopairs')
  if ok_ap then
    npairs.setup({
      check_ts = true,
    })

    -- Connect autopairs with cmp
    if ok then
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  end

  -- Setup gitsigns
  local ok_gs, gitsigns = pcall(require, 'gitsigns')
  if ok_gs then
    gitsigns.setup({
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    })

    -- Git signs navigation
    vim.keymap.set('n', '[g', function()
      gitsigns.prev_hunk()
    end, { desc = 'Previous git chunk' })
    vim.keymap.set('n', ']g', function()
      gitsigns.next_hunk()
    end, { desc = 'Next git chunk' })
    vim.keymap.set('n', 'gs', function()
      gitsigns.stage_hunk()
    end, { desc = 'Stage git chunk' })
    vim.keymap.set('n', 'gu', function()
      gitsigns.undo_stage_hunk()
    end, { desc = 'Undo git chunk' })
    vim.keymap.set('n', '<leader>hp', function()
      gitsigns.preview_hunk()
    end, { desc = 'Preview git chunk' })
    vim.keymap.set('n', '<leader>hb', function()
      gitsigns.blame_line()
    end, { desc = 'Git blame line' })
  end

  -- Setup conform.nvim (formatting)
  -- Replicates null-ls formatting behavior: same filetypes, same formatters, same triggers
  local ok_cf, conform = pcall(require, 'conform')
  if ok_cf then
    conform.setup({
      formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        html = { 'prettier' },
        markdown = { 'prettier' },
        yaml = { 'prettier' },
        go = { 'goimports' },
      },
      -- Note: format_on_save is handled by explicit autocmd below for better control
    })

    -- Formatting commands (preserves old :Prettier command)
    vim.api.nvim_create_user_command('Prettier', function()
      conform.format({ async = true })
    end, { desc = 'Format with Prettier' })

    -- Explicit format on save hook (replicates null-ls behavior)
    -- Triggers on BufWritePre, same as null-ls used to
    -- Only format if conform has a formatter for this filetype
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('conform_format', { clear = true }),
      callback = function(args)
        -- Check if there's a formatter for this filetype before formatting
        local ft = vim.bo[args.buf].filetype
        if ft then
          local formatters = conform.list_formatters(args.buf)
          if #formatters > 0 then
            conform.format({ bufnr = args.buf })
          end
        end
      end,
    })
  end

  -- Setup nvim-lint (linting)
  -- Replicates null-ls linting behavior: same filetypes, same linters, same triggers
  local ok_lint, lint = pcall(require, 'lint')
  if ok_lint then
    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    -- Explicit lint on save hook (replicates null-ls behavior)
    -- Triggers on BufWritePost, same as null-ls used to
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      group = vim.api.nvim_create_augroup('lint_on_save', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end

  -- Organize imports command
  vim.api.nvim_create_user_command('OR', function()
    vim.lsp.buf.code_action({
      filter = function(a)
        return a.name == 'source.organizeImports'
      end,
      apply = true,
    })
  end, { desc = 'Organize imports' })
end

return M

