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
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- config.initial_cols = 130
-- config.initial_rows = 35
config.line_height = 1
config.font_size = 13
-- config.color_scheme = "AlienBlood"
-- config.color_scheme = "tlh (terminal.sexy)"
config.color_scheme = "Srcery (Gogh)"
config.scrollback_lines = 35000
config.show_tab_index_in_tab_bar = true
config.leader = { key = "a", mods = "CTRL", timeout = 2 }
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
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

config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },

	-- split pane
	{ key = '"', mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- vi mode
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },

	-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{ key = "a", mods = "LEADER", action = act.ActivateKeyTable({ name = "activate_pane" }) },

	-- resize pane
	{ key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- move between pane
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

	-- spawn tab
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
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

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32

config.colors = {
	tab_bar = {
		-- Top strip background
		background = "#1b1918", -- base00

		-- Active tab (current)
		active_tab = {
			bg_color = "#68615e", -- base02
			fg_color = "#f1efee", -- base07
			intensity = "Bold",
			underline = "Single",
			italic = false,
			strikethrough = false,
		},

		-- Inactive tabs
		inactive_tab = {
			bg_color = "#2c2421", -- base01
			fg_color = "#a8a19f", -- base05
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		-- Inactive tab on hover
		inactive_tab_hover = {
			bg_color = "#766e6b", -- base03
			fg_color = "#e6e2e0", -- base06
			intensity = "Normal",
			underline = "Single",
			italic = true,
			strikethrough = false,
		},

		-- New tab button
		new_tab = {
			bg_color = "#2c2421", -- base01
			fg_color = "#7b9726", -- base0B
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		-- New tab on hover
		new_tab_hover = {
			bg_color = "#68615e", -- base02
			fg_color = "#407ee7", -- base0D
			intensity = "Normal",
			underline = "Single",
			italic = true,
			strikethrough = false,
		},
	},
}
-- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
-- config.tab_bar_style = {
-- active_tab_left = wezterm.format {
--   { Background = { Color = '#0b0022' } },
--   { Foreground = { Color = '#2b2042' } },
--   { Text = SOLID_LEFT_ARROW },
-- },
-- active_tab_right = wezterm.format {
--   { Background = { Color = '#0b0022' } },
--   { Foreground = { Color = '#2b2042' } },
--   { Text = SOLID_RIGHT_ARROW },
-- },
-- inactive_tab_left = wezterm.format {
--   { Background = { Color = '#0b0022' } },
--   { Foreground = { Color = '#1b1032' } },
--   { Text = SOLID_LEFT_ARROW },
-- },
-- inactive_tab_right = wezterm.format {
--   { Background = { Color = '#0b0022' } },
--   { Foreground = { Color = '#1b1032' } },
--   { Text = SOLID_RIGHT_ARROW },
-- },
-- }

-- Finally, return the configuration to wezterm:
return config
