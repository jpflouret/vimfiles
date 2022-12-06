set nocompatible
if has('eval')
  silent! execute pathogen#infect()
endif

" GUI and font settings
" GUI Options (applied only once)
if !exists('gui_initialized')
  let gui_initialized=0
endif
if has('gui_running') && !gui_initialized
  set guioptions=aAcemg
  let gui_initialized=1
endif

" Run vim-sensible now so that we can override the settings
runtime! plugin/sensible.vim

" Options
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
" set number
set nofoldenable
set cmdheight=1
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

" Plugin configuration
if has('eval')
  let c_space_errors=1
  let g:airline#extensions#tabline#enabled=1
  let g:camelcasemotion_key = '<leader>'
  let g:bufExplorerVersionWarn=0
endif

" Syntax and file type detection
if has('syntax') && (&t_Co > 2 || has('gui_running'))
  syntax on
endif
if has('autocmd')
  filetype plugin indent on
endif

" Auxiliary functions
" Cleans up all trailing whitespace and retabs the file
if has('eval')
  command! Cleanup call <SID>CleanupFile()
  function! <SID>CleanupFile()
    %s/\s\+$//ge
    retab
  endfunction
endif


" From vimrc_example.vim
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if has('eval') && !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif


" Key mappings
" Manipulate .vimrc
nnoremap <silent> <Leader>v :e $MYVIMRC<CR>
nnoremap <silent> <Leader>p :source $MYVIMRC<CR>

" Window manipulation
nnoremap <silent> <Leader>q :Bdelete<CR>
nnoremap <silent> <Leader>bd :Bdelete<CR>
nnoremap <silent> <Leader>a :A<CR>
nnoremap <silent> <C-S> :update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
noremap <silent> <C-TAB> :bnext<CR>
noremap <silent> <S-C-TAB> :bprev<CR>
noremap <silent> <C-F6> :bnext<CR>
noremap <silent> <C-F4> :Bdelete<CR>

" Function keys
nnoremap <silent> <F3> :nohlsearch<CR>

" Control-Backspace deletes a word
inoremap <C-BS> <C-W>
cnoremap <C-BS> <C-W>


" Auto commands
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

    autocmd FileType yaml,yml setlocal indentkeys-=0#

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

  augroup END
end

" Load local config file
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

" vim:ts=2:sw=2:tw=100:et:ft=vim:
