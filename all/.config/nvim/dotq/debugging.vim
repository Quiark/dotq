" TODO how to auto-load
lua dofile(os.getenv('DOTQ_HOME') .. '/all/.config/nvim/dotq/debugging.lua')

" TODO
func! g:DotqSetupDapPython()
  call g:DotqSetupDap()
  " https://github.com/mfussenegger/nvim-dap-python
  lua require('dap-python').setup('~/install/py3_11stuff/bin/python')
endfun
