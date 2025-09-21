return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
            ensure_installed = { "zls", "gopls", "ts_ls" },
        },
    },

    -- nvim-lspconfig
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Lua
            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- TypeScript/JS
            vim.lsp.config("ts_ls", { capabilities = capabilities })
            vim.lsp.config("eslint", { capabilities = capabilities })

            -- Zig
            vim.lsp.config("zls", { capabilities = capabilities })

            -- YAML
            vim.lsp.config("yamlls", { capabilities = capabilities })

            -- Golang
            vim.lsp.config("gopls", { capabilities = capabilities })

            -- Nix
            vim.lsp.config("rnix", { capabilities = capabilities })

            -- Protocol Buffers
            vim.lsp.config("buf_ls", { 
                capabilities = capabilities,
                filetypes = { "proto" }
            })

            -- Svelte
            vim.lsp.config("svelte", { capabilities = capabilities })

            -- Python
            vim.lsp.config("pylsp", { capabilities = capabilities })

            -- Bash
            vim.lsp.config("bashls", { capabilities = capabilities })

            -- LSP keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

            -- List all methods in a file
            vim.keymap.set("n", "<leader>fm", function()
                local filetype = vim.bo.filetype
                local symbols_map = {
                    python = "function",
                    javascript = "function",
                    typescript = "function",
                    java = "class",
                    lua = "function",
                    go = { "method", "struct", "interface" },
                }
                local symbols = symbols_map[filetype] or "function"
                
                -- Ensure symbols is an array for fzf-lua
                if type(symbols) ~= "table" then
                    symbols = { symbols }
                end
                
                require("fzf-lua").lsp_document_symbols({ symbols = symbols })
            end, { desc = "Find methods" })
        end,
    },


    -- Java LSP
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
    }
}
