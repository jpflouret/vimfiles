
execute pathogen#infect()

colorscheme hybrid

"set noswapfile
"set viminfo=
set history=1000
set tabstop=4
set shiftwidth=4
set expandtab
set list listchars=tab:»\ ,trail:·,extends:>
set mouse=a
set mousehide
set shortmess=a
set hidden
set nonumber
set cmdheight=2
set laststatus=2
set nohlsearch
set incsearch
set ignorecase
set smartcase
set cinoptions=:0,g0,t0,(0,w1,W4
set encoding=utf-8
set switchbuf=useopen
set selectmode=key
set mousemodel=popup
set keymodel=startsel
set selection=inclusive
set whichwrap=b,s,<,>,~,[,]
set nowrap
set backspace=indent,eol,start
set guioptions=acegim
set formatoptions=qn1
set nospell
set wildmode=full
set complete=.,b,t,w,d,i
set completeopt=menuone

let c_space_errors=1
let g:airline#extensions#tabline#enabled = 1

syntax on
filetype plugin indent on
highlight SpecialKey guifg=#003030
highlight Pmenu guifg=white guibg=darkmagenta

function! BetterDelete()
    if getline('.') =~ '^$'
        delete_
    else
        execute "normal! \<DEL>"
    endif
endfunction

function! DeleteEmptyLineAbove()
    let lineAbove = line('.')-1
    if getline(lineAbove) =~ '^\s*$'
        exe lineAbove . " delete _"
    endif
endfunction

function! s:CleanupFile()
    %s/\s\+$//ge
    retab
endfunction

command! Cleanup call s:CleanupFile()

nnoremap            <Leader>v     :e $MYVIMRC<CR>
nnoremap            <Leader>p     :source $MYVIMRC<CR>
inoremap <silent>   <ESC>         <ESC>`^
inoremap            <C-SPACE>     <C-N>
inoremap            <C-BS>        <C-W>
nnoremap <silent>   <DEL>         :call BetterDelete()<CR>
nnoremap            <TAB>         >>
vnoremap            <TAB>         >gv
nnoremap            <S-TAB>       <<
vnoremap            <S-TAB>       <gv
nnoremap            <F3>          :set hlsearch!<CR>
nnoremap            <S-ENTER>     O<ESC>j
nnoremap            <S-DOWN>      O<ESC>j
nnoremap <silent>   <S-UP>        :call DeleteEmptyLineAbove()<CR>
nnoremap            <C-DOWN>      <C-E>
nnoremap            <C-UP>        <C-Y>
inoremap            <C-DOWN>      <C-O><C-E>
inoremap            <C-UP>        <C-O><C-Y>
nnoremap <silent>   <Leader>q     :Bdelete<CR>

augroup vimrc
  autocmd!
  autocmd BufRead,BufEnter * silent! lcd %:p:h    " Change directory to the current buffer's dir
augroup END

