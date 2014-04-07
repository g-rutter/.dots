"-------------------------------------------------------------------------------
" Various settings
"-------------------------------------------------------------------------------
set ofu=syntaxcomplete#Complete
set completeopt+=preview
set noswapfile                     " Turn off annoying swap file.
set encoding=utf-8                 " Necessary to show unicode glyphs
set fillchars+=stlnc:\             " Fill an inactive window statusline with \\\\\\\\
set background=dark
set autoindent                     " copy indent from current line
if has ( "conceal" )
  set cole=2                       " enable conceal
endif
set backup                         " keep a backup file
set backupdir=~/.vim/backup        " where to put backup files
set noerrorbells                   " don't make noise
set browsedir=current              " which directory to use for the file browser
set history=500                    " keep N lines of command line history
set hlsearch                       " highlight the last used search pattern
set incsearch                      " do incremental searching
set mouse=                         " disable the use of the mouse
set showcmd                        " display incomplete commands
set smartindent                    " smart autoindenting when starting a new line
set wildmenu                       " command-line completion in an enhanced mode
set modelines=1
set modeline
set showcmd                        " Show the command being typed in the bottom right
set iskeyword+=95                  " Now a word with an underscore will be seen as one word, e.g. big_output is one word.
set laststatus=2                   " Always show me the file name.
set ruler                          " Show % through a file.
"set autochdir                      " always switch to the current file directory
set synmaxcol=10000                " Maximum number of characters on a line that will be syntax highlighted.
set cursorline                     " Highlight current cursor line.
set timeoutlen=600                 " Don't wait so long for the next keypress.
set formatoptions-=r               " Dont add the comment prefix when I press <Enter> in Insert
set formatoptions-=o               " Dont add the comment prefix when I hit o/O on a comment line.
let g:tex_conceal='adgm'           " Conceal accents, ligatures, delimiters, Greek, maths, but not super|sub-scripts.
let tab_size=3                     " Number of spaces which correspond to 1 tab.
set ignorecase                     " When searching, don't care about case of match...
set smartcase                      " ... unless it includes a capital letter.
set clipboard=unnamed              " system clipboard pls
set ttyfast                        " faster redrawing
set lazyredraw                     " screen doesn't update during macros or registers being executed (big speedup)
set scrolloff=5                    " Scroll before reaching edge.
set thesaurus+=~/.vim/mthesaur.txt
set autoread                       " Reload file when changed.
set suffixes+=,                    " Lower matching priority to files without extension (likely binary)
set suffixes-=.h                   " Remove .h from low priority group
set showtabline=1                  " Show tabline when there is more than 1 tab.

"-------------------------------------------------------------------------------
" Persistent undo!
"-------------------------------------------------------------------------------

if has ("persistent_undo")
   set undodir=~/.vim/undo
   set undofile
   set undolevels=1000 "maximum number of changes that can be undone
   set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

"-------------------------------------------------------------------------------
" Set extra filetypes
"-------------------------------------------------------------------------------

if expand('%:t') =~? 'bash-fc-\d\+' "Temp bash files
 setfiletype sh
endif

if expand('%:t') =~? '\.in$'
 setfiletype lammps
endif

"-------------------------------------------------------------------------------
" Keyboard
"-------------------------------------------------------------------------------

let mapleader = ","

" Enter a blank line below/above cursor in Normal mode.
" The o command will continue comments in a program.
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

"make K split lines (opposite of J)
nnoremap K i<cr><esc>k$

"open and close NERD tree
nnoremap <Leader>nt :NERDTreeToggle<CR>

"Update tags for extra highlighting with <leader>ut
nnoremap <Leader>ut :UpdateTypesFile<CR>

" Resize windows with + and -
if bufwinnr(1)
 map + <C-W>+
 map - <C-W>-
endif

" save and quit shortcuts
nnoremap <Leader>a :wall<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>x :x<CR>
nnoremap <Leader>! :qall!<CR>

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
inoremap  <Left><Del>
set backspace=2      "backspace over line breaks

"Can enter 45<Space> to go to line 45!
"<Space> goes to end of file! etc
noremap <Space> G
vnoremap <Space> G

"Reload settings or vsplit to vimrc
cab sv so ~/.vimrc
cab spv vs ~/.vimrc
cab vsv vs ~/.vimrc

"Arrow keys are disabled.
inoremap <Left>  <Nop>
inoremap <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
noremap  <Left>  <Nop>
noremap  <Right> <Nop>
noremap  <Up>    <Nop>
noremap  <Down>  <Nop>

"Switch to nth tab with <Leader>n
noremap <Leader>1 1gt
noremap <Leader>2 2gt
noremap <Leader>3 3gt
noremap <Leader>4 4gt
noremap <Leader>5 5gt
noremap <Leader>6 6gt
noremap <Leader>7 7gt
noremap <Leader>8 8gt
noremap <Leader>9 9gt

"Centre search matches when jumping
noremap N Nzz
noremap n nzz

"Open a fold and put the line above the top of the fold at the top of the
"screen
nnoremap <Leader>Z zAkztj
nnoremap <Leader>z zakztj

"Returns the syntax highlighting group of the current thing under the cursor:
nnoremap <silent> <Leader>h :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"Make working in command mode less straining on the wrists. Ctrl-space is
"equivalent to enter, and alt+hjkl move through history and left and right
cnoremap <C-@> <Enter>
cnoremap <Esc>j <C-Down>
cnoremap <Esc>k <C-Up>
cnoremap <Esc>h <Left>
cnoremap <Esc>l <Right>

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

"Make scrolloff compatible with H, L
execute 'nnoremap H H'.&l:scrolloff.'k'
execute 'nnoremap L L'.&l:scrolloff.'j'
execute 'vnoremap H H'.&l:scrolloff.'k'
execute 'vnoremap L L'.&l:scrolloff.'j'

"Align visually selected text by a single character
vnoremap <leader>a :<c-u>execute ":'<,'>Tabular /".nr2char(getchar())<cr>

"define a macro that inserts a line printing its line number in a variety of
"languages
au FileType cpp,c noremap <Leader>p o<Esc>:s/^/\=printf('printf ("Line %d\n.");', line('.'))<Enter>:nohlsearch<CR>
au FileType sh noremap <Leader>p o<Esc>:s/^/\=printf('echo "Line %d."', line('.'))<Enter>:nohlsearch<CR>
au FileType python noremap <Leader>p o<Esc>:s/^/\=printf('print "Line %d."', line('.'))<Enter>:nohlsearch<CR>
au FileType vim noremap <Leader>p o<Esc>:s/^/\=printf('echo "Line %d."', line('.'))<Enter>:nohlsearch<CR>
"-------------------------------------------------------------------------------
"" Load bundles/plugins
""-------------------------------------------------------------------------------

filetype off " required!
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

""Github bundles here:
"Bundle 'kien/ctrlp.vim'
"Bundle 'kshenoy/vim-signature'
"Bundle 'Valloric/YouCompleteMe'
"Bundle 'maxbrunsfeld/vim-yankstack'
"Bundle 'nathanaelkane/vim-indent-guides'
"Bundle 'scrooloose/nerdtree'
"Bundle 'scrooloose/syntastic'
"Bundle 'Shougo/unite.vim'

Bundle 'godlygeek/tabular'
Bundle 'guns/xterm-color-table.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
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
Bundle 'osyo-manga/vim-over'
Bundle 'honza/vim-snippets'

if has('python')
  Bundle 'SirVer/ultisnips'
  Bundle 'gregsexton/VimCalc'
  "Bundle 'alfredodeza/pytest.vim'
endif

"Quick bundle options:
let g:EasyMotion_leader_key = '<leader>'

nnoremap <TAB> :<C-U>call InsertChar#insert(v:count1)<CR>
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit='horizontal'

let g:NERDCustomDelimiters = { 'lammps' : { 'left' : '#' } }

filetype plugin indent on "required!

"nnoremap þ yankstack_substitute_older_paste
"nnoremap Þ yankstack_substitute_newer_paste
"call yankstack#setup()
nnoremap Y y$

nnoremap ŋ :GundoToggle<CR>

"Unite
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"let g:unite_source_history_yank_enable = 1
"let g:unite_winheight = 10

"nnoremap \p :Unite -start-insert file_rec/async<cr>
"nnoremap \y :Unite history/yank<cr>
"nnoremap \l :Unite -start-insert line<cr>

""-------------------------------------------------------------------------------
"" Colours and such
""-------------------------------------------------------------------------------

"Set scheme:
set t_Co=256
syntax on
hi clear
colorscheme molokai

"Show line numbers.
set number
set relativenumber

"Highlight semi-colons that don't terminate a line in C and C++:
au BufEnter *.cpp,*.c hi semicolon ctermfg=46
au BufEnter *.cpp,*.c let m = matchadd("semicolon", ';\ze[ \t]\+[^ \t\/$]')

"Make cursor line grey for high visibility and telling the active mode
if exists('+cursorline')
 hi CursorLine ctermbg=234 cterm=underline
 au InsertLeave * hi CursorLine ctermbg=234 cterm=underline
 au InsertEnter * hi CursorLine ctermbg=234 cterm=none
endif

" Search highlighting I like
highlight Search ctermfg=78
highlight Search ctermbg=none
highlight Search cterm=underline
highlight IncSearch term=bold

" Override some unwanted molokai settings
highlight   Normal       ctermfg=255   ctermbg=16
highlight   NonText      ctermfg=250
highlight   Comment      ctermfg=250
highlight   SpecialKey   ctermfg=250
highlight   Delimiter    ctermfg=228
highlight   LineNr       ctermfg=15    ctermbg=53
highlight   Conceal      ctermfg=11    ctermbg=16
highlight   Pmenu        ctermbg=53    ctermfg=15
highlight   VertSplit    ctermfg=53    ctermbg=53

" Tabline
highlight   TabLine      ctermfg=255   ctermbg=236 cterm=bold
highlight   TabLineSel   ctermfg=10    ctermbg=0   cterm=bold
highlight   TabLineFill                ctermbg=236 cterm=NONE

" Make Vimdiff tolerable
hi DiffAdd ctermbg=24 ctermfg=15 cterm=bold
hi DiffChange ctermbg=16
hi DiffDelete ctermbg=16 ctermfg=12
hi DiffText ctermbg=0

" Make paren matches less confusing
hi MatchParen cterm=bold ctermbg=16 ctermfg=198

"Show tabs
set list
set listchars=tab:›\ ,trail:⋅,nbsp:⋅

"-------------------------------------------------------------------------------
" Conceal settings
"-------------------------------------------------------------------------------

au BufEnter *.cpp,*.c syn match cpp_logical_and /&&/ conceal cchar=⋀
au BufEnter *.cpp,*.c syn match cpp_logical_or /||/ conceal cchar=⋁
au BufEnter *.cpp,*.c syn match cpp_sqrt /sqrt/ conceal cchar=√
au BufEnter *.cpp,*.c syn match cpp_le /<=/ conceal cchar=≤
au BufEnter *.cpp,*.c syn match cpp_ge />=/ conceal cchar=≥
au BufEnter *.cpp,*.c syn match cpp_multiply / \* / conceal cchar=✕

"-------------------------------------------------------------------------------
" Extra colours from TagHighlight
"-------------------------------------------------------------------------------

"hi! link Class Normal
"hi! link Enumerator Normal
"hi! link EnumerationName Normal
"hi! link Union Normal
"hi! link GlobalConstant Normal
"hi! link GlobalVariable Normal
"hi! link LocalVariable Normal

hi! Member ctermfg=255 cterm=bold
hi! Structure ctermfg=45
hi! DefinedName ctermfg=153
hi! Function ctermfg=228
hi! CTagsClass ctermfg=143 cterm=bold

"-------------------------------------------------------------------------------
" Rainbow Parens
"-------------------------------------------------------------------------------

"Turn on rainbow parenthesis
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadBraces

let g:rbpt_colorpairs = [
  \ ['darkgray',    'DarkOrchid3' ],
  \ ['brown',       'RoyalBlue3'  ],
  \ ['Darkblue',    'SeaGreen3'   ],
  \ ['darkgreen',   'firebrick3'  ],
  \ ['darkcyan',    'RoyalBlue3'  ],
  \ ['darkred',     'SeaGreen3'   ],
  \ ['darkmagenta', 'DarkOrchid3' ],
  \ ['brown',       'firebrick3'  ],
  \ [89,        'RoyalBlue3'  ],
  \ [202,       'SeaGreen3'   ], 
  \ ['darkmagenta', 'DarkOrchid3' ],
  \ [27,    'firebrick3'          ], 
  \ [214,   'RoyalBlue3'  ], 
  \ ['darkgreen',    'SeaGreen3'   ],
  \ ['darkcyan',     'DarkOrchid3' ],
  \ ['darkred',         'firebrick3'  ],
  \ ]

"-------------------------------------------------------------------------------
" Needed for LaTeX
"-------------------------------------------------------------------------------

au filetype tex noremap ;w :update<CR>:!latexmk -pdf % && clear<CR> " save file then run latexmk to make pdf file.
noremap ;o :!kde-open %<.pdf<CR>:!clear<CR>                         " open the pdf file corresponding to current latex file.

"-------------------------------------------------------------------------------
" Statusline (Powerline)
"-------------------------------------------------------------------------------

let g:Powerline_stl_path_style = 'full'
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
let Powerline_cache_enabled = 1
call Pl#Theme#InsertSegment('currhigroup', 'after', 'fileinfo')
let Powerline_colorscheme = 'solarized256'
"Add PWD then short/relative path

"-------------------------------------------------------------------------------
" Folding and visual fold cuing
"-------------------------------------------------------------------------------

set foldmethod=indent " Fold lines by indentation
set foldminlines=5

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

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=233
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=30

"-------------------------------------------------------------------------------
" Search for selected text, forwards or backwards.
" Source:http://vim.wikia.com/wiki/Search_for_visually_selected_text 
"-------------------------------------------------------------------------------
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

"""""""""""""""""
"  Window tabs  "
"""""""""""""""""

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
