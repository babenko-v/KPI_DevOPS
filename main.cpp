#include <iostream>
#include "FuncClass.h"

int CreateHTTPserver();
int main() {
    FuncClass obj;
    std::cout << "FuncA result: " << obj.FuncA(5.0, 1.0) << std::endl;

    CreateHTTPserver();
    return 0;
}
