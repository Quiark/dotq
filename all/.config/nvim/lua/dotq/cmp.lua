local M = {}
M.methods = {}

function M.setup()
	local status_cmp_ok, cmp_types = pcall(require, "cmp.types.cmp")
	if not status_cmp_ok then
		return
	end
	local ConfirmBehavior = cmp_types.ConfirmBehavior
	local SelectBehavior = cmp_types.SelectBehavior

	local cmp = require "cmp"
	local cmp_mapping = require "cmp.config.mapping"

	cmp.setup({
		mapping = {
			['<C-p>'] = cmp.mapping.select_prev_item(),
			['<C-n>'] = cmp.mapping.select_next_item(),
			-- Add tab support (no thanks)
			-- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
			-- ['<Tab>'] = cmp.mapping.select_next_item(),
			['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			-- TODO why does the popup disappear after typing   res.p
			-- TODO I want this to select the first one
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			["<C-y>"] = cmp_mapping {
				i = cmp_mapping.confirm { behavior = ConfirmBehavior.Replace, select = false },
				c = function(fallback)
					if cmp.visible() then
						cmp.confirm { behavior = ConfirmBehavior.Replace, select = false }
					else
						fallback()
					end
				end,
			},
		},
		sources = {
			{ name = 'path' },                              -- file paths
			{ name = 'nvim_lsp', keyword_length = 3 },      -- from language server
			{ name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
			{ name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
			{ name = 'buffer', keyword_length = 2 },        -- source current buffer
		},
		-- TODO forbid in denite-filter i guess it's buffer name
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			fields = {'menu', 'abbr', 'kind'},
			format = function(entry, item)
				local menu_icon ={
					nvim_lsp = 'λ',
					vsnip = '⋗',
					buffer = 'Ω',
					path = '/',
				}
				item.menu = menu_icon[entry.source.name]
				return item
			end,
		},
  })
  cmp.setup.filetype("denite-filter", {
	  enabled = false,
  })
end

return M
