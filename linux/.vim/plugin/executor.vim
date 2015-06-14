" Executor
" taky umi prepinat hlavickovy <-> implementacni soubor u cpp

"expand('%:p') -- cesta k aktualnimu souboru
"expand('%:e') -- jen pripona
" TODO:
" + bibtex
" + python exceptions
" + lepsi pipe

let g:ExParams = ''
let g:ExCompiler = 1

function s:SetCompiler(name)
    if g:ExCompiler == 1
        exe "compiler " . a:name
    endif
endfunction

function s:Quote(str)
    return '"' . a:str . '"'
endfunction

function s:GetProgramsByExt(ext, filename, root)
    if a:ext == 'py'
        call s:SetCompiler('python')
        return 'python ' . s:Quote(a:filename)
    elseif a:ext == 'tex'
        call s:SetCompiler('tex')
        return 'latexbib.bat ' . a:root
    elseif a:ext == 'dot'
        call s:SetCompiler('dot')
        return 'dot -Tpdf ' . s:Quote(a:filename) . ' -o' . a:root . '.pdf'
    elseif a:ext == 'clj'
        set efm=%m(%f:%l)
        return 'cljide ' . a:filename
    endif

endfunction

function s:Run()
    let filename = expand('%:p')
    let ext = expand('%:e')
    let path = expand('%:h')
    let root = expand('%:t:r')
    let oldpwd = getcwd()

    let prg = s:GetProgramsByExt(ext, filename, root)
    exe "cd " . path
    let &makeprg=prg
    exe "make " . g:ExParams
    exe "cd " . oldpwd
endfunction

function! s:SwitchCpp()
    let no_ext = expand('%:r')
    let ext = expand('%:e')

    if ext == 'cpp'
        let ext = "h"
    elseif ext == 'h'
        let ext = "cpp"
    elseif ext == 'hh'
        let ext = 'cc'
    elseif ext == 'c'
        let ext = 'h'
    elseif ext == 'cc'
        let ext = 'hh'
    end

    exe "edit " . no_ext . "." . ext

endfunction

" avoid conflict with Explore
command! RunExecutor :call <SID>Run()

menu &Plugin.&Execute :call <SID>Run()<CR>
menu &Plugin.Ex\ &args :let g:ExParams=''<Left>
map <F12> :call <SID>Run()<CR>
set shellpipe=2>&1\ \|\ tee\ %s

menu &Plugin.&Switch :call <SID>SwitchCpp()<CR>
command! SwitchCpp :call <SID>SwitchCpp()
