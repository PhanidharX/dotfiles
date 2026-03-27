return {
  -- Lazygit inside neovim float
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitFilter" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  -- Generate + open GitHub/Bitbucket permalinks
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {
      router = {
        browse = {
          -- GitHub
          ["^github%.com"] = "https://github.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or ''}",
          -- Bitbucket
          ["^bitbucket%.org"] = "https://bitbucket.org/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/src/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#lines-{_A.LSTART}"
            .. "{_A.LEND > _A.LSTART and (':' .. _A.LEND) or ''}",
        },
      },
    },
    keys = {
      -- Copy permalink to clipboard
      {
        "<leader>gL",
        function() require("gitlinker").link({ action = require("gitlinker.actions").clipboard }) end,
        mode = { "n", "v" },
        desc = "Copy git permalink",
      },
      -- Open permalink in browser
      {
        "<leader>go",
        function() require("gitlinker").link({ action = require("gitlinker.actions").system }) end,
        mode = { "n", "v" },
        desc = "Open git permalink in browser",
      },
    },
  },
}
