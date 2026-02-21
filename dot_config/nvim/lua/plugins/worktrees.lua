-- Simple git worktree switcher using Snacks picker (no external plugin needed)
local function switch_worktree()
  local output = vim.fn.system("git worktree list --porcelain")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  local worktrees = {}
  local current
  for path in output:gmatch("worktree ([^\n]+)") do
    table.insert(worktrees, path)
  end

  current = vim.fn.getcwd()

  Snacks.picker({
    title = "Git Worktrees",
    items = vim.tbl_map(function(path)
      local branch = vim.fn.system("git -C " .. vim.fn.shellescape(path) .. " branch --show-current 2>/dev/null"):gsub("\n", "")
      local label = (path == current and "* " or "  ") .. branch .. "  " .. path
      return { text = label, path = path }
    end, worktrees),
    format = function(item)
      return { { item.text } }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.cmd("cd " .. vim.fn.fnameescape(item.path))
      vim.cmd("enew")
      vim.notify("Switched to " .. item.path)
    end,
  })
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gw", switch_worktree, desc = "Switch worktree" },
    },
  },
}
