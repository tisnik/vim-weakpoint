# vim-weakpoint

Simple slideshow tool

## Installation

With [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone git://github.com/tisnik/vim-weakpoint

## Usage

    :cd directory_with_slides
    :WeakPoint

or directly:

    cd  directory_with_slides && vim  -c ":WeakPoint"

* If you use pathogen, you can use :Helptags to regenerate documentation.
* You then can see ":h weakpoint" for more information.
* Don't forget that your slides must be **sortable** to have an order in slideshow

## Markdown support
Markdown, which is nice both as plain text and as interpreted file, will change vim-plain-text-presentation to really fully featured one.
### Enabling markdown
 * Install, again via pathogen,  [vim-markdown](https://github.com/plasticboy/vim-markdown):
 * suffix your slides with .markdown as `xyz.markdown`
 * out of the box you will get
    * bullets
    * bold and italic
    * urls
    * headlines
    * code highlight
    * and much more... to create awesome plaintext presentation
    
**tip**: configure font of your terminal emulator to adapt to the screen/projector ... blindness of audience

### Folding
For successful presentation, except usual pathogen settings of

    execute pathogen#infect()
    syntax on
    filetype plugin indent on
    
it is **strongly recomended** to have also

    let g:vim_markdown_folding_disabled = 1
    :set tabstop=4
    :set shiftwidth=4
    
in `/.vimrc `; to avoid unexpected behavior of markdown during presentations (like auto folding or corrupted tables)


## License

Copyright (c) 2012-2015 Pavel Tisnovsky (BSD-Like)

