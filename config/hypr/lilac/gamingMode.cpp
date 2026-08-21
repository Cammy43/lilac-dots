#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string inPath = "/home/cameronv/.config/hypr/gamingMonitors.lua";
string outPath = "/home/cameronv/.config/hypr/internal/monitors.lua";
string defaultPath = "/home/cameronv/.config/hypr/monitors.lua";

inline int toInt(std::string s)
{
  return stoi(s);
}

inline void notify(string n)
{
  system(string("notify-send \"" + n + "\" -a 'lilac::gamingMode()'").c_str());
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
    error("Requires at least one argument");
    exit(1);
  }

  if (argc > 2)
  {
    error("Too many arguments");
    exit(1);
  }

  // outFile << "";

  string lineIn;
  unsigned int oldFileSize = 0;
  string p = inPath;

  if (toInt(argv[1]))
    p = defaultPath;

  ifstream inFile(p);
  ofstream outFile(outPath);
  if (!inFile.is_open())
  {
    error("Failed to open file: " + p);
    inFile.close();
    exit(1);
  }
  if (!outFile.is_open())
  {
    error("Failed to open file: " + outPath);
    outFile.close();
    exit(1);
  }
  while (getline(inFile, lineIn))
  {
    outFile << lineIn << std::endl;
  }

  inFile.close();
  outFile.close();
  return 0;
}
