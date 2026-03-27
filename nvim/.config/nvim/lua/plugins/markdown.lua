return {
  -- Inline markdown rendering (headings, tables, code blocks, checkboxes)
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      modes = { "n", "i", "no", "c" },
      hybrid_modes = { "i" },
      markdown_inline = {
        checkboxes = {
          enable = true,
          checked = { text = "✔", hl = "MarkviewCheckboxChecked" },
          unchecked = { text = "☐", hl = "MarkviewCheckboxUnchecked" },
        },
      },
    },
  },
  -- Browser preview
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
    },
  },
  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.expand("~/.markdownlint.json"),
            "--",
          },
        },
      },
    },
  },
}
