lua vim.keymap.set("n", "<leader>np", "<cmd>Forester browse<CR>", { silent = true })
lua vim.keymap.set("n", "<leader>nn", "<cmd>Forester new<CR>", { silent = true })
lua vim.keymap.set("i", "<C-t>", "<cmd>Forester transclude_new<CR>", { silent = true })
lua vim.keymap.set("i", "<C-l>", "<cmd>Forester link_new<CR>", { silent = true })
