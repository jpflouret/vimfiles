set nocompatible
execute pathogen#infect()

" Colorscheme {{{1
set background=dark
colorscheme hybrid


" GUI and font settings {{{1
" GUI Options (applied only once) {{{2
if !exists('gui_initialized')
  let gui_initialized=0
endif
if has('gui_running') && !gui_initialized
  set lines=60 columns=200
  set guioptions=aAcemg
  let gui_initialized=1
endif

" Font {{{2
" To make the powerline look good, install fonts from
" https://github.com/Lokaltog/powerline-fonts/
" or the patched windows fonts from
" https://github.com/daagar/powerline-fonts
if has('win32')
  set guifont=Droid_Sans_Mono_for_Powerline:h10,Droid_Sans_Mono:h10,Lucida_console:h10
elseif has('gui_gtk2')
  set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 10,Droid\ Sans\ Mono\ 10
endif

" Run vim-sensible now so that we can override the settings {{{1
runtime! plugin/sensible.vim

" Options {{{1
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
set mouse=nvc
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

" Plugin configuration {{{1
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
let g:gundo_close_on_revert=1

if has('win32')
  let g:tagbar_ctags_bin='d:\tools\ctags58\ctags.exe'
endif

if has('unix')
  let g:netrw_browsex_viewer='gnome-open'
endif

if has('gui_running')
  let g:airline_powerline_fonts=(&guifont =~ 'Powerline')
else
  if !(&term == 'linux')
    " This assumes that the terminal is configured with the proper powerline fonts
    " This would need to be set in the terminal emulator or in the default system font
    let g:airline_powerline_fonts=1
  endif
endif

" Syntax and file type detection {{{1
if &t_Co > 2 || has('gui_running')
  syntax on
endif
if has('autocmd')
  filetype plugin indent on
endif

" Auxiliary functions {{{1

" Delete an empty line also when hitting delete {{{2
nnoremap <silent> <DEL> :call <SID>DeleteOrDeleteLine()<CR>
function! <SID>DeleteOrDeleteLine()
  if getline('.') =~ '^$'
    delete _
  else
    execute 'normal! \<DEL>'
  endif
endfunction


" Deletes a line above the current line if it is empty {{{2
" function! <SID>DeleteEmptyLineAbove()
"   let lineAbove = line('.')-1
"   if getline(lineAbove) =~ '^\s*$'
"     exe lineAbove . ' delete _'
"   endif
" endfunction


" Cleans up all trailing whitespace and retabs the file {{{2
command! Cleanup call <SID>CleanupFile()
function! <SID>CleanupFile()
  %s/\s\+$//ge
  retab
endfunction


" Open the alternate buffer of the next file {{{2
noremap <silent> <C-^> :call <SID>AlternateOrNext()<CR>
function! <SID>AlternateOrNext()
  if expand('#')=='' | silent! next
  else
    exe 'normal! \<c-^>'
  endif
endfunction


" Show syntax highlight stack {{{2
command! SynStack call <SID>SynStack()
function! <SID>SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, 'name')')
endfunc


" Populate the argslist from the qflist {{{2
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction


" Folding configuration {{{1
" Fold options {{{2
set foldcolumn=3
set foldtext=GetFoldText()

" Enable syntax folding for c++ and python
if has('autocmd')
  autocmd Syntax python setlocal foldmethod=indent
  autocmd Syntax c,cpp setlocal foldmethod=syntax
  autocmd Syntax c,cpp,python normal zR
endif

" Show the fold text first before the number of lines {{{2
function! GetFoldText()
  let foldsize=v:foldend-v:foldstart
  return getline(v:foldstart).'  [... '.foldsize.' more lines]'
endfunction


" Configure grep to be qgrep {{{1
if has('win32') " I don't have qgrep working on linux yet
  set grepprg=qgrep
  command! -nargs=1 Qgrep :execute 'silent grep! search '.g:QGREP_PROJ.' '.<q-args>
  nnoremap <silent>   <Leader>g     :Qgrep <cword><CR>
endif


" Key mappings {{{1
" vimrc {{{2
nnoremap <silent> <Leader>v :e $MYVIMRC<CR>
nnoremap <silent> <Leader>p :source $MYVIMRC<CR>

" Window manipulation {{{2
nnoremap <silent> <Leader>q :Bdelete<CR>
nnoremap <silent> <Leader>bd :Bdelete<CR>
nnoremap <silent> <Leader>a :A<CR>
nnoremap <silent> <C-S> :update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
noremap <silent> <C-TAB> :bnext<CR>
noremap <silent> <S-C-TAB> :bprev<CR>
noremap <silent> <C-F6> :bnext<CR>
noremap <silent> <C-F4> :Bdelete<CR>

" Function keys {{{2
nnoremap <silent> <F2> :Tagbar<CR>
nnoremap <silent> <F3> :set hlsearch!<CR>
nnoremap <silent> <F4> :GundoToggle<CR>
"nnoremap <silent> <F5> :LookupFile<CR> " this is the default
nnoremap <silent> <F8> :YRShow<CR>

" Control-Backspace deletes a word {{{2
inoremap <C-BS> <C-W>
cnoremap <C-BS> <C-W>

" Open files with path relative to current file {{{2
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Folding with <Space> {{{2
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'\<Space>')<CR>
vnoremap <Space> zf

" Use C-Arrow for window navigation {{{2
nnoremap <silent> <C-Up> <C-W>k
nnoremap <silent> <C-Down> <C-W>j
nnoremap <silent> <C-Left> <C-W>h
nnoremap <silent> <C-Right> <C-W>l

" Disable the arrows so you learn vim the hard way {{{2
inoremap           <Up>          <NOP>
inoremap           <Down>        <NOP>
inoremap           <Left>        <NOP>
inoremap           <Right>       <NOP>
noremap            <Up>          <NOP>
noremap            <Down>        <NOP>
noremap            <Left>        <NOP>
noremap            <Right>       <NOP>


" cscope mappings {{{2
nmap <C-\>s :cs find s <C-R>=expand('<cword>')<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand('<cword>')<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand('<cword>')<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand('<cword>')<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand('<cword>')<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand('<cfile>')<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand('<cfile>')<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand('<cword>')<CR><CR>

" Using 'CTRL-spacebar' then a search type makes the vim window
" split horizontally, with search result displayed in
" the new window.
nmap <C-Space>s :scs find s <C-R>=expand('<cword>')<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand('<cword>')<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand('<cword>')<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand('<cword>')<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand('<cword>')<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand('<cfile>')<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand('<cfile>')<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand('<cword>')<CR><CR>


" Text bubbling {{{2
" Bubble single lines
nmap <S-Up> [e
nmap <S-Down> ]e
" Bubble multiple lines {{{2
vmap <S-Up> [egv
vmap <S-Down> ]egv

" clang-format {{{2
if (has('unix'))
  "Mappings for clang-format-3.5 under ubuntu....
  map  <silent> <C-K> :pyf      /usr/share/vim/addons/syntax/clang-format-3.5.py<CR>
  imap <silent> <C-K> <ESC>:pyf /usr/share/vim/addons/syntax/clang-format-3.5.py<CR>i
else
  map  <silent> <C-K> :pyf      d:/tools/clang-format.py<CR>
  imap <silent> <C-K> <ESC>:pyf d:/tools/clang-format.py<CR>i
endif

" Auto commands {{{1
if has('autocmd')
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

    " Auto cleanup of vim-fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
  augroup END
end
"}}}

" vim:ts=2:sw=2:tw=100:et:fdm=marker:fdc=3:
