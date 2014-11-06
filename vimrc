" vim: set ts=2 sw=2 tw=100 et :

execute pathogen#infect()

set background=dark
colorscheme hybrid

if !exists('gui_initialized')
  let gui_initialized=0
endif

if has("gui_running") && !gui_initialized
  set lines=60 columns=200
  set guioptions=aAcemg
  let gui_initialized=1
endif

" Run vim-sensible now so that we can override the settings
runtime! plugin/sensible.vim

scriptencoding utf-8
set encoding=utf-8
set autoread
set modeline
set history=1000
set tabstop=4
set shiftwidth=4
set expandtab
set list
set listchars=tab:»\ ,trail:·,eol:¬,extends:>,precedes:<,nbsp:+
set mouse=a
set mousehide
set shortmess=a
set hidden
set number
set cmdheight=2
set laststatus=2
set nohlsearch
set incsearch
set ignorecase
set smartcase
set cinoptions=:0,g0,t0,(0,w1,W4
set fileformats=unix,dos,mac
set switchbuf=useopen
set mousemodel=popup_setpos
set whichwrap=b,s,<,>,~,[,]
set nowrap
set backspace=indent,eol,start
set nospell
set diffopt=filler,vertical
set colorcolumn=+1
set textwidth=120
set nowildmenu

let c_space_errors=1
let g:yankring_replace_n_pkey='<Leader>.'
let g:yankring_replace_n_nkey='<Leader>,'
let g:yankring_persist=0 "disabled for privacy
let g:airline#extensions#tabline#enabled=1
let g:ctrlp_root_markers=['.p4config', '.clang-format', '.project']
let g:SuperTabMappingForward='<C-SPACE>'
let g:SuperTabMappingBackward='<S-C-SPACE>'
let g:LookupFile_DisableDefaultMap=0
let g:LookupFile_EnableRemapCmd=0
let g:LookupFile_PreserveLastPattern=0
let g:LookupFile_AllowNewFiles=0
let g:LookupFile_smartcase=1
let g:LookupFile_SearchForBufsInTabs=1
let g:LookupFile_UsingSpecializedTag=1
let g:LookupFile_TagExpr=string('./filenametags')

if has('win32')
  let g:tagbar_ctags_bin='d:\tools\ctags58\ctags.exe'
endif

" To make the powerline look good, install fonts from
" https://github.com/Lokaltog/powerline-fonts/
" or the patched windows fonts from
" https://github.com/daagar/powerline-fonts
if has('win32')
  set guifont=Droid_Sans_Mono_for_Powerline:h10,Droid_Sans_Mono:h10,Lucida_console:h10
elseif has('gui_gtk2')
  set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 10,Droid\ Sans\ Mono\ 10
endif

if has('gui_running')
  let g:airline_powerline_fonts=(&guifont =~ "Powerline")
else
  if !(&term == 'linux')
    " This assumes that the terminal is configured with the proper powerline fonts
    " This would need to be set in the terminal emulator or in the default system font
    let g:airline_powerline_fonts=1
  endif
endif

syntax on
filetype plugin indent on


" Delete an empte line also when hitting delete
nnoremap <silent> <DEL> :call <SID>DeleteOrDeleteLine()<CR>
function! <SID>DeleteOrDeleteLine()
  if getline('.') =~ '^$'
    delete _
  else
    execute "normal! \<DEL>"
  endif
endfunction


" Deletes a line above the current line if it is empty
nnoremap <silent> <S-UP> :call <SID>DeleteEmptyLineAbove()<CR>
function! <SID>DeleteEmptyLineAbove()
  let lineAbove = line('.')-1
  if getline(lineAbove) =~ '^\s*$'
    exe lineAbove . " delete _"
  endif
endfunction


" Cleans up all trailing whitespace and retabs the file
command! Cleanup call <SID>CleanupFile()
function! <SID>CleanupFile()
  %s/\s\+$//ge
  retab
endfunction


" Open the alternate buffer of the next file
noremap <silent> <C-^> :call <SID>AlternateOrNext()<CR>
function! <SID>AlternateOrNext()
  if expand('#')=="" | silent! next
  else
    exe "normal! \<c-^>"
  endif
endfunction


command SynStack call <SID>SynStack()
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


if has('win32') " I don't have qgrep working on linux yet
  set grepprg=qgrep
  command! -nargs=1 Qgrep :execute 'silent grep! search '.g:QGREP_PROJ.' '.<q-args>
  nnoremap <silent>   <Leader>g     :Qgrep <cword><CR>
endif


noremap             <Leader>*     :s/\(\s\+\)\*\(\s*\)/*\1\2/g<CR>
nnoremap            <Leader>v     :tabe $MYVIMRC<CR>
nnoremap            <Leader>p     :source $MYVIMRC<CR>
nnoremap            <C-S>         :update<CR>
inoremap            <C-S>         <C-O>:update<CR>
inoremap            <C-BS>        <C-W>
cnoremap            <C-BS>        <C-W>
nnoremap            <F3>          :set hlsearch!<CR>
nnoremap            <S-DOWN>      O<ESC>j
nnoremap            <C-DOWN>      <C-E>
nnoremap            <C-UP>        <C-Y>
inoremap            <C-DOWN>      <C-O><C-E>
inoremap            <C-UP>        <C-O><C-Y>
noremap <silent>    <C-TAB>       :bnext<CR>
noremap <silent>    <S-C-TAB>     :bprev<CR>
noremap <silent>    <C-F6>        :bnext<CR>
noremap <silent>    <C-F4>        :Bdelete<CR>
nnoremap <silent>   <Leader>q     :Bdelete<CR>
nnoremap <silent>   <Leader>bd    :Bdelete<CR>
nnoremap <silent>   <F8>          :Tagbar<CR>
nnoremap <silent>   <F9>          :YRShow<CR>
nnoremap <silent>   <Leader>a     :A<CR>

cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Folding with <Space>
nnoremap <silent>   <SPACE>       @=(foldlevel('.')?'za':"\<SPACE>")<CR>
vnoremap            <SPACE>       zf

" Make navigation with arrows similar to Windows
nnoremap <silent>   <C-LEFT>      b
vnoremap <silent>   <C-LEFT>      b
inoremap <silent>   <C-LEFT>      <C-O>b
nnoremap <silent>   <C-RIGHT>     w
vnoremap <silent>   <C-RIGHT>     w
inoremap <silent>   <C-RIGHT>     <C-O>w

" Disable the arrows so you learn vim the hard way?
"inoremap           <Up>          <NOP>
"inoremap           <Down>        <NOP>
"inoremap           <Left>        <NOP>
"inoremap           <Right>       <NOP>
"noremap            <Up>          <NOP>
"noremap            <Down>        <NOP>
"noremap            <Left>        <NOP>
"noremap            <Right>       <NOP>


" cscope mappings

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" Using 'CTRL-spacebar' then a search type makes the vim window
" split horizontally, with search result displayed in
" the new window.

nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>


" Maybe these need to be moved to a per-machine vimrc?
if (has('unix'))
  "Mappings for clang-format-3.5 under ubuntu....
  map  <silent> <C-K> :pyf      /usr/share/vim/addons/syntax/clang-format-3.5.py<CR>
  imap <silent> <C-K> <ESC>:pyf /usr/share/vim/addons/syntax/clang-format-3.5.py<CR>i
else
  map  <silent> <C-K> :pyf      d:/tools/clang-format.py<CR>
  imap <silent> <C-K> <ESC>:pyf d:/tools/clang-format.py<CR>i
endif

augroup vimrc
  autocmd!

  " Maximize the window on Windows
  if (has('win32'))
    autocmd GUIEnter * simalt ~x
  endif

  " Change formatoptions regardless of filetype
  autocmd FileType * setlocal formatoptions-=o

  " Auto open qf window after grep
  autocmd QuickFixCmdPost [^l]*grep*  cwindow
  autocmd QuickFixCmdPost l*grep*     lwindow

  " Restore line position
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " K looks up help in .vim files instead of running man
  autocmd FileType vim  nmap K  :help <c-r><c-w><cr>
augroup END
