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
-- language support TODO find a better one for typescript? something based on treesitter????
-- 'ervandew/supertab',
{ 'dag/vim-fish', ft='fish' },
{'rust-lang/rust.vim', ft='rust' },
-- 'HerringtonDarkholme/yats.vim', -- replaced by treesitter
{'derekwyatt/vim-scala', ft='scala' },
'jceb/vim-orgmode',
{'udalov/kotlin-vim', ft='kotlin' },
'pangloss/vim-javascript',
'b4b4r07/vim-hcl', -- TODO replace with treesitter / so I get proper indenting?
'posva/vim-vue',
{'LnL7/vim-nix', ft='nix' },
'Glench/Vim-Jinja2-Syntax',
{'rvmelkonian/move.vim', ft = 'move' },
'chrisbra/csv.vim',
{'tomlion/vim-solidity', lazy = true },

-- color schemes
{'junegunn/seoul256.vim', lazy = true },
{'savq/melange-nvim', lazy = true },
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
{ 'sainnhe/edge', lazy = true },
{ 'nyoom-engineering/oxocarbon.nvim', lazy = true },
{ 'lunarvim/lunar.nvim', lazy = true },
{ "scottmckendry/cyberdream.nvim", lazy = false, priority = 1000, },
{ 'AlexvZyl/nordic.nvim',  config = function()
        require 'nordic' .load()
    end },
{ "NTBBloodbath/sweetie.nvim" },


-- 'vim-airline/vim-airline-themes',
-- utilities
'tpope/vim-surround',
-- 'preservim/tagbar', -- trying alternatives
'editorconfig/editorconfig-vim',
-- TODO switch to Treesitter based text objects
-- 'vim-scripts/argtextobj.vim',
'nvim-lua/plenary.nvim',
'github/copilot.vim',
{ 'sindrets/diffview.nvim', lazy = true, cmd = { "DiffviewOpen", } },

-- UI 
'Shougo/denite.nvim',
'Shougo/defx.nvim',
-- 'weilbith/nvim-lsp-denite', -- no worky
{ dir = '~/install/vim-choosewin' },
'tjdevries/stackmap.nvim',
-- {'ThePrimeagen/harpoon',  branch= 'harpoon2' , dependencies =  {"nvim-lua/plenary.nvim"} },
{'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
-- {'nvim-treesitter/nvim-treesitter-context'},  -- still having DESYNC problems and don't like this plugin anyway
{'nvim-treesitter/nvim-treesitter-textobjects'},
{
  "otavioschwanck/arrow.nvim",
  opts = {
    show_icons = true,
    leader_key = ',a', -- Recommended to be a single key
    buffer_leader_key = ',o', -- Per Buffer Mappings
  }
},

-- local
-- { dir = '~/install/vifm.vim' },
-- { dir = '~/Devel/hector.nvim' },

-- debugging disabled to investigete DESYNC
{'mfussenegger/nvim-dap',  ft = { 'typescript', 'python', 'rust' } },
{'mxsdev/nvim-dap-vscode-js',ft= { 'typescript' } },
{'mfussenegger/nvim-dap-python',ft= { 'python' } },
{'rcarriga/nvim-dap-ui',ft = { 'typescript', 'python', 'rust' } }

}

local qroot = {}
_G.qroot = qroot
_G.qutils = require("dotq.utils")
qroot.lsp = require('dotq.lsp')
qroot.mason = require('dotq.mason')
qroot.cmp = require('dotq.cmp')
qroot.treesitter = require('dotq.treesitter')
qroot.il = require('dotq.illuminate')
qroot.priv = require('priv.cgentium')
qroot.tmux = require('dotq.tmuxctl')
local qutils = _G.qutils

if true then
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
	if true then
		table.insert(plugindef, { "hrsh7th/nvim-cmp",
			config = function()
				qroot.cmp.setup()
			end,
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"cmp-nvim-lsp",
				-- "cmp_luasnip",
				"cmp-buffer",
				"cmp-path",
				-- "cmp-cmdline",
			}
		})
		table.insert(plugindef, { "hrsh7th/cmp-nvim-lsp", lazy = true })
		-- table.insert(plugindef, { "saadparwaiz1/cmp_luasnip", lazy = true })
		table.insert(plugindef, { 'hrsh7th/cmp-nvim-lsp-signature-help', lazy = true })
		table.insert(plugindef, { "hrsh7th/cmp-buffer", lazy = true })
		table.insert(plugindef, { "hrsh7th/cmp-path", lazy = true })
	end
	table.insert(plugindef, { "nvim-treesitter/nvim-treesitter",
		-- run = ":TSUpdate",
		config = function()
			local path = qutils.join_paths(qutils.get_runtime_dir(), "lazy", "nvim-treesitter")
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
			"TSEnable",
			"TSModuleInfo",
		},
		event = "User FileOpened",
		lazy = true,
	})
	-- DESYNC
	-- what does this do anyway?
	-- table.insert(plugindef, { "JoosepAlviste/nvim-ts-context-commentstring",
		-- Lazy loaded by Comment.nvim pre_hook
	--	lazy = true,
	-- })
	table.insert(plugindef, { "nvim-tree/nvim-web-devicons",
		enabled = true,
		lazy = true,
	})
	-- DESYNC big suspect
-- 	table.insert(plugindef, { "RRethy/vim-illuminate",
-- 		config = function()
-- 			qroot.il.setup()
-- 		end,
-- 		cmd = {
-- 			"IlluminatePause",
-- 			"IlluminateResume",
-- 			"IlluminateToggle",
-- 		},
-- 		event = "User FileOpened",
-- 		enabled = true,
-- 		lazy = true
-- 	})
end

require("lazy").setup(plugindef, {})

-- vim.lsp.set_log_level("debug")
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
