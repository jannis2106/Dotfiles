return require("packer").startup(function(use)
    -- packer itself
    use 'wbthomason/packer.nvim'

    -- fuzzy finder
    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.0",
        requires = { { "nvim-lua/plenary.nvim" } }
    }

    -- color scheme
    use({
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    })

    -- treesitter
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

    -- lsp
    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },             -- Required
            { "williamboman/mason.nvim" },           -- Optional
            { "williamboman/mason-lspconfig.nvim" }, -- Optional

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },     -- Required
            { "hrsh7th/cmp-nvim-lsp" }, -- Required
            { "L3MON4D3/LuaSnip" },     -- Required
        }
    }

    -- colored hex-codes
    use("norcalli/nvim-colorizer.lua")

    -- lualine
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }

    -- vimtex
    use("lervag/vimtex")

    -- git diffs
    use("airblade/vim-gitgutter")
end)
