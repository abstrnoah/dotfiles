lua require("forester").setup()

lua vim.keymap.set("n", "<leader>n.", "<cmd>Forester browse<CR>", { silent = true })
lua vim.keymap.set("n", "<leader>nn", "<cmd>Forester new<CR>", { silent = true })
lua vim.keymap.set("n", "<leader>nr", "<cmd>Forester new_random<CR>", { silent = true })
lua vim.keymap.set("i", "<C-t>", "<cmd>Forester transclude<CR>", { silent = true })
lua vim.keymap.set("i", "<C-l>", "<cmd>Forester link<CR>", { silent = true })
