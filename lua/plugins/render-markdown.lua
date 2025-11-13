return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { 
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons" 
  },
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      -- Renderiza automaticamente ao abrir .md
      enabled = true,
      -- Renderiza em tempo real enquanto digita
      render_modes = { 'n', 'c', 'i' },
      -- Configurações de estilo
      headings = {
        enabled = true,
        sign = true,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      },
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        width = 'full',
      },
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
      },
    })
    
    -- Keymaps
    vim.keymap.set("n", "<leader>mr", ":RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Render" })
  end,
}
