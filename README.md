# vimfiles

Vim setup by JP Flouret

## Plugins

* [Align](https://github.com/vim-scripts/Align.git)
* [bufexplorer](https://github.com/jlanzarotta/bufexplorer.git)
* [ctrlp.vim](https://github.com/kien/ctrlp.vim.git)
* [gitv](https://github.com/gregsexton/gitv.git)
* [Gundo](https://github.com/vim-scripts/Gundo.git)
* [supertab](https://github.com/ervandew/supertab.git)
* [tagbar](https://github.com/majutsushi/tagbar.git)
* [unite.vim](https://github.com/Shougo/unite.vim.git)
* [vim-abolish](https://github.com/tpope/vim-abolish.git)
* [vim-airline](https://github.com/bling/vim-airline)
* [vim-bbye](https://github.com/moll/vim-bbye.git)
* [vim-capslock](https://github.com/tpope/vim-capslock.git)
* [vim-commentary](https://github.com/tpope/vim-commentary.git)
* [vim-easymotion](https://github.com/Lokaltog/vim-easymotion.git)
* [vim-eunuch](https://github.com/tpope/vim-eunuch.git)
* [vim-fugitive](https://github.com/tpope/vim-fugitive.git)
* [vim-hybrid](https://github.com/w0ng/vim-hybrid.git)
* [vim-indent-guides](https://github.com/nathanaelkane/vim-indent-guides.git)
* [vim-repeat](https://github.com/tpope/vim-repeat.git)
* [vim-sensible](https://github.com/tpope/vim-sensible.git)
* [vim-sleuth](https://github.com/tpope/vim-sleuth.git)
* [vim-surround](https://github.com/tpope/vim-surround.git)
* [vim-unimpaired](https://github.com/tpope/vim-unimpaired.git)
* [vim-vinegar](https://github.com/tpope/vim-vinegar.git)
* [vimp4python](https://github.com/jpflouret/vimp4python.git)

## Installation

This repository is intended to be cloned into the user's Vim runtime folder
(~/.vim on unix or %USERPROFILE%/vimfiles)

### Linux/Unix

    cd ~
    git clone --recursive https://github.com/jpflouret/vimfiles.git .vim

### Windows

    cd %USERPROFILE%
    git clone --recursive https://github.com/jpflouret/vimfiles.git vimfiles


### For Vim version < 7.4:

    ln -s .vim/vimrc ~/.vimrc

Or alternatively:

    echo "runtime vimrc" > ~/.vimrc

## Adding a new plugin

    cd ~/.vim
    git submodule add <plugin remote url> bundle/<plugin>

## Requirements

* Vim 7.3+
* Python support for Vim
* Puthon 2.4+

## License
Each plugin comes with its own license. See bundle/<plugin>/README or bundle/<plugin>/LICENSE
for individual plugin licenses.

Copyright (c) JP Flouret. Distributed under the same terms as Vim itself.
See :help license.
