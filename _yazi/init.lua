-- Border
require("full-border"):setup {
    -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
    type = ui.Border.ROUNDED,
}

-- Show user/group
Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil or ya.target_family() ~= "unix" then
        return ""
    end

    return ui.Line {
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        " ",
    }
end, 500, Status.RIGHT)

-- Hide preview when yazi is opened inside nvim
if os.getenv("NVIM") then
    require("hide-preview"):entry()
end

-- git.yazi (https://github.com/yazi-rs/plugins/tree/main/git.yazi)
require("git"):setup()

-- yatline.yazi (https://github.com/imsi32/yatline.yazi/wiki)
require("yatline"):setup({
    show_background = true,

    header_line = {
        left = {
            section_a = {
            },
            section_b = {
            },
            section_c = {
            }
        },
        right = {
            section_a = {
            },
            section_b = {
            },
            section_c = {
            }
        }
    },
    status_line = {
        left = {
            section_a = {
                { type = "string", custom = false, name = "tab_mode" },
            },
            section_b = {
                { type = "string", custom = false, name = "hovered_size" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_name" },
            }
        },
        right = {
            section_a = {
                { type = "string", custom = false, name = "cursor_position" },
            },
            section_b = {
                { type = "string", custom = false, name = "cursor_percentage" },
            },
            section_c = {
                { type = "coloreds", custom = false, name = "permissions" },
            }
        }
    },
})

-- Example rule: make Downloads folder sorted by modtime, while others alphabetically.
require("folder-rules"):setup()

-- Show symlink in status bar
Status:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
        return " -> " .. tostring(h.link_to)
    else
        return ""
    end
end, 3300, Status.LEFT)

-- dedukun/bookmarks.yazi
require("bookmarks"):setup({
    last_directory = { enable = true, persist = true },
    persist = "all",
    desc_format = "full",
    file_pick_mode = "hover",
    notify = {
        enable = true,
        timeout = 1,
        message = {
            new = "New bookmark '<key>' -> '<folder>'",
            delete = "Deleted bookmark in '<key>'",
            delete_all = "Deleted all bookmarks",
        },
    },
})
