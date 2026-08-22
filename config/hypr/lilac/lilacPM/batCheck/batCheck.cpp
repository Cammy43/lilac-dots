#include <iostream>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <csignal>

using namespace std;
string basePath = "";
string username = "";
inline void notify(string n)
{
	system(string("notify-send \"" + n + "\" -a 'lilac::batCheck()'").c_str());
}

inline void error(string e)
{
	notify("[FATAL]: " + e);
	cerr << e << '\n';
}

inline int toInt(string s)
{
	return std::stoi(s);
}
void sigintExit(int signum)
{
	exit(signum);
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
	username = argv[1];
	signal(SIGINT, sigintExit);
	basePath = "/home/" + username + "/.config/hypr/";
	string tmp = "/usr/bin/luajit " + basePath + "lilac/lilacPM/batCheck.lua " + username;
	const char *cmd = tmp.c_str();
	cout << cmd << endl;
	while (true)
	{
		system(cmd);
		sleep(2);
	}
	return 0;
}
