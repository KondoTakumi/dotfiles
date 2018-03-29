" vimの設定"{{{
set modifiable
set fenc=utf-8
" vi互換の動作を無効にするコマンド
set nocompatible
" インデント
filetype indent on
" これやらないとcaw.vimが動かない
filetype plugin on
" バックスペースは行末は消去不可
set bs=indent,eol,start
" 履歴情報を保存するviminfoを作成
set viminfo='20,\"50
" コマンドの履歴数を50に設定
set history=50
" 保存されていないファイルがあるときは終了前に保存確認
set confirm
" 保存されていないファイルがある時でも別ファイルを開けるようにする
set hidden
" 入力中のコマンドを表示
set showcmd
" 行を表示
set number
" カーソルラインを表示
set cursorline
" 括弧をハイライト
set showmatch
" 折り畳み
set foldmethod=marker
" ステータス表示とか
set laststatus=2
set statusline=%<%f
set statusline+=\ %m
set statusline+=[%{&fileencoding}:%{&ff}]%y
set statusline+=%=
set statusline+=%c,%l\ /%L\ %p%%
" 検索結果をハイライト
set hlsearch
" 不可視文字の表示と設定
set list
set listchars=tab:>-,eol:$,trail:-
" tab設定
set shiftwidth=2
set tabstop=2
set expandtab
" インクリメンタルサーチ
set incsearch
" 行末まで検索したら先頭に戻る
set wrapscan
" インデント
set autoindent
" 上下1行の視界を確保
set scrolloff=1
" マウス無効
set mouse-=a

set completeopt=menuone

set clipboard&
set clipboard^=unnamedplus

set spell

" 前回の編集場所から開始できる(rootのvimrcからパクってきたからよくわからん)
if has("autocmd")
  augroup nyan
  autocmd!
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

" cscopeっていう凄いものの設定(/etc/vimrcからのパクり)
if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   if filereadable("cscope.out")
      cs add $pwd/cscope.out
   elseif $cscope_db != ""
      cs add $cscope_db
   endif
   set csverb
endif
" }}}

" プラグインマネージャ"{{{
" プラグインがインストールされるディレクトリ
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
  " 予め TOML ファイルを用意しておく
  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#add("wesleyche/SrcExpl",{
              \"autoload":{"commands":["SrcExplToggle"]}})
  call dein#add('Shougo/deoppet.nvim')
  " 設定終了
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#end()
  call dein#save_state()
endif
" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif
" }}}

" 自作関数宣言{{{
" IMEを切り換える関数
function ToggleIbusEngine(mode)
  if a:mode=='x'
      call system('ibus engine "xkb:jp::jpn"')
  elseif a:mode=='k'
      call system('ibus engine "kkc"')
  else
    if split(system('ibus engine'))[0]=="kkc"
      call system('ibus engine "xkb:jp::jpn"')
    else
      call system('ibus engine "kkc"')
    endif
  endif
endfunction
" }}}

" コマンド宣言{{{
command Run call myfunction#Run()
command CT call myfunction#CT()
command VT call myfunction#Vterminal()
command ST call myfunction#Sterminal()
command Terminal call myfunction#Terminal()
command Sc call myfunction#Sc()
command Nsc call myfunction#Nsc()
" }}}

" autocmdとか{{{
augroup IMEGroup
  autocmd!
  autocmd InsertLeave * :call ToggleIbusEngine('x')
augroup END

if has('nvim')
" Terminalのときは行番号とスペルチェックをなしにする
  autocmd TermOpen * set nonumber | set nospell
  autocmd TermClose * set number | set spell
endif
" }}}

" プラグインに関する設定{{{
set t_Co=256
syntax on
colorscheme jellybeans

let tlist_php_settings='php;c:class;d:constant;f:function'

autocmd BufRead,BufNewFile *.md set filetype=markdown

if filereadable(expand('~/.config/nvim/token.vim'))
  source ~/.config/nvim/token.vim
endif

let twitvim_enable_python3 = 1

let g:syntaxCheck=0

call gina#custom#command#alias('status', 'st')
call gina#custom#command#option('st','-s')
call gina#custom#command#option('st','--opener','split')

" }}}

" キー設定{{{
" 自作関数のマッピングとか
cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>
noremap <silent> <C-c> <C-c>:call ToggleIbusEngine('x')<CR>
cnoremap <silent> <C-c> <C-c>:call ToggleIbusEngine('x')<CR>
inoremap <silent> <C-c> <C-c>:call ToggleIbusEngine('x')<CR>

noremap <C-l> <ESC><ESC>:call myfunction#Run()<CR>
noremap! <C-l> <ESC><ESC>:call myfunction#Run()<CR>

noremap <C-s> <ESC><ESC>:call myfunction#Format()<CR>
noremap! <C-s> <ESC><ESC>:call myfunction#Format()<CR>

noremap <A-o> :on<CR>

noremap <A-p> gt<CR>
noremap <A-n> gT<CR>
noremap <A-o> :tabonly<CR>
noremap <A-t><CR> :tabedit<CR>:Startify<CR>

map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

nmap s <Plug>(easymotion-overwin-f2)
vmap s <Plug>(easymotion-bd-f2)

noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l
noremap <A-+> <C-w>+
noremap <A--> <C-w>-
noremap <A-,> <C-w><
noremap <A-.> <C-w>>

noremap <C-]> g<C-]>

noremap <silent> gb :Denite buffer<CR>

inoremap <expr> = smartchr#loop(' = ',' == ', '=')

inoremap <expr> , smartchr#loop(', ',',')

tnoremap <ESC> <C-\><C-n>
" }}}
