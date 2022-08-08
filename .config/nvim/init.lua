local g =   vim.g
local o =   vim.o
local A =   vim.api

o.termguicolors = true

-- Options
o.fileencoding = "utf-8"

-- Lines to keep above / below the cursor
o.scrolloff = 10

-- UI
o.number = true
o.cursorline = true

-- Editing
o.expandtab = true
o.smarttab = true
o.tabstop = 4
o.shiftwidth = 4

-- Neovim and OS share the same clipboard
o.clipboard = "unnamedplus"

-- Disable case sensitive searching
o.ignorecase = true
o.smartcase = true

-- Backup / Undo
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false

-- Splitting
o.splitbelow = true
o.splitright = true

o.mouse = "a"

-- Always show statusline
o.laststatus = 2

-- Map leader to space
g.mapleader = ' '
g.maplocalleader = ' '

-- KEYBINDINGS
local function map(m, k, v)
    vim.api.nvim_set_keymap(m, k, v, { noremap = true, silent = true })
end

-- Nerdtree keybindings
map("n", "<C-t>", ":NERDTreeToggle<CR>")

-- Vifm keybindings
map("n", "<leader>vv", ":Vifm<CR>")
map("n", "<leader>vs", ":VsplitVifm<CR>")
map("n", "<leader>sp", ":SplitVifm<CR>")
map("n", "<leader>dv", ":DiffVifm<CR>")
map("n", "<leader>tv", ":TabVifm<CR>")

-- Remap splits navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize splits
map("n", "<C-Left>", ":vertical resize +4<CR>")
map("n", "<C-Right>", ":vertical resize -4<CR>")
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")

-- Lualine
local lualineTheme = require'lualine.themes.base16'
lualineTheme.normal.a.bg = "#26bbd9"
lualineTheme.insert.a.bg = "#29d398"
lualineTheme.visual.a.bg = "#fab795"
lualineTheme.replace.a.bg = "#e95678"
lualineTheme.inactive.a.bg = "#666666"

require('lualine').setup {
    options = {
        theme = lualineTheme,
   }
}

-- Color scheme
require('base16-colorscheme').setup({
    base00 = '#191919FA', -- background
    base01 = '#262626', -- lighter background
    base02 = '#383838', -- selection background
    base03 = '#666666', -- comments
    base04 = '#565656', -- dark foreground
    base05 = '#f2f2f2', -- foreground
    base06 = '#ffffff', -- light foreground
    base07 = '#383838', -- light background
    base08 = '#e95678', -- variables, xml tags, markup link text, markup lists, diff deleted
    base09 = '#fab795', -- integers, boolean, constants, xml attributes, markup link url
    base0A = '#fbc3a7', -- classes markup bold search text background
    base0B = '#29d398', -- strings, inherited class, markup code, diff inserted
    base0C = '#59e1e3', -- support, regular expressions, escape characters, markup quotes
    base0D = '#26bbd9', -- functions, methods, attribute ids, headings
    base0E = '#ee64ac', -- keywords, storage, selector, markup italic, diff changed
    base0F = '#bf564b', -- deprecated, opening/closing embedded language tags
})

-- Colorizer
require('colorizer').setup()

-- Plugins
return require('packer').startup(function(use)
    
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- File management
    use "vifm/vifm.vim"
    use "scrooloose/nerdtree"
    use "tiagofumo/vim-nerdtree-syntax-highlight"
    use "ryanoasis/vim-devicons"

    use "tpope/vim-surround"

    -- Syntax highlighting / colors
    use "norcalli/nvim-colorizer.lua"
   
    -- Color scheme
    use "RRethy/nvim-base16"
end)
