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

-- --- ----. Mappings .---- --- --
-- vim.keymap.set(mode, key, val, opt)
--
-- * to open CocOutline
vim.api.nvim_set_keymap('n', ',l', '<cmd>Denite mark<CR>', { noremap = true, silent = true })
