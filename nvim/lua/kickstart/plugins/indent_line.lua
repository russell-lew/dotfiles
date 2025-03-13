return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>ibl', ':IBLToggle<CR>', { noremap = true, silent = true })
    end,
  },
}
