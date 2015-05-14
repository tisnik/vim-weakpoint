" Slideshow tool v1.2
" Pavel Tisnovsky 2012, 2013, 2014, 2015

" Ziskani seznamu vsech souboru v aktualnim adresari
function! s:GetFileList()
    return split(system("ls -1 | sort"))
endfunction

" Prechod na prvni slajd
function! s:GotoFirstSlide()
    let s:index = 0
endfunction

" Prechod na posledni slajd
function! s:GotoLastSlide()
    let s:index = len(s:slides) - 1
endfunction

" Zjisteni, zda uzivatel nepresel pred prvni slajd
function! s:BeforeFirstSlide()
    return s:index < 0
endfunction

" Zjisteni, zda uzivatel nepresel za posledni slajd
function! s:AfterLastSlide()
    return s:index >= len(s:slides)
endfunction

" Zobrazeni nasledujiciho slajdu
function! s:ShowNextSlide()
    let s:index += 1
    if s:AfterLastSlide()
        call s:GotoFirstSlide()
    endif
    call s:ShowActualSlide()
endfunction

" Zobrazeni predchoziho slajdu
function! s:ShowPrevSlide()
    let s:index -= 1
    if s:BeforeFirstSlide()
        call s:GotoLastSlide()
    endif
    call s:ShowActualSlide()
endfunction

" Zobrazeni prvniho slajdu
function! s:ShowFirstSlide()
    call s:GotoFirstSlide()
    call s:ShowActualSlide()
endfunction

" Zobrazeni posledniho slajdu
function! s:ShowLastSlide()
    call s:GotoLastSlide()
    call s:ShowActualSlide()
endfunction

" Funkce zajistujici nacteni slajdu
function! s:ShowActualSlide()
    execute "edit" s:slides[s:index]
endfunction

" Uprava stavove radky - bude se zobrazovat cislo
" slajdu, pocet slajdu a jmeno souboru obsahujiciho slajd
function! StatusLine()
    return "Slide " . (1+s:index) . "/" . len(s:slides) . " : " . s:slides[s:index]
endfunction

" Nastaveni zpusobu ovladani prohlizecky
function! s:SetupKeys()
    noremap <PageUp>   :call <SID>ShowPrevSlide()<cr>
    noremap <PageDown> :call <SID>ShowNextSlide()<cr>
    noremap <Home>     :call <SID>ShowFirstSlide()<cr>
    noremap <End>      :call <SID>ShowLastSlide()<cr>
endfunction

function! s:WeakPoint()
    " Promenna obsahujici seznam slajdu
    let s:slides = s:GetFileList()

    " Index aktualniho slajdu
    let s:index = 0

    " Kontrola
    if s:slides == []
        echo "Zadne soubory v pracovnim adresari"
    else
        " Registrace funkce pouzite pro zjisteni obsahu stavove radky
        set statusline=%!StatusLine()

        " Nastaveni zobrazeni stavove radky i v pripade, ze je pouzito
        " jen jedno okno
        set laststatus=2

        call s:ShowFirstSlide()
        call s:SetupKeys()
    endif
endfunction

command WeakPoint :call s:WeakPoint()

