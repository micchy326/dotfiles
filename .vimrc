" プラグイン読み込みの前にpython3の使用を宣言しておく
" プラグインを先に読み込むとpython2が使用されてしまう
call has('python3')

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

" .mdファイルをmarkdownに変更
au BufRead,BufNewFile *.md set filetype=markdown

colorscheme ron

syntax on

set cursorline
highlight CursorLine ctermfg=NONE guibg=#303030 ctermbg=236 gui=NONE cterm=NONE

" 縦分割の線色設定
set fillchars=vert:┃,fold:-
highlight VertSplit ctermfg=black ctermbg=156

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" gtags-cscope.vim settings
set cscopetag
let GtagsCscope_Auto_Load = 1
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
let GtagsCscope_Ignore_Case = 0
let GtagsCscope_Absolute_Path = 0

" gtags settings
map <F2> :copen<CR>
map <F4> :cclose<CR>
map <C-h> :Gtags -f %<CR>
map <F3> :GtagsCursor<CR>
map <S-C-G> :Gtags -r <C-r><C-w><CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>
let g:Gtags_OpenQuickfixWindow = 1
let g:Gtags_Close_When_Single = 1
let g:Gtags_Auto_Update = 1

set tabstop=4
set autoindent
set expandtab
set shiftwidth=4


" vim-easymotion の設定 -------------------------
" デフォルトのキーマッピングを無効に
"  let g:EasyMotion_do_mapping = 0
" f + 2文字 で画面全体を検索してジャンプ
"  nmap f <plug>(easymotion-overwin-f2)
" 検索時、大文字小文字を区別しない
"  let g:EasyMotion_smartcase = 1

"File
set hidden

"Backup
call system('mkdir -p $HOME/dotfiles/.vim/backup')
set backupdir=$HOME/dotfiles/.vim/backup
set browsedir=buffer
set directory=$HOME/dotfiles/.vim/backup
set history=10000

"Search
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan

"Input
set cindent
set shiftwidth=4
set tabstop=4
set expandtab "<Tab>の代わりに<Space>を挿入する
set softtabstop=4 "expandtabで<Tab>が対応する<Space>の数
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]

"挿入モード中の移動コマンド
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>

"コマンドラインでのemacsバインディング 
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" コマンドモード時のTAB補完をzsh風にする
set wildmenu
set wildmode=full

"空白文字を表示
"http://4geek.net/set-gvims-vimrc-on-windows/
set list "タブ、行末等の不可視文字を表示する
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%

"全角スペースをハイライト
"https://shobon.hatenablog.com/entry/2014/06/24/221750
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif


"インサートモードからノーマルモード切り替え時にIMEを無効化
"入力システムがfcitxである必要がある
"https://qiita.com/hoshitocat/items/a80d613ef73b7a06ec50
function! ImInActivate()
    call system('fcitx-remote -c')
endfunction
inoremap <silent> <ESC> <ESC>:call ImInActivate()<CR>

" ESC to jj
inoremap <silent> jj <ESC>:call ImInActivate()<CR>
" 日本語入力で”っj”と入力してもEnterキーで確定させればインサートモードを抜、IMEを無効化
inoremap <silent> っｊ <ESC>:call ImInActivate()<CR>
inoremap <silent> っっｊ <ESC>:call ImInActivate()<CR>
inoremap <silent> っっっｊ <ESC>:call ImInActivate()<CR>
inoremap <silent> っっっっｊ <ESC>:call ImInActivate()<CR>
inoremap <silent> っｋ <ESC>:call ImInActivate()<CR>
inoremap <silent> っっｋ <ESC>:call ImInActivate()<CR>
inoremap <silent> っっっｋ <ESC>:call ImInActivate()<CR>
inoremap <silent> っっっっｋ <ESC>:call ImInActivate()<CR>

nnoremap <silent> っｊ <ESC>:call ImInActivate()<CR>
nnoremap <silent> っっｊ <ESC>:call ImInActivate()<CR>
nnoremap <silent> っっっｊ <ESC>:call ImInActivate()<CR>
nnoremap <silent> っっっっｊ <ESC>:call ImInActivate()<CR>
nnoremap <silent> っｋ <ESC>:call ImInActivate()<CR>
nnoremap <silent> っっｋ <ESC>:call ImInActivate()<CR>
nnoremap <silent> っっっｋ <ESC>:call ImInActivate()<CR>
nnoremap <silent> っっっっｋ <ESC>:call ImInActivate()<CR>

" :helpの日本語化
set helplang=ja,en

" 数行余裕を持ってスクロールする
set scrolloff=3

" バッファ切り替えを高速に
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>

" mouseを使用する
set mouse=a
set ttymouse=sgr

" airlineの設定
set laststatus=2
set showtabline=2 " 常にタブラインを表示
set t_Co=256 " この設定がないと色が正しく表示されない
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#anzu#enabled = 1
let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1


" ctrlp settings
let g:ctrlp_map = '<C-x>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['GTAGS']
let g:ctrlp_show_hidden = 1
"let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_lazy_update = 1
let g:ctrlp_max_height = 30
let g:ctrlp_use_caching = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_custom_ignore = {
  \ 'func': 'CtrlPIgnoreFilter',
  \ }
"map <c-x> :CtrlP<CR>

function! CtrlPIgnoreFilter(item, type) abort
    let l:cnv_item = tr(a:item, "\\", "/")
    let l:pattern = ['\.git/', '\.svn/', '/\.cache/', '/\.dropbox/', '/\.conda/', '/\.eclipse/', '\.o$', '\.a$', 'GPATH', 'GRTAGS', 'GTAGS']
    for p in l:pattern
        if match(l:cnv_item, p) >= 0
            "echo 'skip = ' l:cnv_item
            return 1
        endif
    endfor
    return 0
endfunction

" previewウインドウをひとまず無効化
set completeopt=menuone

" 補完メニューの色
hi Pmenu ctermbg=23 cterm=BOLD
hi Pmenu ctermfg=209 cterm=BOLD
hi PmenuSel ctermbg=29
hi PmenuSel ctermfg=209 cterm=BOLD
hi PmenuSbar ctermbg=22
hi PmenuThumb ctermfg=3

" vim-quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <F9>     <Plug>(quickhl-manual-toggle)
xmap <F9>     <Plug>(quickhl-manual-toggle)

nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

nmap <Space>j <Plug>(quickhl-cword-toggle)

nmap <Space>] <Plug>(quickhl-tag-toggle)

map H <Plug>(operator-quickhl-manual-this-motion)
" 上から順にハイライト時の色として使用される。抵抗のカラーコードと同じ
let g:quickhl_manual_colors = [
   \ "gui=bold ctermfg=15 ctermbg=172 guibg=#8A4B08 guifg=#ffffff",
   \ "gui=bold ctermfg=15 ctermbg=160 guibg=#DF013A guifg=#ffffff",
   \ "gui=bold ctermfg=0  ctermbg=202 guibg=#FF8000 guifg=#000000",
   \ "gui=bold ctermfg=0  ctermbg=220 guibg=#F3F781 guifg=#000000",
   \ "gui=bold ctermfg=0  ctermbg=118 guibg=#00FF00 guifg=#000000",
   \ "gui=bold ctermfg=15 ctermbg=20  guibg=#2E64FE guifg=#ffffff",
   \ "gui=bold ctermfg=15 ctermbg=5   guibg=#A901DB guifg=#ffffff",
   \ "gui=bold ctermfg=0  ctermbg=247 guibg=#FFFFFF guifg=#000000",
   \ "gui=bold ctermfg=0  ctermbg=255 guibg=#D8D8D8 guifg=#000000",
   \ "gui=bold ctermfg=15 ctermbg=239 guibg=#585858 guifg=#ffffff",
      \ ]

" 常時ハイライトしたい文字列を指定する。上の配色が上から使用される
"let g:quickhl_manual_keywords = [
"      \ "finish",
"      \ {"pattern": '\s\+$', "regexp": 1 },
"      \ {"pattern": '\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}', "regexp": 1 },
"      \ ]
"

" vimdiffのアルゴリズムを賢く (vim vim 8.1.0360-)
set diffopt=internal,filler,algorithm:histogram,indent-heuristic

" ctrlp + memolist
nmap ,mf :exe "CtrlP" g:memolist_path<cr><f5>
nmap ,mc :MemoNew<cr>
nmap ,mg :MemoGrep<cr>


" dirvish-git
let g:dirvish_git_indicators = {
\ 'Modified'  : 'Ṁ',
\ 'Staged'    : 'Ṥ',
\ 'Untracked' : 'Ṳ',
\ 'Renamed'   : 'Ṟ',
\ 'Unmerged'  : '⌥',
\ 'Ignored'   : 'ỉ',
\ 'Unknown'   : '?'
\ }

" Sort folders at the top: >
let g:dirvish_mode = ':sort ,^.*[\/],'

let g:modified = 'guifg=#FFFF00 ctermfg=226'
let g:added = 'guifg=#5FFF87 ctermfg=84'
let g:unmerged = 'guifg=#FF005F ctermfg=197'

silent exe 'hi default DirvishGitModified '.g:modified
silent exe 'hi default DirvishGitStaged '.g:added
silent exe 'hi default DirvishGitRenamed '.g:modified
silent exe 'hi default DirvishGitUnmerged '.g:unmerged
silent exe 'hi default DirvishGitIgnored guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
silent exe 'hi default DirvishGitUntracked guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
" Untracked dir linked to Dirvish default dir color
silent exe 'hi default link DirvishGitUntrackedDir DirvishPathTail'

augroup DirVishHighlight
  au!
  autocmd FileType dirvish :hi Conceal ctermfg=123 ctermbg=0 guifg=LightGrey guibg=DarkGrey
augroup END

" anzu
nmap n <Plug>(anzu-n)zz
nmap N <Plug>(anzu-N)zz
nmap * <Plug>(anzu-star)zz
nmap # <Plug>(anzu-sharp)zz

" g* 時にステータス情報を出力する場合
nmap g* g*<Plug>(anzu-update-search-status-with-echo)

" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

" statusline
set statusline=%{anzu#search_status()}

let g:airline_extensions=[ "ctrlp", "keymap", "netrw", "po", "quickfix", "tabline", "term", "whitespace", "wordcount", "anzu",]

let g:airline#extensions#languageclient#enabled = 1
let airline#extensions#languageclient#error_symbol = 'E:'
let airline#extensions#languageclient#warning_symbol = 'W:'
let airline#extensions#languageclient#show_line_numbers = 1
let airline#extensions#languageclient#open_lnum_symbol = '(L'
let airline#extensions#languageclient#close_lnum_symbol = ')'

let g:LanguageClient_serverCommands = {
    \ 'c': ['clangd', '-background-index'],
    \ 'cpp': ['clangd', '-background-index'],
    \ 'typescript': ['typescript-language-server', '--stdio'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }

let g:LanguageClient_loggingFile = expand('~/.vim/LanguageClient.log')
"let g:LanguageClient_windowLogMessageLevel = "Log"
"let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_selectionUI = 'quickfix'
let g:LanguageClient_diagnosticsList = 'Disabled'

highlight ALEError ctermfg=red guibg=black ctermbg=black gui=NONE cterm=bold
highlight ALEWarning ctermfg=green guibg=black ctermbg=black gui=NONE cterm=bold
highlight ALEInfo ctermfg=lightblue guibg=black ctermbg=black gui=NONE cterm=bold

nnoremap <silent> <Space>h :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <Space><Space> :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <Space>r :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <Space><F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <Space>c :call LanguageClient_contextMenu()<CR>
nnoremap <silent> <Space>w :call LanguageClient#workspace_symbol('<C-r><C-w>')<CR>

augroup cproject
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c
    autocmd FileType c setlocal completefunc=LanguageClient#complete
augroup END

augroup typescriptproject
    autocmd!
    autocmd FileType typescript setlocal completefunc=LanguageClient#complete
    autocmd FileType typescript setlocal iskeyword=@,48-57,_,192-255
augroup END

augroup rustproject
    autocmd!
    autocmd FileType rust setlocal completefunc=LanguageClient#complete
augroup END

" mapの一覧をファイル出力
function! MapList()
    redir! > ~/vim_keys.txt
    silent verbose map
    redir END
endfunction
