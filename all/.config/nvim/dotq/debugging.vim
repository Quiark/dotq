lua dofile(os.getenv('DOTQ_HOME') .. '/all/.config/nvim/dotq/debugging.lua')

func! g:DotqSetupDap()
  " deprecated in favour of Lua
  map <F10> :lua require('dap').step_over()<CR>
  map <F11> :lua require('dap').step_into()<CR>
  map <F12> :lua require('dap').step_out()<CR>

  " load dotq file
endfun

func! g:DotqSetupDapPython()
  call g:DotqSetupDap()
  " https://github.com/mfussenegger/nvim-dap-python
  lua require('dap-python').setup('~/install/py3_11stuff/bin/python')
endfun

func! g:DotqSetupDapRust()
  call g:DotqSetupDap()
endfun

func! DotqDapStart()
  lua require('dap').continue()
  lua require('dapui').open()
endfun

func! DotqDapStop()
  lua require('dapui').close()
endfun
