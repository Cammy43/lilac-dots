#include <iostream>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <string>

using namespace std;

string basePath = "";

inline int toInt(std::string s)
{
    return std::stoi(s);
}

inline void notify(string n)
{
    system(string("notify-send \"" + n + "\" -a 'lilac::updLockState()'").c_str());
}

inline void error(string e)
{
    notify("[FATAL]: " + e);
    cerr << e << '\n';
}

string runCmd(const string &cmd)
{ // found this one on cplusplus.com: https://cplusplus.com/forum/beginner/176747/
    char psBuffer[256];
    FILE *pPipe;
    string result, command;
    command = "fish -c \"" + cmd + "\"";

    if ((pPipe = popen(command.c_str(), "rt")) == NULL)
    {
        error("Command" + command + " could not be executed");
        return "";
    }
    while (fgets(psBuffer, sizeof(psBuffer), pPipe) != NULL)
        result += psBuffer;

    if (!feof(pPipe))
        error("Error executing command");

    pclose(pPipe);
    return result;
}

inline string getLilacUser()
{
    string u = runCmd("whoami");
    if (u == "" or u == "\n")
    {
        error("Failed to get username!");
        exit(1);
    }
    return "cameronv";
}

int main(int argc, char *argv[])
{
    if (argc == 1)
    {
        error("No arguments provided");
        exit(1);
    }
    if (argc > 3)
    {
        error("Too many arguments");
        exit(1);
    }
    basePath = argv[1];

    std::ofstream locked(basePath + "lilac/kv/lilacPM/isLocked.txt", std::ios::out | std::ios::trunc);
    if (!locked)
    {
        error("File access failed");
        return 1;
    }
    if (toInt(argv[2]))
    {
        error("Locking...");
        locked << "1";
    }
    else
    {
        error("Unlocked");
        locked << "0";
    }

    locked.close();
    return 0;
}
