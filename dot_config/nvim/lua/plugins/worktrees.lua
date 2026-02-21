return {
  {
    "Juksuu/worktrees.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "GitWorktreeCreate", "GitWorktreeSwitch", "GitWorktreeCreateExisting", "GitWorktreeRemove" },
    keys = {
      { "<leader>gw", "<cmd>GitWorktreeSwitch<cr>", desc = "Switch worktree" },
      { "<leader>gW", "<cmd>GitWorktreeCreate<cr>", desc = "Create worktree" },
    },
    opts = {},
  },
}
