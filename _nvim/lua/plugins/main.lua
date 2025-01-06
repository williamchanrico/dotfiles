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

    -- Completion: https://cmp.saghen.dev/recipes.html
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = 'rafamadriz/friendly-snippets',

        version = '*',

        -- @module 'blink.cmp'
        -- @type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = 'enter',
                ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
                ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
                ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
                ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
                ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
                ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
                ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
                ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
                ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
                ['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = false,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- Dynamically picking providers by treesitter node/filetype
            sources = {
                default = function(ctx)
                    local success, node = pcall(vim.treesitter.get_node)
                    if vim.bo.filetype == 'lua' then
                        return { 'lsp', 'path' }
                    elseif success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                        return { 'buffer' }
                    else
                        return { 'lsp', 'path', 'snippets', 'buffer' }
                    end
                end,
            },

            completion = {
                menu = {
                    min_width = 15,
                    max_height = 10,
                    auto_show = function(ctx)
                        -- Don't show on cmdline / searches
                        return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
                    end,


                    draw = {
                        columns = { { 'item_idx' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
                        components = {

                            -- Index for keymap
                            item_idx = {
                                text = function(ctx) return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx) end,
                                highlight = 'BlinkCmpItemIdx' -- optional, only if you want to change its color
                            },

                            -- Adjust icons
                            -- kind_icon = {
                            -- 	ellipsis = false,
                            -- 	text = function(ctx)
                            -- 		local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                            -- 		return kind_icon
                            -- 	end,
                            -- 	-- Optionally, you may also use the highlights from mini.icons
                            -- 	highlight = function(ctx)
                            -- 		local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                            -- 		return hl
                            -- 	end,
                            -- }
                        },
                        -- Use treesitter to highlight the label for the given list of sources (experimental)
                        treesitter = { 'lsp' },
                    },
                },

                -- Show documentation when selecting a completion item
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 2,
                },

                -- 'prefix' will fuzzy match on the text before the cursor
                -- 'full' will fuzzy match on the text before *and* after the cursor
                -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
                keyword = { range = 'prefix' },

                -- Insert completion item on selection, don't select by default
                list = { selection = 'auto_insert' },

            },
            signature = { enabled = true },
            fuzzy = {
                -- When enabled, allows for a number of typos relative to the length of the query
                -- Disabling this matches the behavior of fzf
                use_typo_resistance = true,
                -- Frecency tracks the most recently/frequently used items and boosts the score of the item
                use_frecency = true,
                -- Proximity bonus boosts the score of items matching nearby words
                use_proximity = true,
                -- max_items = 200,
                -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
                -- You may pass a function instead of a string to customize the sorting
                sorts = { 'score', 'sort_text' },

                prebuilt_binaries = {
                    -- Whether or not to automatically download a prebuilt binary from github. If this is set to `false`
                    -- you will need to manually build the fuzzy binary dependencies by running `cargo build --release`
                    download = true,
                    -- Extra arguments that will be passed to curl like { 'curl', ..extra_curl_args, ..built_in_args }
                    extra_curl_args = {}
                },
            }

        },
        opts_extend = { "sources.default" }
    },
    -- Docs: https://lsp-zero.netlify.app/docs/language-server-configuration.html
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' },

        opts = {
            servers = {
                lua_ls = {
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
                },


                gopls = {
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
                },


                yamlls = {
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
                                enable = true,                                             -- Automatically fetch schemas from schema store
                                url = "https://www.schemastore.org/api/json/catalog.json", -- URL for the schema store
                            },
                            validate = true,                                               -- Enable/disable validation
                            hover = true,                                                  -- Enable hover support
                            completion = true,                                             -- Enable completion support
                            format = {
                                enable = true,                                             -- Enable/disable formatting
                                singleQuote = false,                                       -- Use single quotes for scalars
                                bracketSpacing = true,                                     -- Add spaces between brackets
                                proseWrap = "preserve",                                    -- Wrap text in scalars: "always", "never", or "preserve"
                                printWidth = 180,                                          -- Wrap text longer than printWidth
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
                },

                jsonls = {
                    on_attach = on_attach,
                    cmd = { "vscode-json-language-server", "--stdio" },
                },

                pyright = {
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
                },

                bashls = {
                    on_attach = on_attach,
                },

                dockerls = {
                    on_attach = on_attach,
                },

                docker_compose_language_service = {
                    cmd = { "docker-compose-langserver", "--stdio" }
                },
            }
        },

        config = function(_, opts)
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

            local lspconfig = require('lspconfig')
            for server, config in pairs(opts.servers) do
                -- passing config.capabilities to blink.cmp merges with the capabilities in your
                -- `opts[server].capabilities, if you've defined it
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end
        end
    },

    -- Notification progress messages
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
                    max_size = 10000,            -- Maximum log file size, in KB
                    float_precision = 0.01,      -- Limit the number of decimals displayed for floats
                    path =                       -- Where Fidget writes its logs to
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
    -- 		vim.cmd("highlight MatchParen gui=underline guibg=black guifg=NONE")
    -- 	end,
    -- },

    -- Syntax highlighting
    -- { "sheerun/vim-polyglot" },

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
                matchup = {
                    enable = true,
                },
            })
        end,
    },

    -- Show code header/context when we are too far down (https://github.com/nvim-treesitter/nvim-treesitter-context)
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require('treesitter-context').setup({
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = '-',
            })
        end
    },

    -- Navigation through objects/functions/etc based on treesitter
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            -- Repeat movement
            -- vim way: ; goes to the direction you were moving.
            local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

            require('nvim-treesitter.configs').setup({
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
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
                            ['@function.outer'] = 'V',  -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>ts"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>tS"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = { query = "@block.outer", desc = "Next block start" },
                            --
                            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
                            ["]o"] = "@loop.*",
                            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                            --
                            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                            ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
                            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@block.inner",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                        -- Below will go to either the start or the end, whichever is closer.
                        -- Use if you want more granular movements
                        -- Make it even more gradual by adding multiple queries and regex.
                        goto_next = {
                            ["]d"] = "@conditional.outer",
                        },
                        goto_previous = {
                            ["[d"] = "@conditional.outer",
                        }
                    },
                },
            })
        end,
    },

    -- Provide better '%' matching with treesitter
    { "andymass/vim-matchup" },

    -- Split/unsplit arguments
    {
        'echasnovski/mini.splitjoin',
        version = '*',
        config = function()
            require('mini.splitjoin').setup({
                -- Module mappings. Use `''` (empty string) to disable one.
                -- Created for both Normal and Visual modes.
                mappings = {
                    toggle = '<leader>as',
                },
            })
        end
    },

    -- Surround quotes, etc (https://github.com/echasnovski/mini.surround/blob/main/README.md)
    -- saiw (Surround Add In Word)
    {
        'echasnovski/mini.surround',
        version = '*',
        config = function()
            require('mini.surround').setup({
                -- Add custom surroundings to be used on top of builtin ones. For more
                -- information with examples, see `:h MiniSurround.config`.
                custom_surroundings = nil,

                -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
                highlight_duration = 500,

                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    add = 'ra', -- Add surrounding in Normal and Visual modes
                    delete = 'rd', -- Delete surrounding
                    find = 'rf', -- Find surrounding (to the right)
                    find_left = 'rF', -- Find surrounding (to the left)
                    highlight = 'rh', -- Highlight surrounding
                    replace = 'rr', -- Replace surrounding
                    update_n_lines = 'rn', -- Update `n_lines`

                    suffix_last = 'l', -- Suffix to search with "prev" method
                    suffix_next = 'n', -- Suffix to search with "next" method
                },

                -- Number of lines within which surrounding is searched
                n_lines = 20,

                -- Whether to respect selection type:
                -- - Place surroundings on separate lines in linewise mode.
                -- - Place surroundings on each line in blockwise mode.
                respect_selection_type = false,

                -- How to search for surrounding (first inside current line, then inside
                -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
                -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
                -- see `:h MiniSurround.config`.
                search_method = 'cover',

                -- Whether to disable showing non-error feedback
                -- This also affects (purely informational) helper messages shown after
                -- idle time if user input is required.
                silent = false,
            })
        end,
    },

    -- Better auto inserting pair of characters
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

    { "pearofducks/ansible-vim" },

    -- Golang
    {
        "fatih/vim-go",
        config = function()
            -- Disable vim-go's LSP features
            vim.g.go_def_mapping_enabled = 0 -- Prevent conflict
            vim.g.go_def_mode = 'gopls'      -- Use gopls for Go-to-Definition
            vim.g.go_info_mode = 'gopls'     -- Use gopls for hover information
            vim.g.go_rename_command = "gopls"

            -- Disable redundant features
            vim.g.go_fmt_command = ''            -- Disable formatting (handled by LSP)
            vim.g.go_auto_type_info = 0          -- Disable type info on cursor hover
            vim.g.go_doc_keywordprg_enabled = 0  -- Disable keyword lookup (handled by LSP)
            vim.g.go_code_completion_enabled = 0 -- Disable vim-go's completion (use LSP or nvim-cmp)
            vim.g.go_textobj_enabled = 0         -- Disable text objects for structs, functions, etc.

            -- Disable diagnostics/linting (use LSP or nvim-lint)
            vim.g.go_metalinter_enabled = {} -- Disable Go Metalinter
            vim.g.go_metalinter_autosave = 0 -- Disable linting on save
            vim.g.go_list_type = ''          -- Disable quickfix and location list handling

            -- Disable jump handlers (use LSP for navigation)
            vim.g.go_jump_to_error = 0    -- Disable jump to error on compile
            vim.g.go_jump_to_type_def = 0 -- Disable jump to type definition
            vim.g.go_jump_to_struct = 0   -- Disable jump to struct fields

            -- Disable tag generation (use gopls code actions for this)
            vim.g.go_auto_sameids = 0          -- Disable automatic identifier highlighting
            vim.g.go_auto_sameids_use_tree = 0 -- Disable same ID highlighting using tree-sitter

            -- Disable unused imports removal (use LSP formatting or code actions)
            vim.g.go_remove_unused_imports = 0 -- Disable unused import removal

            -- Disable test-specific features (if using custom tooling)
            vim.g.go_term_enabled = 0   -- Disable terminal integration for tests
            vim.g.go_test_show_name = 0 -- Disable test name display
            vim.g.go_term_mode = ''     -- Disable vim-go terminal mode

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

    -- Golang test helper
    { 'buoto/gotests-vim' },


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

    -- Open your Kitty scrollback buffer with Neovim
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

    -- Show scope of current indent
    {
        'echasnovski/mini.indentscope',
        version = '*',
        config = function()
            require('mini.indentscope').setup()
        end,
    },

    -- Navigate using brackets
    {
        'echasnovski/mini.bracketed',
        version = '*',
        config = function()
            require('mini.bracketed').setup()
        end
    },

    -- Navigate using jump characters
    {
        'echasnovski/mini.jump2d',
        version = '*',
        config = function()
            require('mini.jump2d').setup()
        end
    },

    -- Rainbow parenthesis
    {
        'HiPhish/rainbow-delimiters.nvim',
        version = '*',
        config = function()
            require('rainbow-delimiters.setup').setup()
        end,
    },

    -- Edit filesystem as a buffer
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
        config = function()
            require("oil").setup()
        end
    },

}
