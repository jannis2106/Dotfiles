set number
:set noshowmode

call plug#begin()

Plug 'itchyny/lightline.vim'

" File Management
Plug 'vifm/vifm.vim'

" Colors / Syntax Highlighting
Plug 'ap/vim-css-color'

call plug#end()

syntax enable

set laststatus=2

set expandtab       " spaces instead of tabs
set smarttab
set shiftwidth=4    " tab is four spaces
set tabstop=4       " tab is four spaces

" ### Vifm ### "
map <Leader>vv :Vifm<CR>
map <Leader>vs :VsplitVifm<CR>
map <Leader>sp :SplitVifm<CR>
map <Leader>dv :DiffVifm<CR>
map <Leader>tv :TabVifm<CR>
