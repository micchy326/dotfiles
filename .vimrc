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

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

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
inoremap <silent> kk <ESC>:call ImInActivate()<CR>
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

"検索語が画面の真ん中に来るようにする
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

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
let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1

" Bracketd Paste Modeを有効に
if has("patch-8.0.0238")
    " Bracketed Paste Mode対応バージョン(8.0.0238以降)では、特に設定しない
    " 場合はTERMがxtermの時のみBracketed Paste Modeが使われる。
    " tmux利用時はTERMがscreenなので、Bracketed Paste Modeを利用するには
    " 以下の設定が必要となる。
    if &term =~ "screen"
        let &t_BE = "\e[?2004h"
        let &t_BD = "\e[?2004l"
        exec "set t_PS=\e[200~"
        exec "set t_PE=\e[201~"
    endif
else
    " 8.0.0210 ～ 8.0.0237 ではVim本体でのBracketed Paste Mode対応の挙動が
    " 望ましくない(自動インデントが無効にならない)ので、Vim本体側での対応を
    " 無効にする。
    if has("patch-8.0.0210")
        set t_BE=
    endif

    " Vim本体がBracketed Paste Modeに対応していない時の為の設定。
    if &term =~ "xterm" || &term =~ "screen"
        let &t_ti .= "\e[?2004h"
        let &t_te .= "\e[?2004l"

        function XTermPasteBegin(ret)
            set pastetoggle=<Esc>[201~
            set paste
            return a:ret
        endfunction

        noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
        inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
        vnoremap <special> <expr> <Esc>[200~ XTermPasteBegin("c")
        cnoremap <special> <Esc>[200~ <nop>
        cnoremap <special> <Esc>[201~ <nop>
    endif
endif

