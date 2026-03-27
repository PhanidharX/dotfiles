return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,       -- show dotfiles, but dimmed
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
