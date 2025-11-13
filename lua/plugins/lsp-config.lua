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

      -- Autocmd para configurar keymaps quando LSP anexa ao buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          -- Keymaps LSP específicos do buffer
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)  -- Usa gI maiúsculo para não conflitar
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          -- Ctrl+Click para ir para definição (similar ao VS Code)
          vim.keymap.set("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", opts)
          vim.keymap.set("n", "<C-RightMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.references()<CR>", opts)
        end,
      })

      -- Configuração dos servidores usando a nova API vim.lsp (Neovim 0.11+)
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
    end,
  },
}
