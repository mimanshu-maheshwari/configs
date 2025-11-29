-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({ "Hasklug Nerd Font Mono", "Hurmit Nerd Font Mono", "JetBrains Mono" })

config.colors = {
	tab_bar = {
		inactive_tab_edge = "#575757",
	},
}
-- config.initial_cols = 130
-- config.initial_rows = 35
config.line_height = 1
config.font_size = 13
-- config.color_scheme = "AlienBlood"
-- config.color_scheme = "tlh (terminal.sexy)"
config.color_scheme = "Srcery (Gogh)"
config.scrollback_lines = 35000
config.show_tab_index_in_tab_bar = true
config.leader = { key = "Space", mods = "CTRL|SHIFT", timeout = 3 }
config.window_padding = {
	left = 2,
	right = 1,
	top = 0,
	bottom = 0,
}
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)
-- config.launch_menu = {
-- 	{
-- 		label = "Debian",
-- 		args = { "wsl", "~", "-d", "Debian", "tmux", "new-session", "-A", "-s", "main" },
-- 	},
-- }
config.wsl_domains = {
	{
		-- The name of this specific domain.  Must be unique amonst all types
		-- of domain in the configuration file.
		name = "WSL:Debian",

		-- The name of the distribution.  This identifies the WSL distribution.
		-- It must match a valid distribution from your `wsl -l -v` output in
		-- order for the domain to be useful.
		distribution = "Debian",

		-- The username to use when spawning commands in the distribution.
		-- If omitted, the default user for that distribution will be used.

		username = "avidvivarta",

		-- The current working directory to use when spawning commands, if
		-- the SpawnCommand doesn't otherwise specify the directory.

		default_cwd = "~",

		-- The default command to run, if the SpawnCommand doesn't otherwise
		-- override it.  Note that you may prefer to use `chsh` to set the
		-- default shell for your user inside WSL to avoid needing to
		-- specify it here

		default_prog = { "tmux" }, --, "new-session", "-A" , "-s main" },
	},
}
config.default_domain = "WSL:Debian"

-- config.window_frame = {
-- 	border_left_width = "0.25cell",
-- 	border_right_width = "0.25cell",
-- 	border_bottom_height = "0.25cell",
-- 	border_top_height = "0.25cell",
-- 	border_left_color = "#2b2042",
-- 	border_right_color = "#2b2042",
-- 	border_bottom_color = "#2b2042",
-- 	border_top_color = "#2b2042",
-- 	inactive_titlebar_bg = "#353535",
-- 	active_titlebar_bg = "#2b2042",
-- 	inactive_titlebar_fg = "#cccccc",
-- 	active_titlebar_fg = "#ffffff",
-- 	inactive_titlebar_border_bottom = "#2b2042",
-- 	active_titlebar_border_bottom = "#2b2042",
-- 	button_fg = "#cccccc",
-- 	button_bg = "#2b2042",
-- 	button_hover_fg = "#ffffff",
-- 	button_hover_bg = "#3b3052",
-- }
config.keys = {
	-- {
	-- 	key = "|",
	-- 	mods = "LEADER|SHIFT",
	-- 	action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	-- },
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = act.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "d",
		mods = "LEADER|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "a",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "activate_pane",
		}),
	},
}
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
}
-- config.wsl_domains = {
--   {
--     -- The name of this specific domain.  Must be unique amonst all types
--     -- of domain in the configuration file.
--     name = 'WSL:Ubuntu-18.04',
--
--     -- The name of the distribution.  This identifies the WSL distribution.
--     -- It must match a valid distribution from your `wsl -l -v` output in
--     -- order for the domain to be useful.
--     distribution = 'Ubuntu-18.04',
--
--     -- The username to use when spawning commands in the distribution.
--     -- If omitted, the default user for that distribution will be used.
--
--     -- username = "hunter",
--
--     -- The current working directory to use when spawning commands, if
--     -- the SpawnCommand doesn't otherwise specify the directory.
--
--     -- default_cwd = "/tmp"
--
--     -- The default command to run, if the SpawnCommand doesn't otherwise
--     -- override it.  Note that you may prefer to use `chsh` to set the
--     -- default shell for your user inside WSL to avoid needing to
--     -- specify it here
--
--     -- default_prog = {"fish"}
--   },
-- }

-- Finally, return the configuration to wezterm:
return config
