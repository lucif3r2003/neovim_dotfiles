return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate', -- tự động update parser khi cần
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { "go", "c_sharp", "java", "javascript", "lua" }, -- thêm lua cho chính config
      sync_install = false,
      auto_install = true,

      highlight = {
        enable = true,              -- bật highlight thông minh
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true               -- indent thông minh
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },
    }
  end
}

