-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

vim.o.termguicolors = true

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = { float = true },
})

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
local api = vim.api

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- [[ Plugins ]] --
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mg979/vim-visual-multi",
	"https://github.com/chomosuke/typst-preview.nvim",
	"https://codeberg.org/andyg/leap.nvim",
	"https://github.com/rktjmp/lush.nvim",
	"https://github.com/zenbones-theme/zenbones.nvim",
	"https://github.com/seblyng/roslyn.nvim",
})

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "<leader>l", "<Plug>(leap-from-window)")

require("conform").setup({
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 1000,
				lsp_format = "fallback",
			}
		end
	end,

	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		cs = { "csharpier" },
		lua = { "stylua" },
		rust = { "rustfmt" },
	},
})

vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

do -- // mini.nvim
	local miniclue = require("mini.clue")
	miniclue.setup({
		triggers = {
			-- Leader triggers
			{ mode = { "n", "x" }, keys = "<Leader>" },

			-- `[` and `]` keys
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = { "n", "x" }, keys = "g" },

			-- Marks
			{ mode = { "n", "x" }, keys = "'" },
			{ mode = { "n", "x" }, keys = "`" },

			-- Registers
			{ mode = { "n", "x" }, keys = '"' },
			{ mode = { "i", "c" }, keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = { "n", "x" }, keys = "z" },
		},

		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			miniclue.gen_clues.square_brackets(),
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
		},

		window = {
			delay = 0,
			config = { width = "auto" },
		},
	})

	require("mini.icons").setup()
	require("mini.ai").setup({ n_lines = 500 })
	require("mini.completion").setup()
	require("mini.cmdline").setup()
	require("mini.operators").setup()

	local MiniFiles = require("mini.files")
	MiniFiles.setup()
	vim.keymap.set("n", "<leader>o", MiniFiles.open, { desc = "[O]pen files" })

	require("mini.pairs").setup()
	local MiniPick = require("mini.pick")
	MiniPick.setup()
	vim.keymap.set("n", "<leader>sf", MiniPick.builtin.files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep_live, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader><leader>", MiniPick.builtin.buffers, { desc = "[␣] Buffers" })
	vim.keymap.set("n", "<leader>/", function()
		MiniExtra.pickers.buf_lines({ scope = "current", preserve_order = false })
	end, { desc = "[/] Fuzzy search current buffer" })

	require("mini.surround").setup()
	local MiniStatusline = require("mini.statusline")

	MiniStatusline.setup({ use_icons = vim.g.have_nerd_font })
	MiniStatusline.section_location = function()
		return "%2l:%-2v"
	end

	require("mini.extra").setup()
end

do -- // treesitter
	local treesitter_cfg = function()
		local parsers = {
			"asm",
			"bash",
			"c",
			"cpp",
			"c_sharp",
			"diff",
			"fish",
			"glsl",
			"lua",
			"luadoc",
			"markdown",
			"python",
			"rust",
			"slang",
			"toml",
			"typst",
		}
		require("nvim-treesitter").install(parsers)
		---@param buf integer
		---@param language string
		local function treesitter_try_attach(buf, language)
			-- check if parser exists and load it
			if not vim.treesitter.language.add(language) then
				return
			end
			-- enables syntax highlighting and other treesitter features
			vim.treesitter.start(buf, language)

			-- enables treesitter based folds
			-- for more info on folds see `:help folds`
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo.foldmethod = "expr"

			-- check if treesitter indentation is available for this language, and if so enable it
			-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
			local has_indent_query = vim.treesitter.query.get(language, "indent") ~= nil

			-- enables treesitter based indentation
			if has_indent_query then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end

		local available_parsers = require("nvim-treesitter").get_available()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match

				local language = vim.treesitter.language.get_lang(filetype)
				if not language then
					return
				end

				local installed_parsers = require("nvim-treesitter").get_installed("parsers")

				if vim.tbl_contains(installed_parsers, language) then
					-- enable the parser if it is installed
					treesitter_try_attach(buf, language)
				elseif vim.tbl_contains(available_parsers, language) then
					-- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
					require("nvim-treesitter").install(language):await(function()
						treesitter_try_attach(buf, language)
					end)
				else
					-- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
					treesitter_try_attach(buf, language)
				end
			end,
		})
	end
	treesitter_cfg()
end

-- stylua: ignore
do -- // flash.nvim
	require("flash").setup()

	vim.keymap.set({ "n", "x", "o" }, "<leader>j", function() require("flash").jump() end, { desc = "Flash Jump" })
	vim.keymap.set({ "n", "x", "o" }, "<leader>t", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
	vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Flash Remote" })
	vim.keymap.set({ "x", "o" }, "R", function() require("flash").treesitter_search() end, { desc = "Flash Search Treesitter" })
	vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Flash Search Toggle" })

	-- Simulate nvim-treesitter incremental selection
	vim.keymap.set({ "n", "x", "o" }, "<c-space>", function()
		require("flash").treesitter({
			actions = {
				["<c-space>"] = "next",
				["<c-p>"] = "prev",
			},
		})
	end, { desc = "Flash Treesitter Incremental Selection" })
end

do -- // trouble.nvim
	local Trouble = require("trouble")
	Trouble.setup({
		modes = {
			lsp = {
				win = { position = "right" },
			},
		},
	})
	vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
	vim.keymap.set("n", "<leader>cr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "References (Trouble)" })
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("tn-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = more or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("gln", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gla", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("glD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight", event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("tn-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("tn-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "tn-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

require("roslyn").setup()

---@type table<string, vim.lsp.Config>
local servers = {
	clangd = {},
	ruff = {},
	rust_analyzer = {},
	roslyn = {},
}

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end

vim.cmd.colorscheme("tokyobones")
require("todo-comments").setup()
