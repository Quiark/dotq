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

require("lazy").setup({
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
{'tomlion/vim-solidity', lazy = true },
{'atelierbram/vim-colors_atelier-schemes', lazy = true },
{'keith/parsec.vim', lazy = true },
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
'github/copilot.vim',

-- UI 
{'neoclide/coc.nvim', branch= 'release'},
'Shougo/denite.nvim',
'Shougo/defx.nvim',
{ dir = '~/install/vim-choosewin' },
'tjdevries/stackmap.nvim',
{'ThePrimeagen/harpoon',  branch= 'harpoon2' , dependencies =  {"nvim-lua/plenary.nvim"} },
{'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},

-- local
{ dir = '~/install/vifm.vim' },
{ dir = '~/Devel/hector.nvim' },

-- debugging
{'mfussenegger/nvim-dap',  ft = { 'typescript', 'python', 'rust' } },
{'mxsdev/nvim-dap-vscode-js',ft= { 'typescript' } },
{'mfussenegger/nvim-dap-python',ft= { 'python' } },
{'rcarriga/nvim-dap-ui',ft = { 'typescript', 'python', 'rust' } }

}, {})


-- --- ----. Harpoon .---- --- --

local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", ",a", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- --- ----. LuaLine .---- --- --
require('lualine').setup {
	options = { theme  = 'molokai' }
}
