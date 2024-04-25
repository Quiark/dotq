local M = {}

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

---Join path segments that were passed as input
---@return string
function M.join_paths(...)
	local result = table.concat({ ... }, path_sep)
	return result
end

function M.get_runtime_dir()
	return vim.call("stdpath", "data")
end

return M
