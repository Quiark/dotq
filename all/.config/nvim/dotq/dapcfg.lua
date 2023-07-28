local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.adapters.codelldb = {
  type = 'server',
  host = '127.0.0.1',
  port = 13000
}

dap.configurations.rust = {
  {
    name = "Launch BattleDAO",
    type = "codelldb",
    request = "launch",
    program = "~/CGentium/battledao/backend/target/debug/battledao",
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    stdio = [nil, '~/CGentium/battledao/backend/debugout.txt']
  },
}
