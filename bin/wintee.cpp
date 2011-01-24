#if 0
g++ -std=c++0x -O4 -W -Wextra -Wall -pedantic $0 -Wl,--subsystem,windows,-s -o ${0%.cpp}
exit $?
#endif

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <io.h>

#include <iostream>
#include <fstream>
#include <vector>

int main(int argc, char** argv)
{
   AllocConsole();

   stdout->_file = _open_osfhandle((intptr_t)GetStdHandle(STD_OUTPUT_HANDLE),0);

   std::vector<std::ostream*> out;

   for (char** it = argv + 1, **end = argv + argc; it != end; ++it)
      out.push_back(new std::ofstream(*it));

   auto begin = out.begin(), end = out.end();

   std::string line;
   while (getline (std::cin, line))
   {
      std::cout << line << "\n";
      for (auto it = begin; it != end; ++it)
         **it << line << "\n";
   }

   for (auto it = begin; it != end; ++it)
      delete *it;
}

