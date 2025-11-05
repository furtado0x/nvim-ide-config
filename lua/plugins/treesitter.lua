return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        -- ⬇️ ADICIONE ISSO - força instalação desses parsers
        ensure_installed = {
          "lua",
          "python",
          "html",
          "javascript",
          "typescript",
          "json",
          "yaml",
          "markdown",
        },
        
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
