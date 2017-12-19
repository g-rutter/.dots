""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      Vim doesn't work well with fish                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &shell =~# 'fish$'
    set shell=sh
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Various settings                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set autochdir                      " always switch to the current file directory
"set autoread                       " Reload file when changed.
set nocompatible
set backupdir=~/.vim/backup        " where to put backup files
set backup                         " keep a backup file
set browsedir=current              " which directory to use for the file browser
set clipboard=                     " make yank work on Mac
set history=500                    " keep N lines of command line history
set iskeyword+=95                  " Now a word with an underscore will be seen as one word, e.g. big_output is one word.
set noerrorbells                   " don't make noise
set noswapfile                     " Turn off annoying swap file.
set ignorecase                     " When searching, don't care about case of match...
set smartcase                      " ... unless it includes a capital letter.
set thesaurus+=~/.vim/mthesaur.txt

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            Neovim-only settings                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("nvim")
    set inccommand=split
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Persistent undo                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has ("persistent_undo")
    set undodir=~/.vim/undo
    set undofile
    set undolevels=1000  "maximum number of changes that can be undone
    set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Filetype settings                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if expand('%:t') =~? 'bash-fc-\d\+' "Temp bash files
    setfiletype sh
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Input                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""
"  Settings  "
""""""""""""""

set timeoutlen=600                 " Don't wait so long for the next keypress.
set mouse=                         " disable the use of the mouse
set completeopt+=preview
set ofu=syntaxcomplete#Complete
set autoindent                     " copy indent from current line
set smartindent                    " smart autoindenting when starting a new line
set suffixes-=.h                   " Remove .h from low priority group for filename completion
set suffixes+=,                    " Lower matching priority to files without extension (likely binary)

" REALLY disable adding the comment prefix for me:
" (Lots of syntax files loaded after vimrc turn it back on.)
augroup formatoptions
    autocmd!
    au BufEnter * set formatoptions-=o
    au BufEnter * set formatoptions-=r
augroup END

""""""""""""""
"  Mappings  "
""""""""""""""

" Allow access to # character on Mac. £ symbol is rarely needed.
inoremap £ #

let mapleader = " "

" Enter a blank line below/above cursor in Normal mode.
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
nnoremap <Leader>l o<Esc>O

" make zz/zt/zb work nicely with visual selections
vnoremap <silent> zz :<C-u>call setpos('.',[0,(line("'>")-line("'<"))/2+line("'<"),0,0])<Bar>normal! zzgv<CR>
vnoremap <silent> zt :<C-u>call setpos('.',[0,line("'<"),0,0])<Bar>normal! ztgv<CR>
vnoremap <silent> zb :<C-u>call setpos('.',[0,line("'>"),0,0])<Bar>normal! zbgv<CR>

" make << and >> work nicely with visual selections
vnoremap < <gv
vnoremap > >gv

" Make Y consistent with D, C, S etc.
nnoremap Y y$

"make K split lines (opposite of J)
nnoremap K i<cr><esc>k$

"Update tags for extra highlighting with <leader>ut
nnoremap <Leader>ut :UpdateTypesFile<CR>

"I dont like ex mode
nnoremap Q <nop>
nnoremap gQ <nop>

" save and quit-all shortcuts. c.f. ZZ (=:wq) and ZQ (=:q!)
nnoremap <Leader>W :w<CR>
nnoremap <Leader>!! :qall!<CR>
nnoremap <Leader>Q :q<CR>
nnoremap <Leader>Z ZZ

" Enter command mode quickly
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Clear search highlighting
nnoremap <silent> <Leader>\ :nohlsearch<CR>

"Backspace wasn't working:
set backspace=2      "backspace over line breaks

"sv: source vimrc || ev: tabe vimrc || ed: tabe dotfiles dir
cab sv so ~/.vimrc
cab ev tabe ~/.vimrc
cab ed tabe ~/.dots

"Switch to nth tab with <Leader>n
for N in [1 , 2, 3, 4, 5, 6, 7, 8, 9]
    "Removed bufmap because it puts delay before ^ cmd
    "let bufmap="^[".N." :b ".N."<CR>"
    "execute "noremap".bufmap

    let tabmap="<Leader>".N." ".N."gt"
    execute "noremap".tabmap
endfor

"Centre search matches when jumping
noremap N Nzz
noremap n nzz

"* Doesn't go anywhere, just selects the word for searching
noremap * *N
noremap # <Nop>

"Make working in command mode less straining on the wrists. Ctrl-space is
"equivalent to enter, and alt+hjkl move through history and left and right
cnoremap <C-@> <Enter>
cnoremap <Esc>j <C-Down>
cnoremap <Esc>k <C-Up>
cnoremap <Esc>h <Left>
cnoremap <Esc>l <Right>

"Make scrolloff compatible with H, L
execute 'nnoremap H H'.&l:scrolloff.'k'
execute 'nnoremap L L'.&l:scrolloff.'j'
execute 'vnoremap H H'.&l:scrolloff.'k'
execute 'vnoremap L L'.&l:scrolloff.'j'

"Align visually selected text by a single character
vnoremap <leader>a :<c-u>execute ":'<,'>Tabular /".nr2char(getchar())<cr>

" Fix print commands in python 2 to be python 3 style.
command! FixPrint %s/\(^ *\)print *\([a-zA-Z].*$\)/\1print(\2)/

""""""""""""""""""""""""""""""""""""""""""""
"  Insert line number in various langages  "
""""""""""""""""""""""""""""""""""""""""""""

augroup linenr
    autocmd!
    au FileType cpp,c  noremap <Leader>p o<Esc>:s/^/\=printf('printf ("Line %d\n.");', line('.'))<Enter>:nohlsearch<CR>
    au FileType sh     noremap <Leader>p o<Esc>:s/^/\=printf('echo "Line %d."', line('.'))<Enter>:nohlsearch<CR>
    au FileType python noremap <Leader>p o<Esc>:s/^/\=printf('print "Line %d."', line('.'))<Enter>:nohlsearch<CR>
    au FileType vim    noremap <Leader>p o<Esc>:s/^/\=printf('echo "Line %d."', line('.'))<Enter>:nohlsearch<CR>
augroup END

""""""""""""""""""""""""""""""""
"  Compile sphinx docs in rst  "
""""""""""""""""""""""""""""""""

augroup makehtml
    au FileType rst noremap <Leader>m :VimuxPromptCommand<CR>make clean; PYTHONPATH=~/Documents/HyperSearch/ make html<CR>
augroup END

""""""""""""""""""""""""""""
"  Integration with nbtxt  "
""""""""""""""""""""""""""""
augroup nbtxt
    " Update notebook based on current fileset
    au FileType python noremap <silent> <Leader>nbn :silent !nbtxt nb '%:p:h'<CR>:redraw!<CR>
    " Update fileset based on notebook
    au FileType python noremap <silent> <Leader>nbt :!nbtxt txt '%:p:h'<CR>:e<CR>
augroup END

""""""""""""""""""""
"  Latex mappings  "
""""""""""""""""""""

augroup latex
    autocmd!
    " save file then run latexmk to make pdf file.
    au filetype tex noremap ;p :up<CR>:!latexmk -pdf % && clear<CR>
    " force latexmk to run even if it thinks there are no changes
    au filetype tex noremap ;f :up<CR>:!latexmk -c && latexmk -pdf % && clear<CR>
    " open the pdf file corresponding to current latex file.
    au filetype tex noremap ;o :!kde-open %<.pdf<CR>:!clear<CR>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Search for selected text, forwards or backwards  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source:http://vim.wikia.com/wiki/Search_for_visually_selected_text

vnoremap <silent> * :<C-U>
\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
\gvy/<C-R><C-R>=substitute(
\escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
\gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
\gvy?<C-R><C-R>=substitute(
\escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
\gV:call setreg('"', old_reg, old_regtype)<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Bundles                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off " required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'w0rp/ale'

"Plugin 'derekwyatt/vim-scala'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'benmills/vimux'
Plugin 'godlygeek/tabular'
Plugin 'guns/xterm-color-table.vim'
Plugin 'eapache/rainbow_parentheses.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'osyo-manga/vim-over'
Plugin 'salsifis/vim-transpose'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Shougo/vimproc.vim'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-scripts/a.vim'
Plugin 'vim-scripts/CmdlineComplete.git'
Plugin 'vim-scripts/InsertChar'
Plugin 'vim-scripts/TagHighlight'

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

Plugin 'chrisbra/csv.vim'

Plugin 'dag/vim-fish'

if has('python')
    Plugin 'gregsexton/VimCalc'
    Plugin 'honza/vim-snippets'
    Plugin 'SirVer/ultisnips'
    Plugin 'Valloric/YouCompleteMe'
endif

call vundle#end()
filetype plugin indent on "required!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Bundle settings                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""
"  Airline  "
"""""""""""""

let g:airline_theme='tomorrow'

"""""""""""""""
"  Ultisnips  "
"""""""""""""""

let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit='horizontal'

""""""""""""""""""""
"  Rainbow parens  "
""""""""""""""""""""

augroup rainbowparens
    autocmd!
    au VimEnter * RainbowParenthesesActivate
    au BufEnter * RainbowParenthesesLoadRound
    au BufEnter * RainbowParenthesesLoadBraces
augroup END

let g:rbpt_colorpairs = [
    \ ['gray'    , 'DarkOrchid3'],
    \ [202           , 'SeaGreen3'  ],
    \ [214           , 'RoyalBlue3' ],
    \ ['red'       , 'RoyalBlue3' ],
    \ ['blue'    , 'SeaGreen3'  ],
    \ ['darkgreen'   , 'firebrick3' ],
    \ ['darkcyan'    , 'RoyalBlue3' ],
    \ ['darkred'     , 'SeaGreen3'  ],
    \ ['darkmagenta' , 'DarkOrchid3'],
    \ ['brown'       , 'firebrick3' ],
\ ]

let g:rbpt_max = 10

"""""""""""
"  Vimux  "
"""""""""""

let g:VimuxUseNearest = 0
let g:VimuxPromptString = "Vimux > "
noremap <Leader>vc :w<CR>:VimuxPromptCommand<CR>
noremap <Leader>vl :w<CR>:VimuxRunLastCommand<CR>
noremap <Leader>vQ :VimuxCloseRunner<CR>

noremap <Leader>t :w<CR>:VimuxRunCommand expand('%:p')<CR>

"""""""""
"  ALE  "
"""""""""

let g:ale_sign_error = 'x'
let g:ale_sign_warning = '!'
nmap <silent> <Leader>ak <Plug>(ale_previous_wrap)
nmap <silent> <Leader>aj <Plug>(ale_next_wrap)

highlight link ALEErrorSign SignColumn
highlight link ALEWarningSign SignColumn

let g:ale_echo_msg_format = '[%linter%] %s'

let ignore_pylint = "-d W0401,R0914,R0903,R1705,R0913,R0902,W503,W1202,W503,C0413"
let good_names = "--good-names e,x,n,i,w"
let g:ale_python_pylint_options = ignore_pylint . " " . good_names

let g:ale_linters = {
\   'python': ['pylint'],
\}

""""""""""""""""""""""""""
"  Misc bundle settings  "
""""""""""""""""""""""""""

nnoremap <TAB> :<C-U>call InsertChar#insert(v:count1)<CR>
nnoremap <Leader>g :GundoToggle<CR>
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

"For A.vim. No <Leader> mappings in insert mode please.
augroup avim
    autocmd!
    au VimEnter * iunmap <Leader>is
    au VimEnter * iunmap <Leader>ih
    au VimEnter * iunmap <Leader>ihn
augroup END

"""""""""
"  FZF  "
"""""""""

noremap <Leader>f :FZF<CR>
noremap <Leader>/ :BLines<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Appearance                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""
"  Settings  "
""""""""""""""

set lazyredraw                       " screen doesn't update during macros or registers being executed (big speedup)
set ttyfast                          " faster redrawing
set fillchars+=stlnc:\               " Fill an inactive window statusline with \\\\\\\\
set encoding=utf-8                   " Show unicode glyphs
set wildmenu                         " command-line completion in an enhanced mode
set scrolloff=5                      " Scroll before reaching edge.
set foldmethod=indent                " Fold lines by indentation
set foldminlines=5
set laststatus=2                     " Always show me the file name.
set showtabline=1                    " Show tabline when there is more than 1 tab.
set hlsearch                         " highlight the last used search pattern
set incsearch                        " do incremental searching
set showcmd                          " Show the command being typed in the bottom right
set ruler                            " Show % through a file.
set synmaxcol=10000                  " Maximum number of characters on a line that will be syntax highlighted.
set t_Co=256                         " Number of colours terminal supports
set list                             " Show some chars explicitly
set listchars=tab:›\ ,trail:⋅,nbsp:⋅ " Show these chars explicitly

" This should not require an augroup, but there appears to be a bug with
" relativenumber and number cooperating
if exists ("+relativenumber")
    augroup set_number
        autocmd!
        au BufEnter * set number
        au BufEnter * set relativenumber
    augroup END
else
    augroup set_number
        autocmd!
        au BufEnter * set number
    augroup END
endif

""""""""""""""""""""""""""""""
"  Colours and highlighting  "
""""""""""""""""""""""""""""""

"Set scheme:
syntax on
hi clear
colorscheme Tomorrow

"Highlight semi-colons that don't terminate a line in C and C++:
augroup nontrailing_semicolons
    autocmd!
    au BufEnter *.cpp,*.c hi semicolon ctermfg=46
    au BufEnter *.cpp,*.c let m = matchadd("semicolon", ';\ze[ \t]\+[^ \t\/$]')
augroup END

"Make cursor line grey for high visibility and telling the active mode
if exists('+cursorline')
    set cursorline                     " Highlight current cursor line.
    hi CursorLine cterm=underline ctermbg=None

    augroup cursor
        autocmd!
        au InsertLeave * hi CursorLine cterm=underline ctermbg=NONE
        au InsertEnter * hi CursorLine cterm=none ctermbg=255
    augroup END

endif

"""""""""""""
"  Conceal  "
"""""""""""""

if has ( "conceal" )
    let g:tex_conceal='adgm'           " Conceal accents, ligatures, delimiters, Greek, maths, but not super|sub-scripts.
    set cole=2                         " enable conceal

    augroup conceal
        autocmd!
        au BufEnter *.cpp,*.c syn match cpp_logical_and /&&/ conceal cchar=⋀
        au BufEnter *.cpp,*.c syn match cpp_logical_or /||/ conceal cchar=⋁
        au BufEnter *.cpp,*.c syn match cpp_sqrt /sqrt/ conceal cchar=√
        au BufEnter *.cpp,*.c syn match cpp_le /<=/ conceal cchar=≤
        au BufEnter *.cpp,*.c syn match cpp_ge />=/ conceal cchar=≥
        au BufEnter *.cpp,*.c syn match cpp_multiply / \* / conceal cchar=✕
    augroup END
endif

""""""""""""""""""""
"  Useful func(s)  "
""""""""""""""""""""

function! Rmcolorcodes()
    let substitution = '%s/\[\([0-9]\{1,2}\(;[0-9]\{1,2}\)\?\)\?m//g'
    execute l:substitution
endfunction

function! Fixtabs(spaces)
    let old_space_tab = repeat(' ', a:spaces)
    let new_space_tab = repeat(' ', g:tab_size)
    for indentation in range(30,1, -1)
        let substitution     = '%s/^'.repeat(l:old_space_tab, indentation).'\ze\S/'.repeat(l:new_space_tab, indentation).'/e'
        execute l:substitution
    endfor
    let substitution = '%s/\t/'.new_space_tab.'/ge'
    execute l:substitution
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Tabs and spaces                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let tab_size=4  " Number of spaces which correspond to 1 tab.
set expandtab
let &tabstop=g:tab_size
let &shiftwidth=g:tab_size
let &softtabstop=g:tab_size

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Tab line                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let t = tabpagenr()
        let i = 1

        while i <= tabpagenr('$')

            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let file = bufname(buflist[winnr - 1])
            let file = fnamemodify(file, ':p:t')

            if file == ''
                let file = '[No Name]'
            endif

            let s .= ' ' . i . ': ' . file  . ' ' . '%#TabLine#' . '│'
            let i = i + 1

        endwhile

        let s.= '%#TabLineFill#'

        return s

    endfunction

    set tabline=%!MyTabLine()
endif
