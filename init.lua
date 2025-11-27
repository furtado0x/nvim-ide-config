local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")

-- Quando abrir diretório ou nvim sem arquivo, abre Neo-tree + janela vazia
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg == "" or vim.fn.isdirectory(arg) == 1 then
      -- Primeiro cria o split para ter janela do editor
      vim.cmd("vsplit")
      vim.cmd("wincmd l")
      vim.cmd("enew")
      -- Depois abre Neo-tree na janela original (esquerda)
      vim.cmd("wincmd h")
      vim.cmd("Neotree show")
      -- Volta foco para o editor (direita)
      vim.cmd("wincmd l")
    end
  end,
})
