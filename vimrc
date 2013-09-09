call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

"==============================================================================
" ######################################################## GENERAL EDITOR STUFF
syntax enable
set nocompatible
set encoding=utf-8
set hidden
set magic
set autoread " reload file if it was changed outside of vim
set ttyfast
set title
set noesckeys " fix lag after hitting escape
set splitbelow
set splitright

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

set history=10000
set swapfile
set backup
set backupdir=~/.vim/_backup    " where to put backup files.
set directory=~/.vim/_temp      " where to put swap files.

set wildignore+=*.rbc,*.scssc,*.sassc,.rbx,.jhw-cache
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=.ds_store,.gitkeep

" text
set backspace=indent,eol,start "backspace through everything in indent mode
set nowrap
set expandtab
set shiftwidth=2
set tabstop=2
set ai " autoindent
set si " smartindent

" searching
set incsearch
set ignorecase
set hlsearch
set smartcase

" highlight all occurrences of the same word
" run :so $VIMRUNTIME/syntax/hitest.vim to see more colors
" augroup highlight_same
"   autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
" augroup END

augroup last_position
  au!
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

"==============================================================================
" ########################################################################## UI
set rnu
set ruler
set showmatch
set showcmd
set cmdheight=1
set cursorline
set colorcolumn=80
set scrolloff=5
set sidescrolloff=15

set list
set listchars=""
set listchars+=tab:▸\
set listchars+=extends:>
set listchars+=precedes:<

" don't show trailing spaces in insert mode
augroup trailing
  au!
  au InsertEnter * :set listchars-=trail:·
  au InsertLeave,BufReadPost * :set listchars+=trail:·
augroup END

augroup hide_cursor_line
  au!
  au InsertEnter * :set nocursorline
  au InsertLeave * :set cursorline
augroup END

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

if has("statusline") && !&cp
  set laststatus=2  " always show the status bar
  set statusline=
  set statusline+=%2*\ %n%H%M%R%W\ %*                  " buffer number & flags
  set statusline+=%<\ %-.75t                           " cut here, path
  set statusline+=%=                                   " seperate between right & left
  set statusline+=\ \ %{fugitive#statusline()}\ \      " git status
  set statusline+=%1*\ %{strlen(&ft)?&ft:'???'}\ %*%*  " file type or ???
  set statusline+=\ \ %3(%c%)                          " column
  set statusline+=%10(\ \ %l/%L%)                      " line
  set statusline+=\ \ %P\ \                            " percentage through file
endif

let g:solarized_contrast='high'
let g:solarized_visibility='high'

if has("gui_running")
  set guifont=Source\ Code\ Pro:h12
  set guioptions=egmrt " turn off toolbar
  set vb " disable visual bell
  set antialias
  set guioptions-=r "don't show right scrollbar
  set showtabline=1
endif

set t_Co=256 " 256 colors
set background=dark
colorscheme solarized

"Invisible character colors
" highlight NonText guifg=0 ctermfg=0 ctermbg=8 guibg=8
" highlight SpecialKey guifg=8 ctermfg=8 ctermbg=0 guibg=0

"==============================================================================
" ################################################### FILETYPE SPECIFIC OPTIONS
augroup file_type
  au!

  " In Makefiles, use real tabs, not tabs expanded to spaces
  au filetype make setlocal noexpandtab
  au filetype gitcommit setlocal nolist
  au filetype qf setlocal nolist

  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} setf markdown | call s:setup_wrapping()
  au BufRead,BufNewFile *.{txt} setf txt | call s:setup_wrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " Highlighting for rspec files
  autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
  highlight def link rubyRspec Function
augroup END

"==============================================================================
" ############################################################## PLUGIN OPTIONS
augroup plugins
  au!

  " auto clean fugitive buffers
  au BufReadPost fugitive://* set bufhidden=delete

  " default compiler is rspec with bundle exec
  au BufRead * compiler rspec | set makeprg=bundle\ exec\ rspec\ --format\ progress\ --no-profile
augroup END

" For vim-gitgutter
highlight SignColumn ctermbg=NONE
highlight SignColumn guibg=NONE

" load matchit plugin
so $VIMRUNTIME/macros/matchit.vim

" indent-guides config
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors=0
" solarized dark
" hi IndentGuidesEven ctermbg=237
" hi IndentGuidesOdd ctermbg=242
hi IndentGuidesEven ctermbg=0
hi IndentGuidesOdd ctermbg=0
" solarized light
" hi IndentGuidesEven ctermbg=252
" hi IndentGuidesOdd ctermbg=252

" use auto colors for indent guides in the gui
if has("gui_running")
  let g:indent_guides_auto_colors=1
  let g:indent_guides_guide_size=1
endif

" ctrlp options
let g:ctrlp_extensions = ["tag"]
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 15
let g:ctrlp_cache_dir = $HOME.'/.vim/_cache/ctrlp'
let g:ctrlp_custom_ignore = 'tmp$\|\.git$\|\.hg$\|\.svn$'
let g:ctrlp_open_new_file = 'r'

"==============================================================================
" ################################################################### FUNCTIONS
function s:setup_wrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

" run rspec command in a new tmux window
function! RspecWindow()
  if exists('$TMUX')
    " tmux neww with the -d option renames the current window
    " so get the current window name and index number to unrename the current window
    let names = system("tmux list-windows -F '#F#W'")
    let names_array = split(names, '\n')
    for name in names_array
      if name =~ "^*"
        let windowname = split(name, '*')[0]
      endif
    endfor

    let indices = system("tmux list-windows -F '#F#I'")
    let indices_array = split(indices, '\n')
    for index in indices_array
      if index =~ "^*"
        let indexnum = split(index, '*')[0]
      endif
    endfor

    let output = system("tmux neww -n output -d -P -F '#I' -c " . getcwd())
    call system("tmux rename-window -t " . indexnum . " " . windowname)
    let window = split(output, '\n')[0] " remove the newline
    call system("tmux send-keys -t " . window . " \"bundle exec rspec\" C-m")
    call system("tmux select-window -t " . window)
  endif
endfunction

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://overstimulate.com/articles/vim-ruby)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

" taken and modified from
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! ShowRoutes()
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":resize " . line("$")
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction

" taken and modified from
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

"==============================================================================
" #################################################################### MAPPINGS
" yank/paste to/from clipboard
map <leader>y "*y
map <leader>p "*p

" Git Gutter
nmap <silent> ]h :<C-U>execute v:count1 . "GitGutterNextHunk"<CR>
nmap <silent> [h :<C-U>execute v:count1 . "GitGutterPrevHunk"<CR>

" ctrl u / ctrl d distance
nnoremap <c-u> 10k
nnoremap <c-d> 10j

nnoremap Y y$

" center after jumping
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz

" `^ prevents cursuring from moving left
inoremap jk <Esc>`^
" gV prevents reselection
vnoremap <tab> <Esc>gV
nnoremap <tab> <Esc>

set pastetoggle=<F2>

" remap j and k to move up and down DISPLAYED lines
" without having to press 2 keys
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" cowboy coding!!!
nnoremap <leader>t :w <bar> ! ruby % <cr>

" open alternate file
nnoremap <leader>. :A<cr>

" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Switch between last two buffers
nnoremap <leader><leader> <c-^>

" rake routes
map <leader>rr :call ShowRoutes()<cr><F5>

" ctrlp mappings... f5 purges cache and gets new files
map <leader>f :CtrlP .<cr><F5>
map <leader>F :CtrlPCurFile<cr><F5>

map <leader>sv :CtrlP app/views<cr><F5>
map <leader>sc :CtrlP app/controllers<cr><F5>
map <leader>sm :CtrlP app/models<cr><F5>
map <leader>sh :CtrlP app/helpers<cr><F5>
map <leader>ss :CtrlP app/assets/stylesheets<cr><F5>
map <leader>sj :CtrlP app/assets/javascripts<cr><F5>
map <leader>st :CtrlP spec<cr><F5>
map <leader>sl :CtrlP lib<cr><F5>

" fugitive mappings
map <leader>gs :Gstatus<cr>
map <leader>gd :Git diff %<cr>
map <leader>gl :Git l<cr>

" tab completion
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" don't use Ex mode, use Q for formatting
map Q gq

" Window splitting shortcuts
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" Window movement shortcuts
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" disable cursor keys in normal mode
map <Left>  :echo "BAD"<cr>
map <Right> :echo "BAD"<cr>
map <Up>    :echo "BAD"<cr>
map <Down>  :echo "BAD"<cr>

" run jshint on current file
nnoremap <leader>js :w <bar> :JSHint<cr>

" diff current file against saved version
nnoremap <leader>d :DiffSaved<cr>

" ack word under cursor
nnoremap <silent>K :Ack <cword><CR>

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Annoyance
nnoremap <F1> <nop>

"==============================================================================
" #################################################################### COMMANDS

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
command! Marked :normal :!open -a Marked.app '%:p'<cr> :redraw!<cr>
command! DiffSaved :w !diff % - -u | colordiff
command! JSONPretty :normal :.!jsonpp %<cr>
command! RenameFile :call RenameFile()
command! RspecWindow :call RspecWindow()
command! Path :echo expand('%:p')
