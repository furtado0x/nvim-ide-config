return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format", "ruff_organize_imports" },
        },
        -- SEM format_on_save - você controla!
      })
      
      -- Formata arquivo inteiro OU seleção
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or selection" })
      
      -- Formata só linhas modificadas no buffer
      vim.keymap.set("n", "<leader>F", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
          range = {
            start = vim.fn.line("'["),
            ["end"] = vim.fn.line("']"),
          },
        })
      end, { desc = "Format last change" })
    end,
  },
}
