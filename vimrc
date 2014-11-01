" vim: set ts=2 sw=2 tw=100 et :

execute pathogen#infect()

colorscheme hybrid
if !exists('gui_initialized')
  let gui_initialized=0
endif

if has("gui_running") && !gui_initialized
  set lines=60 columns=200
  let gui_initialized=1
endif

set autoread
set modeline
set history=1000
set tabstop=4
set shiftwidth=4
set expandtab
set list
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
set encoding=utf-8
set fileformats=unix,dos,mac
set switchbuf=useopen
set selectmode=key
set mousemodel=popup
set keymodel=startsel
set selection=inclusive
set whichwrap=b,s,<,>,~,[,]
set nowrap
set backspace=indent,eol,start
set guioptions=aAcemg
set formatoptions=qn1
set nospell

let c_space_errors=1
let g:airline#extensions#tabline#enabled=1

" To make the powerline look good, install fonts from
" https://github.com/Lokaltog/powerline-fonts/
if has('unix')
  let g:airline_powerline_fonts = 1
  if has('gui_running')
    set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 10
  endif
endif

syntax on
filetype plugin indent on
highlight SpecialKey guifg=#003030
highlight Pmenu guifg=white guibg=darkmagenta


" Delete an empte line also when hitting delete
function! BetterDelete()
  if getline('.') =~ '^$'
    delete _
  else
    execute "normal! \<DEL>"
  endif
endfunction


" Deletes a line above the current line if it is empty
function! DeleteEmptyLineAbove()
  let lineAbove = line('.')-1
  if getline(lineAbove) =~ '^\s*$'
    exe lineAbove . " delete _"
  endif
endfunction


" Cleans up all trailing whitespace and retabs the file
function! s:CleanupFile()
  %s/\s\+$//ge
  retab
endfunction
command! Cleanup call s:CleanupFile()


" Open the alternate buffer of the next file
function! AlternateOrNext()
  if expand('#')=="" | silent! next
  else
    exe "normal! \<c-^>"
  endif
endfunction


noremap             <Leader>*     :s/\(\s\+\)\*\(\s*\)/*\1\2/g<CR>
nnoremap            <Leader>v     :e $MYVIMRC<CR>
nnoremap            <Leader>p     :source $MYVIMRC<CR>
inoremap <silent>   <ESC>         <ESC>`^
nnoremap            <C-S>         :w<CR>
inoremap            <C-SPACE>     <C-N>
inoremap            <C-BS>        <C-W>
nnoremap <silent>   <DEL>         :call BetterDelete()<CR>
nnoremap            <TAB>         >>
vnoremap            <TAB>         >gv
nnoremap            <S-TAB>       <<
vnoremap            <S-TAB>       <gv
nnoremap            <F3>          :set hlsearch!<CR>
nnoremap            <S-DOWN>      O<ESC>j
nnoremap <silent>   <S-UP>        :call DeleteEmptyLineAbove()<CR>
nnoremap            <C-DOWN>      <C-E>
nnoremap            <C-UP>        <C-Y>
inoremap            <C-DOWN>      <C-O><C-E>
inoremap            <C-UP>        <C-O><C-Y>
noremap <silent>    <C-^>         :call AlternateOrNext()<CR>
noremap <silent>    <C-TAB>       :bnext<CR>
noremap <silent>    <S-C-TAB>     :bprev<CR>
noremap <silent>    <C-F6>        :bnext<CR>
noremap <silent>    <C-F4>        :Bdelete<CR>
nnoremap <silent>   <Leader>q     :Bdelete<CR>

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
  autocmd BufRead,BufEnter * silent! lcd %:p:h    " Change directory to the current buffer's dir
  if (has('win32'))
    "Maximize the window on Windows
    autocmd GUIEnter * simalt ~x
  endif
augroup END

