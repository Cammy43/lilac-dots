-------------------------
---- CONFIGURE LILAC ----
-------------------------

 -- Choose when the battery level is considered low. 
low_battery_level = 15
power_profile_while_charging = "performance"
power_profile_on_battery = "power-saver"
power_profile_on_low_battery = "power-saver"
-- If you are using a laptop, set this to true
laptop = true

-- If enabled, gaming mode will switch the monitor config to the one specified in ~/config/hypr/gamingMonitors.lua
gaming_mode_res_switch = true
-- If this is enabled noctalia and other fancy features will be disabled for maximum speed
gaming_mode_ultra_pro_max = true
-- Just paste the output of the "whoami" command if you don't know your username somehow. Lilac won't work without this.
username = "user"

default_terminal = "foot"
default_file_manager = "thunar"
default_app_launcher = "hyprlauncher"
desktop_switch_speed = "hi"

debug_mode = false
