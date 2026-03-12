return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configura nvim-dap-ui com layout padrão
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            -- Painel esquerdo: scopes, breakpoints, stacks, watches
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            -- Painel inferior: REPL e console
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
        floating = {
          border = "rounded",
        },
      })

      -- Abre/fecha dap-ui automaticamente com sessão de debug
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Configura debugpy para Python
      local dap_python = require("dap-python")

      -- Encontra o python do virtualenv ou do sistema
      local function get_debugpy_python()
        local util = require("lspconfig.util")
        local path = util.path
        local cwd = vim.fn.getcwd()

        -- Verifica VIRTUAL_ENV
        if vim.env.VIRTUAL_ENV then
          return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
        end

        -- Procura venvs comuns
        for _, pattern in ipairs({ "venv", ".venv", "env", ".env" }) do
          local match = vim.fn.glob(path.join(cwd, pattern, "bin", "python"))
          if match ~= "" then
            return match
          end
        end

        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end

      dap_python.setup(get_debugpy_python())

      -- Configuração de Remote Attach para Docker
      -- Conecta ao debugpy rodando dentro do container na porta 5678
      -- O docker-compose já expõe: "5678:5678" e roda debugpy --listen 0.0.0.0:5678
      table.insert(dap.configurations.python, 1, {
        type = "python",
        request = "attach",
        name = "Docker: Attach (porta 5678)",
        connect = {
          host = "127.0.0.1",
          port = 5678,
        },
        pathMappings = {
          {
            localRoot = "${workspaceFolder}",
            remoteRoot = "/app",
          },
        },
        justMyCode = false,
      })

      -- Ícones nos breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpoint", linehl = "", numhl = "" })

      -- Cores dos ícones
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d" })

      -- Keymaps de debug (prefixo <leader>db para "debug")
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Condição: "))
      end, { desc = "Breakpoint condicional" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, { desc = "Log point" })
      vim.keymap.set("n", "<leader>dX", dap.clear_breakpoints, { desc = "Limpar todos os breakpoints" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue / Start debug" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart debug" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate debug" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Eval expression" })
      vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Eval seleção" })

      -- Atalhos com teclas F (estilo VS Code)
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue / Start debug" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

      -- Debug do método/classe Python mais próximo
      vim.keymap.set("n", "<leader>dm", dap_python.test_method, { desc = "Debug test method" })
      vim.keymap.set("n", "<leader>dC", dap_python.test_class, { desc = "Debug test class" })
    end,
  },
}
