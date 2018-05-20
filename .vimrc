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

colorscheme elflord

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" gtags settings
map <C-h> :Gtags -f %<CR>
map <F3> :GtagsCursor<CR>
map <S-C-G> :Gtags -r <C-r><C-w><CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

syntax on

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
inoremap <C-a>  <Home>
inoremap <C-e>  <End>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>

"コマンドラインでのemacsバインディング 
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

"空白文字を表示
"http://4geek.net/set-gvims-vimrc-on-windows/
set list "タブ、行末等の不可視文字を表示する
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
scriptencoding utf-8 "これ入れないと下記が反映されない
augroup highlightZenkakuSpace "全角スペースを赤色にする
    autocmd!
    autocmd VimEnter,ColorScheme * highlight ZenkakuSpace term=underline ctermbg=Red guibg=Red
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
augroup END

"インサートモードからノーマルモード切り替え時にIMEを無効化
"入力システムがfcitxである必要がある
"https://qiita.com/hoshitocat/items/a80d613ef73b7a06ec50
function! ImInActivate()
  call system('fcitx-remote -c')
endfunction
inoremap <silent> <C-[> <ESC>:call ImInActivate()<CR>

" ESC to jj
inoremap <silent> jj <ESC>:call ImInActivate()<CR>
inoremap <silent> kk <ESC>:call ImInActivate()<CR>
" 日本語入力で”っj”と入力してもEnterキーで確定させればインサートモードを抜、IMEを無効化
noremap <silent> っｊ <ESC>:call ImInActivate()<CR>
noremap <silent> っっｊ <ESC>:call ImInActivate()<CR>
noremap <silent> っっっｊ <ESC>:call ImInActivate()<CR>
noremap <silent> っっっっｊ <ESC>:call ImInActivate()<CR>
noremap <silent> っｋ <ESC>:call ImInActivate()<CR>
noremap <silent> っっｋ <ESC>:call ImInActivate()<CR>
noremap <silent> っっっｋ <ESC>:call ImInActivate()<CR>
noremap <silent> っっっっｋ <ESC>:call ImInActivate()<CR>

