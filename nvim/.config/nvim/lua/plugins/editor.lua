return {
  -- Seamless Ctrl+h/j/k/l navigation between nvim splits and tmux panes
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    keys = {
      { "<M-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Navigate left" },
      { "<M-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Navigate down" },
      { "<M-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Navigate up" },
      { "<M-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
    },
  },
}
