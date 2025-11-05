return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2, -- Adiciona mais escurecimento
        start_in_insert = true,
        close_on_exit = true,
      })
      
      -- Terminal 1: Horizontal com vírgula
      vim.keymap.set("n", ",", function()
        vim.cmd("ToggleTerm size=15 direction=horizontal")
      end, { desc = "Toggle terminal horizontal" })
      
      -- Variável para o terminal do Claude
      local claude_term_buf = nil
      
      -- Terminal 2: Vertical com ponto-e-vírgula (;)
      vim.keymap.set("n", ";", function()
        -- Procura a janela do terminal
        local term_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if buf == claude_term_buf and vim.api.nvim_buf_is_valid(claude_term_buf) then
            term_win = win
            break
          end
        end
        
        if term_win then
          -- Fecha se já está aberto
          vim.api.nvim_win_close(term_win, false)
        else
          -- Abre o terminal
          vim.cmd("botright vsplit")
          if claude_term_buf and vim.api.nvim_buf_is_valid(claude_term_buf) then
            vim.api.nvim_win_set_buf(0, claude_term_buf)
          else
            vim.cmd("terminal")
            claude_term_buf = vim.api.nvim_get_current_buf()
          end
          vim.cmd("vertical resize 80")
          
          -- Aplica as mesmas cores do toggleterm
          vim.cmd("setlocal winhighlight=Normal:ToggleTerm1Normal,SignColumn:ToggleTerm1SignColumn")
          
          vim.cmd("startinsert")
        end
      end, { desc = "Toggle Claude Code terminal" })
      
      -- Autocmd para aplicar cores do toggleterm em todos os terminais
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
          if vim.bo.buftype == "terminal" then
            vim.cmd("setlocal winhighlight=Normal:ToggleTerm1Normal,SignColumn:ToggleTerm1SignColumn")
          end
        end,
      })
      
      -- Sair do modo terminal
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]])
    end,
  },
}
