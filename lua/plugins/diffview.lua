return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gv", ":DiffviewClose<CR>:DiffviewOpen -- %<CR>", desc = "Diff do arquivo atual" },
    { "<leader>gV", ":DiffviewClose<CR>:DiffviewOpen<CR>", desc = "Diff do projeto todo" },
    { "<leader>gc", ":DiffviewClose<CR>", desc = "Fechar diff view" },
    { "<leader>gh", ":DiffviewFileHistory %<CR>", desc = "Histórico do arquivo" },
    { "<leader>gH", ":DiffviewFileHistory<CR>", desc = "Histórico do branch" },
    { "<leader>gm", ":DiffviewOpen HEAD...main<CR>", desc = "Diff contra main" },
    { "<leader>gh", ":'<,'>DiffviewFileHistory<CR>", mode = "v", desc = "Histórico da seleção" },
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

  end,
}
