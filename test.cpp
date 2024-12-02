#include <cassert>
#include "FuncClass.h"

int main() {
    FuncClass obj;
    assert(obj.FuncA(1, 1.0) == 1.0); // Replace expected_value
    return 0;
}
