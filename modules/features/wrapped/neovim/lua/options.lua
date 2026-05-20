local o = vim.opt
local g = vim.g

-- Options
o.number = true
o.relativenumber = true
o.scrolloff = 9
o.cursorline = true
o.showmatch = false
o.termguicolors = true
o.confirm = true
o.pumheight = 10
o.pumblend = 10

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Search options
o.ignorecase = true
o.smartcase = true

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "nix" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Langmap Colemak -> RU
langmap = [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz]]
