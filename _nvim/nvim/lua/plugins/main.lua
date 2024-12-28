-- Generic setup for all LSP servers to enable formatting on save
local function on_attach(client, bufnr)
	-- Enable formatting on save if the LSP server supports it
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = vim.api.nvim_create_augroup("LSPFormatOnSave", { clear = true }),
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end
end

return {

	-- Plugin manager for lazy loading
	{ "folke/lazy.nvim" },

	-- Docs: https://lsp-zero.netlify.app/docs/language-server-configuration.html
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Reserve a space in the gutter
			-- This will avoid an annoying layout shift in the screen
			vim.opt.signcolumn = "yes"

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- This is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", vim.tbl_extend("force", opts, { desc = "Show hover information" }))
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", vim.tbl_extend("force", opts, { desc = "Go to definition" }))
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
					vim.keymap.set("i", "<c-i>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Show signature help" })
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
					vim.keymap.set("n", "gl", "<cmd>lua vim.lsp.buf.references()<cr>", vim.tbl_extend("force", opts, { desc = "Show references" }))
					vim.keymap.set("n", "<leader>r", function()
						-- Automatically "press" CTRL-F to enter the command-line window `:h cmdwin`
						local cmdId
						cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
							callback = function()
								local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
								vim.api.nvim_feedkeys(key, "c", false)
								vim.api.nvim_feedkeys("0", "n", false)
								-- autocmd was triggered and so we can remove the ID and return true to delete the autocmd
								cmdId = nil
								return true
							end,
						})
						vim.lsp.buf.rename()
						-- if LSP couldn't trigger rename on the symbol, clear the autocmd
						vim.defer_fn(function()
							-- the cmdId is not nil only if the LSP failed to rename
							if cmdId then
								vim.api.nvim_del_autocmd(cmdId)
							end
						end, 500)
					end, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

					vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Show code actions" }))
					vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format code" }))
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", vim.tbl_extend("force", opts, { desc = "Show signature help" }))
					vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
					vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", vim.tbl_extend("force", opts, { desc = "Format code" }))
					vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", vim.tbl_extend("force", opts, { desc = "Show code actions" }))

					-- Key mapping for navigating diagnostics
					vim.keymap.set("n", "<C-j>", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
					vim.keymap.set("n", "<C-k>", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
					vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
				end,
			})

			require("lspconfig").lua_ls.setup({
				-- Disable formatter from language server
				-- on_attach = function(client)
				-- 	client.server_capabilities.documentFormattingProvider = false
				-- 	client.server_capabilities.documentFormattingRangeProvider = false
				-- end,
				on_attach = on_attach,

				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								"${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,

				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- Prevent linting errors for 'vim'
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true), -- Include neovim's runtime files
						},
						format = {
							enable = true,
							defaultConfig = {
								indent_style = "space",
								max_line_length = "180",
								indent_size = "2",
							}
						},
						telemetry = {
							enable = false
						}
					},
				},
			})

			-- require("lspconfig").ansiblels.setup({
			-- 	on_attach = function(client, bufnr)
			-- 		-- Enable formatting capability if supported
			-- 		-- Force enable formatting
			-- 		client.server_capabilities.documentFormattingProvider = true
			--
			-- 		if client.server_capabilities.documentFormattingProvider then
			-- 			vim.api.nvim_create_autocmd("BufWritePre", {
			-- 				buffer = bufnr,
			-- 				callback = function()
			-- 					vim.lsp.buf.format({ async = false })
			-- 				end,
			-- 			})
			-- 		end
			-- 	end,
			-- })

			require("lspconfig").yamlls.setup({
				-- Modeline:
				-- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>

				on_attach = function(client, bufnr)
					-- Enable formatting capability if supported
					-- Force enable formatting
					client.server_capabilities.documentFormattingProvider = true

					if client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end,

				filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },

				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							-- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
							-- ["/path/from/root/of/project"] = "/.github/workflows/*",
						},
						schemaStore = {
							enable = true,                        -- Automatically fetch schemas from schema store
							url = "https://www.schemastore.org/api/json/catalog.json", -- URL for the schema store
						},
						validate = true,                          -- Enable/disable validation
						hover = true,                             -- Enable hover support
						completion = true,                        -- Enable completion support
						format = {
							enable = true,                        -- Enable/disable formatting
							singleQuote = false,                  -- Use single quotes for scalars
							bracketSpacing = true,                -- Add spaces between brackets
							proseWrap = "preserve",               -- Wrap text in scalars: "always", "never", or "preserve"
						},
						customTags = {
							"!fn", "!fn sequence", "!And scalar", "!If mapping", "!Not sequence", "!Equals sequence",
							"!Or sequence", "!FindInMap sequence", "!Base64 scalar", "!Cidr sequence",
							"!Ref scalar", "!Ref mapping", "!Ref sequence", "!Sub scalar", "!Sub sequence",
							"!GetAtt scalar", "!GetAtt sequence", "!GetAZs scalar", "!ImportValue scalar",
							"!ImportValue mapping", "!Select sequence", "!Split sequence", "!Join sequence",
						},
						trace = {
							server = "off", -- Options: "off", "messages", or "verbose"
						},
					},
				},
			})

			require("lspconfig").jsonls.setup({
				on_attach = on_attach,
				cmd = { "vscode-json-language-server", "--stdio" },
			})

			require("lspconfig").gopls.setup({
				on_attach = on_attach,
				cmd = { "gopls", "--remote=auto" },
				settings = {
					gopls = {
						experimentalWorkspaceModule = true,
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
					},
				},
			})

			require("lspconfig").pyright.setup({
				on_attach = on_attach,
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			require("lspconfig").bashls.setup {
				on_attach = on_attach,
			}

			require("lspconfig").dockerls.setup {
				on_attach = on_attach,
			}

			require("lspconfig").docker_compose_language_service.setup({
				cmd = { "docker-compose-langserver", "--stdio" }
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
			-- require("lspconfig").abc.setup({})

			local cmp = require("cmp")
			cmp.setup({
			})
		end,
	},
	{
		'onsails/lspkind.nvim',
		config = function()
			local lspkind = require('lspkind')
			require("lspkind").setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = 'symbol', -- show only symbol annotations
						maxwidth = {
							-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
							-- can also be a function to dynamically calculate max width such as
							-- menu = function() return math.floor(0.45 * vim.o.columns) end,
							menu = 50, -- leading text (labelDetails)
							abbr = 50, -- actual suggestion item
						},
						ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default
					})
				}
			})
		end,
	},

	{
		'L3MON4D3/LuaSnip',
		dependencies = {
			{ 'rafamadriz/friendly-snippets' },
		},
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")

			vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })
		end,

	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				-- these dependencies will only be loaded when cmp loads
				-- dependencies are always lazy-loaded unless specified otherwise
				dependencies = {
					"L3MON4D3/LuaSnip",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-buffer",
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{
						name = 'buffer',
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end
						}
					},
				},

				-- snippet = {
				-- 	expand = function(args)
				-- 		require("luasnip").lsp_expand(args.body)
				-- 	end,
				-- },

				mapping = {
					-- ["<Tab>"] = cmp.mapping(function(fallback)
					-- 	-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
					-- 	if cmp.visible() then
					-- 		local entry = cmp.get_selected_entry()
					-- 		if not entry then
					-- 			cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					-- 		end
					-- 		cmp.confirm()
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s", "c", }),

					-- ['<CR>'] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		if luasnip.expandable() then
					-- 			luasnip.expand()
					-- 		else
					-- 			cmp.confirm({
					-- 				select = false,
					-- 			})
					-- 		end
					-- 	else
					-- 		fallback()
					-- 	end
					-- end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},

				formatting = {
					format = require("lspkind").cmp_format({
						mode = 'symbol_text',
						maxwidth = 50,

						before = function(_, vim_item)
							return vim_item
						end
					})
				},
			})
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp" },

	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				-- Options related to integrating with other plugins
				integration = {
					["nvim-tree"] = {
						enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
					},
					["xcodebuild-nvim"] = {
						enable = true, -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
					},
				},

				-- Options related to logging
				logger = {
					level = vim.log.levels.WARN, -- Minimum logging level
					max_size = 10000, -- Maximum log file size, in KB
					float_precision = 0.01, -- Limit the number of decimals displayed for floats
					path =        -- Where Fidget writes its logs to
						string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
				},
			})
		end,
	},

	-- Colorscheme
	{
		"tomasr/molokai",
		config = function()
			vim.cmd("colorscheme molokai")
			-- Better showmatch
			vim.cmd("highlight MatchParen gui=underline guibg=black guifg=NONE")
		end,
	},
	-- {
	-- 	"joshdick/onedark.vim",
	-- 	config = function()
	-- 		vim.cmd("colorscheme onedark")
	-- 	end,
	-- },

	-- Syntax highlighting
	{ "sheerun/vim-polyglot" },

	-- Popup to show shortcuts as we type
	-- {
	-- 	"folke/which-key.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- 	keys = {
	-- 		{
	-- 			"<leader>?",
	-- 			function()
	-- 				require("which-key").show({ global = false })
	-- 			end,
	-- 			desc = "Buffer Local Keymaps (which-key)",
	-- 		},
	-- 	},
	-- },

	-- File tree explorer
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{ "stevearc/dressing.nvim",      event = "VeryLazy" },

	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{ '<C-m>', "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session", },
			-- { "<C-m>", "<cmd>Yazi<cr>",     desc = "Open yazi at the current file", },
			{ "<C-n>", "<cmd>Yazi cwd<cr>",    desc = "Open the file manager in nvim's working directory", },
		},
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = true,

			keymaps = {
				show_help = '<leader>?',
				open_file_in_vertical_split = '<c-v>',
				open_file_in_horizontal_split = '<c-s>',
				open_file_in_tab = '<c-t>',
				grep_in_directory = '<c-g>',
				replace_in_directory = '<c-h>',
				cycle_open_buffers = '<tab>',
				copy_relative_path_to_selected_files = '<c-y>',
				send_to_quickfix_list = '<c-l>',
				change_working_directory = "<c-\\>",
			},
		},
	},

	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	config = function()
	-- 		require("nvim-tree").setup({
	-- 			sort = {
	-- 				sorter = "case_sensitive",
	-- 			},
	-- 			view = {
	-- 				width = 30,
	-- 			},
	-- 			renderer = {
	-- 				group_empty = true,
	-- 			},
	-- 			filters = {
	-- 				dotfiles = true,
	-- 			},
	-- 		})
	--
	-- 		local api = require "nvim-tree.api"
	-- 		vim.keymap.set('n', '<C-n>', api.tree.toggle, { desc = "Toggle Nvim Tree" })
	-- 		vim.keymap.set('n', '<C-a>', require("nvim-tree.api").tree.expand_all, { desc = "Expand All Nodes" })
	-- 		vim.keymap.set('n', '<C-a>', require("nvim-tree.api").tree.collapse_all, { desc = "Collapse All Nodes" })
	-- 	end,
	--
	-- 	on_attach = function(bufnr)
	-- 		local api = require "nvim-tree.api"
	--
	-- 		local function opts(desc)
	-- 			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	-- 		end
	--
	-- 		-- default mappings
	-- 		api.config.mappings.default_on_attach(bufnr)
	--
	-- 		-- custom mappings
	-- 		vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
	-- 	end
	-- },

	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the listed parsers MUST always be installed)
				ensure_installed = {},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				-- List of parsers to ignore installing (or "all")
				ignore_install = {},

				-- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- Default: ~/.local/share/nvim/lazy/nvim-treesitter/parser
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	{ "nvim-treesitter/nvim-treesitter-context" },

	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup({
				-- In which modes mappings from this `config` should be created
				modes = { insert = true, command = false, terminal = false },

				-- Global mappings. Each right hand side should be a pair information, a
				-- table with at least these fields (see more in |MiniPairs.map|):
				-- - <action> - one of 'open', 'close', 'closeopen'.
				-- - <pair> - two character string for pair to be used.
				-- By default pair is not inserted after `\`, quotes are not recognized by
				-- `<CR>`, `'` does not insert pair after a letter.
				-- Only parts of tables can be tweaked (others will use these defaults).
				mappings = {
					["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
					["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
					["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

					[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
					["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
					["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

					['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
					["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
					["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
				},
			})
		end,
	},

	-- Statusline
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = true,
					theme = 'onedark',
					-- component_separators = { left = '', right = '' },
					-- section_separators = { left = '', right = '' },
					section_separators = '',
					component_separators = '',
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					}
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
		end,
	},
	-- {
	-- 	"vim-airline/vim-airline",
	-- 	dependencies = {
	-- 		"vim-airline/vim-airline-themes",
	-- 	},
	-- 	config = function()
	-- 		vim.g.airline_theme = "minimalist"
	-- 		vim.g.airline_powerline_fonts = 1
	-- 	end,
	-- },

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope_builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Find files in the current project" })
			vim.keymap.set("n", "<C-p>", telescope_builtin.resume, { desc = "Resume the last Telescope search" })
			vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Search for text in project using live grep" })
			vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "List and switch between open buffers" })
			vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Browse available help tags" })
			vim.keymap.set('n', '<leader>o', function()
				require('telescope.builtin').oldfiles({ only_cwd = false })
			end, { noremap = true, silent = true, desc = 'Open recently used files' })
		end,
	},

	-- Find and replace
	{
		'MagicDuck/grug-far.nvim',
		config = function()
			require('grug-far').setup({
				-- options, see Configuration section below
				-- there are no required options atm
				-- engine = 'ripgrep' is default, but 'astgrep' can be specified
			});
		end
	},

	-- ALE
	{
		"dense-analysis/ale",
		config = function()
			vim.g.ale_completion_enabled = 0
			vim.g.ale_lint_on_save = 1
			vim.g.ale_linters_explicit = 1
			vim.g.ale_lint_on_text_changed = "never"
			vim.g.ale_linters = {
				-- Only use these when LSP does not supports it.
				-- lua = { "lua_language_server" },
				-- go = { "gopls", "golint" },
				-- sh = { "bash-language-server" },
				-- yaml = { "yaml-language-server" },
				-- python = { "pyright" },
				-- html = { "prettier" },
				-- sql = { "sqlfluff" },
				dockerfile = { "hadolint" },
			}

			vim.g.ale_fix_on_save = 1
			vim.g.ale_fixers = {
				-- Only use these when LSP does not supports it.
				-- sh = { "shfmt" },
				-- yaml = { "prettier" },
				python = { "black" },
				sql = { "sqlfluff" },
				html = { "prettier" },
				-- lua = { "stylua" },
			}

			-- sqlfluff
			vim.g.ale_sql_sqlfluff_options = "format --dialect=bigquery"

			-- Enable vim-airline integration with ALE
			vim.g["airline#extensions#ale#enabled"] = 1

			-- vim.keymap.set("n", "<C-k>", "<Plug>(ale_previous_wrap)")
			-- vim.keymap.set("n", "<C-j>", "<Plug>(ale_next_wrap)")
			vim.api.nvim_set_keymap("n", "<C-k>", "<Plug>(ale_previous_wrap)", { silent = true, desc = "Jump to the previous ALE diagnostic (wrapped)" })
			vim.api.nvim_set_keymap("n", "<C-j>", "<Plug>(ale_next_wrap)", { silent = true, desc = "Jump to the next ALE diagnostic (wrapped)" })
		end,
	},

	-- Lint
	-- Only needed when LSP does not have linting capailities.
	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	config = function()
	-- 		require('lint').linters_by_ft = {
	-- 			dockerfile = { 'hadolint' },
	-- 		}
	--
	-- 		-- Run linting on open and on save
	-- 		vim.api.nvim_create_autocmd("BufWritePost", {
	-- 			callback = function()
	-- 				require('lint').try_lint()
	-- 			end,
	-- 		})
	-- 		vim.api.nvim_create_autocmd("BufReadPost", {
	-- 			callback = function()
	-- 				require('lint').try_lint()
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	-- Aligner
	{
		"godlygeek/tabular",
		config = function()
			-- Align text using Tabularize
			vim.keymap.set("n", "<Leader>a=", ":Tabularize /=<CR>", { desc = "Align text around '='" })
			vim.keymap.set("x", "<Leader>a=", ":Tabularize /=<CR>", { desc = "Align visually selected text around '='" })

			vim.keymap.set("n", "<Leader>a:", ":Tabularize /:<CR>", { desc = "Align text around ':'" })
			vim.keymap.set("x", "<Leader>a:", ":Tabularize /:<CR>", { desc = "Align visually selected text around ':'" })

			vim.keymap.set("n", "<Leader>a,", ":Tabularize /,<CR>", { desc = "Align text around ','" })
			vim.keymap.set("x", "<Leader>a,", ":Tabularize /,<CR>", { desc = "Align visually selected text around ','" })

			vim.keymap.set("n", "<Leader>a|", ":Tabularize /|<CR>", { desc = "Align text around '|'" })
			vim.keymap.set("x", "<Leader>a|", ":Tabularize /|<CR>", { desc = "Align visually selected text around '|'" })

			vim.keymap.set("n", "<Leader>a#", ":Tabularize /#<CR>", { desc = "Align text around '#'" })
			vim.keymap.set("x", "<Leader>a#", ":Tabularize /#<CR>", { desc = "Align visually selected text around '#'" })

			vim.keymap.set("n", "<Leader>a$", ":Tabularize /$<CR>", { desc = "Align text around '$'" })
			vim.keymap.set("x", "<Leader>a$", ":Tabularize /$<CR>", { desc = "Align visually selected text around '$'" })

			vim.keymap.set("n", "<Leader>a.", ":Tabularize /.<CR>", { desc = "Align text around '.'" })
			vim.keymap.set("x", "<Leader>a.", ":Tabularize /.<CR>", { desc = "Align visually selected text around '.'" })
		end,
	},

	-- { "chr4/nginx.vim" },

	{ "lepture/vim-jinja" },

	-- { "pearofducks/ansible-vim" },

	{
		"fatih/vim-go",
		config = function()
			-- Disable vim-go's LSP features
			vim.g.go_def_mapping_enabled = 0 -- Prevent conflict
			vim.g.go_def_mode = 'gopls' -- Use gopls for Go-to-Definition
			vim.g.go_info_mode = 'gopls' -- Use gopls for hover information
			vim.g.go_rename_command = "gopls"

			-- Disable redundant features
			vim.g.go_fmt_command = ''   -- Disable formatting (handled by LSP)
			vim.g.go_auto_type_info = 0 -- Disable type info on cursor hover
			vim.g.go_doc_keywordprg_enabled = 0 -- Disable keyword lookup (handled by LSP)
			vim.g.go_code_completion_enabled = 0 -- Disable vim-go's completion (use LSP or nvim-cmp)
			vim.g.go_textobj_enabled = 0 -- Disable text objects for structs, functions, etc.

			-- Disable diagnostics/linting (use LSP or nvim-lint)
			vim.g.go_metalinter_enabled = {} -- Disable Go Metalinter
			vim.g.go_metalinter_autosave = 0 -- Disable linting on save
			vim.g.go_list_type = '' -- Disable quickfix and location list handling

			-- Disable jump handlers (use LSP for navigation)
			vim.g.go_jump_to_error = 0 -- Disable jump to error on compile
			vim.g.go_jump_to_type_def = 0 -- Disable jump to type definition
			vim.g.go_jump_to_struct = 0 -- Disable jump to struct fields

			-- Disable tag generation (use gopls code actions for this)
			vim.g.go_auto_sameids = 0 -- Disable automatic identifier highlighting
			vim.g.go_auto_sameids_use_tree = 0 -- Disable same ID highlighting using tree-sitter

			-- Disable unused imports removal (use LSP formatting or code actions)
			vim.g.go_remove_unused_imports = 0 -- Disable unused import removal

			-- Disable test-specific features (if using custom tooling)
			vim.g.go_term_enabled = 0 -- Disable terminal integration for tests
			vim.g.go_test_show_name = 0 -- Disable test name display
			vim.g.go_term_mode = '' -- Disable vim-go terminal mode

			-- Global variables for vim-go plugin
			vim.g.go_highlight_format_strings = 1
			vim.g.go_highlight_function_parameters = 1
			vim.g.go_highlight_function_calls = 1
			vim.g.go_highlight_functions = 1
			vim.g.go_highlight_operators = 1
			vim.g.go_highlight_types = 1
			vim.g.go_highlight_extra_types = 1
			vim.g.go_highlight_fields = 1
			vim.g.go_highlight_generate_tags = 1
			vim.g.go_highlight_variable_assignments = 1
			vim.g.go_highlight_variable_declarations = 1
			vim.g.go_template_autocreate = 0

			-- Key mappings for Go filetype
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
					vim.keymap.set("n", "<C-t>", "<C-o>", { noremap = true, silent = true })

					vim.api.nvim_set_keymap("n", "<Leader>e", ":GoIfErr<CR>", { noremap = true, silent = true })
					-- vim.api.nvim_set_keymap("n", "<Leader>s", ":GoReferrers<CR>", { noremap = true, silent = true })
					-- vim.api.nvim_set_keymap("n", "<Leader>d", ":GoDescribe<CR>", { noremap = true, silent = true })
					-- vim.api.nvim_set_keymap("n", "<Leader>r", ":GoRename ", { noremap = true, silent = false })
					-- vim.api.nvim_set_keymap("n", "<Leader>f", ":GoDecls<CR>", { noremap = true, silent = true })
					-- vim.api.nvim_set_keymap("n", "<Leader>c", ":GoCallees<CR>", { noremap = true, silent = true })
					-- vim.api.nvim_set_keymap("n", "<Leader>i", "<Plug>(go-info)", {})
				end,
			})
		end,

	},

	{
		"echasnovski/mini.comment",
		config = function()
			-- Install and configure mini.comment with lazy.nvim
			require("mini.comment").setup({
				-- Options which control module behavior
				options = {
					-- Function to compute custom 'commentstring' (optional)
					custom_commentstring = nil,

					-- Whether to ignore blank lines when commenting
					ignore_blank_line = false,

					-- Whether to recognize as comment only lines without indent
					start_of_line = false,

					-- Whether to force single space inner padding for comment parts
					pad_comment_parts = true,
				},

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Toggle comment (like `gcip` - comment inner paragraph) for both
					-- Normal and Visual modes
					comment = '<leader>c<space>',

					-- Toggle comment on current line
					comment_line = '<leader>c<space>',

					-- Toggle comment on visual selection
					comment_visual = '<leader>c<space>',

					-- Define 'comment' textobject (like `d<leader>c` - delete whole comment block)
					-- Works also in Visual mode if mapping differs from `comment_visual`
					textobject = '<leader>c<space>',
				},

				-- Hook functions to be executed at certain stage of commenting
				hooks = {
					-- Before successful commenting. Does nothing by default.
					pre = function() end,
					-- After successful commenting. Does nothing by default.
					post = function() end,
				},
			})
		end,

	},

	-- Animate cursor movements to help when doing screenshare
	{
		"echasnovski/mini.animate",
		version = "*",
		config = function()
			require("mini.animate").setup({
				cursor = { enable = false },
				scroll = { enable = false },
				open = { enable = false },
				close = { enable = false },
			})
		end,
	},

	-- Trim trailing whitespaces
	{
		"echasnovski/mini.trailspace",
		version = "*",
		config = function()
			require("mini.trailspace").setup({
				-- Highlight only in normal buffers (ones with empty 'buftype'). This is
				-- useful to not show trailing whitespace where it usually doesn't matter.
				only_in_normal_buffers = true,
			})
		end,
	},

	{
		"echasnovski/mini.icons",
		version = "*",
		config = function()
			require("mini.icons").setup({})
		end,
	},

	-- {
	-- 	'MeanderingProgrammer/render-markdown.nvim',
	-- 	dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	-- 	--@module 'render-markdown'
	-- 	--@type render.md.UserConfig
	-- 	opts = {},
	-- },

	{
		'echasnovski/mini.cursorword',
		version = '*',
		config = function()
			require('mini.cursorword').setup({
				delay = 100 -- ms
			})
		end,
	},

	{
		'echasnovski/mini.clue',
		version = '*',
		config = function()
			local miniclue = require('mini.clue')
			miniclue.setup({
				triggers = {
					-- Leader triggers
					{ mode = 'n', keys = '<Leader>' },
					{ mode = 'x', keys = '<Leader>' },

					-- Built-in completion
					{ mode = 'i', keys = '<C-x>' },

					-- `g` key
					{ mode = 'n', keys = 'g' },
					{ mode = 'x', keys = 'g' },

					-- Marks
					{ mode = 'n', keys = "'" },
					{ mode = 'n', keys = '`' },
					{ mode = 'x', keys = "'" },
					{ mode = 'x', keys = '`' },

					-- Registers
					{ mode = 'n', keys = '"' },
					{ mode = 'x', keys = '"' },
					{ mode = 'i', keys = '<C-r>' },
					{ mode = 'c', keys = '<C-r>' },

					-- Window commands
					{ mode = 'n', keys = '<C-w>' },

					-- `z` key
					{ mode = 'n', keys = 'z' },
					{ mode = 'x', keys = 'z' },
				},

				clues = {
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
					{ mode = 'n', keys = '<C-w><', postkeys = '<C-w>' }, -- Resize left with <<< (pressing '<' continuously)
					{ mode = 'n', keys = '<C-w>>', postkeys = '<C-w>' }, -- Resize right with >>> (pressing '>' continuously)
				},

				-- Clue window settings
				window = {
					-- Floating window config
					config = {},

					-- Delay before showing clue window
					delay = 250,

					-- Keys to scroll inside the clue window
					scroll_down = '<C-d>',
					scroll_up = '<C-u>',
				},
			})
		end,
	},

	{ 'buoto/gotests-vim' },

	{
		'mikesmithgh/kitty-scrollback.nvim',
		enabled = true,
		lazy = true,
		cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
		event = { 'User KittyScrollbackLaunch' },
		-- version = '*', -- latest stable version, may have breaking changes if major version changed
		-- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
		config = function()
			require('kitty-scrollback').setup()
		end,
	},

	{
		'echasnovski/mini.indentscope',
		version = '*',
		config = function()
			require('mini.indentscope').setup()
		end,
	},
}
