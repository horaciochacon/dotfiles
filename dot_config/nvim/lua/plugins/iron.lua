return {
  {
    "Vigemus/iron.nvim",
    keys = {
      { "<S-CR>", desc = "Smart send to REPL" },
      { "<S-CR>", mode = "v", desc = "Send selection to REPL" },
      { "<leader>sc", desc = "Send motion to REPL" },
      { "<leader>rs", desc = "Open/toggle REPL" },
      { "<leader>rr", desc = "Restart REPL" },
    },
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { "ipython", "--no-autoindent" },
              format = common.bracketed_paste,
            },
            r = {
              command = { "R" },
            },
          },
          repl_open_cmd = view.split.vertical.botright(80),
        },
        keymaps = {
          visual_send = "<S-CR>",
          send_motion = "<leader>sc",
          toggle_repl = "<leader>rs",
          restart_repl = "<leader>rr",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      -- Skip blank lines and place cursor at the start of the next code line
      local function move_to_next_code_line(line)
        local buf_lines = vim.api.nvim_buf_line_count(0)
        local target = math.min(line, buf_lines)
        while target <= buf_lines do
          local text = vim.api.nvim_buf_get_lines(0, target - 1, target, false)[1]
          if text and text:match("%S") then break end
          target = target + 1
        end
        vim.api.nvim_win_set_cursor(0, { math.min(target, buf_lines), 0 })
        vim.cmd("normal! ^")
      end

      -- Smart send (Shift+Enter in normal mode):
      -- Detects the smallest enclosing block (function, class, loop, conditional)
      -- via nvim-treesitter-textobjects queries, sends it directly, then moves
      -- the cursor to the next line with code. Falls back to sending the current line.
      vim.keymap.set("n", "<S-CR>", function()
        local shared = require("nvim-treesitter-textobjects.shared")
        local captures = { "@function.outer", "@class.outer", "@loop.outer", "@conditional.outer" }

        local best_range = nil
        local best_size = math.huge
        for _, capture in ipairs(captures) do
          local range = shared.textobject_at_point(capture, "textobjects", 0, nil, {})
          if range then
            local size = range[4] - range[1]
            if size < best_size then
              best_range = range
              best_size = size
            end
          end
        end

        if best_range then
          local lines = vim.api.nvim_buf_get_lines(0, best_range[1], best_range[4] + 1, false)
          iron.send(nil, lines)
          move_to_next_code_line(best_range[4] + 2)
        else
          iron.send_line()
          local cursor = vim.api.nvim_win_get_cursor(0)
          move_to_next_code_line(cursor[1] + 1)
        end
      end, { silent = true, desc = "Smart send to REPL" })
    end,
  },
}
