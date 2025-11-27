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
      ensure_installed = {
        "basedpyright",
        "ruff",
        "lua_ls",
        "html",
        "ts_ls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Habilita snippets no autocomplete
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
      }

      -- Função para encontrar virtualenv automaticamente
      local function get_python_path(workspace)
        local util = require('lspconfig.util')
        local path = util.path

        -- Verifica variável de ambiente VIRTUAL_ENV
        if vim.env.VIRTUAL_ENV then
          return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
        end

        -- Procura por venv comum no workspace
        for _, pattern in ipairs({ 'venv', '.venv', 'env', '.env' }) do
          local match = vim.fn.glob(path.join(workspace or vim.fn.getcwd(), pattern, 'bin', 'python'))
          if match ~= '' then
            return match
          end
        end

        -- Poetry
        local poetry_match = vim.fn.glob(path.join(workspace or vim.fn.getcwd(), 'poetry.lock'))
        if poetry_match ~= '' then
          local venv = vim.fn.trim(vim.fn.system('poetry env info -p 2>/dev/null'))
          if venv ~= '' then
            return path.join(venv, 'bin', 'python')
          end
        end

        -- Fallback para python do sistema
        return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
      end

      -- Autocmd para configurar keymaps quando LSP anexa ao buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Keymaps LSP específicos do buffer
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

          -- Signature help (mostra parâmetros da função enquanto digita)
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts)

          -- Type definition
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

          -- Workspace symbols (busca símbolos no projeto)
          vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)

          -- Ctrl+Click para ir para definição (similar ao VS Code)
          vim.keymap.set("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", opts)
          vim.keymap.set("n", "<C-RightMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.references()<CR>", opts)

          -- Inlay hints (Neovim 0.10+) - mostra tipos inline
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
            vim.keymap.set("n", "<leader>ih", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, { buffer = ev.buf, desc = "Toggle inlay hints" })
          end
        end,
      })

      -- Configuração dos servidores usando a nova API vim.lsp (Neovim 0.11+)
      local servers = {
        -- Basedpyright: fork mais avançado do Pyright
        basedpyright = {
          filetypes = { "python" },
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  callArgumentNames = true,
                  pytestParameters = true,
                },
                autoImportCompletions = true,
              },
            },
          },
          before_init = function(_, config)
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = get_python_path(config.root_dir)
          end,
        },

        -- Ruff: linter e formatter ultra-rápido para Python
        ruff = {
          filetypes = { "python" },
          init_options = {
            settings = {
              lineLength = 120,
              lint = {
                enable = true,
                select = { "E", "F", "W", "I", "UP", "B", "C4", "SIM" },
              },
              format = {
                enable = true,
              },
            },
          },
        },

        -- HTML (templates Django)
        html = {
          filetypes = { "html", "htmldjango", "templ" },
        },

        -- Lua (config do Neovim) - com suporte completo à API do Neovim
        lua_ls = {
          filetypes = { "lua" },
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
              hint = {
                enable = true,
                arrayIndex = "Disable",
                setType = true,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },

        -- TypeScript (caso precise de frontend)
        ts_ls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
      }

      -- Usa a nova API do Neovim 0.11
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- Diagnósticos mais bonitos
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = "if_many",
        },
        float = {
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Ícones para diagnósticos
      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
