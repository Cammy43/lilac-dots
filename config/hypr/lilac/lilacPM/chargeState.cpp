#include <iostream>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <string>

using namespace std;

inline int toInt(std::string s)
{
    return std::stoi(s);
}

inline void notify(string n)
{
    system(string("notify-send \"" + n + "\" -a lilac::updChargeState()").c_str());
}

inline void error(string e)
{
    notify("[FATAL]: " + e);
    cerr << e << '\n';
}

int main(int argc, char *argv[])
{
    if (argc == 1)
    {
        error("No arguments provided");
        exit(1);
    }
    if (argc > 2)
    {
        error("Too many arguments");
        exit(1);
    }
    std::ofstream charging("/home/cameronv/.config/hypr/lilac/kv/lilacPM/charging.txt", std::ios::out | std::ios::trunc);
    if (!charging)
    {
        error("File access failed");
        return 1;
    }
    if (toInt(argv[1]))
    {
        error("Charging");
        charging << "1";
    }
    else
    {
        error("Not Charging");
        charging << "0";
    }

    charging.close();
    return 0;
}
