" polyglot
let g:polyglot_disabled = ['csv']

call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

"==============================================================================
" ######################################################## GENERAL EDITOR STUFF
syntax enable
set nocompatible
set complete-=i
set encoding=utf-8
set hidden
set magic
set autoread
set ttyfast
set lazyredraw
set noesckeys " fix lag after hitting escape
set splitbelow
set splitright
set updatetime=100
set shortmess=I

set history=10000
set swapfile
set backup
set undofile
set backupdir=~/.vim/_backup
set directory=~/.vim/_temp
set undodir=~/.vim/_undo
let g:netrw_dirhistmax = 0

let host=trim(system('hostname'))

if host == 'titan'
  set viminfofile=/data/secrets/viminfo
endif

" text
set backspace=indent,eol,start
set nowrap
set expandtab
set nojoinspaces
set autoindent
set smartindent

" searching
set incsearch
set ignorecase
set hlsearch
set smartcase

"==============================================================================
" ########################################################################## UI
set number
set ruler
set showmatch
set showcmd
set cmdheight=1
set cursorline
set showtabline=1
set colorcolumn=80
set scrolloff=5
set sidescrolloff=5
set re=1
set nofoldenable
set foldmethod=manual
set signcolumn=yes
set fillchars+=vert:\

set list
set listchars=""
set listchars+=tab:▸▸
set listchars+=extends:>
set listchars+=precedes:<

augroup hide_trailing_spaces_in_insert_mode
  au!
  au InsertEnter * :set listchars-=trail:·
  au InsertLeave,BufReadPost * :set listchars+=trail:·
augroup END

augroup hide_cursor_line
  au!
  au InsertEnter * :set nocursorline
  au InsertLeave * :set cursorline
augroup END

set wildmenu
set wildmode=list:longest

let g:solarized_contrast='high'
let g:solarized_visibility='high'

if $BLINK == 'true'
  let g:solarized_termtrans=1
endif

set t_Co=256 " 256 colors
set background=dark
colorscheme solarized

highlight! EndOfBuffer ctermfg=8
highlight! Visual ctermbg=NONE
highlight! SignColumn ctermbg=NONE
highlight! CursorLineNr ctermfg=15 cterm=bold
highlight! link QuickFixLine Normal
highlight! StatusLine ctermfg=6
highlight! StatusLineNC ctermfg=3
highlight! StatusLineTerm ctermbg=6 cterm=NONE term=NONE
highlight! StatusLineTermNC ctermbg=3 cterm=NONE term=NONE
highlight! VertSplit ctermbg=3

if has("statusline") && !&cp
  set laststatus=2                                     " always show the status bar
  set statusline=
  set statusline+=%2*\ %n%H%M%R%W\ %*                  " buffer number & flags
  set statusline+=%<\%{expand('%:h')}/                 " relative path
  set statusline+=%<\%t%*                              " file name
  set statusline+=%=                                   " seperate between right & left
  set statusline+=\ \                                  " spacer
  set statusline+=%1*\ %{strlen(&ft)?&ft:'???'}\ %*    " file type or ???
  set statusline+=\ \ %3(%c%)                          " column
  set statusline+=%10(\ \ %l/%L%)                      " line
  set statusline+=\ \ %P\ \                            " percentage through file
endif

"==============================================================================
" ################################################### FILETYPE SPECIFIC OPTIONS
augroup file_type
  au!

  au filetype * set tabstop=2 | set shiftwidth=2
  au filetype markdown set tabstop=4 | set shiftwidth=4
  au filetype make,go,markdown setlocal noexpandtab
  au filetype gitcommit,git,qf,go,markdown,netrw setlocal nolist
  au BufRead,BufNewFile *.{md,txt} call SetupWrapping()
  au BufNewFile,BufRead *.json set ft=javascript
  au BufNewFile,BufRead Dockerfile* set ft=Dockerfile
  au BufNewFile,BufRead *.{js,jsx} hi def link jsObjectKey Identifier
augroup END

"==============================================================================
" ############################################################## PLUGIN OPTIONS
augroup plugins
  au!

  " auto clean fugitive buffers
  au BufReadPost fugitive://* set bufhidden=delete
  au BufWritePost * GitGutter
augroup END

" zoomwintab
let g:zoomwintab_hidetabbar = 0

" terminus
let g:TerminusCursorShape = 0
let g:TerminusMouse = 0
let g:TerminusAssumeITerm = 0
let g:TerminusBracketedPaste = 0

" easymotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 0

hi link EasyMotionTarget Search
hi link EasyMotionShade Comment

hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second Search

hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search

" gitgutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_terminal_reports_focus = 0
highlight GitGutterAdd    guifg=#009900 guibg=NONE ctermfg=2 ctermbg=NONE
highlight GitGutterChange guifg=#bbbb00 guibg=NONE ctermfg=3 ctermbg=NONE
highlight GitGutterDelete guifg=#ff2222 guibg=NONE ctermfg=1 ctermbg=NONE

" matchit
so $VIMRUNTIME/macros/matchit.vim

" delimitmate
let g:delimitMate_expand_cr = 2

" indent guides
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

" fzf
let g:homebrew = $HOMEBREW_PREFIX
let &rtp.= ',' . homebrew . '/opt/fzf'

let g:fzf_layout = { 'down': '~20%' }
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
\ }

let g:terminal_ansi_colors = [
  \ '#073642', '#dc322f', '#859900', '#b58900',
  \ '#268bd2', '#d33682', '#2aa198', '#eee8d5',
  \ '#002b36', '#cb4b16', '#586e75', '#657b83',
  \ '#839496', '#6c71c4', '#93a1a1', '#fdf6e3'
\ ]

" vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" ack.vim
let g:ackprg = 'rg -S --no-heading --vimgrep'

" grepper
let g:grepper               = {}
let g:grepper.tools         = ['rg']
let g:grepper.rg = {}
let g:grepper.rg.grepprg = 'rg -H -S --no-heading --vimgrep'

"==============================================================================
" ################################################################### FUNCTIONS
function! SetupWrapping()
  setlocal wrap
  setlocal wrapmargin=2
  setlocal textwidth=72
endfunction

function! DiffSaved()
  :w !diff % - -u | colordiff
endfunction

function! ReloadAll()
  :silent! checktime
  :GitGutterAll
endfunction

let g:outputswitch = 1
let g:outputcmd = "bundle exec rspec"
function! OutputWindow()
  if exists('$TMUX')
    let windows = system("tmux list-windows -F '#I #W'")
    let windows_array = split(windows, '\n')
    let found = 0
    for window in windows_array
      if window =~ "output"
        let indexnum = split(window, ' ')[0]
        call system("tmux send-keys -t " . indexnum . ".0 \"clear\" C-m")
        call system("tmux send-keys -t " . indexnum . ".0 \"" . g:outputcmd . "\" C-m")
        if g:outputswitch == 1
          call system("tmux select-window -t " . indexnum)
        endif
        let found = 1
      endif
    endfor

    if found == 0
      let output = system("tmux neww -n output -d -P -F '#I' -c " . getcwd())
      let indexnum = split(output, '\n')[0] " remove the newline
      call system("tmux send-keys -t " . indexnum . ".0 \"" . g:outputcmd . "\" C-m")
      if g:outputswitch == 1
        call system("tmux select-window -t " . indexnum)
      endif
    endif

  endif
endfunction

let g:outputpane = -1
function! OutputPane()
  if exists('$TMUX') && g:outputpane != -1
    let output = system("tmux display-message -p '#I'")
    let current_window = split(output, '\n')[0]
    call system("tmux send-keys -t " . current_window . "." . g:outputpane . " \"clear\" C-m")
    call system("tmux send-keys -t " . current_window . "." . g:outputpane . " \"" . g:outputcmd . "\" C-m")
  endif
endfunction

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

" remap the tab key to do autocompletion or indentation depending on the
" context (from http://overstimulate.com/articles/vim-ruby)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-n>"
  endif
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

" ctrl u / ctrl d distance
nnoremap <c-u> 10k
nnoremap <c-d> 10j

" Y yanks whole line
nnoremap Y y$

" center after jumping
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz

" `^ prevents cursoring from moving left
inoremap jk <Esc>`^

" gV prevents reselection
vnoremap <tab> <Esc>gV
nnoremap <tab> <Esc>

" remap j and k to move up and down DISPLAYED lines
" without having to press 2 keys
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" save and run
nnoremap <leader>t :w <bar> ! ruby % <cr>

" open alternate file
nnoremap <leader>. :A<cr>

" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :let @/ = ""<bar>:nohlsearch<Bar>:echo<CR>

" Switch between last two buffers
nnoremap <leader><leader> <c-^>

" fzf mappings
nnoremap <leader>f :FZF<cr>
nnoremap <leader>F :FZF %:p:h<cr>
nnoremap <leader>sc :FZF app/controllers<cr>
nnoremap <leader>sm :FZF app/models<cr>
nnoremap <leader>sv :FZF app/views<cr>
nnoremap <leader>st :FZF spec<cr>

" easymotion
nmap s <Plug>(easymotion-overwin-f2)

" tab completion
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" don't use Ex mode, use Q for formatting
map Q gq

" window splitting
nnoremap <silent> vv <C-w>v
nnoremap <silent> __ <C-w>s

" window movement
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" disable cursor keys in normal mode
map <Left>  :echo "NOPE"<cr>
map <Right> :echo "NOPE"<cr>
map <Up>    :echo "NOPE"<cr>
map <Down>  :echo "NOPE"<cr>

" command-line mode history completion
cmap <c-n> <down>
cmap <c-p> <up>

nnoremap <leader>sd :DiffSaved<cr>

" grepper
nnoremap <silent>K :Grepper -tool rg -cword -noprompt<cr>
nnoremap <leader>g :Grepper -tool rg<cr>

" open a Quickfix window for the last search.
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" annoyance
nnoremap <F1> <nop>

" Set netrw refresh so it doesn't overwrite ctrl-l
map <unique> <c-e> <Plug>NetrwRefresh

"==============================================================================
" #################################################################### COMMANDS
command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
command! DiffSaved :call DiffSaved()
command! RenameFile :call RenameFile()
command! OutputWindow :call OutputWindow()
command! OutputPane :call OutputPane()
command! CloseOutputWindow :call CloseOutputWindow()
command! Path :echo expand('%:p')
command! CopyRPath :call system("echo \"" . expand('%') . "\" | tr -d '\n' | pbcopy")
command! CopyAPath :call system("echo \"" . expand('%:p') . "\" | tr -d '\n' | pbcopy")
command! ReloadAll :call ReloadAll()
command! JSONPretty :normal :.!jsonpp %<cr>
command! -range=% SoftWrap
            \ <line2>put _ |
            \ <line1>,<line2>g/.\+/ .;-/^$/ join | normal $x
