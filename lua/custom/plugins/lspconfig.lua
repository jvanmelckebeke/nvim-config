return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    -- make sure mason installs the server
    servers = {
      yamlls = {
        -- Have to add this for yamlls to understand that we support line folding
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            hover = true,
            customTags = { '!Ref', '!Sub', '!If', '!Equals', '!Not', '!And', '!Or' },
            keyOrdering = false,
            format = {
              enable = true,
            },
            validate = true,
            schemaStore = {
              -- Must disable built-in schemaStore support to use
              -- schemas from SchemaStore.nvim plugin
              enable = true,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            },
          },
        },
      },
      pyright = {
        single_file_support = false,
        on_new_config = function(cfg, root)
          print(root)
        end,
      },
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = true },
              pydocstyle = { enabled = true },
              pylint = {
                enabled = true,
              },
              flake8 = { enabled = false },
              yapf = { enabled = false },
              autopep8 = {
                enabled = true,
                args = { '--max-line-length=240' },
              },
              mypy = { enabled = true },
              isort = { enabled = false },
            },
          },
        },
      },

      setup = {
        yamlls = function()
          -- Neovim < 0.10 does not have dynamic registration for formatting
          if vim.fn.has 'nvim-0.10' == 0 then
            require('lazyvim.util').lsp.on_attach(function(client, _)
              if client.name == 'yamlls' then
                client.server_capabilities.documentFormattingProvider = true
              end
            end)
          end
        end,
        pyright = function()
          -- override the root dir to be the current working dir
          -- so that pyright can find the virtualenv and pyright config files
          require('lspconfig').pyright.setup {
            single_file_support = false,
            root_dir = function()
              -- log something so I know it is run
              return vim.fn.getcwd()
            end,
          }
        end,
      },
    },
  },
}
