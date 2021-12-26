# vimfiles

Vim setup by JP Flouret

## Plugins

* [alternate](https://github.com/vim-scripts/a.vim)
* [bufexplorer](https://github.com/jlanzarotta/bufexplorer.git)
* [CamelCaseMotion](https://github.com/bkad/CamelCaseMotion.git)
* [tabular](https://github.com/godlygeek/tabular.git)
* [vim-abolish](https://github.com/tpope/vim-abolish.git)
* [vim-airline](https://github.com/bling/vim-airline.git)
* [vim-bbye](https://github.com/moll/vim-bbye.git)
* [vim-commentary](https://github.com/tpope/vim-commentary.git)
* [vim-easymotion](https://github.com/Lokaltog/vim-easymotion.git)
* [vim-eunuch](https://github.com/tpope/vim-eunuch.git)
* [vim-fugitive](https://github.com/tpope/vim-fugitive.git)
* [vim-indent-guides](https://github.com/nathanaelkane/vim-indent-guides.git)
* [vim-repeat](https://github.com/tpope/vim-repeat.git)
* [vim-sensible](https://github.com/tpope/vim-sensible.git)
* [vim-sleuth](https://github.com/tpope/vim-sleuth.git)
* [vim-surround](https://github.com/tpope/vim-surround.git)
* [vim-unimpaired](https://github.com/tpope/vim-unimpaired.git)
* [vim-vinegar](https://github.com/tpope/vim-vinegar.git)

## Installation

This repository is intended to be cloned into the user's Vim runtime folder
(~/.vim on unix or %USERPROFILE%/vimfiles on Windows)

### Linux/Unix

    cd ~
    git clone --recursive https://github.com/jpflouret/vimfiles.git .vim

### Windows

    cd %USERPROFILE%
    git clone --recursive https://github.com/jpflouret/vimfiles.git vimfiles

### For Vim version < 7.4:

#### Linux
    ln -s .vim/vimrc ~/.vimrc

#### Windows
    echo "runtime vimrc" > ~/_vimrc


## Working with vimfiles

### Updating ~/.vim

    cd ~/.vim
    git pull
    git submodule init      # Initialize new submodules
    git submodule update    # Checkout submodules

### Adding a new plugin

    cd ~/.vim
    git submodule add <plugin remote url> bundle/<plugin>

### Updating all submodules to latest

    cd ~/.vim
    git submodule foreach "(git checkout master && git pull)&"
    git add bundle/
    git commit

## Requirements

* Vim 7.3+
* Python support for Vim
* Python 2.4+

## License

See LICENSE.md
