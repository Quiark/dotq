local M = {}

function M.setup()
	require('nvim-treesitter.configs').setup {
		ensure_installed = { "lua", "rust", "toml", "typescript", "python", "vimdoc", "luadoc", "vim", "lua", "markdown" },
		auto_install = true,
		ignore_install = { "csv" },
		highlight = {
			enable = true,
			additional_vim_regex_highlighting=false,
		},
		ident = { enable = true }, 
		rainbow = {
			enable = true,
			extended_mode = true,
			max_file_lines = nil,
		},
		textobjects = {
			select = {
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ia"] = "@parameter.inner",
					["aa"] = "@parameter.outer",
					--["ac"] = "@class.outer",
					-- You can optionally set descriptions to the mappings (used in the desc parameter of
					-- nvim_buf_set_keymap) which plugins like which-key display
					--["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					-- You can also use captures from other query groups like `locals.scm`
					["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				},
				-- You can choose the select mode (default is charwise 'v')
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * method: eg 'v' or 'o'
				-- and should return the mode ('v', 'V', or '<c-v>') or a table
				-- mapping query_strings to modes.
				selection_modes = {
					['@parameter.outer'] = 'v', -- charwise
					['@function.outer'] = 'V', -- linewise
					['@class.outer'] = '<c-v>', -- blockwise
				},
				-- If you set this to `true` (default is `false`) then any textobject is
				-- extended to include preceding or succeeding whitespace. Succeeding
				-- whitespace has priority in order to act similarly to eg the built-in
				-- `ap`.
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * selection_mode: eg 'v'
				-- and should return true or false
				include_surrounding_whitespace = true,
			},
		},
	}
	if false then
		require'treesitter-context'.setup{
			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
			max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
			mode = 'topline',
			min_window_height = 30
		}
	end
end

return M
