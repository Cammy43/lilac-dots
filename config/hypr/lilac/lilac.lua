require("internal/env")
local function notify(str)
    hl.exec_cmd("notify-send \"" .. str .. "\" -a 'lilac'");
end

local function sleep(t)
    io.popen("sleep " .. tostring(t));
end

function debugOut(str, e)
    if debug_mode == false then
        return;
    end
    if e == nil then
        e = "ok"
    end
    hl.notification.create({
        text = "lilac: " .. str,
        timeout = 10000,
        icon = e
    });
end

local function error(str)
    notify("[FATAL]:" .. str);
    debugOut(str, "err");
end

function readFile(path) -- simple wrapper function for reading from kv
    if string == nil or path == nil then
        error("readFile(): Not enough arguments");
        return "nil";
    end
    local file = assert(io.open(path, "r"));
    if not file then
        error("Could not open file: " .. path .. "! You're fucked!");
    end
    local out = file:read("*all");
    file:close();
    return out;
end

function writeFile(path, data) -- simple wrapper function for writing to kv
    if string == nil or path == nil then
        error("writeFile(): Not enough arguments");
        return "nil";
    end
    local file, err = io.open(path, "w");
    if not file then
        error("Could not open file: " .. path .. " because" .. err .. ". You're fucked!");
        return;
    end

    file:write(data);
    file:close();
end

local function lilacPM_reset()
    debugOut("Setting up lilacPM", "none");
    io.popen("killall batCheck"); -- use popen so the system waits for the processes to be killed
    writeFile(basePath .. "lilac/kv/lilacPM/prof_on_charge", power_profile_while_charging);
    writeFile(basePath .. "lilac/kv/lilacPM/prof_on_bat", power_profile_on_battery);
    writeFile(basePath .. "lilac/kv/lilacPM/prof_on_low", power_profile_on_low_battery);
    hl.exec_cmd(basePath .. "lilac/lilacPM/batCheck " .. username);
    debugOut("Set up lilacPM", "ok");
end

local function kv_reset()
    debugOut("Resetting kv", "none");
    io.popen(basePath .. "lilac/lilacPM/chargeState 0 " .. username);
    -- writeFile(basePath .. "lilac/kv/" .. username);
    writeFile(basePath .. "lilac/kv/username", username);
    debugOut("Reset kv", "ok");
end

local function kv_load()
    debugOut("Setting up key-value", "none");
    writeFile(basePath .. "lilac/kv/lilacPM/lowbatlevel", tostring(low_battery_level));
    debugOut("Set up key-value", "ok");
end

local function setupVars()
    debugOut("Set up local variables", "none");
    ll_username = username;
    hl_desktopSwitchSpeed = desktop_switch_speed;
    basePath = "/home/" .. username .. "/.config/hypr/";
    hl_terminal = "foot";
    hl_isLaptop = laptop;
    hl_gamingModeRes = gaming_mode_cfg;

    debugOut("Setting up local variables", "ok");
end

function setupGui(force)
    debugOut("Setting up shell", "none");
    debugOut("setupComplete:" .. tostring(setupComplete));

    io.popen("killall qs");
    sleep(0.1);
    hl.exec_cmd("qs -c overview");

    if readFile(basePath .. "lilac/kv/setupcomplete") == "0" or force then
        sleep(0.1);
        hl.exec_cmd("noctalia");
        sleep(0.2);
        writeFile(basePath .. "lilac/kv/setupcomplete", "1");
        setupComplete = true;
        hl.exec_cmd("hyprctl reload");
    else
        debugOut("Shell is already loaded, Reloading config.", "warn");
    end
    debugOut("Setup shell", "ok");
end

function gameMode(switch, state)
    debugOut("lilac::gameMode() called");
    local gmPath = basePath .. "lilac/gamingMode " .. basePath .. " ";

    if readFile(basePath .. "lilac/kv/gamingmode/state") == "1" then -- disables game mode
        debugOut("lilac::gameMode() resetting");
        writeFile(basePath .. "lilac/kv/gamingmode/state", "0");

        setupGui(true);
        hl_gameMode = false;
        hl.exec_cmd(gmPath .. "1");
        notify("Gaming Mode disabled");
        return;
    end

    -- if gaming_mode_res_switch == true then
    -- debugOut("STUPID VARIABLE: " .. hl_gamingModeRes)
    -- hl.exec_cmd("hyprctl keyword monitor " .. hl_gamingModeRes);
    -- end
    if gaming_mode_res_switch then
        io.popen(gmPath .. "0");
    else
        hl.exec_cmd("hyprctl reload");
    end
    if gaming_mode_ultra_pro_max then
        io.popen("killall noctalia"); -- lol
    end
    writeFile(basePath .. "lilac/kv/gamingmode/state", "1");
    hl_gameMode = true;
    debugOut("lilac::gameMode() exit");
    notify("Gaming Mode enabled");
end

function startLilac() -- starts essential lilac processes and loads configs
    debugOut("Starting...", "none");
    setupVars();
    if readFile(basePath .. "lilac/kv/setupcomplete") == "0" then
        debugOut("Resetting Game Mode", "none");
        writeFile(basePath .. "lilac/kv/gamingmode/state", "0");
        io.popen(basePath .. "lilac/gamingMode " .. basePath .. " 1");
        debugOut("Reset Game Mode", "ok");
        setupGui();
        --        kv_reset();
        lilacPM_reset();
    else
        debugOut("Skipping one time setup", "warn");
    end
    kv_load();

    debugOut("Initial setup done!");
end

hl.on("hyprland.start", function()
    debugOut("Cold start detected!", "none");
    setupComplete = false;
    writeFile(basePath .. "lilac/kv/setupcomplete", "0");
    coldstart = true;
    startLilac();
    coldstart = false
    debugOut("hyprland.start");
end)
setupVars();
kv_load();
io.popen("killall qs");
sleep(0.01);
hl.exec_cmd("qs -c overview");
