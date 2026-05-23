require("options")
require("plugins.nvim-tree")

vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }

vim.cmd.colorscheme "catppuccin-mocha"
