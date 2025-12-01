vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false
vim.opt.number = true

-- Auto-reload arquivos modificados externamente (ex: Claude Code)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("Arquivo atualizado externamente", vim.log.levels.INFO)
  end,
})
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

-- Clipboard operations with Ctrl+C/V/X
vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({'n', 'i'}, '<C-v>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('v', '<C-x>', '"+d', { desc = 'Cut to clipboard' })

-- Auto-abrir Neo-tree e terminal quando abrir diretório (nvim .)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    local directory = vim.fn.isdirectory(data.file) == 1
    
    if directory then
      vim.cmd.cd(data.file)
      
      -- Abre Neo-tree
      vim.defer_fn(function()
        vim.cmd("Neotree show left")
        
        -- Vai pro editor (painel direito)
        vim.cmd("wincmd l")
        
        -- Cria split horizontal NO editor
        vim.cmd("below split")
        vim.cmd("resize 10")
        
        -- Abre terminal no split criado
        vim.cmd("terminal")
        
        -- Volta pro editor principal (acima do terminal)
        vim.cmd("wincmd k")
      end, 100)
    end
  end,
})

-- Atalho para abrir layout IDE completo manualmente
vim.keymap.set("n", "<leader>i", function()
  vim.cmd("Neotree show left")
  vim.cmd("wincmd l")
  
  -- Cria split horizontal NO editor
  -- vim.cmd("below split")
  -- vim.cmd("resize 10")
  -- vim.cmd("terminal")
  
  -- Volta pro editor
  vim.cmd("wincmd k")
end, { desc = "Open IDE layout" })

-- Redimensionar splits facilmente
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Decrease width' })

-- Toggle terminal tamanho (pequeno <-> grande)
vim.keymap.set('n', '<leader>tm', function()
  local win_height = vim.api.nvim_win_get_height(0)
  if win_height < 15 then
    vim.cmd('resize 25')  -- Aumenta para 25 linhas
  else
    vim.cmd('resize 10')  -- Volta para 10 linhas
  end
end, { desc = 'Toggle terminal size' })

-- Usar <Esc><Esc> para sair do modo terminal (em vez de apenas <Esc>)
-- Isso evita conflitos com ferramentas como Claude Code que usam <Esc>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
