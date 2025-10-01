-- plugins
vim.pack.add({
	-- why so many plugins need ts
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },

	{ src = "https://github.com/romgrk/barbar.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/Saghen/blink.cmp" },

	-- telescope dependency
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/jiangmiao/auto-pairs" },
	-- mason with plugins
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },

	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },

	{ src = "https://github.com/swaits/universal-clipboard.nvim" },

	{ src = "https://github.com/v1nh1shungry/cppman.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
	{ src = "https://github.com/xiyaowong/transparent.nvim" },
})

-- options
vim.cmd("filetype plugin indent on")
vim.wo.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>")
vim.keymap.set("t", "<C-x>", "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set("n", "<leader>h", function()
	vim.cmd("below term")
	vim.cmd("resize 5")
end)
vim.keymap.set({ "n", "i" }, "<D-space>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>g",
	"<Cmd> lua vim.lsp.buf.code_action({apply = true})<CR>",
	{ noremap = true, silent = true }
)

-- colorscheme
vim.cmd.colorscheme("catppuccin")

-- file tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 20,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})
vim.keymap.set("n", "<leader>e", "<Cmd>NvimTreeFocus<CR>")

-- bar
vim.keymap.set("n", "<Tab>", "<Cmd>BufferNext<CR>")
vim.keymap.set("n", "<leader>c", "<Cmd>BufferClose<CR>")

-- mason
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"python-lsp-server",
		"clangd",
		"lua-language-server",
		"ruff",
		"stylua",
		"clang-format",
		"tinymist",
	},
})

-- lspconfig
vim.diagnostic.enable = true
vim.diagnostic.config({
	virtual_text = true,
})
vim.lsp.enable("clangd")
vim.lsp.config("tinymist", {
	settings = {
		formatterMode = "typstyle",
		exportPdf = "onType",
		semanticTokens = "disable",
	},
})
vim.lsp.enable("tinymist")

-- formatting
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff" },
		cpp = { "clang-format" },
		typst = { "typstyle" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- autocompletion
require("blink.cmp").setup({
	fuzzy = {
		implementation = "lua",
	},
	keymap = {
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<Tab>"] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			"snippet_forward",
			"fallback",
		},
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = {
				border = "rounded",
			},
		},
		menu = {
			border = "rounded",
			draw = { gap = 2 },
		},
	},
})

-- telescope
vim.keymap.set("n", "<leader>f", "<Cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>d", "<Cmd>Telescope diagnostics<CR>")

-- clipboard
require("universal-clipboard").setup()

-- cpp docs
-- default
require("cppman").setup({
	-- * builtin: `vim.ui.select()`
	-- * telescope
	-- * snacks (recommended)
	picker = "telescope",
	-- used in `vim.api.nvim_open_win`
	win = {
		split = "below",
		style = "minimal",
	},
})
-- indent lines
require("ibl").setup()
