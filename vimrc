if has('eval')
  silent! execute pathogen#infect()
endif

" GUI Options (applied only once)
if has('gui_running') && !get(g:, 'gui_initialized', 0)
  set guioptions=aAcemg
  set guifont=CaskaydiaMono\ NFM:h12
  set lines=60 columns=200
  let g:gui_initialized=1
endif

" Run vim-sensible now so that we can override the settings
runtime! plugin/sensible.vim

" Options
set belloff=all
set clipboard=unnamedplus
set sessionoptions+=resize,winpos
set encoding=utf-8
scriptencoding utf-8
set autoread
set modeline
set tabstop=4
set shiftwidth=4
set expandtab
set list
set listchars=tab:→\ ,trail:·,extends:⟩,precedes:⟨,nbsp:␣
if has('mouse')
  set mouse=nvc
endif
set mousehide
set shortmess=a
set hidden
set number
set signcolumn=yes
set nofoldenable
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
set diffopt=filler,vertical,algorithm:patience,indent-heuristic
set colorcolumn=+1
" set textwidth=120
set wildmenu
set cursorline
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" Plugin configuration
if has('eval')
  let c_space_errors=1
  let g:airline#extensions#tabline#enabled=1
  let g:airline#extensions#tabline#fnamemod=':t'
  let g:airline#extensions#default#section_truncate_width={}
  let g:airline#extensions#lsp#enabled=1
  let g:airline_powerline_fonts=1
  let g:camelcasemotion_key = '<leader>'
  let g:bufExplorerVersionWarn=0
  let g:rooter_patterns = ['.git', 'GenerateProjectFiles.bat', 'Makefile', 'compile_commands.json']
  if executable('rg')
    let $FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  endif
  let g:fzf_colors = {'fg':['fg','Normal'],'bg':['bg','Normal'],'hl':['fg','Comment'],'fg+':['fg','CursorLine','CursorColumn','Normal'],'bg+':['bg','CursorLine','CursorColumn'],'hl+':['fg','Statement'],'info':['fg','PreProc'],'prompt':['fg','Conditional'],'pointer':['fg','Exception'],'marker':['fg','Keyword'],'spinner':['fg','Label'],'header':['fg','Comment']}
  let g:lsp_diagnostics_echo_cursor=1
  let g:lsp_diagnostics_signs_enabled=1
  let g:lsp_diagnostics_float_cursor=1
  let g:lsp_diagnostics_virtual_text_enabled=1
  let g:lsp_signature_help_enabled=1
  let g:asyncomplete_auto_completeopt=0
  set completeopt=menuone,noinsert,popup
endif

" Completion menu: Enter or Tab accepts the selected item
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-Y>" : "\<Tab>"

" vim-lsp key mappings
if has('eval')
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gD <plug>(lsp-declaration)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> <leader>ca <plug>(lsp-code-action)
    nmap <buffer> <leader>a <plug>(lsp-switch-source-header)
  endfunction
  if has('autocmd')
    augroup lsp_install
      autocmd!
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END
  endif
endif

" Colorscheme
if has('termguicolors')
  if !has('gui_running') && &term =~# '^\(tmux\|screen\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif
if has('eval')
  let g:codedark_modern=1
  let g:airline_theme='codedark'
endif
silent! colorscheme codedark

" Auxiliary functions
" Cleans up all trailing whitespace and retabs the file
if has('eval')
  command! Cleanup call <SID>CleanupFile()
  function! <SID>CleanupFile()
    %s/\s\+$//ge
    retab
  endfunction

  function! s:YankHighlight()
    let [l1, c1] = [line("'["), col("'[")]
    let [l2, c2] = [line("']"), col("']")]
    let lines = []
    if l1 == l2
      call add(lines, [l1, c1, c2 - c1 + 1])
    else
      call add(lines, [l1, c1, col([l1, '$']) - c1])
      for l in range(l1 + 1, l2 - 1)
        call add(lines, [l])
      endfor
      call add(lines, [l2, 1, c2])
    endif
    let m = matchaddpos('IncSearch', lines)
    call timer_start(200, {-> matchdelete(m)})
  endfunction
endif


" vim-which-key
nnoremap <silent> <Leader> :<C-U>WhichKey '\'<CR>

" Key mappings
" Manipulate .vimrc
nnoremap <silent> <Leader>v :e $MYVIMRC<CR>
nnoremap <silent> <Leader>p :source $MYVIMRC<CR>

" fzf
nnoremap <silent> <C-P> :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>/ :Rg<CR>
nnoremap <silent> <Leader>g :silent grep <C-R><C-W> \| copen<CR>
nnoremap <silent> <expr> <Leader>c getwininfo()->filter({_,v -> v.quickfix})->len() ? ":cclose\<CR>" : ":copen\<CR>"

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

    " Briefly highlight yanked text
    if exists('##TextYankPost') && has('patch-8.0.1394')
      autocmd TextYankPost * call s:YankHighlight()
    endif

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

    " Change directory to file path for each buffer (replaced by vim-rooter)
    " autocmd BufEnter,BufReadPost * silent! lcd %:p:h

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
