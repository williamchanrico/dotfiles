-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- General settings
vim.o.cursorline = true
vim.opt.ttyfast = true
vim.opt.modeline = true
vim.opt.updatetime = 100
vim.opt.hidden = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.wrap = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.undofile = true
vim.opt.title = true
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Set match pairs and highlight
vim.opt.matchpairs:append("<:>")

-- Set <leader>yf to copy the full file path to the clipboard
vim.keymap.set('n', '<leader>yf', function()
	local filepath = vim.fn.expand('%:p')
	vim.fn.setreg('+', filepath) -- Copy to system clipboard
	vim.notify('Copied to clipboard: ' .. filepath, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = 'Copy full file path to clipboard' })

-- Clear search highlights.
vim.keymap.set("n", "<Leader>l", function()
	-- Execute the commands in sequence
	vim.cmd("nohlsearch")
	vim.cmd("diffupdate")
	vim.cmd("syntax sync fromstart")
	vim.cmd("redraw") -- Equivalent to <C-l>
end, { desc = "Clear search, update diff, resync syntax, and refresh screen" })

-- Toggle cursor underline and cursorcolumn
local cursor_coordinate_state = 1
function ToggleCursorCoordinate()
	if cursor_coordinate_state == 1 then
		-- Set the highlight for CursorLine with underline in GUI and Cterm
		vim.api.nvim_set_hl(0, "CursorLine", { underline = true })
		vim.opt.cursorcolumn = true
	else
		-- Clear the underline for CursorLine
		vim.api.nvim_set_hl(0, "CursorLine", { underline = false })
		vim.opt.cursorcolumn = false
	end
	-- Toggle the state
	cursor_coordinate_state = 1 - cursor_coordinate_state
end

-- Escape/unescape common characters (e.g. quotes, newlines, etc.)
local function escape_text()
	local current_line = vim.api.nvim_get_current_line()
	local escaped_line = current_line:gsub('"', '\\"'):gsub("\n", '\\n'):gsub("\t", '\\t'):gsub("\r", '\\r')
	vim.api.nvim_set_current_line(escaped_line)
end
local function unescape_text()
	local current_line = vim.api.nvim_get_current_line()
	local unescaped_line = current_line:gsub('\\"', '"'):gsub('\\n', '\n'):gsub('\\t', '\t'):gsub('\\r', '\r')
	vim.api.nvim_set_current_line(unescaped_line)
end
vim.keymap.set('v', '<Leader>ces', escape_text, { desc = "Escape text" })
vim.keymap.set('v', '<Leader>cEs', unescape_text, { desc = "Unescape text" })

-- Encode/unencode string
local function encode_url()
	local current_line = vim.api.nvim_get_current_line()
	local encoded_line = current_line:gsub("([^%w %-%._~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	vim.api.nvim_set_current_line(encoded_line)
end
local function decode_url()
	local current_line = vim.api.nvim_get_current_line()
	local decoded_line = current_line:gsub("%%([0-9a-fA-F][0-9a-fA-F])", function(hex)
		return string.char(tonumber(hex, 16))
	end)
	vim.api.nvim_set_current_line(decoded_line)
end
vim.keymap.set('v', '<Leader>ceu', encode_url, { desc = "URL encode text" })
vim.keymap.set('v', '<Leader>cEu', decode_url, { desc = "URL decode text" })

-- Highlight cursor
vim.keymap.set("n", "<Leader>v", function()
	ToggleCursorCoordinate()
end, { desc = "Toggle cursor highlight", noremap = true, silent = true })

-- From Kitty docs: Modern terminal detection for enhanced features in terminal emulators
-- Enable balloon evaluation in terminal
vim.api.nvim_set_var("balloonevalterm", true)
vim.api.nvim_set_var("t_AU", "\27[58:5:%dm")          -- Indexed underline
vim.api.nvim_set_var("t_8u", "\27[58:2:%lu:%lu:%lum") -- True color underline
vim.api.nvim_set_var("t_Us", "\27[4:2m")              -- Double underline
vim.api.nvim_set_var("t_Cs", "\27[4:3m")              -- Curly underline
vim.api.nvim_set_var("t_ds", "\27[4:4m")              -- Dotted underline
vim.api.nvim_set_var("t_Ds", "\27[4:5m")              -- Dashed underline
vim.api.nvim_set_var("t_Ce", "\27[4:0m")              -- Reset underline
-- Strikethrough
vim.api.nvim_set_var("t_Ts", "\27[9m")
vim.api.nvim_set_var("t_Te", "\27[29m")
-- Truecolor support
vim.api.nvim_set_var("t_8f", "\27[38:2:%lu:%lu:%lum") -- Truecolor foreground
vim.api.nvim_set_var("t_8b", "\27[48:2:%lu:%lu:%lum") -- Truecolor background
vim.api.nvim_set_var("t_RF", "\27]10;?\27\\")
vim.api.nvim_set_var("t_RB", "\27]11;?\27\\")
-- Bracketed paste
vim.api.nvim_set_var("t_BE", "\27[?2004h") -- Enable bracketed paste
vim.api.nvim_set_var("t_BD", "\27[?2004l") -- Disable bracketed paste
vim.api.nvim_set_var("t_PS", "\27[200~")   -- Start paste
vim.api.nvim_set_var("t_PE", "\27[201~")   -- End paste
-- Cursor control
vim.api.nvim_set_var("t_RC", "\27[?12$p")  -- Request cursor state
vim.api.nvim_set_var("t_SH", "\27[%d q")   -- Set cursor shape
vim.api.nvim_set_var("t_RS", "\27P$q q\27\\")
vim.api.nvim_set_var("t_SI", "\27[5 q")    -- Insert mode cursor
vim.api.nvim_set_var("t_SR", "\27[3 q")    -- Replace mode cursor
vim.api.nvim_set_var("t_EI", "\27[1 q")    -- Normal mode cursor
vim.api.nvim_set_var("t_VS", "\27[?12l")   -- Disable cursor blinking
-- Focus tracking
vim.api.nvim_set_var("t_fe", "\27[?1004h") -- Enable focus tracking
vim.api.nvim_set_var("t_fd", "\27[?1004l") -- Disable focus tracking
vim.cmd([[set <FocusGained>=\e[I]])
vim.cmd([[set <FocusLost>=\e[O]])
-- Window title control
vim.api.nvim_set_var("t_ST", "\27[22;2t") -- Save window title
vim.api.nvim_set_var("t_RT", "\27[23;2t") -- Restore window title

-- Set password-store filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "/dev/shm/pass*",
	command = "set ft=yaml",
})

-- Go to the last cursor position after opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd("normal! g`\"") -- Go to the last cursor position
		end
	end,
})

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
})
