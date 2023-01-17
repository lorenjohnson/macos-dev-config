" --- General 

let mapleader = ";"

set termguicolors
set tabstop=2 
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set number
set numberwidth=1
"set relativenumber
"set signcolumn=yes
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set nohlsearch
set ignorecase
set smartcase
set nowrap
set splitbelow
set splitright
set hidden
set scrolloff=999
set noshowmode
set showcmd
set updatetime=250 
set encoding=UTF-8
set mouse=a


" --- Plugins

call plug#begin('~/.config/nvim/plugged')

" General
Plug 'vim-airline/vim-airline'
Plug 'nvim-tree/nvim-web-devicons'                " Devicons
Plug 'nvim-lualine/lualine.nvim'                   " Status line
Plug 'akinsho/bufferline.nvim'                     " Buffers
Plug 'machakann/vim-highlightedyank'               " Highlight yanked text
Plug 'kyazdani42/nvim-tree.lua'                    " File explorer
" Color scheemes
Plug 'marko-cerovac/material.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' } " Color scheme
Plug 'elvessousa/sobrio'                           " https://dev.to/elvessousa/my-basic-neovim-setup-253l
Plug 'declancm/cinnamon.nvim'
Plug 'psliwka/vim-smoothie'
" Plug 'karb94/neoscroll.nvim'
" Syntax highlighting
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
" Commenting
Plug 'scrooloose/nerdcommenter'
" Lsp
Plug 'neovim/nvim-lspconfig'     
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind-nvim'
" Git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'preservim/nerdtree'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

call plug#end()

set number
set numberwidth=1

let NERDTreeShowHidden=1

let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCreateDefaultMappings = 1

let g:airline_theme='sobrio'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

lua require('gitsigns').setup({})
lua require('cinnamon').setup({ extra_keymaps = true, override_keymaps = true, max_length = 500, scroll_limit = -1 })

" --- Colors
"

set background=dark
colorscheme habamax 


" --- Remaps

nnoremap <leader>h :wincmd h<Cr>
nnoremap <leader>j :wincmd j<Cr>
nnoremap <leader>k :wincmd k<Cr>
nnoremap <leader>l :wincmd l<Cr>
nnoremap <silent><leader>[ :BufferLineCyclePrev<Cr>
nnoremap <silent><leader>] :BufferLineCycleNext<Cr>
nnoremap <silent><leader>q :bdelete<Cr>
nnoremap <silent>π :lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({}))<Cr>
nnoremap <silent><leader>f :lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({}))<Cr>
" nnoremap <silent>ππ :lua require'telescope.builtin'.find_files{}<Cr>
" nnoremap <silent><leader>ff :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<<Cr>
nnoremap <silent>∫ :NERDTreeToggle<Cr>

" --- Autocommands

" Remove vert split 
" https://www.reddit.com/r/vim/comments/effwku/transparent_vertical_bar_in_vim/
" https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
set fillchars=vert:\  " there is whitespace after the backslash
augroup RemoveVertSplit
    autocmd!
    autocmd BufEnter,ColorScheme * highlight VertSplit ctermfg=1 ctermbg=None cterm=None
augroup END

