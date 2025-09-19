return {
  "nvimtools/none-ls.nvim", -- fork mới của null-ls
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Go
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,

        -- JS/TS
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint_d,

        -- C#
        -- (không có nhiều formatter, thường rely vào omnisharp)

        -- Java
        -- (đa số rely vào jdtls để format)
      },
    })

    -- Keymap: format file
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
  end,
}


