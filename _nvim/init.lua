-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- enable 24-bit colour
vim.o.termguicolors = true

vim.o.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"

require("config.lazy")
