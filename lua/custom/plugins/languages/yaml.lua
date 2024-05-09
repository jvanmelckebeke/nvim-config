return {
  'someone-stole-my-name/yaml-companion.nvim',
  requires = {
    { 'neovim/nvim-lspconfig' },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
  },
  ft = { 'yaml' },
  config = function()
    local cfg = require('yaml-companion').setup {
      schemas = {
        {
          name = 'github actions',
          description = 'github actions',
          filematch = { '.github/workflows/*.yml' },
          url = 'https://json.schemastore.org/github-workflow.json',
        },
      },
      lspconfig = {
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            validate = true,
            format = { enable = true },
            hover = true,
            schemaStore = {
              enable = true,
              url = 'https://www.schemastore.org/api/json/catalog.json',
            },
            schemaDownload = { enable = true },
            schemas = {},
            trace = { server = 'debug' },
          },
        },
      },
    }

    require('lspconfig')['yamlls'].setup(cfg)

    require('telescope').load_extension 'yaml_schema'
  end,
}
