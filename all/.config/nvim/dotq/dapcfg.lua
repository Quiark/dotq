local dap, dapui = require("dap"), require("dapui")

local HOME = '/Users/roman'

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

local install_root_dir = vim.fn.stdpath("data") .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"

dap.adapters.codelldb = {
  -- type = 'server',
  -- host = '127.0.0.1',
  -- port = 13000
  type = 'executable',
  command = codelldb_path,
}

require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = HOME .. "/install/vscode-js-debug/", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome' }, --, 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

local jsconf = {
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach",
		--processId = require'dap.utils'.pick_process,
		processId = 1409,
		cwd = "${workspaceFolder}",
	}
}

dap.configurations.typescript = jsconf
dap.configurations.javascript = jsconf

