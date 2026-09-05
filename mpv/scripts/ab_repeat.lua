-- This script enables a frame precise A-B repeat functionality in MPV. It allows you to set an A point (start) and a B point (end) in a video or audio file to loop playback between these two points. If only an A point is set, it loops from A to the end of the file. If only an B point is set, it auto loops from the start of the video. The script also provides a reset function to clear the points.
--
-- You can also save, load and delete your AB-Repeats. Multiple AB-Repeat-Ranges per video are allowed. See the Keybindings. When you save an AB-Repeat, you can input an name for it or just press Enter for an default enumerated name.
--
-- Keybindings: You can change the keys used to set A point ("HOME"), B point ("END"), and reset points ("DEL") by modifying the mp.add_key_binding lines below. For example, replace "HOME" with "a" to use the 'a' key instead. Check MPV's documentation for valid key names. There are also Hotkeys for saving ("CTRL+S"), loading ("CTRL+L") and deleting ("CTRL+DEL") AB-Repeat-Ranges.
--
-- This source code is public domain, do whatever you want.

local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

-- Configuration Variables
local CONFIG = {
    -- Automatically set A point to 0 if B is set first
    auto_set_a_point = true,
    -- Automatically set B point to last frame if A is set
    auto_set_b_point = true,
    -- Enable end-file handler as fallback for looping when B point is near video end, useful for streams or files with metadata issues
    use_end_file_handler = true,
    -- Show OSD messages for user actions like setting points, starting loops or if stored repeats are found for a video. Critical msgs, menus or feedback is still shown.
    show_osd_messages = true,
    -- Tolerance (in seconds) for triggering loop before B point, applied only in the end region for automatic B points
    b_point_tolerance = 0.1,
    -- Duration (in seconds) of the end region before video end where b_point_tolerance is applied
    end_region_duration = 1.0,
    -- Timeout (in seconds) for the end-file handler seek to ensure reliability on slow systems or streams
    end_file_timeout = 0.01,
    -- Duration (in seconds) for displaying the load/delete menu
    menu_display_duration = 10,
    -- Reset AB points when a new file is loaded (different from the current file)
    reset_on_new_file = true,
    -- Show OSD message indicating if stored AB ranges exist for a new file
    show_stored_ranges_message = true,
    -- Number of entries to show per page in the load/delete menu
    entries_per_page = 10
}

local CONFIG_ROOT = (os.getenv('APPDATA') or os.getenv('HOME')..'/.config')..'/mpv/'
if not utils.file_info(CONFIG_ROOT) then
    local mpv_conf_path = mp.find_config_file("scripts")
    local mpv_conf_dir = utils.split_path(mpv_conf_path)
    CONFIG_ROOT = mpv_conf_dir
end
local AB_RANGES_DB = CONFIG_ROOT..'ab_repeat.json'

local a_point = nil
local b_point = nil
local initial_loop_file_value = mp.get_property("loop-file", "no")
local video_duration = 0
local video_fps = 30
local last_video_key = nil
local menu_active = false
local active_menu_data = nil
local active_save_data = nil
local menu_close_timer = nil

local function format_time(t)
    if type(t) ~= "number" then return t end
    return string.format("%.3f", t)
end

local function get_key_for_index(i)
    if i >= 1 and i <= 9 then
        return tostring(i)
    elseif i >= 10 and i <= 35 then
        return string.char(string.byte('a') + (i - 10))
    else
        return nil
    end
end

local function close_menu(by_selection)
    if not menu_active or not active_menu_data then return end
    if menu_close_timer then
        menu_close_timer:kill()
        menu_close_timer = nil
    end

    menu_active = false
    for _, binding in ipairs(active_menu_data.item_bindings) do
        mp.remove_key_binding(binding.name)
    end
    if active_menu_data.action == "delete" then
        mp.remove_key_binding("delete_all_ranges")
    end
    mp.remove_key_binding("menu_esc")
    mp.remove_key_binding("menu_pgup")
    mp.remove_key_binding("menu_pgdwn")

    for _, binding in ipairs(active_menu_data.blocked_keys) do
        mp.remove_key_binding(binding.name)
    end
    active_menu_data.blocked_keys = {}

    if by_selection == nil then
        mp.osd_message("", 0.1)
    end
    active_menu_data = nil
end

local function reset_menu_timeout()
    if menu_close_timer then
        menu_close_timer:kill()
        menu_close_timer = nil
    end
    menu_close_timer = mp.add_timeout(CONFIG.menu_display_duration, function()
        if menu_active and active_menu_data then
            close_menu()
        end
    end)
end

local function redraw_menu()
    if not menu_active or not active_menu_data then return end

    reset_menu_timeout()

    for _, binding in ipairs(active_menu_data.item_bindings) do
        mp.remove_key_binding(binding.name)
    end
    active_menu_data.item_bindings = {}

    local ranges = active_menu_data.ranges
    local page = active_menu_data.page
    local total_pages = active_menu_data.total_pages
    local start_index = (page - 1) * CONFIG.entries_per_page + 1
    local end_index = math.min(start_index + CONFIG.entries_per_page - 1, #ranges)

    local menu_text = active_menu_data.header
    if page > 1 then
        menu_text = menu_text .. "(Page " .. page - 1 .. " with Page-Up)\n"
    end

    for i = start_index, end_index do
        local page_index = i - start_index + 1
        local key_label = get_key_for_index(page_index)
        if key_label then
            local range = ranges[i]
            menu_text = menu_text .. key_label .. ": " .. range.name .. " (" .. format_time(range.a_point) .. " -> " .. format_time(range.b_point) .. ")\n"

            local binding_name = "select_range_" .. key_label
            mp.add_forced_key_binding(key_label, binding_name, function()
                active_menu_data.callback(i)
                close_menu(true)
            end)
            table.insert(active_menu_data.item_bindings, { name = binding_name })
        end
    end

    if page < total_pages then
        menu_text = menu_text .. "(Page " .. page + 1 .. " with Page-Down)\n"
    end

    mp.osd_message(menu_text, CONFIG.menu_display_duration)
end

local function cleanup_input()
    if not menu_active or not active_save_data then return end
    active_save_data.input_active = false
    menu_active = false
    if active_save_data.timeout then
        active_save_data.timeout:stop()
    end
    for _, binding in ipairs(active_save_data.key_bindings) do
        mp.remove_key_binding(binding.name)
    end
    active_save_data.key_bindings = {}
    active_save_data = nil
end

local function close_active_menu()
    if menu_active then
        if active_menu_data then
            close_menu()
        elseif active_save_data then
            cleanup_input()
            mp.osd_message("Save cancelled")
        end
    end
end

local function jump_to_a_point()
    if a_point then mp.commandv("seek", a_point, "absolute", "exact") end
end

local function start_loop()
    mp.set_property("loop-file", "no")
    if CONFIG.show_osd_messages then mp.osd_message("Starting AB loop: " .. format_time(a_point) .. " -> " .. format_time(b_point)) end
    jump_to_a_point()
end

local function read_json_file()
    local file = io.open(AB_RANGES_DB, "r")
    if not file then return {} end
    local content = file:read("*all")
    file:close()
    local data = utils.parse_json(content)
    return data or {}
end

local function write_json_file(data)
    local file = io.open(AB_RANGES_DB, "w")
    if not file then
        msg.error("Failed to open file for writing: " .. AB_RANGES_DB)
        mp.osd_message("Failed to save AB range")
        return false
    end

    local json_data = utils.format_json(data)
    if not json_data then
        msg.error("Failed to serialize JSON data: " .. utils.to_string(data))
        mp.osd_message("Failed to serialize AB range data")
        file:close()
        return false
    end

    local success, write_err = pcall(function() file:write(json_data) end)
    if not success then
        msg.error("Failed to write JSON to file: " .. (write_err or "unknown error"))
        mp.osd_message("Failed to write AB range")
        file:close()
        return false
    end

    file:close()
    msg.info("Successfully wrote AB range to " .. AB_RANGES_DB)
    return true
end

local function get_video_key()
    return mp.get_property("path") or ""
end

local function save_ab_range()
    if menu_active then return end
    if not a_point or not b_point then
        mp.osd_message("No valid AB range to save")
        return
    end

    local data = read_json_file()
    local video_key = get_video_key()
    if not data[video_key] then data[video_key] = {} end
    local range_count = #data[video_key] + 1
    local default_name = "Range " .. range_count

    local input = ""
    local input_active = true
    local key_bindings = {}
    menu_active = true
    active_save_data = { input_active = input_active, key_bindings = key_bindings, timeout = nil }

    local function update_osd()
        mp.osd_message("Enter range name (Enter to confirm, Esc to cancel):\n" .. input, 300)
    end

    local function reset_save_menu_timeout()
        if active_save_data.timeout then
            active_save_data.timeout:stop()
        end
        active_save_data.timeout = mp.add_timeout(CONFIG.menu_display_duration, function()
            if active_save_data and active_save_data.input_active then
                active_save_data.input_active = false
                mp.osd_message("Save cancelled")
                cleanup_input()
            end
        end)
    end

    local function handle_input(event)
        if not active_save_data or not active_save_data.input_active then return end
        if event.event ~= "down" then return end

        local key = event.key_name
        local text = event.key_text or event.text

        if key == "ENTER" then
            active_save_data.input_active = false
            local range_name = input:match("^%s*(.-)%s*$") or ""
            range_name = range_name ~= "" and range_name or default_name
            table.insert(data[video_key], { a_point = a_point, b_point = b_point, name = range_name })
            if write_json_file(data) then
                mp.osd_message("Saved AB range: " .. range_name)
            end
            cleanup_input()
        elseif key == "ESC" then
            active_save_data.input_active = false
            mp.osd_message("Save cancelled")
            cleanup_input()
        elseif key == "BS" then
            local byte_pos = #input
            while byte_pos > 0 do
                local byte = string.byte(input, byte_pos)
                if byte < 128 or byte >= 192 then
                    break
                end
                byte_pos = byte_pos - 1
            end
            input = input:sub(1, byte_pos - 1)
            update_osd()
            reset_save_menu_timeout()
        elseif text and text ~= "" then
            input = input .. text
            update_osd()
            reset_save_menu_timeout()
        end
    end

    local chars = {}
    for i = string.byte('a'), string.byte('z') do table.insert(chars, string.char(i)) end
    for i = string.byte('A'), string.byte('Z') do table.insert(chars, string.char(i)) end
    for i = string.byte('0'), string.byte('9') do table.insert(chars, string.char(i)) end

    local symbols = {
        "SPACE", "`", "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+",
        "[", "{", "]", "}", "\\", "|", ";", ":", "'", "\"", ",", "<", ".", ">", "/", "?"
    }
    for _, s in ipairs(symbols) do table.insert(chars, s) end

    for _, char in ipairs(chars) do
        local binding_name = "input_char_" .. char:gsub("[^%w]", function(c) return string.format("_%02x", string.byte(c)) end)
        mp.add_forced_key_binding(char, binding_name, handle_input, { complex = true, repeatable = true })
        table.insert(key_bindings, { name = binding_name })
    end

    mp.add_forced_key_binding("ENTER", "input_enter", handle_input, { complex = true })
    mp.add_forced_key_binding("ESC", "input_esc", handle_input, { complex = true })
    mp.add_forced_key_binding("BS", "input_bs", handle_input, { complex = true, repeatable = true })
    table.insert(key_bindings, { name = "input_enter" })
    table.insert(key_bindings, { name = "input_esc" })
    table.insert(key_bindings, { name = "input_bs" })

    update_osd()
    reset_save_menu_timeout()
end

local function show_menu(ranges, callback, action)
    if not ranges or #ranges == 0 then
        mp.osd_message("No saved AB ranges")
        return
    end

    menu_active = true
    active_menu_data = {
        ranges = ranges,
        action = action,
        callback = callback,
        page = 1,
        total_pages = math.ceil(#ranges / CONFIG.entries_per_page),
        blocked_keys = {},
        item_bindings = {}
    }

    if action == "delete" then
        active_menu_data.header = "Select range to delete (0: All, 1-9, a-z):\n"
    else
        active_menu_data.header = "Select range (1-9, a-z):\n"
    end

    local reserved_keys = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "ESC", "PGUP", "PGDWN" }
    for i = string.byte('a'), string.byte('z') do
        table.insert(reserved_keys, string.char(i))
    end

    local function block_key(key)
        local binding_name = "block_" .. key:gsub("[^%w]", "_")
        mp.add_forced_key_binding(key, binding_name, function() reset_menu_timeout() end)
        table.insert(active_menu_data.blocked_keys, { name = binding_name })
    end

    for _, key in ipairs(reserved_keys) do
        block_key(key)
    end

    mp.add_forced_key_binding("PGUP", "menu_pgup", function()
        if active_menu_data.page > 1 then
            active_menu_data.page = active_menu_data.page - 1
            redraw_menu()
        else
            reset_menu_timeout()
        end
    end)

    mp.add_forced_key_binding("PGDWN", "menu_pgdwn", function()
        if active_menu_data.page < active_menu_data.total_pages then
            active_menu_data.page = active_menu_data.page + 1
            redraw_menu()
        else
            reset_menu_timeout()
        end
    end)

    if action == "delete" then
        mp.add_forced_key_binding("0", "delete_all_ranges", function()
            callback(0)
            close_menu(true)
        end)
    end

    mp.add_forced_key_binding("ESC", "menu_esc", function()
        close_menu()
    end)

    redraw_menu()
end

local function load_ab_range_menu()
    if menu_active then return end
    local data = read_json_file()
    local video_key = get_video_key()
    local ranges = data[video_key] or {}

    show_menu(ranges, function(index)
        local range = ranges[index]
        a_point = range.a_point
        b_point = range.b_point
        if CONFIG.show_osd_messages then mp.osd_message("Loaded AB range: " .. range.name) end
        start_loop()
    end, "load")
end

local function delete_ab_range_menu()
    if menu_active then return end
    local data = read_json_file()
    local video_key = get_video_key()
    local ranges = data[video_key] or {}

    show_menu(ranges, function(index)
        if index == 0 then
            data[video_key] = nil
            write_json_file(data)
            mp.osd_message("Deleted all AB ranges")
        else
            table.remove(ranges, index)
            if #ranges == 0 then
                data[video_key] = nil
            else
                data[video_key] = ranges
            end
            write_json_file(data)
            mp.osd_message("Deleted AB range")
        end
    end, "delete")
end

local function set_a_point()
    if menu_active then return end
    local pos = mp.get_property_number("time-pos")
    if not pos then
        msg.error("Failed to set A point: no time-pos")
        mp.osd_message("Failed to set A point")
        return
    end

    a_point = pos
    mp.osd_message("A point set at " .. format_time(a_point))

    if CONFIG.auto_set_b_point and not b_point then
        if video_duration > 0 and video_fps > 0 then
            b_point = video_duration - (1 / video_fps)
            if CONFIG.show_osd_messages then mp.osd_message("B point set at " .. format_time(b_point)) end
        else
            msg.error("Failed to set B point: duration=" .. video_duration .. ", fps=" .. video_fps)
            mp.osd_message("Failed to set automatic B point")
            a_point = nil
            return
        end
    end
end

local function set_b_point()
    if menu_active then return end
    local pos = mp.get_property_number("time-pos")
    if not pos then
        msg.error("Failed to set B point: no time-pos")
        mp.osd_message("Failed to set B point")
        return
    end

    b_point = pos
    if CONFIG.show_osd_messages then mp.osd_message("B point set at " .. format_time(b_point)) end

    if CONFIG.auto_set_a_point and not a_point then
        a_point = 0
        if CONFIG.show_osd_messages then mp.osd_message("A point set at " .. format_time(a_point)) end
    end
end

local function reset_points()
    if menu_active then return end
    if not a_point and not b_point then
        return
    end
    a_point = nil
    b_point = nil
    mp.set_property("loop-file", initial_loop_file_value)
    if CONFIG.show_osd_messages then mp.osd_message("AB points cleared") end
end

local function monitor_loop()
    local pos = mp.get_property_number("time-pos")
    if not pos or not a_point or not b_point then return end

    local end_region = CONFIG.end_region_duration >= 0 and CONFIG.end_region_duration or 0
    local is_near_end = video_duration > 0 and pos >= video_duration - end_region
    local trigger_pos = is_near_end and (b_point - CONFIG.b_point_tolerance) or b_point

    if pos >= trigger_pos then
        jump_to_a_point()
    end
end

local function on_end_file(event)
    if event.reason == "eof" and a_point and b_point then
        if mp.get_property("loop-file") ~= "no" then mp.set_property("loop-file", "no") end
        mp.add_timeout(CONFIG.end_file_timeout, function()
            jump_to_a_point()
        end)
    end
end

local function reset_points_on_new_file(current_video_key)
    if CONFIG.reset_on_new_file and last_video_key and current_video_key ~= last_video_key then
        reset_points()
        msg.info("New file: Reset AB points")
    end
end

local function show_stored_ranges_osd(video_key)
    if not CONFIG.show_stored_ranges_message then
        return
    end
    local data = read_json_file()
    local ranges = data[video_key] or {}
    local count = #ranges
    if count > 0 then
        if CONFIG.show_osd_messages then mp.osd_message(count .. " stored AB range(s) found for this video") end
    end
end

local function on_file_loaded()
    video_duration = mp.get_property_number("duration") or 0
    if video_duration == 0 then
        msg.warn("Video duration is 0; possibly corrupt file or metadata missing")
    end
    video_fps = mp.get_property_number("container-fps")
    if not video_fps then
        local params = mp.get_property_native("video-params")
        video_fps = params and params.fps
    end
    if not video_fps then
        video_fps = mp.get_property_number("current-vf-fps") or
                    mp.get_property_number("estimated-vf-fps") or
                    30
    end
    msg.info("Initialized video duration: " .. video_duration)
    msg.info("Initialized video FPS: " .. video_fps)

    local current_video_key = get_video_key()
    if current_video_key ~= last_video_key then
        close_active_menu()
        reset_points_on_new_file(current_video_key)
        show_stored_ranges_osd(current_video_key)
    end
    last_video_key = current_video_key
end

mp.register_event("file-loaded", on_file_loaded)
mp.add_key_binding("HOME", "set-a-point", set_a_point)
mp.add_key_binding("END", "set-b-point", set_b_point)
mp.add_key_binding("DEL", "reset-points", reset_points)
mp.add_key_binding("Ctrl+s", "save-ab-range", save_ab_range)
mp.add_key_binding("Ctrl+l", "load-ab-range-menu", load_ab_range_menu)
mp.add_key_binding("Ctrl+DEL", "delete-ab-range-menu", delete_ab_range_menu)

mp.observe_property("time-pos", "number", monitor_loop)
if CONFIG.use_end_file_handler then mp.register_event("end-file", on_end_file) end

msg.info("AB Repeat Script initialized")
