return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
      require("nvim-treesitter").install({
        -- core
        "lua", "vim",

        -- stack
        "javascript", "typescript", "tsx",
        "python",
        "go", "gomod", "gosum", "gowork",

        -- common formats
        "json", "yaml", "toml",
        "html", "css",
        "markdown", "markdown_inline",
        "bash", "dockerfile",
      })
  end
}
