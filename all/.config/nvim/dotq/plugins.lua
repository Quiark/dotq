-- This file is reloadable, doesn't  contain list of plugins actually.

-- --- ----. LuaLine .---- --- --
local function smart_filename()
	local path = vim.fn.expand('%:p')
	local mod = vim.api.nvim_buf_get_option(0, 'modified')
	return vim.fn.fnamemodify(path, ':~:.') .. (mod and ' [+]' or '')
end

require('lualine').setup {
	options = { 
		theme  = 'auto' ,
		icons_enabled = false,
		ignore_focus = { 'defx' },
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = { 'branch', 'diagnostics' },
		lualine_c = { smart_filename },
		lualine_x = {'encoding'}, -- leave more space for filename
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { smart_filename },
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
}

vim.api.nvim_create_user_command('DotqLuaReload', 'luafile ~/.config/nvim/dotq/plugins.lua', { nargs = 0 })

-- --- ----. Win resize (for smol laptop screens) .---- --- --
_G.cycler_wins = {}

_G.cycler_wins.cycle_size = function (hor)
  -- Get the current window ID
  local win_id = vim.api.nvim_get_current_win()

  -- Get the total height of the Neovim window grid
  local total_size = vim.api.nvim_list_uis()[1]

  if hor then
	  -- Calculate the 80% and 50% heights
	  local height_80_percent = math.floor(total_size.height * 0.8)
	  local height_50_percent = math.floor(total_size.height * 0.5)

	  -- Get the current height of the window
	  local current_height = vim.api.nvim_win_get_height(win_id)

	  -- Determine the new height
	  local new_height
	  if current_height < height_80_percent then
		new_height = height_80_percent
	  else
		new_height = height_50_percent
	  end

	  -- Set the new height
	  vim.api.nvim_win_set_height(win_id, new_height)
  else
	  local height_80_percent = math.floor(total_size.width * 0.8)
	  local height_50_percent = math.floor(total_size.width * 0.5)

	  local current_height = vim.api.nvim_win_get_width(win_id)

	  local new_height
	  if current_height < height_80_percent then
		new_height = height_80_percent
	  else
		new_height = height_50_percent
	  end

	  vim.api.nvim_win_set_width(win_id, new_height)
  end
end


vim.api.nvim_set_keymap('n', ',wh', '<cmd>lua _G.cycler_wins.cycle_size(true)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',ww', '<cmd>lua _G.cycler_wins.cycle_size(false)<CR>', { noremap = true, silent = true })

-- --- ----. File mark viewer  .---- --- --
-- Function to get all mark details
_G.mark_view = {}
_G.mark_view.supported_marks = {'G', 'C', 'R', 'L', 'H', 'T', 'N', 'S'}

_G.mark_view.get_marks = function ()
  local lines = {}
	--[[
  local marks = vim.api.nvim_exec("marks", true)
  for mark in marks:gmatch("[^\r\n]+") do
    table.insert(lines, mark)
  end
  ]]--
  for _, m in ipairs(_G.mark_view.supported_marks) do
	  local row, col, buffer, buffername = unpack(vim.api.nvim_get_mark(m, {}))
	  local last_seg = buffername:match("^.+[/\\](.+)$") or buffername
	  table.insert(lines, ' ' .. m .. '  ' .. last_seg)
  end
  return lines
end

-- Open or find the marks buffer
_G.mark_view.open_marks_window = function ()
  -- Find an existing marks buffer, if any
  local existing_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match(".*marks_list.*") then
      existing_buf = buf
      break
    end
  end

  local buf
  if existing_buf then
	  return existing_buf
  else
    -- Create a buffer if it doesn't exist
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "marks_list")
  end
  local oldwin = vim.api.nvim_get_current_win()

  -- go to the leftmost window, not working maybe because async?
  -- Create a window for the buffer in the leftmost vertical split
  vim.cmd("wincmd 5 h | new")

  --vim.cmd("topleft new")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)

  -- Formatting and settings for the buffer and window
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  vim.api.nvim_win_set_height(win, #_G.mark_view.supported_marks)
  vim.api.nvim_win_set_option(win, 'buftype', 'nofile')
  vim.api.nvim_win_set_option(win, 'noswapfile', true)

  vim.api.nvim_set_current_win(oldwin)

  return buf
end

-- Function to update the marks list
_G.mark_view.open_marks_list = function ()
  local buf = _G.mark_view.open_marks_window()
  local marks = _G.mark_view.get_marks()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, marks)
end

-- Monitoring marks changes and updating the marks list
_G.mark_view.set_mark = function (m)
	-- Set the mark in current buffer on current line
	local win = vim.api.nvim_get_current_win()

	-- Obtain the cursor position in the current window
	local row, col = unpack(vim.api.nvim_win_get_cursor(win))
	vim.api.nvim_buf_set_mark(0, m, row, col + 1, {})

	-- Update the marks list
	_G.mark_view.open_marks_list()
end

-- --- ----. Mappings .---- --- --
-- vim.keymap.set(mode, key, val, opt)
--
-- * to open CocOutline
vim.api.nvim_set_keymap('n', ',l', '<cmd>Denite mark<CR>', { noremap = true, silent = true }) -- probably unused
vim.api.nvim_set_keymap('n', ',wm', '<cmd>lua _G.mark_view.open_marks_list()<CR>', { noremap = true, silent = true })

for i, m in ipairs(_G.mark_view.supported_marks) do 
	vim.api.nvim_set_keymap('n', 'm' .. m, '<cmd>lua _G.mark_view.set_mark("'..m..'")<CR>', { noremap = true, silent = true })
end
