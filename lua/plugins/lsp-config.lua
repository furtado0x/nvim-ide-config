return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Configuração dos servidores usando a nova API vim.lsp
      local servers = {
        -- Python (essencial para FastAPI/Django)
        pyright = {
          filetypes = { "python" },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              }
            }
          }
        },
        
        -- HTML (templates Django)
        html = {
          filetypes = { "html", "htmldjango", "templ" },
        },
        
        -- Lua (config do Neovim)
        lua_ls = {
          filetypes = { "lua" },
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }
              }
            }
          }
        },
        
        -- TypeScript (caso precise de frontend)
        ts_ls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
      }
      
      -- Usa a nova API do Neovim 0.11
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
      
      -- Keymaps LSP
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
    end,
  },
}
