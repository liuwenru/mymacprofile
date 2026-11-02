return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "darker",
        transparent = false,
        term_colors = true,
        ending_tildes = false,
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "none",
          variables = "none",
        },
        highlights = {
          Comment = { fg = "#4b5263", bg = "none", fmt = "italic" },
          SpecialComment = { fg = "#4b5263", bg = "none", fmt = "italic" },
          ["@comment"] = { fg = "#4b5263", bg = "none", fmt = "italic" },
          ["@comment.documentation"] = { fg = "#4b5263", bg = "none", fmt = "italic" },
          TSComment = { fg = "#4b5263", bg = "none", fmt = "italic" },
        },
        lualine = {
          transparent = false,
        },
      })
      require("onedark").load()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
