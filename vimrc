call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

"==============================================================================
" ######################################################## GENERAL EDITOR STUFF
syntax enable
syntax sync minlines=256
" set synmaxcol=300
set re=1
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
set ai " autoindent
set si " smartindent

" searching
set incsearch
set ignorecase
set hlsearch
set smartcase

"==============================================================================
" ########################################################################## UI
set rnu
set number
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
  set statusline+=%<\%{expand('%:h')}/                 " relative path
  set statusline+=%<\%t%*                              " file name
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
  " set guifont=Source\ Code\ Pro:h12
  set guifont=PragmataPro:h14
  set guioptions=egmrt " turn off toolbar
  set guicursor+=n:blinkon0 " don't blink in normal mode
  set vb " disable visual bell
  set antialias
  set guioptions-=r "don't show right scrollbar
  set showtabline=1
endif

set t_Co=256 " 256 colors
set background=dark
colorscheme solarized

"==============================================================================
" ################################################### FILETYPE SPECIFIC OPTIONS
augroup file_type
  au!

  au filetype * set tabstop=2 | set shiftwidth=2
  au filetype markdown,vimwiki set tabstop=4 | set shiftwidth=4

  au filetype make,go setlocal noexpandtab
  au filetype gitcommit,git,qf,go setlocal nolist

  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} call SetupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " Treat Fastfile as Ruby
  au BufNewFile,BufRead Fastfile set ft=ruby

  " Highlighting for rspec files
  au BufNewFile,BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
  highlight def link rubyRspec Function
augroup END

"==============================================================================
" ############################################################## PLUGIN OPTIONS
augroup plugins
  au!

  " auto clean fugitive buffers
  au BufReadPost fugitive://* set bufhidden=delete
augroup END

" For vim-gitgutter
let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=NONE
highlight SignColumn guibg=NONE
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/Documents/Writing/Wiki/', 'syntax': 'markdown', 'ext': '.md', 'diary_rel_path': 'journal/', 'diary_header': 'Journal', 'diary_index': 'index'}]
let g:vimwiki_global_ext = 0

" load matchit plugin
so $VIMRUNTIME/macros/matchit.vim

" indent-guides config
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors=0
let g:indent_guides_indent_levels=10
hi IndentGuidesEven ctermbg=0
hi IndentGuidesOdd ctermbg=0
augroup highlights
  au!
  au BufLeave *.go hi IndentGuidesOdd ctermbg=0
  au BufEnter *.go hi IndentGuidesOdd ctermbg=8
augroup END

" use auto colors for indent guides in the gui
if has("gui_running")
  let g:indent_guides_auto_colors=1
endif

" ctrlp options
let g:ctrlp_extensions = ["tag"]
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 15
let g:ctrlp_show_hidden = 1
let g:ctrlp_cache_dir = $HOME.'/.vim/_cache/ctrlp'
let g:ctrlp_custom_ignore = 'tmp$\|\.git$\|\.hg$\|\.svn$\|bower_components$\|node_modules$\|\.keep$\|\.cache$\|Godeps$\|vendor$\|pkg$\|\.vagrant$\|assets/source_maps$'
let g:ctrlp_open_new_file = 'r'

" vim-go options
let g:go_fmt_command = "goimports"
" let g:go_fmt_options = "-srcdir ". getcwd()
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"==============================================================================
" ################################################################### FUNCTIONS
function! SetupWrapping()
  setlocal wrap
  setlocal wrapmargin=2
  setlocal textwidth=72
endfunction

function! DiffSaved()
  if has("gui_running")
    :w !diff % - -u
  else
    :w !diff % - -u | colordiff
  endif
endfunction

function! ReloadAll()
  :GitGutterAll
  :checktime
endfunction

" run command in a new tmux window
let g:outputswitch = 1
let g:outputcmd = "bundle exec rubocop && bundle exec rspec"
function! OutputWindow()
  if exists('$TMUX')
    let windows = system("tmux list-windows -F '#I #W'")
    let windows_array = split(windows, '\n')
    let found = 0
    for window in windows_array
      if window =~ "output"
        let indexnum = split(window, ' ')[0]
        call system("tmux send-keys -t " . indexnum . " \"clear\" C-m")
        call system("tmux send-keys -t " . indexnum . " \"" . g:outputcmd . "\" C-m")
        if g:outputswitch == 1
          call system("tmux select-window -t " . indexnum)
        endif
        let found = 1
      endif
    endfor

    if found == 0
      let output = system("tmux neww -n output -d -P -F '#I' -c " . getcwd())
      let indexnum = split(output, '\n')[0] " remove the newline
      call system("tmux send-keys -t " . indexnum . " \"" . g:outputcmd . "\" C-m")
      if g:outputswitch == 1
        call system("tmux select-window -t " . indexnum)
      endif
    endif

  endif
endfunction

" close window created by OutputWindow
function! CloseOutputWindow()
  if exists('$TMUX')
    let windows = system("tmux list-windows -F '#I #W'")
    let windows_array = split(windows, '\n')
    for window in windows_array
      if window =~ "output"
        let indexnum = split(window, ' ')[0]
        call system("tmux kill-window -t " . indexnum)
      endif
    endfor
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
  :0r! bundle exec rake -s routes
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

" Open today's journal file, add header (date) if it is new, switch to index
" file and update links, then switch back to today's journal file
function! OpenTodaysJournal()
  exe "VimwikiMakeDiaryNote"

  if !filereadable(expand('%:p'))
    exe ":normal i" . "# " . expand("%:t:r") . "\r"
  endif

  exe ":w"
  exe "VimwikiDiaryIndex"
  exe "VimwikiDiaryGenerateLinks"
  exe ":w"

  exe "VimwikiMakeDiaryNote"
  exe ":normal G"
endfunc

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
nnoremap <silent> <Space> :let @/ = ""<bar>:nohlsearch<Bar>:echo<CR>

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

" command-line mode history completion
cmap <c-n> <down>
cmap <c-p> <up>

" run jshint on current file
nnoremap <leader>js :w <bar> :JSHint<cr>

" diff current file against saved version
nnoremap <leader>sd :DiffSaved<cr>

" ack word under cursor
nnoremap <silent>K :Ack <cword><cr>

" call dispatch
nnoremap <leader>d :w <bar> :Dispatch bundle exec rspec --format progress --no-profile<cr>

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Open today's journal file
nnoremap <silent> <leader>jf :call OpenTodaysJournal()<cr>

" Annoyance
nnoremap <F1> <nop>

" split join
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

"==============================================================================
" #################################################################### COMMANDS

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
command! Marked :normal :!open -a Marked\ 2.app '%:p'<cr> :redraw!<cr>
command! DiffSaved :call DiffSaved()
command! RenameFile :call RenameFile()
command! OutputWindow :call OutputWindow()
command! CloseOutputWindow :call CloseOutputWindow()
command! Path :echo expand('%:p')
command! ReloadAll :call ReloadAll()
command! JSONPretty :normal :.!jsonpp %<cr>
command! -range=% SoftWrap
            \ <line2>put _ |
            \ <line1>,<line2>g/.\+/ .;-/^$/ join | normal $x
