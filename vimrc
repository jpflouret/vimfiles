set nocompatible
if has('eval')
  silent! execute pathogen#infect()
endif

" Colorscheme {{{1
if has('syntax')
  set background=dark
  "silent! colorscheme hybrid
endif


" GUI and font settings {{{1
" GUI Options (applied only once) {{{2
if !exists('gui_initialized')
  let gui_initialized=0
endif
if has('gui_running') && !gui_initialized
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

" if !exists('g:loaded_editexisting')
"   let g:loaded_editexisting = 1
"   runtime! macros/editexisting.vim
" endif

" Options {{{1
set sessionoptions+=resize,winpos
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
if has('mouse')
  set mouse=nvc
endif
set mousehide
set shortmess=a
set hidden
set number
set cmdheight=2
set laststatus=2
set hlsearch
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
" set textwidth=120
set nowildmenu

" Plugin configuration {{{1
if has('eval')
  let c_space_errors=1
  let g:airline#extensions#tabline#enabled=1
  let g:ctrlp_root_markers=['.p4config', '.clang-format', '.project']
  let g:LookupFile_DisableDefaultMap=0
  let g:LookupFile_EnableRemapCmd=0
  let g:LookupFile_PreserveLastPattern=0
  let g:LookupFile_AllowNewFiles=0
  let g:LookupFile_smartcase=1
  let g:LookupFile_SearchForBufsInTabs=1
  let g:LookupFile_UsingSpecializedTag=1
  let g:LookupFile_TagExpr='findfile("filenametags", ",;")'
  let g:gundo_close_on_revert=1
  let g:UltiSnipsNoPythonWarning=1

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

endif

" Syntax and file type detection {{{1
if has('syntax') && (&t_Co > 2 || has('gui_running'))
  syntax on
endif
if has('autocmd')
  filetype plugin indent on
endif

" Auxiliary functions {{{1
" Cleans up all trailing whitespace and retabs the file {{{2
if has('eval')
  command! Cleanup call <SID>CleanupFile()
  function! <SID>CleanupFile()
    %s/\s\+$//ge
    retab
  endfunction
endif


" Show syntax highlight stack {{{2
if has('eval')
  command! SynStack call <SID>SynStack()
  function! <SID>SynStack()
    if !exists('*synstack')
      return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunction
endif


" Populate the argslist from the qflist {{{2
if has('eval')
  command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
  function! QuickfixFilenames()
    " Building a hash ensures we get each buffer only once
    let buffer_numbers = {}
    for quickfix_item in getqflist()
      let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
  endfunction
endif


" Visual star search from vimcasts.org {{{2
if has('eval')
  function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
endif


" From vimrc_example.vim
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if has('eval') && !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif


" Folding configuration {{{1
" Fold options {{{2
if has('eval') && has('folding')
  set foldcolumn=3
  set foldtext=GetFoldText()
  set foldlevelstart=99
endif

" Enable syntax folding for c++ and python {{{2
if has('autocmd')
  augroup vimrc_fold
    autocmd!
    autocmd Syntax python setlocal foldmethod=indent
    autocmd Syntax c,cpp setlocal foldmethod=syntax
  augroup END
endif

" Show the fold text first before the number of lines {{{2
if has('eval') && has('folding')
  function! GetFoldText()
    let w = &textwidth
    if w <= 0
      let w = winwidth(0) - &numberwidth - &foldcolumn
    endif
    let foldsize=v:foldend-v:foldstart
    let text=getline(v:foldstart)
    let follow=' ['.foldsize.' lines]'
    let padlen=w-(strlen(text)+strlen(follow))
    if (padlen<0)
      let padlen = 0
    endif
    return text . repeat(' ', padlen) . follow
  endfunction
endif


" Key mappings {{{1
" Manipulate .vimrc {{{2
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
nnoremap <silent> <F3> :nohlsearch<CR>
nnoremap <silent> <F4> :GundoToggle<CR>
" nnoremap <silent> <F5> <VDebug>
nnoremap <silent> <F6> :LookupFile<CR>

" Control-Backspace deletes a word {{{2
inoremap <C-BS> <C-W>
cnoremap <C-BS> <C-W>

" Control-Space does the same as C-N
noremap  <silent> <Nul>     <Nop>
inoremap <silent> <Nul>     <C-N>
vnoremap <silent> <Nul>     <Nop>
cnoremap <silent> <Nul>     <Nop>
nnoremap <silent> <Nul>     <Nop>
inoremap <silent> <C-Space> <C-N>

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
"inoremap           <Up>          <NOP>
"inoremap           <Down>        <NOP>
"inoremap           <Left>        <NOP>
"inoremap           <Right>       <NOP>
"noremap            <Up>          <NOP>
"noremap            <Down>        <NOP>
"noremap            <Left>        <NOP>
"noremap            <Right>       <NOP>


" cscope mappings {{{2
" nmap <C-\>s :cs find s <C-R>=expand('<cword>')<CR><CR>
" nmap <C-\>g :cs find g <C-R>=expand('<cword>')<CR><CR>
" nmap <C-\>c :cs find c <C-R>=expand('<cword>')<CR><CR>
" nmap <C-\>t :cs find t <C-R>=expand('<cword>')<CR><CR>
" nmap <C-\>e :cs find e <C-R>=expand('<cword>')<CR><CR>
" nmap <C-\>f :cs find f <C-R>=expand('<cfile>')<CR><CR>
" nmap <C-\>i :cs find i ^<C-R>=expand('<cfile>')<CR>$<CR>
" nmap <C-\>d :cs find d <C-R>=expand('<cword>')<CR><CR>

" Using 'CTRL-spacebar' then a search type makes the vim window
" split horizontally, with search result displayed in
" the new window.
" nmap <C-Space>s :scs find s <C-R>=expand('<cword>')<CR><CR>
" nmap <C-Space>g :scs find g <C-R>=expand('<cword>')<CR><CR>
" nmap <C-Space>c :scs find c <C-R>=expand('<cword>')<CR><CR>
" nmap <C-Space>t :scs find t <C-R>=expand('<cword>')<CR><CR>
" nmap <C-Space>e :scs find e <C-R>=expand('<cword>')<CR><CR>
" nmap <C-Space>f :scs find f <C-R>=expand('<cfile>')<CR><CR>
" nmap <C-Space>i :scs find i ^<C-R>=expand('<cfile>')<CR>$<CR>
" nmap <C-Space>d :scs find d <C-R>=expand('<cword>')<CR><CR>


" Text bubbling {{{2
" Bubble single lines
nmap <S-Up> [e
nmap <S-Down> ]e
" Bubble multiple lines {{{2
vmap <S-Up> [egv
vmap <S-Down> ]egv

" clang-format {{{2
if has('unix') && has('python')
  "Mappings for clang-format-3.5 under ubuntu....
  map  <silent> <C-K> :pyf      /usr/share/vim/addons/syntax/clang-format-3.5.py<CR>
  imap <silent> <C-K> <ESC>:pyf /usr/share/vim/addons/syntax/clang-format-3.5.py<CR>i
else
  map  <silent> <C-K> :pyf      C:\Program\ Files\ (x86)\LLVM\share\clang\clang-format.py<CR>
  imap <silent> <C-K> <ESC>:pyf C:\Program\ Files\ (x86)\LLVM\share\clang\clang-format.py<CR>i
endif

" Auto commands {{{1
if has('autocmd')
  augroup vimrc
    autocmd!

    " Change formatoptions regardless of filetype
    autocmd FileType * setlocal formatoptions-=o

    " Use C++ style comments in C++
    autocmd FileType c,cpp let b:commentary_format="//%s"

    " Set tw=78 on text files
    autocmd FileType markdown setlocal tw=78 spell

    " Git commit tw=72
    autocmd FileType gitcommit setlocal textwidth=72 spell

    " K looks up help in .vim files instead of running man
    autocmd FileType vim  nmap K :help <c-r><c-w><cr>

    autocmd FileType bindzone setlocal ts=8 sw=8

    " Auto open qf window after grep
    autocmd QuickFixCmdPost [^l]*grep*  cwindow
    autocmd QuickFixCmdPost l*grep*     lwindow

    " Restore line position
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

    " Auto cleanup of vim-fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete

    " Change directory to file path for each buffer
    autocmd BufEnter,BufReadPost * silent! lcd %:p:h

    " Set .md files to ft=markdown
    autocmd BufNewFile,BufRead *.md set filetype=markdown

    " Automatically create a session to save window position
    " autocmd VIMEnter * :silent! source ~/.session.vim
    " autocmd VIMLeave * :mksession! ~/.session.vim

  augroup END
end
"}}}

" Load local config file {{{1
if has('eval')
  let s:vimrc_local = expand("<sfile>:p:r")."_local"
  if filereadable(s:vimrc_local)
    exe "source " . fnameescape(s:vimrc_local)
  endif
  if has('gui_running')
    let s:vimrc_local_gui = expand("<sfile>:p:r")."_local_gui"
    if filereadable(s:vimrc_local_gui)
      exe "source " . fnameescape(s:vimrc_local_gui)
    endif
  endif
endif
"}}}

" vim:ts=2:sw=2:tw=100:et:fdm=marker:fdc=3:ft=vim:
