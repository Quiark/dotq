local stackmap = require 'stackmap'
local dap = function()
  return require('dap')
end
local dapui = function()
  return require('dapui')
end

local setup_dap = function () 
  dofile( os.getenv('DOTQ_HOME') .. '/all/.config/nvim/dotq/dapcfg.lua' )
  qroot.priv.debug_configs()
end

local start_dap = function () 
  local dap = dap()
  dap.continue()

  stackmap.push('debugger', 'n', {
    ['<F8>'] = dap.continue,
    ['<F10>'] = dap.step_over,
    ['<F11>'] = dap.step_into,
    ['<S-F10>'] = dap.step_out,
  })
  dapui().setup()
  dapui().open()
end

local stop_dap = function () 
  dap().disconnect()
  stackmap.pop('debugger', 'n')
end

vim.api.nvim_create_user_command("Dap", setup_dap, { nargs = 0 })
vim.api.nvim_create_user_command("DapStart", start_dap, { nargs = 0 })
vim.api.nvim_create_user_command("DapStop", stop_dap, { nargs = 0 })

vim.api.nvim_set_var("copilot_filetypes", {
      ["dap-repl"] = false,
})

