"-----------------------------------------------------------------------------
" Init
"-----------------------------------------------------------------------------
set nocompatible
scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8
set clipboard=unnamedplus
filetype off
set path+=**
set rtp+=~/.vim/bundle/Vundle.vim
" Lets switch with Ctrl-^
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
call vundle#begin()
Plugin 'Vundle/Vundle.vim'

"-----------------------------------------------------------------------------
" Plugins
"-----------------------------------------------------------------------------
Plugin 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plugin 'junegunn/fzf.vim'
call vundle#end()
filetype plugin indent on

"-----------------------------------------------------------------------------
" Sets
"-----------------------------------------------------------------------------
set scrolloff=7
set timeout timeoutlen=500 ttimeoutlen=500
set smartindent
set hidden
set nohlsearch
set ignorecase
set incsearch
set wildmenu
set showcmd
set noshowmode
set autoread
set list
set listchars=tab:‣\ ,trail:·,precedes:«,extends:»,eol:¬
set nu
set relativenumber
set ttyfast
set nowrap
set shiftwidth=4
set softtabstop=4
set expandtab
set backspace=indent,eol,start
set colorcolumn=80
set termwinsize=10x200
set textwidth=80
" Don't format to 79 textwidth by default
set formatoptions=
set splitright

"-----------------------------------------------------------------------------
" IndentLine
"-----------------------------------------------------------------------------
let g:indentLine_setColors = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_color_gui = '#7f7061'
"let g:indentLine_color_tty_light = 7 " (default: 4)
"let g:indentLine_color_dark = 1 " (default: 2)

"-----------------------------------------------------------------------------
" Autocommands
"-----------------------------------------------------------------------------
" Highlight horizontal line in NORMAL mode
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END
" Fix default weird vim behaviour with json files
let g:vim_json_conceal = 0
" Ripgrep function used by \s
command! -bang -nargs=* RG call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

"-----------------------------------------------------------------------------
" YAML
"-----------------------------------------------------------------------------
"au BufNewFile,BufRead *.yaml,*.yml  setf yaml
" Fix auto-indentation for YAML files
augroup yaml_fix
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup END

"-----------------------------------------------------------------------------
" Color and visual settings
"-----------------------------------------------------------------------------
set t_Co=256
syntax enable
set colorscheme=desert
"set background=dark
"if exists('+termguicolors')
  "" Tmux colors fix
  "let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  "let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  "set termguicolors
"endif
" Cursos color
if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;blue\x7"
  " use a red cursor otherwisue
  let &t_EI = "\<Esc>]12;white\x7"
  silent !echo -ne "\033]12;white\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
endif

"-----------------------------------------------------------------------------
" custom binds
"-----------------------------------------------------------------------------
" Go full-vim mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
" Numbers on/off
map <F1> :set nu!<CR> :set rnu!<CR><ESC>
" Toggle special indent characters
map <F2> :IndentLinesToggle<CR>
" Toggle special characters
map <F3> :set list!<CR>
" Paste mode on/off
set pastetoggle=<F4>
" 'preservim/tagbar'
"Remove all trailing whitespace by pressing F8
nnoremap <F8> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" System clipboard binds 
inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
" Xplr binds to open new buffers
"let g:nnn#action = {
      "\ '<c-t>': 'tab split',
      "\ '<c-x>': 'split',
      "\ '<c-v>': 'vsplit' }
"-----------------------------------------------------------------------------
" FZF
"-----------------------------------------------------------------------------
" FZF Buffer Delete
function! s:list_buffers() abort
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines) abort
  " Use bdelete so buffers stay in locationlist
  execute 'bdelete' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({ 'source': s:list_buffers(), 'sink*': { lines -> s:delete_buffers(lines) }, 'options': '--multi --reverse --bind ctrl-a:select-all+accept' }))

" List all buffers
nnoremap <silent> <C-b> :Buffers<CR>
" Search in current buffer
nnoremap <silent> <C-f> :BLines<CR>
" Search in all buffers
nnoremap <silent> <C-l> :Lines<CR>
" Search in marks
nnoremap <silent> <C-m> :Marks<CR>
" Search in history
nnoremap <silent> <C-h> :History<CR>
" Navigation in NORMAL mode
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" Navigation in INSERT mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-w> <S-Right>
inoremap <C-b> <S-Left>
" Scroll beetween tabs
"nnoremap <C-h> gT
"nnoremap <C-l> gt
" Scroll inside tab beetween panes
"nnoremap <C-j> <C-W><C-H>
"nnoremap <C-k> <C-W><C-L>
" Resize panes
noremap <C-Down> <C-w>+
noremap <C-Up> <C-w>-
noremap <C-Right> <C-w>>
noremap <C-Left> <C-w><

"-----------------------------------------------------------------------------
" leader \ shortcuts
"-----------------------------------------------------------------------------
" Fzf
" Current dir file search
nnoremap <leader>f :Files .<CR>
" Search in cwd with rg
nnoremap <leader>s :RG<CR>
nnoremap <leader>t :below terminal<CR>
nnoremap <leader>c :close<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>pi :PluginInstall<CR>
nnoremap <leader>vv :vsplit<CR>
"nnoremap <leader>x :XplrPicker<CR>
" File shortcuts
nnoremap <leader>ev :e $HOME/.vimrc<CR>
" Wrap line under cursor to 80 width
nnoremap <leader>8 :normal Vgq<CR>
" Delete marks in document
nnoremap <leader>m :delm! | delm A-Z0-9<CR>
" Select again deselected
nnoremap <leader>v V`]
" Turn of the highlighting after search
nnoremap <leader>hl :nohl<CR>
" Indent select with Shift-< and Shift->
nnoremap <lt>> V`]<
nnoremap ><lt> V`]>
nnoremap =- V`]=

"-----------------------------------------------------------------------------
" Backup settings
"-----------------------------------------------------------------------------
" enable undo, backup, swap
set undofile
set backup
set noswapfile
" Folder paths
set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

