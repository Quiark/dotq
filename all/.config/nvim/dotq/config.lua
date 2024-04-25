-- --- ----. Lazy package manager .---- --- --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugindef = {
-- language support
'ervandew/supertab',
{ 'dag/vim-fish', ft='fish' },
{'rust-lang/rust.vim', ft='rust' },
'HerringtonDarkholme/yats.vim',
{'derekwyatt/vim-scala', ft='scala' },
'jceb/vim-orgmode',
{'udalov/kotlin-vim', ft='kotlin' },
'pangloss/vim-javascript',
'b4b4r07/vim-hcl',
'posva/vim-vue',
{'LnL7/vim-nix', ft='nix' },
'Glench/Vim-Jinja2-Syntax',
{'rvmelkonian/move.vim', ft = 'move' },
'chrisbra/csv.vim',
{'tomlion/vim-solidity', lazy = true },

-- color schemes
{'junegunn/seoul256.vim', lazy = true },
{'savq/melange', lazy = true },
{'cocopon/iceberg.vim', lazy = true },
{'mswift42/vim-themes', lazy = true },
{'rebelot/kanagawa.nvim', lazy = true },
{'EdenEast/nightfox.nvim', lazy = true },
{'folke/tokyonight.nvim',  branch = 'main', lazy = true },
{'Rigellute/shades-of-purple.vim', lazy = true },
{'Rigellute/rigel', lazy = true },
{'franbach/miramare', lazy = true },
{'wadackel/vim-dogrun', lazy = true },
{'sainnhe/sonokai', lazy = true },
{'jacoborus/tender', lazy = true },
{'bluz71/vim-nightfly-guicolors', lazy = true },
{'nielsmadan/harlequin', lazy = true },
{'flazz/vim-colorschemes', lazy = true },
{'atelierbram/vim-colors_atelier-schemes', lazy = true },
-- {'keith/parsec.vim', lazy = true },
{'NLKNguyen/papercolor-theme', lazy = true },
{'vim-scripts/proton', lazy = true },
{'daddye/soda.vim', lazy = true },
{'sainnhe/everforest', lazy = true },
{'ayu-theme/ayu-vim', lazy = true },
{'ray-x/aurora', lazy = true },
{'catppuccin/nvim', lazy = true },
{'ribru17/bamboo.nvim', lazy = true },
{'ray-x/starry.nvim', lazy = true },
{ "yorik1984/newpaper.nvim", priority = 1000, config = true, },

-- 'vim-airline/vim-airline-themes',
-- utilities
'tpope/vim-surround',
'preservim/tagbar',
'editorconfig/editorconfig-vim',
'vim-scripts/argtextobj.vim',
'nvim-lua/plenary.nvim',

-- UI 
'Shougo/denite.nvim',
'Shougo/defx.nvim',
{ dir = '~/install/vim-choosewin' },
'tjdevries/stackmap.nvim',
-- {'ThePrimeagen/harpoon',  branch= 'harpoon2' , dependencies =  {"nvim-lua/plenary.nvim"} },
{'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},

-- local
{ dir = '~/install/vifm.vim' },
{ dir = '~/Devel/hector.nvim' },

-- debugging
{'mfussenegger/nvim-dap',  ft = { 'typescript', 'python', 'rust' } },
{'mxsdev/nvim-dap-vscode-js',ft= { 'typescript' } },
{'mfussenegger/nvim-dap-python',ft= { 'python' } },
{'rcarriga/nvim-dap-ui',ft = { 'typescript', 'python', 'rust' } }

}

local qroot = {}
_G.qroot = qroot
_G.qutils = require("dotq.utils")
local qutils = _G.qutils

if not os.getenv('NVIM_NATIVE_LSP') then
	-- TODO disable copilot for now when debugging LSP
	table.insert(plugindef, 'github/copilot.vim')
	table.insert(plugindef, { 'neoclide/coc.nvim', branch='release' })
else
	table.insert(plugindef, {
		"neovim/nvim-lspconfig",
		lazy = true,
		cmd = { "LspInfo", "LspLog", "LspStop", "LspStart", "LspRestart" },
		dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
		config = function()
			qroot.lsp.setup()
		end,
	})
	table.insert(plugindef, {
		"williamboman/mason-lspconfig.nvim",
		cmd = { "LspInstall", "LspUninstall" },
		config = function()
			require("mason-lspconfig").setup()  -- (qroot.lsp.installer.setup)

			-- automatic_installation is handled by lsp-manager
			local settings = require "mason-lspconfig.settings"
			-- settings.current.automatic_installation = false
		end,
		lazy = true,
		event = "User FileOpened",
		dependencies = "mason.nvim",
	})
	table.insert(plugindef, { "tamago324/nlsp-settings.nvim", cmd = "LspSettings", lazy = true })
	table.insert(plugindef, { "nvimtools/none-ls.nvim", lazy = true })
	table.insert(plugindef, { "williamboman/mason.nvim",
		config = function()
			qroot.mason.setup()
		end,
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
		build = function()
			pcall(function()
				require("mason-registry").refresh()
			end)
		end,
		event = "User FileOpened",
		lazy = true,
	})
	if false then
		table.insert(plugindef, { "hrsh7th/nvim-cmp",
			config = function()
				qroot.cmp.setup()
			end,
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"cmp-nvim-lsp",
				"cmp_luasnip",
				"cmp-buffer",
				"cmp-path",
				-- "cmp-cmdline",
			}
		})
		table.insert(plugindef, { "hrsh7th/cmp-nvim-lsp", lazy = true })
		table.insert(plugindef, { "saadparwaiz1/cmp_luasnip", lazy = true })
		table.insert(plugindef, { "hrsh7th/cmp-buffer", lazy = true })
		table.insert(plugindef, { "hrsh7th/cmp-path", lazy = true })
	end
	table.insert(plugindef, { "nvim-treesitter/nvim-treesitter",
		-- run = ":TSUpdate",
		config = function()
			local path = qutils.join_paths(qutils.get_runtime_dir(), "site", "pack", "lazy", "opt", "nvim-treesitter")
			vim.opt.rtp:prepend(path) -- treesitter needs to be before nvim's runtime in rtp
			qroot.treesitter.setup()
		end,
		cmd = {
			"TSInstall",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
			"TSInstallInfo",
			"TSInstallSync",
			"TSInstallFromGrammar",
		},
		event = "User FileOpened",
	})
	table.insert(plugindef, { "JoosepAlviste/nvim-ts-context-commentstring",
		-- Lazy loaded by Comment.nvim pre_hook
		lazy = true,
	})
	table.insert(plugindef, { "nvim-tree/nvim-web-devicons",
		enabled = true,
		lazy = true,
	})
	table.insert(plugindef, { "RRethy/vim-illuminate",
		config = function()
			qroot.illuminate.setup()
		end,
		event = "User FileOpened",
		enabled = true
	})
end

require("lazy").setup(plugindef, {})

vim.lsp.set_log_level("debug")
require('dotq.plugins')

-- --- ----. Harpoon .---- --- --
if false then
	local harpoon = require("harpoon")
	harpoon:setup()

	vim.keymap.set("n", ",a", function() harpoon:list():append() end)
	vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

	vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
	vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
	vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
	vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

end
