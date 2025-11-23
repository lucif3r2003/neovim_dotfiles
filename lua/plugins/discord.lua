return {
  {
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup({
        auto_update = true,
        neovim_image_text = "Coding with Neovim",
        main_image = "file",
        buttons = true,
        show_time = true,
      })
    end,
  },
}

