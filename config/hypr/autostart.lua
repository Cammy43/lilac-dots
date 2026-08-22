-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Autostart necessary processes (like notifications daemons, status bars, etc.)

hl.on("hyprland.start", function()
    -- put your autostart things here:
    -- example: "Say Welcome!" when hyprland starts:
    hl.exec_cmd("notify-send 'Welcome!' -a 'My autostart function'")
end)
