" ===============================
" Edoardo's Awesome vimrc 🚀
" ===============================

" ---- Powerline integration ----
set rtp+=/Users/edoardo/.pyenv/versions/3.10.5/Library/Frameworks/Python.framework/Versions/3.10/lib/python3.10/site-packages/powerline/bindings/vim/
set laststatus=2
let g:Powerline_symbols = 'unicode'

" ---- Sensible defaults ----
syntax on                  " Enable syntax highlighting
filetype plugin indent on  " Filetype-based plugins & indent
set number                 " Show line numbers
set relativenumber         " Relative numbers for navigation
set cursorline             " Highlight current line
" set mouse=a                " Enable mouse
set hidden                  " Allow buffer switching without saving
set history=1000           " Long command history
set updatetime=300         " Faster updates for plugins (important for ALE)

" ---- Search behavior ----
set ignorecase
set smartcase
set incsearch
set hlsearch

" ---- Tabs & indentation ----
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent

" ---- Backspace behavior ----
set backspace=indent,eol,start

" ---- UI tweaks ----
set scrolloff=5
set sidescrolloff=5
set splitbelow
set splitright
set signcolumn=yes          " Always show sign column for ALE

" ---- Leader key ----
let mapleader=","

" ---- Plugin manager ----
call plug#begin('~/.vim/plugged')

" Core
Plug 'dense-analysis/ale'             " Async linting & fixing
Plug 'tpope/vim-surround'             " Easy manipulation of surroundings
Plug 'tpope/vim-commentary'           " Comment/uncomment lines
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'               " Fuzzy finder
Plug 'preservim/nerdtree'             " File explorer
Plug 'godlygeek/tabular'              " Vim script for text filtering and alignment
Plug 'tpope/vim-fugitive'
Plug 'vim-test/vim-test'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Autocompletion

call plug#end()

" ---- ALE configuration ----
let g:ale_linters = {
\   'python': ['flake8', 'mypy', 'pylint'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\}
let g:ale_fix_on_save = 1

" ---- CoC configuration ----
" Autocomplete with <Tab>
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use K to show documentation in preview window
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" Trigger completion manually
inoremap <silent><expr> <C-Space> coc#refresh()

" ---- NERDTree toggle ----
nnoremap <leader>n :NERDTreeToggle<CR>

" ---- FZF keymaps ----
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles?<CR>

" ---- Python specific ----
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType python nnoremap <leader>r :w<CR>:!python3 %<CR>

" --- My inc plugin
" Esempi: sostituisci con i tuoi
let g:inc_list_cmd = 'bash -c "my_inc_tool list --simple"'          " 1 incident per riga
let g:inc_info_cmd = 'bash -c "my_inc_tool info %s"'                " %s = ID
let g:inc_id_pattern = '^\s*\(INC\d\{10\}\)\>'                     " come estrarre l'ID
let g:inc_open_list_cmd = 'enew'   " o 'enew' se non vuoi split
