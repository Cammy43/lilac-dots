require("internal/env")
local function notify(str)
    hl.exec_cmd("notify-send \"" .. str .. "\" -a 'lilac'");
end

local function sleep(t)
    io.popen("sleep " .. tostring(t));
end

function debugOut(str, e)
    if debug ~= true then
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

local function readFile(path) -- simple wrapper function for reading from kv
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

local function writeFile(path, data) -- simple wrapper function for writing to kv
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
    debugOut("Setting up lilacPM kv", "none");
    io.popen("killall batCheck"); -- use popen so the system waits for the processes to be killed
    hl.exec_cmd(basePath .. "lilac/lilacPM/batCheck " .. username);
    debugOut("Set up lilacPM kv", "ok");
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
    debugOut("Set up key-value", "ok");
end

local function setupVars()
    debugOut("Set up local variables", "none");
    ll_username = username;
    hl_desktopSwitchSpeed = desktop_switch_speed;
    basePath = "/home/" .. username .. "/.config/hypr/";
    hl_terminal = "foot";
    hl_isLaptop = laptop;
    writeFile(basePath .. "lilac/kv/lilacPM/lowbatlevel", low_battery_level);
    debugOut("Setting up local variables", "ok");
end

function setupGui()
    debugOut("Setting up shell", "none");
    io.popen("killall qs");
    hl.exec_cmd("qs -c overview");

    -- debugOut("STUPID THING:" .. readFile(basePath .. "lilac/kv/setupcomplete"));
    if readFile(basePath .. "lilac/kv/setupcomplete") == "0" then
        sleep(0.5);
        hl.exec_cmd("noctalia");
        sleep(1);
        writeFile(basePath .. "lilac/kv/setupcomplete", "1");
        hl.exec_cmd("hyprctl reload");
    else
        debugOut("Shell is already loaded, Reloading config.");
    end
    debugOut("Setup shell", "ok");
end

function gameMode()
    if gameMode == false then
        notify("Gaming Mode enabled");
        hl.exec_cmd("tlpcli performance");
        writeFile(basePath .. "lilac/kv/gamingmode/state", "1");
    else
        writeFile(basePath .. "lilac/kv/gamingmode/state", "0");
        notify("Gaming Mode disabled");
    end
end

hl.on("hyprland.start", function()
    debugOut("Cold start detected!", "none");
    setupComplete = false; -- DO NOT remove this line. EVER. If you are curious, removing it will get the shell stuck in a bootloop at 1 fps.
    writeFile(basePath .. "lilac/kv/setupcomplete", "0");
    debugOut("hyprland.start");
end)

function startLilac() -- starts essential lilac processes and loads configs
    debugOut("Starting...", "none");
    setupVars();
    kv_reset();
    lilacPM_reset();
    debugOut("Initial setup done!");
end
