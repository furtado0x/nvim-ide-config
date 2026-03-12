return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local diffview = require("diffview")

    diffview.setup({
      enhanced_diff_hl = true,
      view = {
        -- Layout de merge 3-way (similar ao VS Code)
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config = {
          position = "left",
          width = 35,
        },
      },
    })

    -- Keymaps (prefixo <leader>gd para "git diff")
    vim.keymap.set("n", "<leader>gv", ":DiffviewOpen<CR>", { desc = "Abrir diff view" })
    vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Fechar diff view" })
    vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "Histórico do arquivo" })
    vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "Histórico do branch" })
    vim.keymap.set("n", "<leader>gm", ":DiffviewOpen HEAD...main<CR>", { desc = "Diff contra main" })
    vim.keymap.set("v", "<leader>gh", ":'<,'>DiffviewFileHistory<CR>", { desc = "Histórico da seleção" })
  end,
}
