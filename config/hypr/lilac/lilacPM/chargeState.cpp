#include <iostream>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <string>

inline int toInt(std::string s)
{
    return std::stoi(s);
}

int main(int argc, char *argv[])
{
    if (argc == 1)
    {
        std::system("notify-send 'No arguments provided' -a pheonix::updChargeState()");
        exit(1);
    }
    if (argc > 2)
    {
        std::system("notify-send 'Too many arguments' -a pheonix::updChargeState()");
        exit(1);
    }
    std::ofstream charging("/home/cameronv/.config/hypr/lilac/kv/lilacPM/charging.txt", std::ios::out | std::ios::trunc);
    if (!charging)
    {
        std::system("notify-send 'File access failed' -a pheonix::updChargeState()");
        return 1;
    }
    if (toInt(argv[1]))
    {
        std::system("notify-send 'Charging' -a pheonix::updChargeState()");
        charging << "1";
    }
    else
    {
     std::system("notify-send 'Not Charging' -a pheonix::updChargeState()");   
        charging << "0";
    }
    
    charging.close();
    return 0;
}
