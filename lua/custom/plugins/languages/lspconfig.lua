return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },

    -- schemastore
    'b0o/schemastore.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    require('lspconfig.configs').cfn_lsp = {
      default_config = {
        cmd = { os.getenv 'HOME' .. '/.local/bin/cfn-lsp-extra' },
        filetypes = { 'yaml.cloudformation', 'json.cloudformation' },
        root_dir = function(fname)
          return require('lspconfig').util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        settings = {
          documentFormatting = false,
        },
      },
    }
    require('lspconfig').cfn_lsp.setup {}

    local servers = {
      -- Add specific server configurations here
      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },

      -- cfn-lint gets used by cfn_lsp under the hood
      -- ['cfn-lint'] = {
      --   filetypes = { 'yaml.cloudformation', 'json.cloudformation' },
      -- },

      yamlls = {
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
        end,
        settings = {
          yaml = {
            completion = true,

            customTags = {
              '!fn',
              '!And',
              '!If',
              '!Not',
              '!Equals',
              '!Or',
              '!FindInMap sequence',
              '!Base64',
              '!Cidr',
              '!Ref',
              '!Ref Scalar',
              '!Sub',
              '!GetAtt',
              '!GetAZs',
              '!ImportValue',
              '!Select',
              '!Split',
              '!Join sequence',
            },
            hover = true,
            keyOrdering = false,
            format = {
              enable = true,
            },
            validate = true,
            schemas = {
              ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            },
            schemaStore = {
              enable = true,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemaDownload = {
              enable = true,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
          },
        },
      },
      -- Other servers...
      pyright = {
        single_file_support = false,
        root_dir = function(fname)
          -- return current working dir
          return vim.loop.cwd()
        end,
        on_new_config = function(cfg, root) end,
      },
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = false },
              pydocstyle = { enabled = false },
              pylint = { enabled = false },
              flake8 = { enabled = false },
              yapf = { enabled = false },
              autopep8 = {
                enabled = true,
                args = { '--max-line-length=240' },
              },
              mypy = { enabled = false },
              isort = { enabled = false },
            },
          },
        },
        root_dir = function(fname)
          -- return current working dir
          return vim.loop.cwd()
        end,
      },
    }

    require('mason').setup()
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })

    require('mason-tool-installer').setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
  setup = {
    yamlls = function()
      -- Neovim < 0.10 does not have dynamic registration for formatting
      if vim.fn.has 'nvim-0.10' == 0 then
        vim.lsp.on_attach(function(client, _)
          if client.name == 'yamlls' then
            client.server_capabilities.documentFormattingProvider = true
          end
        end)
      end
    end,
  },
}
