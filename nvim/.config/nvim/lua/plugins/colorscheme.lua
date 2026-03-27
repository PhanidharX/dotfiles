return {
  -- Catppuccin Mocha — matches Ghostty + Tmux theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      integrations = {
        telescope = { enabled = true },
        neotree = true,
        gitsigns = true,
        which_key = true,
        treesitter = true,
        mason = true,
        noice = true,
        mini = { enabled = true },
        lsp_trouble = true,
      },
    },
  },
  -- Override LazyVim default (tokyonight) with catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
