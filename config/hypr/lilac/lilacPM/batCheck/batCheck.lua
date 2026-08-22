local function notify(str)
    io.popen("notify-send \"" .. str .. "\" -a 'lilac::lua::batCheck()'").close();
end

local function error(str)
    notify("[FATAL]:" .. str);
end
local function runCmd(cmd)
    local proc
    rr = io.popen(cmd);
    if not proc then
        error("runCmd(): failed to run command " .. cmd);
        return "nil";
    end
    out = proc.read();
    proc.close();
    return out;
end
local function readFile(path) -- simple wrapper function for reading from kv
    local file = assert(io.open(path, "r"));
    local out = file:read("*all");
    file:close();
    return out;
end

local function writeFile(path, str) -- simple wrapper function for writing to kv
    local file, err = io.open(path, "w");

    if not file then
        error("Error opening file: " .. err);
        return;
    end

    file:write(str);
    file:close();
end

local function getBat() -- gets the battery percentage using dbus. stiched togheter from multiple stackoverflow posts
    local cmd = "gdbus call --system " .. "--dest org.freedesktop.UPower " ..
                    "--object-path /org/freedesktop/UPower/devices/DisplayDevice " ..
                    "--method org.freedesktop.DBus.Properties.Get " .. "org.freedesktop.UPower.Device Percentage";

    local handle = io.popen(cmd);
    if not handle then
        local e = "Command " .. cmd .. " failed!";
        error(e);
        return nil, "Command " .. cmd .. " failed!";
    end

    local result = handle:read("*a");
    handle:close();

    local percent_str = result:match("<([%d%.]+)>");
    if percent_str then
        return math.floor(tonumber(percent_str));
    else
        local e = "Failed to extract battery data!";
        error(e)
        return nil, e;
    end
end

local argc = #arg;
if argc == 0 then
    error("No arguments provided! Got: " .. tostring(argc) .. " args");
    return;
end

local batPct, err = getBat();
if not batPct then
    error("Error: " .. err);
    return;
end
local lowBatLevel = tonumber(readFile("/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/lowbatlevel"));
local currentModePath = "/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/currentmode";
local isGameMode = readFile("/home/" .. arg[1] .. "/.config/hypr/lilac/kv/gamingmode/state");
local lpmOpenPath = "/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/lpmopen";
local currentMode = readFile(currentModePath);
if isGameMode == "0" then
    if readFile("/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/charging.txt") == "1" then
        if currentMode ~= "performance" then
            notify("Performance mode");
        end
        os.execute("tlpctl performance");
        writeFile(lpmOpenPath, "0");
        writeFile(currentModePath, "performance");

    else
        if batPct < lowBatLevel then
            if currentMode ~= "power-saver" then
                notify("Eco mode");
            end
            if readFile(lpmOpenPath) ~= "1" then
                notify("Low battery! " .. tostring(batPct) .. "% remaining.");
                writeFile(lpmOpenPath, "1");
            end
            os.execute("tlpctl power-saver");
            writeFile(currentModePath, "power-saver");
        else
            if currentMode ~= "balanced" then
                notify("Balanced mode");
            end
            writeFile(lpmOpenPath, "0");
            os.execute("tlpctl balanced");
            writeFile(currentModePath, "balanced");

        end
    end
end
local function notify(str)
    io.popen("notify-send \"" .. str .. "\" -a 'lilac::lua::batCheck()'").close();
end

local function error(str)
    notify("[FATAL]:" .. str);
end
local function runCmd(cmd)
    local proc rr = io.popen(cmd);
    if not proc then
        error("runCmd(): failed to run command ".. cmd);
        return "nil";
    end
    out = proc.read();
    proc.close();
    return out;
end
local function readFile(path) -- simple wrapper function for reading from kv
    local file = assert(io.open(path, "r"));
    local out = file:read("*all");
    file:close();
    return out;
end

local function writeFile(path, str) -- simple wrapper function for writing to kv
    local file, err = io.open(path, "w");

    if not file then
        error("Error opening file: " .. err);
        return;
    end

    file:write(str);
    file:close();
end

local function getBat() -- gets the battery percentage using dbus. stiched togheter from multiple stackoverflow posts
    local cmd = "gdbus call --system " .. "--dest org.freedesktop.UPower " ..
                    "--object-path /org/freedesktop/UPower/devices/DisplayDevice " ..
                    "--method org.freedesktop.DBus.Properties.Get " .. "org.freedesktop.UPower.Device Percentage";

    local handle = io.popen(cmd);
    if not handle then
        local e = "Command " .. cmd .. " failed!";
        error(e);
        return nil, "Command " .. cmd .. " failed!";
    end

    local result = handle:read("*a");
    handle:close();

    local percent_str = result:match("<([%d%.]+)>");
    if percent_str then
        return math.floor(tonumber(percent_str));
    else
        local e = "Failed to extract battery data!";
        error(e)
        return nil, e;
    end
end

local argc = #arg;
if argc == 0 then
    error("No arguments provided! Got: " .. tostring(argc) .. " args");
    return;
end

local batPct, err = getBat();
if not batPct then
    error("Error: " .. err);
    return;
end
local lowBatLevel = tonumber(readFile("/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/lowbatlevel"));
local currentModePath = "/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/currentmode";
local isGameMode = readFile("/home/" .. arg[1] .. "/.config/hypr/lilac/kv/gamingmode/state");
local lpmOpenPath = "/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/lpmopen";
local currentMode = readFile(currentModePath);
if isGameMode == "0" then
    if readFile("/home/" .. arg[1] .. "/.config/hypr/lilac/kv/lilacPM/charging.txt") == "1" then
        if currentMode ~= "performance" then
            notify("Performance mode");
        end
        os.execute("tlpctl performance");
        writeFile(lpmOpenPath,"0");
        writeFile(currentModePath, "performance");

    else
        if batPct < lowBatLevel then
            if currentMode ~= "power-saver" then
                 notify("Eco mode");
            end
            if readFile(lpmOpenPath) ~= "1" then
                notify("Low battery! " .. tostring(batPct) .. "% remaining.");
                writeFile(lpmOpenPath,"1");
            end
            os.execute("tlpctl power-saver");
            writeFile(currentModePath, "power-saver");
        else
            if currentMode ~= "balanced" then
                notify("Balanced mode");
            end
            writeFile(lpmOpenPath,"0");
            os.execute("tlpctl balanced");
            writeFile(currentModePath, "balanced");

        end
    end
end
