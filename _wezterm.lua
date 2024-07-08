local wezterm = require 'wezterm';
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

-- Hide title bar, but allow resize.
config.window_decorations = "RESIZE"

-- Visual Bell
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 150,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 150
}

-- Base16 Seti UI Colors
config.colors = {
    visual_bell = "#202020",
    foreground = "#d6d6d6",
    background = "#151718",
    cursor_bg = "#d6d6d6",
    cursor_fg = "#151718",
    cursor_border = "#d6d6d6",
    selection_bg = "#41535B",
    selection_fg = "#d6d6d6",
    ansi = {
        "#151718", -- base00
        "#Cd3f45", -- base08
        "#9fca56", -- base0B
        "#e6cd69", -- base0A
        "#55b5db", -- base0D
        "#a074c4", -- base0E
        "#55dbbe", -- base0C
        "#d6d6d6" -- base05
    },
    brights = {
        "#41535B", -- base03
        "#Cd3f45", -- base08
        "#9fca56", -- base0B
        "#e6cd69", -- base0A
        "#55b5db", -- base0D
        "#a074c4", -- base0E
        "#55dbbe", -- base0C
        "#ffffff" -- base07
    },
    indexed = {
        [16] = "#db7b55", -- base09
        [17] = "#8a553f", -- base0F
        [18] = "#8ec43d", -- base01
        [19] = "#3B758C", -- base02
        [20] = "#43a5d5", -- base04
        [21] = "#eeeeee" -- base06
    }
}
-- Font Configuration
config.font = wezterm.font_with_fallback({
    "DejaVuSansM Nerd Font Mono", "Font Awesome 5 Free", "EmojiOne"
})
config.font_size = 14.0
-- Window configuration
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {left = 5, right = 5, top = 5, bottom = 5}

-- Scrollback and other settings
config.enable_scroll_bar = true
config.scrollback_lines = 99999
config.automatically_reload_config = true

config.check_for_updates = false

-- Keybindings
local copy_mode = nil
local search_mode = nil
if wezterm.gui then
    copy_mode = wezterm.gui.default_key_tables().copy_mode
    search_mode = wezterm.gui.default_key_tables().search_mode

    table.insert(copy_mode, {
        key = 'y',
        mods = 'NONE',
        action = act.Multiple {
            act.CopyTo 'ClipboardAndPrimarySelection', act.ClearSelection,
            act.CopyMode 'Close'
        }
    })

    table.insert(copy_mode, {
        key = 'w',
        mods = 'SHIFT',
        action = act.Multiple {act.CopyMode 'MoveForwardWord'}
    })

    table.insert(copy_mode, {
        key = 'e',
        mods = 'SHIFT',
        action = act.Multiple {act.CopyMode 'MoveForwardWordEnd'}
    })

    table.insert(copy_mode, {
        key = 'b',
        mods = 'SHIFT',
        action = act.Multiple {act.CopyMode 'MoveBackwardWord'}
    })

    table.insert(search_mode, {
        key = 'Enter',
        mods = 'NONE',
        action = act.Multiple {
            act.CopyTo 'ClipboardAndPrimarySelection', act.ClearSelection,
            act.CopyMode 'Close'
        }
    })

    table.insert(search_mode, {
        key = 'Backspace',
        mods = 'SUPER',
        action = act.CopyMode 'ClearPattern'
    })
end

config.key_tables = {copy_mode = copy_mode, search_mode = search_mode}
config.keys = {
    -- Turn off the default CMD-m Hide action, allowing CMD-m to
    -- be potentially recognized and handled by the tab
    {key = 'm', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment},
    {key = 'w', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment},
    {
        key = 'w',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment
    }, {
        key = "V",
        mods = "SHIFT|SUPER",
        action = wezterm.action.PasteFrom("Clipboard")
    },
    {
        key = "C",
        mods = "SHIFT|CTRL",
        action = wezterm.action.CopyTo("Clipboard")
    }, {key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize},
    {key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize},
    {key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize},
    -- Custom keybinding to enter hyperlink selection mode
    {
        key = "u",
        mods = "ALT",
        action = wezterm.action {
            QuickSelectArgs = {
                patterns = {"\\b\\w+://\\S*\\b"},
                action = wezterm.action_callback(
                    function(window, pane)
                        local url = window:get_selection_text_for_pane(pane)
                        wezterm.log_info("opening: " .. url)
                        wezterm.open_with(url)
                    end)
            }
        }
    }, -- Custom keybinding to enter search mode
    {
        key = "f",
        mods = "SHIFT|SUPER",
        action = wezterm.action.Search {CaseSensitiveString = ""}
    }, -- Custom keybinding to enter copy mode
    {key = "i", mods = "ALT", action = wezterm.action.ActivateCopyMode},
    {key = "PageUp", mods = "NONE", action = wezterm.action.ScrollByPage(-1)},
    {key = "PageDown", mods = "NONE", action = wezterm.action.ScrollByPage(1)},
    {key = "u", mods = "SHIFT|CTRL", action = wezterm.action.ScrollByLine(-1)},
    {key = "d", mods = "SHIFT|CTRL", action = wezterm.action.ScrollByLine(1)},
    -- Custom Split Management
    {
        key = "e",
        mods = "ALT|SHIFT",
        action = wezterm.action.SplitHorizontal {domain = "CurrentPaneDomain"}
    }, {
        key = "e",
        mods = "ALT|SHIFT|CTRL|SUPER",
        action = wezterm.action.SplitHorizontal {domain = "CurrentPaneDomain"}
    }, -- MacOS
    {
        key = "o",
        mods = "ALT|SHIFT",
        action = wezterm.action.SplitVertical {domain = "CurrentPaneDomain"}
    }, {
        key = "o",
        mods = "ALT|SHIFT|CTRL|SUPER",
        action = wezterm.action.SplitVertical {domain = "CurrentPaneDomain"}
    }, -- MacOS
    {
        key = "h",
        mods = "SUPER",
        action = wezterm.action.ActivatePaneDirection("Left")
    }, {
        key = "h",
        mods = "ALT|SHIFT|CTRL|SUPER",
        action = wezterm.action.ActivatePaneDirection("Left")
    }, -- MacOS
    {
        key = "l",
        mods = "SUPER",
        action = wezterm.action.ActivatePaneDirection("Right")
    }, {
        key = "l",
        mods = "ALT|SHIFT|CTRL|SUPER",
        action = wezterm.action.ActivatePaneDirection("Right")
    }, -- MacOS
    {
        key = "k",
        mods = "SUPER",
        action = wezterm.action.ActivatePaneDirection("Up")
    }, {
        key = "k",
        mods = "ALT|SHIFT|CTRL|SUPER",
        action = wezterm.action.ActivatePaneDirection("Up")
    }, -- MacOS
    {
        key = "j",
        mods = "SUPER",
        action = wezterm.action.ActivatePaneDirection("Down")
    }, {
        key = "j",
        mods = "ALT|SHIFT|CTRL|SUPER",
        action = wezterm.action.ActivatePaneDirection("Down")
    }, -- MacOS
    -- Keybindings for Tab Management
    {
        key = "t",
        mods = "CTRL",
        action = wezterm.action.SpawnTab("CurrentPaneDomain")
    },
    {key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1)},
    {
        key = "Tab",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ActivateTabRelative(-1)
    }, -- Quick Reload Configuration
    {
        key = "r",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ReloadConfiguration
    }, -- Fullscreen Toggle
    {key = "Enter", mods = "CTRL", action = wezterm.action.ToggleFullScreen},
    {key = "f", mods = "SUPER", action = wezterm.action.TogglePaneZoomState}, {
        key = "f",
        mods = "ALT|SHIFT|CTRL|SUPER",
        action = wezterm.action.TogglePaneZoomState
    } -- MacOS

}

-- Enable TrueColor and cursor settings
config.enable_wayland = false
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 800
config.force_reverse_video_cursor = true

-- Hyperlinks

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- Enable hyperlinking
enable_hyperlinks = true

return config
