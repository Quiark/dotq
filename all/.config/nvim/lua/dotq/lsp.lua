local M = {}

function M.setup()
	local lspconfig = require('lspconfig')
	lspconfig.rust_analyzer.setup({
		settings = {
			["rust-analyzer"] = {
				assist = {
					importGranularity = "module",
					importPrefix = "by_self",
				},
				cargo = {},
				procMacro = {
					enable = true
				},
			}
		}
	})
	lspconfig.terraformls.setup({})
	lspconfig.tsserver.setup({})

	vim.keymap.set('n', 'gh', vim.diagnostic.open_float)
	vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
	vim.keymap.set('n', ']g', vim.diagnostic.goto_next)

	-- TODO standardise
	-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
	vim.keymap.set('n', '<C-W>x', ':pcl<CR>:ccl<CR>')

	-- Use LspAttach autocommand to only map the following keys
	-- after the language server attaches to the current buffer
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

			-- TODO remap omni complete to something else
			-- TODO need something to show function arguments on demand
			-- TODO search symbol, i guess others use telescope

			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = ev.buf }
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
			-- wanted to use C-P  but thats used for going through popup menu
			vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
			-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
			-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
			--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
			--vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
			vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, opts)
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
			--vim.keymap.set('n', '<space>f', function()
				--vim.lsp.buf.format { async = true }
			--end, opts)
		end,
	})
end

return M
