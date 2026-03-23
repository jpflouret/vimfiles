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
  let g:airline_inactive_collapse=0
  let g:netrw_fastbrowse = 0
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
  let g:lsp_code_action_ui='float'
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
    nmap <buffer> gd :FzfLspDefinition<CR>
    nmap <buffer> gD :FzfLspDeclaration<CR>
    nmap <buffer> gr :FzfLspReferences<CR>
    nmap <buffer> gi :FzfLspImplementation<CR>
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> <leader>ca :FzfLspCodeAction<CR>
    nmap <buffer> <leader>a <plug>(lsp-switch-source-header)
    nmap <buffer> <leader>f <plug>(lsp-document-format)
    vmap <buffer> <leader>f <plug>(lsp-document-range-format)
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
  command! SessionReset only | %bdelete
  command! DiffOff call <SID>DiffOff()
  function! <SID>DiffOff()
    let l:scratchbufs = []
    for l:buf in getbufinfo()
      let l:name = bufname(l:buf.bufnr)
      let l:is_scratch = getbufvar(l:buf.bufnr, '&buftype') ==# 'nofile' && getbufvar(l:buf.bufnr, '&diff')
      let l:is_fugitive = l:name =~# '^fugitive://' && getbufvar(l:buf.bufnr, '&diff')
      if l:is_scratch || l:is_fugitive
        call add(l:scratchbufs, l:buf.bufnr)
      endif
    endfor
    diffoff!
    for l:buf in l:scratchbufs
      execute 'bwipeout ' . l:buf
    endfor
  endfunction
  command! DiffGit Gdiffsplit
  command! DiffP4 call <SID>DiffP4()
  function! <SID>DiffP4()
    let l:file = expand('%:p')
    let l:have = systemlist('p4 have ' . shellescape(l:file))
    let l:name = len(l:have) ? matchstr(l:have[0], '#\d\+') : '#have'
    diffthis
    vert new
    set buftype=nofile
    execute 'file ' . fnameescape(fnamemodify(l:file, ':t') . l:name)
    execute 'silent read !p4 print -q ' . shellescape(l:file)
    0d_
    setlocal nomodifiable
    diffthis
    wincmd p
  endfunction
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
nnoremap <silent> <Leader>a :A<CR>
nnoremap <silent> <C-S> :update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
noremap <silent> <C-TAB> :bnext<CR>
noremap <silent> <S-C-TAB> :bprev<CR>

" Toggle bottom terminal
nnoremap <silent> <C-`> :call <SID>ToggleTerminal()<CR>
tnoremap <silent> <C-`> <C-W>:call <SID>ToggleTerminal()<CR>
if has('eval')
  function! s:ToggleTerminal()
    let l:buf = get(g:, 'terminal_buf', -1)
    if l:buf != -1 && bufexists(l:buf)
      let l:win = bufwinnr(l:buf)
      if l:win != -1
        execute l:win . 'wincmd w'
        hide
      else
        execute 'botright sbuffer ' . l:buf
        resize 15
      endif
    else
      botright terminal
      resize 15
      let g:terminal_buf = bufnr('%')
    endif
  endfunction
endif

" Window navigation
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
tnoremap <C-H> <C-W>h
tnoremap <C-J> <C-W>j
tnoremap <C-K> <C-W>k
tnoremap <C-L> <C-W>l

" IDE-style mappings
nnoremap <silent> <A-o> :A<CR>
nnoremap <silent> <F2> <plug>(lsp-rename)
nnoremap <silent> <F12> :FzfLspDefinition<CR>
nnoremap <silent> <S-F12> :FzfLspReferences<CR>
nnoremap <silent> <C-S-o> :FzfLspDocumentSymbol<CR>
nnoremap <silent> <C-t> :FzfLspWorkspaceSymbol<CR>
nnoremap <silent> <A-Up> :move .-2<CR>==
nnoremap <silent> <A-Down> :move .+1<CR>==
vnoremap <silent> <A-Up> :move '<-2<CR>gv=gv
vnoremap <silent> <A-Down> :move '>+1<CR>gv=gv
nnoremap <silent> <A-g> :FzfLspDefinition<CR>
nnoremap <silent> <C-LeftMouse> <LeftMouse>:FzfLspDefinition<CR>
nnoremap <silent> <X1Mouse> <C-O>
nnoremap <silent> <X2Mouse> <C-I>
nnoremap <silent> <A-m> :FzfLspDocumentSymbol<CR>
nnoremap <silent> <A-S-o> :Files<CR>
nnoremap <silent> <A-S-s> :FzfLspWorkspaceSymbol<CR>
nnoremap <silent> <A-Left> <C-O>
nnoremap <silent> <A-Right> <C-I>
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>do :DiffOrig<CR>
nnoremap <silent> <Leader>dg :DiffGit<CR>
nnoremap <silent> <Leader>dp :DiffP4<CR>
nnoremap <silent> <Leader>dq :DiffOff<CR>
nnoremap <silent> <C-S-f> :Rg<CR>
nnoremap <silent> <C-/> :Commentary<CR>
vnoremap <silent> <C-/> :Commentary<CR>

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

    " Auto-restore session if Session.vim exists and no files were passed
    autocmd VimEnter * nested
          \ if !argc() && filereadable('Session.vim') |
          \   source Session.vim |
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
