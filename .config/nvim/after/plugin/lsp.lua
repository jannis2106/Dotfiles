local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "tsserver",
    "eslint",
    "pyright",
    "lua_ls",
    "marksman",
    "clangd",
    "texlab",
    "ltex"
})

-- start language servers
require 'lspconfig'.rust_analyzer.setup {}
require 'lspconfig'.marksman.setup {}
require 'lspconfig'.clangd.setup {}
require'lspconfig'.texlab.setup{}
require'lspconfig'.ltex.setup{
    settings = {
		ltex = {
			language = "de-de",
		},
	}
}

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)           -- go to definition
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)                 -- see detailed definition
    vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, opts) -- open diagnostic
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)         -- go to next diagnostic
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)         -- go to previous diagnostic
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)       -- rename
end)

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.setup()
