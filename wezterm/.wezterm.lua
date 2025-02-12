local function changeBackground(conf, img_path)
	conf.background = {
		{
			source = {
				File = img_path,
			},
			repeat_x = "NoRepeat",
			repeat_y = "NoRepeat",
			horizontal_align = "Right",
			vertical_align = "Middle",
			hsb = {
				brightness = 0.4,
			},
		},
		{
			-- blend the image into the current color scheme
			source = {
				Color = "#002b36",
			},
			height = "100%",
			width = "100%",
			opacity = 0.85,
		},
	}
end

function OSname()
	local pattern = package.config:sub(1, 1)
	if pattern == "/" then
		return "mac"
	elseif pattern == "\\" then
		return "win"
	else
		return "unknown"
	end
end

-- Start configurating from here
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Solarized (dark) (terminal.sexy)"
config.font = wezterm.font("BlexMono Nerd Font")
config.font_size = OSname() == "win" and 12 or 15

config.enable_tab_bar = false
-- config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	bottom = 0,
	top = 0,
}

local dir_path = OSname() == "win" and os.getenv("LOCALAPPDATA") or os.getenv("HOME") .. "/.config"
local bg_path = dir_path .. "/nvim/bg_imgs/blue.png"
changeBackground(config, bg_path)

config.default_prog = { OSname() == "win" and "wsl" or "/opt/homebrew/bin/fish" }

local toggle_transparency = {
	brief = "Toggle terminal transparency",
	icon = "md_circle_opacity",
	action = wezterm.action_callback(function(window)
		local overrides = window:get_config_overrides() or {}

		if not overrides.window_background_opacity or overrides.window_background_opacity == 1 then
			-- Set opacity to 0.8 (semi-transparent) and remove background image
			overrides.window_background_opacity = 0.87
			if OSname == "mac" then
				overrides.macos_window_background_blur = 50
			end
			overrides.background = {}
		else
			-- Set opacity back to 1 (full opacity) and apply the background image
			overrides.window_background_opacity = 1

			changeBackground(overrides, bg_path)
		end

		-- Apply the config overrides
		window:set_config_overrides(overrides)
	end),
}

-- Register the custom command to the command palette
wezterm.on("augment-command-palette", function()
	return { toggle_transparency }
end)

-- Using Ctrl-Space in vim
-- need to disable Ctrl Space selection of keyboard setting (input sources) on MacOS
return config
