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

## markdown support
With markdown, which is nice both as plain text and as interpreted file, the vim-plain-text-presentation can become really fully featured. 
### Enabling markdown
 * Install, again via pathogen,  [vim-markdown](https://github.com/plasticboy/vim-markdown):
 * suffix your slides as `xyz.markdown`
 * out of the box you will get
    * bullets
    * bold and italic
    * urls
    * headlines
    * and much more... to create awesome plaintext preentation
    
**tip**: configure font of your terminal emulator to adapt to the screen/projector ... blindness of audience

## License

Copyright (c) 2012-2015 Pavel Tisnovsky (BSD-Like)

