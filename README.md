# vim-weakpoint

Simple markdown-able plaintext slideshow tool for vim

### Table of Contents
* [Installation](#installation)
* [Usage](#usage)
* [Markdown support](#markdown-support)
    * [Enabling markdown](#enabling-markdown)
    * [Folding](#folding)
* [Single file presentation](#single-file-presentation)
     * [Example file](#example-file)
     * [Magic command](#magic-command)
     * [Options](#options)
* [License](#license)

# vim-weakpoint

Simple markdown-able plaintext slideshow tool for vim

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

## Single file presentation
The plaintext presentations (especially markdowned) may be awesome for some cases, however *creating* them with slide per file can be extremely uncomfortable. To help with this issue `~/.vim/bundle/vim-weakpoint/WeekPointSplitter.lua` was added. This lua (which you already have) script requires lua-posix (which you likely have too).

### Example file
This allows you to write single file presentation, eg:
<pre>
# WeakPoint markdown presentation
	* vim-weakpoint + vim-markdown are **awesome**
		* allows code `like this`
		* allows bullets
		* allows *italic*
		=> creates non disturbing presentation with all comfort
   * Above you can see that also errors in parsing can be useful
   * it also allows http://some.url/highlighted/clickable ,  cool!

## Folding
Unluckily folding must be disabled, and various levels of headlines are not distinguished
--PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE--
# Tables
 			cool	diff-able	images
WeakPoint	x		x			only via url
PowerPoint	no		no			depends on your opinion on cliparts

So they works to...
--PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE----PAGE---
# Code
single `code` is working. How does multi-line?
```
it can
rocks too!
```
the one with empty lines:

	code
	is it
	right

This is no more code
	HTH
</pre>

### Magic command

This file can then can be processed like eg:
`lua  ~/.vim/bundle/vim-weakpoint/WeekPointSplitter.lua  ~/Desktop/examplePresentation.markdown  -deduct -height 30 -vim`
This created:
```
 tree ~/Desktop/examplePresentation-WeakPoint/
~/Desktop/examplePresentation-WeakPoint/
├── 1.markdown
├── 2.markdown
└── 3.markdown

0 directories, 3 files
```
And lunched your plaintext presentation in the ~/Desktop/examplePresentation-WeakPoint/. You do not need to worry about sorting, as output of WeekPointSplitter.lua is always sortable, no metter of count of slides.

### Options

Except simple splitting of given file in current working directory, WeekPointSplitter allowes you a bit more:
 * enforce output dir via `-output`
 * if necessary, to remove content of this directory via `-clean`
  * **deduct** via `-deduct` switch the output directory location and name from input file
 * to get rid of vim's `~` non existing line marker via `-height number` which adds *number* of empty spaces
 * to overwrite default `--PAGE--` marker via `-break new_value`
   * the page is split, everytime line *starts with* this pattern
 * to generate slides,  or directly start WeakPoint via `-vim`
 
if you wish to chain the tool, it uses stderr, except final output of output directory to stdout.
 
## License

Copyright (c) 2012-2015 Pavel Tisnovsky (BSD-Like)

