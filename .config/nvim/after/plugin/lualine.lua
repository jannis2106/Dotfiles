local lualineTheme = require('lualine.themes.base16')
lualineTheme.normal.a.bg = "#7cd4f0"   --blue
lualineTheme.insert.a.bg = "#85f07c"   --green
lualineTheme.visual.a.bg = "#f0bb7c"   --orange/yellow
lualineTheme.replace.a.bg = "#f07d7c"  --red
lualineTheme.inactive.a.bg = "#3f475a" --gray

require("lualine").setup {
    options = {
        theme = lualineTheme
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}

vim.o.cursorline = true
vim.o.laststatus = 2
