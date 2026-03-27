-- Keymaps (in addition to LazyVim defaults)
local map = vim.keymap.set

-- Remove LazyVim's default Ctrl+h/j/k/l window navigation
-- (using Alt+h/j/k/l via vim-tmux-navigator instead)
for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
  pcall(vim.keymap.del, "n", key)
end

-- Markdown: toggle checkbox anywhere on the line
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>mt", function()
      local line = vim.api.nvim_get_current_line()
      local new_line
      if line:match("%- %[[xX]%]") then
        new_line = line:gsub("%- %[[xX]%]", "- [ ]", 1)
      elseif line:match("%- %[ %]") then
        new_line = line:gsub("%- %[ %]", "- [x]", 1)
      end
      if new_line then vim.api.nvim_set_current_line(new_line) end
    end, { buffer = true, desc = "Toggle markdown checkbox" })
  end,
})

-- Better escape
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Keep search term centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
