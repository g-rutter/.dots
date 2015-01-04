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

if expand('%:t') =~? '\.in$'
    setfiletype lammps
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
nnoremap <silent> <Leader>/ :nohlsearch<CR>
" Open a Quickfix window for the last search.
nnoremap <silent> <Leader>\ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

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
noremap * *Nzz
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
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

"Github bundles here:
"Bundle 'kien/ctrlp.vim'
"Bundle 'kshenoy/vim-signature'
"Bundle 'maxbrunsfeld/vim-yankstack'
"Bundle 'scrooloose/syntastic'
"Bundle 'Shougo/unite.vim'
"Bundle 'blueyed/vim-diminactive'
"Bundle 'fholgado/minibufexpl.vim'

Bundle 'benmills/vimux'
Bundle 'godlygeek/tabular'
Bundle 'guns/xterm-color-table.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'osyo-manga/vim-over'
Bundle 'salsifis/vim-transpose'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Shougo/vimproc.vim'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/a.vim'
Bundle 'vim-scripts/CmdlineComplete.git'
Bundle 'vim-scripts/InsertChar'
Bundle 'vim-scripts/TagHighlight'

if has('python')
    Bundle 'gregsexton/VimCalc'
    Bundle 'honza/vim-snippets'
    Bundle 'SirVer/ultisnips'
    Bundle 'Valloric/YouCompleteMe'
endif

filetype plugin indent on "required!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Bundle settings                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""
"  Smooth-scroll  "
"""""""""""""""""""

"noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 1)<CR>
"noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 1)<CR>

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
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadBraces
augroup END

let g:rbpt_colorpairs = [
    \ ['darkgray',    'DarkOrchid3'    ] ,
    \ ['brown',       'RoyalBlue3'     ] ,
    \ ['Darkblue',    'SeaGreen3'      ] ,
    \ ['darkgreen',   'firebrick3'     ] ,
    \ ['darkcyan',    'RoyalBlue3'     ] ,
    \ ['darkred',     'SeaGreen3'      ] ,
    \ ['darkmagenta', 'DarkOrchid3'    ] ,
    \ ['brown',       'firebrick3'     ] ,
    \ [89,        'RoyalBlue3'         ] ,
    \ [202,       'SeaGreen3'          ] ,
    \ ['darkmagenta', 'DarkOrchid3'    ] ,
    \ [214,   'RoyalBlue3'             ] ,
    \ ['darkgreen',    'SeaGreen3'     ] ,
    \ ['darkcyan',     'DarkOrchid3'   ] ,
    \ ['darkred',         'firebrick3' ] ,
    \                                  ]

"""""""""""""""
"  Powerline  "
"""""""""""""""

let g:Powerline_stl_path_style = 'full'
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
let Powerline_cache_enabled = 1
call Pl#Theme#InsertSegment('currhigroup', 'after', 'fileinfo')
let Powerline_colorscheme = 'solarized256'

"""""""""""
"  Vimux  "
"""""""""""

let g:VimuxUseNearest = 0
let g:VimuxPromptString = "Vimux > "
noremap <Leader>vc :VimuxPromptCommand<CR>
noremap <Leader>vl :VimuxRunLastCommand<CR>
noremap <Leader>vQ :VimuxCloseRunner<CR>

""""""""""""""""""""""""""
"  Misc bundle settings  "
""""""""""""""""""""""""""

nnoremap <TAB> :<C-U>call InsertChar#insert(v:count1)<CR>
nnoremap ŋ :GundoToggle<CR>
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

"For A.vim. No <Leader> mappings in insert mode please.
augroup avim
    autocmd!
    au VimEnter * iunmap <Leader>is
    au VimEnter * iunmap <Leader>ih
    au VimEnter * iunmap <Leader>ihn
augroup END

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
augroup set_number
    autocmd!
    au BufEnter * set number
    au BufEnter * set relativenumber
augroup END

""""""""""""""""""""""""""""""
"  Colours and highlighting  "
""""""""""""""""""""""""""""""

"Set scheme:
syntax on
hi clear
colorscheme molokai

"Highlight semi-colons that don't terminate a line in C and C++:
augroup nontrailing_semicolons
    autocmd!
    au BufEnter *.cpp,*.c hi semicolon ctermfg=46
    au BufEnter *.cpp,*.c let m = matchadd("semicolon", ';\ze[ \t]\+[^ \t\/$]')
augroup END

" Colour definitions
let g:black=233
let g:white=253
let g:hi_cmds=[]

"Make cursor line grey for high visibility and telling the active mode
if exists('+cursorline')
    set cursorline                     " Highlight current cursor line.
    hi CursorLine ctermbg=234 cterm=underline

    augroup cursor
        autocmd!
        au InsertLeave * hi CursorLine cterm=underline
        au InsertEnter * hi CursorLine cterm=none
    augroup END

endif

" Search highlighting I like
highlight Search ctermfg=78
highlight Search ctermbg=none
highlight Search cterm=underline
highlight IncSearch term=bold

" Override some unwanted molokai settings
call add(hi_cmds, "Normal       ctermfg=".white." ctermbg=".black              )
call add(hi_cmds, "NonText      ctermfg=250"                                   )
call add(hi_cmds, "Comment      ctermfg=245       ctermbg=".black              )
call add(hi_cmds, "SpecialKey   ctermfg=250"                                   )
call add(hi_cmds, "Special                        ctermbg=".black              )
call add(hi_cmds, "Delimiter    ctermfg=228"                                   )
call add(hi_cmds, "LineNr       ctermfg=25        ctermbg=".black." cterm=NONE")
call add(hi_cmds, "Conceal      ctermfg=11        ctermbg=".black              )
call add(hi_cmds, "VertSplit    ctermfg=25        ctermbg=".black              )
call add(hi_cmds, "MatchParen   ctermfg=198       ctermbg=".black." cterm=bold")
call add(hi_cmds, "Folded       ctermfg=3         ctermbg=".black." cterm=bold")
call add(hi_cmds, "ColorColumn  ctermfg=220       ctermbg=".black." cterm=NONE")

" Popup menu
call add(hi_cmds, "Pmenu        ctermfg=".white." ctermbg=235"                 )
call add(hi_cmds, "PmenuSel     ctermfg=288       ctermbg=235       cterm=bold")

" Tabline
call add(hi_cmds, "TabLine      ctermfg=".white." ctermbg=236       cterm=bold")
call add(hi_cmds, "TabLineSel   ctermfg=10        ctermbg=0         cterm=bold")
call add(hi_cmds, "TabLineFill                    ctermbg=236       cterm=NONE")

" Vimdiff
call add(hi_cmds, "DiffAdd      ctermfg=15        ctermbg=24        cterm=bold")
call add(hi_cmds, "DiffChange                     ctermbg=".black              )
call add(hi_cmds, "DiffDelete   ctermfg=12        ctermbg=".black              )
call add(hi_cmds, "DiffText                       ctermbg=0"                   )

"Extra highlight groups from TagHighlight
call add(hi_cmds, "Member      ctermfg=".white."                    cterm=bold")
call add(hi_cmds, "Structure   ctermfg=45"                                     )
call add(hi_cmds, "DefinedName ctermfg=153"                                    )
call add(hi_cmds, "Function    ctermfg=228"                                    )
call add(hi_cmds, "CTagsClass  ctermfg=143                          cterm=bold")

"hi! link Class Normal
"hi! link Enumerator Normal
"hi! link EnumerationName Normal
"hi! link Union Normal
"hi! link GlobalConstant Normal
"hi! link GlobalVariable Normal
"hi! link LocalVariable Normal

" Execute highlighting commands
for hi_cmd in g:hi_cmds
    execute "hi ".hi_cmd
endfor

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

""""""""""""""""""""""""""""""""""""""""
"  Highlight Nth column in some langs  "
""""""""""""""""""""""""""""""""""""""""

augroup colorcol
   autocmd!
   au FileType python set colorcolumn=80
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Tabs and spaces                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let tab_size=4  " Number of spaces which correspond to 1 tab.
set expandtab
let &tabstop=g:tab_size
let &shiftwidth=g:tab_size
let &softtabstop=g:tab_size

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
