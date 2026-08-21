function startLilac() -- starts essential lilac processes
    hl.notification.create({
        text = "lilac::lua::startLilac(): Starting...",
        timeout = 2000,
        icon = "none"
    });

    io.popen("killall batCheck"); -- use popen so the system waits for the processes to be killed
    io.popen("killall qs");
    
    hl.exec_cmd("/home/" .. username .. "/.config/hypr/lilac/lilacPM/batCheck " .. username);
    io.popen("noctalia");
    hl.exec_cmd("qs -c overview");

    hl.notification.create({
        text = "lilac::lua::startLilac(): Done",
        timeout = 2000,
        icon = "ok"
    });
end
