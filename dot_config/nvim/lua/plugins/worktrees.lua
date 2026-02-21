return {
  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("git_worktree")

      -- Register hooks for proper buffer handling on switch
      local Hooks = require("git-worktree.hooks")
      Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
    end,
    keys = {
      {
        "<leader>gw",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Switch worktree",
      },
      {
        "<leader>gW",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "Create worktree",
      },
    },
  },
}
