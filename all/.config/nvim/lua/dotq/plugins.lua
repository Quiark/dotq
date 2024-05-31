-- --- ----. LuaLine .---- --- --
local function smart_filename()
	local path = vim.fn.expand('%:p')
	local mod = vim.api.nvim_buf_get_option(0, 'modified')
	return vim.fn.fnamemodify(path, ':~:.') .. (mod and ' [+]' or '')
end

local function project()
	local path = vim.fn.expand('%:p')
  -- if path contains any of the keys in projects, return the value
  for k, v in pairs(qroot.priv.PROJECTS) do
    -- case sensitive
    if string.find(path, k, nil, true) ~= nil then
      return v
    end
  end
end

require('lualine').setup {
	options = { 
		theme  = 'auto' ,
		icons_enabled = true,
		ignore_focus = { 'defx' },
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = { 'branch', 'diagnostics', project },
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

vim.api.nvim_create_user_command('DotqLuaReload', 'luafile ~/.config/nvim/lua/dotq/plugins.lua', { nargs = 0 })

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

_G.cycler_wins.cycle_current_and_size = function (direction)
	local dirs = {
		left = { 'h', 'w' },
		right = { 'l', 'w' },
		up = { 'k', 'h' },
		down = { 'j', 'h' } 
	}
	local dir, hor = unpack(dirs[direction])
	-- vim.cmd('normal <C-W><C-' .. dirs[direction] .. '>')

	print("<C-W>" .. dir .. ",w" .. hor)
  vim.cmd('wincmd ' .. dir)
	--vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-W>" .. dir .. ",w" .. hor , true, true, true), "n", false)
	--vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(',w' .. hor, true, true, true), "n", false)
	-- no worky because previous cmd is async
	cycler_wins.cycle_size(direction == 'up' or direction == 'down')
end

vim.api.nvim_set_keymap('n', ',wh', '<cmd>lua _G.cycler_wins.cycle_size(true)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',ww', '<cmd>lua _G.cycler_wins.cycle_size(false)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-N>h', '<cmd>lua _G.cycler_wins.cycle_current_and_size("left")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-N>l', '<cmd>lua _G.cycler_wins.cycle_current_and_size("right")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-N>k', '<cmd>lua _G.cycler_wins.cycle_current_and_size("up")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-N>j', '<cmd>lua _G.cycler_wins.cycle_current_and_size("down")<CR>', { noremap = true, silent = true })

-- --- ----. File mark viewer  .---- --- --
-- Function to get all mark details
-- TODO may need a feature to save / load / session mgmt bectaue the file marks are apparently global
_G.mark_view = {}
_G.mark_view.supported_marks = {'G', 'C', 'R', 'L', 'H', 'T', 'N', 'S'}

function getLastTwoSegments(path)
    -- Split the path into segments
    local segments = {}
    for segment in string.gmatch(path, "[^/]+") do
        table.insert(segments, segment)
    end

    -- Get the last two segments
    local lastSegments = {}
    if #segments >= 2 then
        table.insert(lastSegments, segments[#segments - 1])
        table.insert(lastSegments, segments[#segments])
    elseif #segments == 1 then
        table.insert(lastSegments, segments[1])
    end

    -- Join the last two segments with '/'
    --return table.concat(lastSegments, '/')
	return lastSegments
end


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
	  --local last_seg = buffername:match("^.+[/\\](.+)$") or buffername
	  local segments = getLastTwoSegments(buffername)
	  local last_seg = segments[2]
	  if segments[2]:match('index.[tsxjhml]*') then
		  last_seg = segments[1] .. '/' .. segments[2]
	  end
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
	  buf = existing_buf
  else
    -- Create a buffer if it doesn't exist
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "marks_list")
  end

  -- now we find if there is a window with this buffer
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return buf
    end
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
  vim.api.nvim_win_set_option(win, 'winfixheight', true)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  vim.api.nvim_win_set_height(win, #_G.mark_view.supported_marks)
  vim.api.nvim_buf_set_option(0, 'swapfile', false)
  vim.api.nvim_buf_set_option(0, 'filetype', 'mark_view')

  vim.cmd('syntax match MarksCharG /^ G  .*$/')
  vim.cmd('syntax match MarksCharC /^ C  .*$/')
  vim.cmd('syntax match MarksCharR /^ R  .*$/')
  vim.cmd('syntax match MarksCharL /^ L  .*$/')
  vim.cmd('syntax match MarksCharH /^ H  .*$/')
  vim.cmd('syntax match MarksCharT /^ T  .*$/')
  vim.cmd('syntax match MarksCharN /^ N  .*$/')
  vim.cmd('syntax match MarksCharS /^ S  .*$/')

  vim.cmd('hi MarksCharG guifg=#33aa44')
  vim.cmd('hi MarksCharC guifg=#aa4433')
  vim.cmd('hi MarksCharR guifg=#3344dd')
  vim.cmd('hi MarksCharL guifg=#9933dd')
  vim.cmd('hi MarksCharH guifg=#aa9944')
  vim.cmd('hi MarksCharT guifg=#3399aa')
  vim.cmd('hi MarksCharN guifg=#aa7744')
  vim.cmd('hi MarksCharS guifg=#7711aa')

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
-- TODO setup key to navigate to window using choosewin
--
-- * to open CocOutline
vim.api.nvim_set_keymap('n', ',l', '<cmd>Denite mark<CR>', { noremap = true, silent = true }) -- probably unused
vim.api.nvim_set_keymap('n', ',wm', '<cmd>lua _G.mark_view.open_marks_list()<CR>', { noremap = true, silent = true })

for i, m in ipairs(_G.mark_view.supported_marks) do 
	vim.api.nvim_set_keymap('n', 'm' .. m, '<cmd>lua _G.mark_view.set_mark("'..m..'")<CR>', { noremap = true, silent = true })
end
