-- Full border frame
require("full-border"):setup()

-- Git status indicators
require("git"):setup({
	order = 1500,
})

-- Starship prompt in header
require("starship"):setup()

-- Relative motions (numbers disabled — clashes with selection styling)
require("relative-motions"):setup({
	show_motion = true,
})
