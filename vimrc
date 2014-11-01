" vim: set ts=2 sw=2 tw=100 et fenc=utf8 ff=unix :

execute pathogen#infect()

colorscheme hybrid
if !exists('gui_initialized')
  let gui_initialized=0
endif

if has("gui_running") && !gui_initialized
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=60 columns=200
  let gui_initialized=1
endif

set autoread
"set autowriteall

set history=1000
set tabstop=4
set shiftwidth=4
set expandtab
set list listchars=tab:»\ ,trail:·,extends:>
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
set statusline=%t\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%{P4RulerStatus()}%=C%v,L%l/%L\ %P
set textwidth=120
set cinoptions=:0,g0,t0,(0,w1,W4
set encoding=utf-8
set commentstring=//%s
set fileformats=dos,unix,mac
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
    delete _
  else
    execute "normal! \<DEL>"
  endif
endfunction


function! DeleteEmptyLineAbove()
  let lineAbove = line('.')-1
  if (getline(lineAbove) =~ '^\s*$')
    exe lineAbove . " delete _"
  endif
endfunction

function! s:CleanupFile()
  %s/\s\+$//ge
  retab
endfunction

function! MyNextBuffer()
  if expand('#')=="" | silent! next
  else
    exe "normal! \<c-^>"
  endif
endfu

command! GREP :execute 'grep search ' . g:projectName . ' ' . expand('<cword>') | copen
command! -nargs=1 Grep :execute 'grep search ' . g:projectName <q-args> | copen
command! -nargs=+ Proj call s:ChangeProject(<f-args>)
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1|nohl
command! Cleanup call s:CleanupFile()
command! P4 call P4Run()


iab                 jpf           jpflouret
iab   <expr>        dts           strftime("%x")
iab                 pvztodo       [PVZ][JPF][TODO]

noremap             <C-K>         :pyf C:/Users/jpflouret/vimfiles/clang/clang-format.py<CR>
inoremap            <C-K>         <ESC>:pyf C:/Users/jpflouret/vimfiles/clang/clang-format.py<CR>i

noremap             ,cc           :s:^://:<CR>
noremap             ,cu           :s:^\(\s*\)// :\1:<CR>
noremap             ,ml           :call InsertModeline(line('.'))<CR>
noremap             ,ct           :call AddTODO(line('.'))<CR>
noremap             ,cpy          :call AddCopyright()<CR>
nnoremap            ,id           :call InsertRandomID(0)<CR>
vnoremap            ,id           :call InsertRandomID(1)<CR>

noremap             <Leader>q     :GREP<CR>
noremap             <Leader>*     :s/\(\s\+\)\*\(\s*\)/*\1\2/g<CR>
nnoremap            <Leader>v     :e $MYVIMRC<CR>
nnoremap            <Leader>p     :source $MYVIMRC<CR>
nnoremap <silent>   <Leader>s     vip:sort iu<CR>

inoremap <silent>   <ESC>         <ESC>`^

nnoremap            ï             :Alternate<CR>
vnoremap            ï             :Alternate<CR>
inoremap            ï             <C-O>:Alternate<CR>

nnoremap            <C-S>         :w<CR>
inoremap            <C-SPACE>     <C-N>
inoremap            <C-BS>        <C-W>
nnoremap <silent>   <DEL>         :call BetterDelete()<CR>

nnoremap            <TAB>         >>
vnoremap            <TAB>         >gv
nnoremap            <S-TAB>       <<
vnoremap            <S-TAB>       <gv

noremap  <silent>   <F2>          :TlistToggle<CR>
nnoremap            <F3>          :set hlsearch!<CR>
noremap             <F4>          :NERDTreeToggle<CR>
nnoremap            <F6>          :LUWalk<CR>
inoremap            <F6>          <C-O>:LUWalk<CR>
nnoremap            <F9>          :cnext<CR>
nnoremap            <F10>         :cprev<CR>
nnoremap            <F11>         <C-O>
nnoremap            <F12>         <C-I>

nnoremap            <S-ENTER>     O<ESC>j
nnoremap            <S-DOWN>      O<ESC>j
nnoremap <silent>   <S-UP>        :call DeleteEmptyLineAbove()<CR>
nnoremap            <C-DOWN>      <C-E>
nnoremap            <C-UP>        <C-Y>
inoremap            <C-DOWN>      <C-O><C-E>
inoremap            <C-UP>        <C-O><C-Y>
noremap <silent>    <C-^>         :call MyNextBuffer()<CR>
noremap <silent>    <C-TAB>       :bnext<CR>
noremap <silent>    <S-C-TAB>     :bprev<CR>
noremap <silent>    <C-F6>        :bnext<CR>
noremap <silent>    <C-F4>        :Bclose<CR>
nnoremap <silent>   <Leader>q     :Bclose<CR>

" Make navigation with arrows not suck
nnoremap <silent>   <C-LEFT>      b
vnoremap <silent>   <C-LEFT>      b
inoremap <silent>   <C-LEFT>      <C-O>b
nnoremap <silent>   <C-RIGHT>     w
vnoremap <silent>   <C-RIGHT>     w
inoremap <silent>   <C-RIGHT>     <C-O>w

" Disable the arrows so you learn vim the hard way
"inoremap           <Up>          inoremap<NOP>
"inoremap           <Down>        inoremap<NOP>
"inoremap           <Left>        inoremap<NOP>
"inoremap           <Right>       inoremap<NOP>
"noremap            <Up>          inoremap<NOP>
"noremap            <Down>        inoremap<NOP>
"noremap            <Left>        inoremap<NOP>
"noremap            <Right>       inoremap<NOP>


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

augroup vimrc
  autocmd!
  autocmd BufRead,BufEnter * silent! lcd %:p:h    " Change directory to the current buffer's dir
  autocmd GUIEnter * simalt ~x                    " Maximize the window when entering the gui
augroup END

