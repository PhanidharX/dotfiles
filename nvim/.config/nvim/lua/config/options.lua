-- Options (loaded before LazyVim defaults)
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.concealcursor = "nc" -- keep concealed text hidden in normal+command mode

-- Ensure mise-managed tools (node, python, etc.) are available to nvim
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
