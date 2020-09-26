scriptencoding utf-8

" 初期設定
let g:use_coc = v:true
let g:use_ccls = v:true

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

  if g:use_coc
    call dein#add('neoclide/coc.nvim_release', { 'merged': 0 })
  else
    call dein#add('prabirshrestha/vim-lsp', { 'merged': 0 })
    call dein#add('micchy326/vim-lsp-clangd-switch')
  endif

  " 設定終了
  call dein#end()
  if !g:dein#_is_sudo
    call dein#save_state()
  endif
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

execute 'set runtimepath+=' . expand('~/.vim/')

" .mdファイルをmarkdownに変更
autocmd BufRead,BufNewFile *.md set filetype=markdown

" true color用設定
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" bracketed paste mode設定
" TERMがxterm*でないとvimが自動的にbracketed paste modeを有効化できない
" しかし、tmux内ではTERM=tmux*なのでこの設定が必要
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
exec "set t_PS=\e[200~"
exec "set t_PE=\e[201~"

filetype plugin on

let mapleader = ','

set background=dark
colorscheme tender
augroup fix_tender
    autocmd!
    autocmd ColorScheme tender set cursorline
    autocmd ColorScheme tender highlight CursorLine guibg=#484848 gui=NONE
    autocmd ColorScheme tender highlight! link Search WildMenu
    autocmd ColorScheme tender set fillchars=vert:┃,fold:-
    autocmd ColorScheme tender highlight VertSplit guifg=#999999
    autocmd ColorScheme tender highlight Comment guifg=#aaaaaa
    autocmd ColorScheme tender highlight LineNr guifg=#999999
    autocmd ColorScheme tender highlight SignColumn guifg=#000000 guibg=#3c3c3c
    autocmd ColorScheme tender highlight Visual guibg=#6a6a6a
    autocmd ColorScheme tender highlight! link Pmenu DiffChange
    autocmd ColorScheme tender highlight! link PmenuSel DiffDelete
    autocmd ColorScheme tender highlight PopupWindow guifg=#ffffff guibg=#232b4c
    autocmd ColorScheme tender highlight SpecialKey guifg=#707070
    autocmd ColorScheme tender highlight ZenkakuSpace gui=reverse guibg=#888888
    autocmd ColorScheme tender call matchadd("ZenkakuSpace", "　")
    autocmd ColorScheme tender highlight Tab gui=reverse guifg=#555555 guibg=#333333
    autocmd ColorScheme tender call matchadd("Tab", "	")
    autocmd ColorScheme tender highlight Trail gui=reverse guibg=#555555
    autocmd ColorScheme tender call matchadd("Trail", ' \+$')
    autocmd ColorScheme tender highlight lspReference guifg=Black guibg=#cccccc
    autocmd ColorScheme tender highlight CocHighlightText guibg=#666666
augroup END

augroup fix_koehler
    autocmd!
    autocmd ColorScheme koehler set cursorline
    autocmd ColorScheme koehler highlight CursorLine ctermfg=NONE guibg=#303030 ctermbg=236 gui=NONE cterm=NONE term=NONE
    autocmd ColorScheme koehler highlight Search     term=reverse ctermfg=15 ctermbg=9 guifg=Black guibg=Yellow
    " 補完メニューの色
    autocmd ColorScheme koehler highlight Pmenu ctermfg=209 ctermbg=23 guibg=#191970 guifg=#fAfAff
    autocmd ColorScheme koehler highlight PmenuSel ctermfg=209 ctermbg=29 guifg=#000000
    autocmd ColorScheme koehler highlight PmenuSbar ctermbg=22 guibg=#708090
    autocmd ColorScheme koehler highlight PmenuThumb ctermfg=3 guifg=#000000
    " 縦分割の線色設定
    autocmd ColorScheme koehler set fillchars=vert:┃,fold:-
    autocmd ColorScheme koehler highlight VertSplit ctermfg=black ctermbg=156
    autocmd ColorScheme koehler highlight SpecialKey guibg=NONE guifg=Gray40
    autocmd ColorScheme koehler highlight lspReference ctermfg=Black guifg=Black ctermbg=lightgray guibg=#dddddd
augroup END

syntax on

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" ウインドウを閉じずにバッファのみ閉じる
command! Bd :bp | :sp | :bn | :bd

" enable Alt + char mappings
if !has('gui_running')
  map n <A-n>
  map a <A-a>
  map j <A-j>
  map k <A-k>
endif

" gtags settings
map <F2> :cclose<CR>
map <F4> :copen<CR>
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

"File
set hidden

"Backup
call system('mkdir -p $HOME/dotfiles/.vim/backup')
set backupdir=$HOME/dotfiles/.vim/backup
set browsedir=buffer
set directory=$HOME/dotfiles/.vim/backup
set history=10000

" persistent undo
set undofile
set undodir=~/.vimundo

"Search
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan

"Input
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
set wildmode=list,longest

"空白文字を表示
"http://4geek.net/set-gvims-vimrc-on-windows/
set list "タブ、行末等の不可視文字を表示する
set listchars=tab:»\ ,extends:>,precedes:<,nbsp:%



"インサートモードからノーマルモード切り替え時にIMEを無効化
"入力システムがfcitxである必要がある
"https://qiita.com/hoshitocat/items/a80d613ef73b7a06ec50
function! ImInActivate()
    call system('fcitx-remote -c')
endfunction
inoremap <silent> <ESC> <ESC>:call ImInActivate()<CR>

" ESC to jj
inoremap <silent> jj <ESC>:call ImInActivate()<CR>
" 日本語入力で”っj”と入力してもEnterキーで確定させればインサートモードを抜け、IMEを無効化
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
tnoremap <silent> <C-j> <C-w>:bprev<CR>
tnoremap <silent> <C-k> <C-w>:bnext<CR>

" mouseを使用する
set mouse=a
set ttymouse=sgr

" airlineの設定
set laststatus=2
set showtabline=2 " 常にタブラインを表示
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#anzu#enabled = 1
let g:airline_theme = 'tender'
let g:airline_powerline_fonts = 1
nmap <Space>1 <Plug>AirlineSelectTab1
nmap <Space>2 <Plug>AirlineSelectTab2
nmap <Space>3 <Plug>AirlineSelectTab3
nmap <Space>4 <Plug>AirlineSelectTab4
nmap <Space>5 <Plug>AirlineSelectTab5
nmap <Space>6 <Plug>AirlineSelectTab6
nmap <Space>7 <Plug>AirlineSelectTab7
nmap <Space>8 <Plug>AirlineSelectTab8
nmap <Space>9 <Plug>AirlineSelectTab9

" ctrlp settings
let g:ctrlp_map = '<Space>x'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['GTAGS', 'compile_commands.json', '.git']
let g:ctrlp_show_hidden = 1
"let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_max_height = 40
let g:ctrlp_use_caching = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_key_loop = 1
let g:ctrlp_mruf_exclude = '\.git\|\.svn'
let g:ctrlp_user_command_async = 1
let g:ctrlp_user_command = 'find %s -type d
    \ -name ".git" -prune -o
    \ -name ".svn" -prune -o
    \ -name ".cache" -prune -o
    \ -name ".dropbox" -prune -o
    \ -name ".conda" -prune -o
    \ -name ".eclipse" -prune -o
    \ -name ".clangd" -prune -o
    \ -name ".ccls-cache" -prune -o
    \ -name ".clang-tidy" -prune -o
    \ -type f
    \ -not -name "*.o"
    \ -not -name "*.a"
    \ -not -name "*.d"
    \ -not -name GPATH
    \ -not -name GRTAGS
    \ -not -name GTAGS
    \ -print'

" let g:ctrlp_custom_ignore = {
"   \ 'func': 'CtrlPIgnoreFilter',
"   \ }
" function! CtrlPIgnoreFilter(item, type) abort
"     let l:cnv_item = tr(a:item, "\\", "/")
"     let l:pattern = ['\.git/', '\.svn/', '/\.cache/', '/\.dropbox/', '/\.conda/', '/\.eclipse/', '\.o$', '\.a$', 'GPATH', 'GRTAGS', 'GTAGS']
"     for p in l:pattern
"         if match(l:cnv_item, p) >= 0
"             "echo 'skip = ' l:cnv_item
"             return 1
"         endif
"     endfor
"     return 0
" endfunction

" previewウインドウをひとまず無効化
set completeopt=menuone

" 補完時のキーマッピングを変更(<C-p>, <C-n>を使っても候補が入力されなくする)
inoremap <C-p> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-p>"<CR>
inoremap <C-n> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-n>"<CR>

" vim-quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <F9>     <Plug>(quickhl-manual-toggle)
xmap <F9>     <Plug>(quickhl-manual-toggle)

nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

nmap <Space>j <Plug>(quickhl-cword-toggle)

nmap <Space>] <Plug>(quickhl-tag-toggle)
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
" 空白行を無視する/しない
nmap <leader>w :set diffopt+=iwhiteall<cr>
nmap <leader>W :set diffopt-=iwhiteall<cr>

" ctrlp + memolist
nmap ,mf :exe "CtrlP" g:memolist_path<cr><f5>
nmap ,mc :MemoNew<cr>
nmap ,mg :MemoGrep<cr>

" anzu
nmap n <Plug>(anzu-n)zz
nmap N <Plug>(anzu-N)zz
nmap * <Plug>(anzu-star)zz
nmap # <Plug>(anzu-sharp)zz

" g* 時にステータス情報を出力する場合
nmap g* g*<Plug>(anzu-update-search-status-with-echo)

" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

let airline#extensions#languageclient#error_symbol = 'E:'
let airline#extensions#languageclient#warning_symbol = 'W:'
let airline#extensions#languageclient#show_line_numbers = 1
let airline#extensions#languageclient#open_lnum_symbol = '(L'
let airline#extensions#languageclient#close_lnum_symbol = ')'
let g:airline#extensions#branch#empty_message = 'vcs empty'
let g:airline#extensions#tabline#keymap_ignored_filetypes = ['vimfiler']

if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_symbols.dirty='⚒'

if g:use_coc
    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    if has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
    " position. Coc only does snippet and additional edit on confirm.
    " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
    if exists('*complete_info')
      inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json,c,cpp,rust setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Use CTRL-S for selections ranges.
    " Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Mappings for CoCList
    " Show all diagnostics.
    nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

    nnoremap <silent> <Space>h :call CocAction('doHover')<CR>
    nmap <silent> <Space><Space> <Plug>(coc-definition)
    nmap <silent> <Space>r <Plug>(coc-references)
    nmap <Space><F2> <Plug>(coc-rename)
    nnoremap <silent> <Space>p :LspPeekDefinition<CR>
    nnoremap <silent><nowait> <Space>w  :<C-u>CocList -I symbols<cr>
    nnoremap <silent><nowait> <A-j> :CocCommand document.jumpToNextSymbol<CR>
    nnoremap <silent><nowait> <A-k> :CocCommand document.jumpToPrevSymbol<CR>
    nnoremap <silent> <Space>f :call CocAction('format')<CR>
else
    " vim-lsp
    "let g:lsp_log_verbose = 1
    "let g:lsp_log_file = expand('~/.vim/vim-lsp.log')
    "let g:asyncomplete_log_file = expand('~/.vim/asyncomplete.log')

    let g:lsp_diagnostics_float_cursor = 1
    nnoremap <silent> <Space>h :LspHover<CR>
    nnoremap <silent> <Space><Space> :LspDefinition<CR>
    nnoremap <silent> <Space>r :LspReference<CR>
    nnoremap <silent> <Space><F2> :LspRename<CR>
    nnoremap <silent> <Space>p :LspPeekDefinition<CR>
    nnoremap <silent> <Space>w :LspWorkspaceSymbol<CR>
    nnoremap <silent> <A-j> :LspNextReference<CR>
    nnoremap <silent> <A-k> :LspPreviousReference<CR>
    nnoremap <silent> <Space>f ggVG:'<,'>LspDocumentRangeFormat<CR>
    vnoremap <silent> <Space>f :'<,'>LspDocumentRangeFormat<CR>
    let g:lsp_highlight_references_enabled = 1

    function! AirlineLspSetting()
        let g:airline_section_warning = '⚠ %{lsp#get_buffer_diagnostics_counts()["warning"]}'
        let g:airline_section_error = '✗ %{lsp#get_buffer_diagnostics_counts()["error"]}%{lsp#get_buffer_first_error_line()? "-".lsp#get_buffer_first_error_line():""}'
    endfunction

    let g:lsp_settings = {
    \  'clangd': {
    \    'disabled': v:true,
    \   }
    \}
    if g:use_ccls
        if executable('ccls')
           autocmd User lsp_setup call lsp#register_server({
              \ 'name': 'ccls',
              \ 'cmd': {server_info->['ccls']},
              \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
              \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }},
              \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
              \ })
        endif
        let g:ccls_levels = 2
    else
        if executable('clangd')
            autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->['clangd', '--header-insertion-decorators']},
                \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
                \ 'whitelist': ['c', 'cpp'],
                \ })
        endif
    endif

    augroup cproject
        autocmd!
        autocmd BufRead,BufNewFile *.h,*.c set filetype=c
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType c setlocal cindent
        autocmd FileType c call AirlineLspSetting()
        autocmd FileType c nmap <Space>s <plug>(lsp-clangd-switch)
    augroup END

    if executable('typescript-language-server')
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'typescript-language-server',
            \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
            \ 'whitelist': ['javascript', 'typescript'],
            \ })
        autocmd FileType typescript imap <expr> . ".\<C-X>\<C-O>"
        autocmd FileType typescript imap <expr> : ":\<C-X>\<C-O>"
    endif
    augroup typescriptproject
        autocmd!
        autocmd FileType typescript setlocal omnifunc=lsp#complete
        autocmd FileType typescript setlocal iskeyword=@,48-57,_,192-255
        autocmd FileType typescript call AirlineLspSetting()
    augroup END

    if executable('rls')
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'rls',
            \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
            \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
            \ 'whitelist': ['rust'],
            \ })
    endif
    augroup rustproject
        autocmd!
        autocmd FileType rust setlocal omnifunc=lsp#complete
        autocmd FileType rust call AirlineLspSetting()
    augroup END

    if executable('vscode-html-languageserver')
      au User lsp_setup call lsp#register_server({
        \ 'name': 'html-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'vscode-html-languageserver --stdio']},
        \ 'initialization_options': {"provideFormatter": v:true, "embeddedLanguages": ["html"]},
        \ 'whitelist': ['html'],
        \ })
    endif
    augroup htmlproject
        autocmd!
        autocmd FileType html setlocal omnifunc=lsp#complete
        autocmd FileType html call AirlineLspSetting()
    augroup END

    if executable('vscode-json-languageserver')
      au User lsp_setup call lsp#register_server({
        \ 'name': 'json-languageserver',
        \ 'initialization_options': {"provideFormatter": v:true},
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'vscode-json-languageserver --stdio']},
        \ 'whitelist': ['json'],
        \ })
    endif
    augroup jsonproject
        autocmd!
        autocmd FileType json setlocal omnifunc=lsp#complete
        autocmd FileType json call AirlineLspSetting()
    augroup END

    augroup lsp_float_colours
        autocmd!
        autocmd User lsp_float_opened
            \ call win_execute(lsp#ui#vim#output#getpreviewwinid(),
            \		       'setlocal wincolor=PopupWindow')
    augroup end
endif

" mapの一覧をファイル出力
function! MapList()
    redir! > ~/vim_keys.txt
    silent verbose map
    redir END
endfunction

" 検索ヒット数と今の位置を表示する
set shortmess-=S

" vim-ccls(yggdrasil)
let g:yggdrasil_no_default_maps = 1
autocmd FileType yggdrasil nmap <silent> <buffer> o <Plug>(yggdrasil-toggle-node)
autocmd FileType yggdrasil nmap <silent> <buffer> O <Plug>(yggdrasil-open-subtree)
autocmd FileType yggdrasil nmap <silent> <buffer> C <Plug>(yggdrasil-close-subtree)
autocmd FileType yggdrasil nmap <silent> <buffer> <cr> <Plug>(yggdrasil-execute-node)
autocmd FileType yggdrasil nnoremap <silent> <buffer> q :q<cr>

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<A-n>'
let g:multi_cursor_select_all_word_key = '<A-a>'
let g:multi_cursor_start_key           = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<A-a>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<C-[>'

" vim-dirdiff
let g:DirDiffForceLang = "C LC_ALL=C"
let g:DirDiffExcludes = "*.o,*.a,*.swp,.git,.svn,GPATH,GRTAGS,GTAGS"
augroup dirdiffgroup
    autocmd!
augroup END

" vim-fugitive
let g:fugitive_no_maps = 1
augroup fugitivegroup
    autocmd!
    autocmd FileType git set nofoldenable
augroup END
  let g:airline#extensions#fugitiveline#enabled = 0

let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
    for mode in [ "inactive", "insert", "normal", "replace", "visual",]
        let a:palette[mode]['airline_warning'] = [ '#000000', '#ffd700', 232, 166 ]
        let a:palette[mode]['airline_error'] = [ '#000000', '#ff4500', 232, 160 ]
    endfor
endfunction

packadd termdebug

" Sourcetrailの設定
let g:sourcetrail_autostart = 1
let g:sourcetrail_ip = "localhost"
let g:sourcetrail_to_vim_port = 6666
let g:vim_to_sourcetrail_port = 6667

" spelunker
let g:spelunker_check_type = 2
let g:ctrlp_extensions = get(g:, 'ctrlp_extensions', [])
      \ + ['spelunker']"

runtime ftplugin/man.vim
augroup manpage
    autocmd!
    autocmd FileType man set tabstop=8
    autocmd FileType man set nolist
augroup END

" fern
"let g:fern#logfile = '~/fern.tsv'
"let g:fern#loglevel = g:fern#DEBUG
nnoremap <silent> <leader><leader> :Fern . -drawer -toggle -keep -reveal=%<cr>
nnoremap <silent> <leader>. :Fern . -drawer -toggle -keep<cr>

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

function! s:init_fern() abort
  nmap <buffer> k k<Plug>(fern-action-mark:toggle)
  nmap <buffer> j <Plug>(fern-action-mark:toggle)j
  " disable spelunker
  let b:enable_spelunker_vim = 0
endfunction

let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1
let g:fern_git_status#disable_ignored = 1

nmap <Space>g <Plug>(fern-action-grep)

" vista
let g:vista_default_executive = 'vim_lsp'
" vistaで関数名をairlineに表示する際の更新頻度を上げる
set updatetime=300
"let g:vista_log_file = '/tmp/vista.log'

" 関数名をairlineに表示するために一度Vistaを有効化する
" ctagsではこの動作は不要だったのでもしかしたらVistaのバグかもしれないが
" そもそもvim-lspで関数名をairlineに表示する機能が現状だと未サポートなので
" ひとまず回避しておく
func EnableAirlineFunctionNameHandler(timer)
  execute "Vista"
  sleep 100m
  execute "Vista!"
  call timer_stop(a:timer)
endfunc
func EnableAirlineFunctionName()
  let timer = timer_start(1000, 'EnableAirlineFunctionNameHandler')
endfunc
augroup enable_airline_function_name
    autocmd!
    autocmd FileType typescript,json,c,cpp,rust,vim call EnableAirlineFunctionName()
augroup END
