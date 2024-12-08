#include <cassert>
#include <chrono>
#include <vector>
#include <algorithm>
#include <random>
#include <iostream>
#include "FuncClass.h"

int main() {
    FuncClass obj;

    auto t1 = std::chrono::high_resolution_clock::now();

    std::vector<double> aValues;
    aValues.reserve(1000000);

    std::mt19937 mtre{123};
    std::uniform_int_distribution<int> distr{5, 55};

    for (int i = 0; i < 600000; i++) {
        aValues.push_back(obj.FuncA(distr(mtre), 4.0));
    }

    for (int i = 0; i < 400; i++) {
        std::sort(begin(aValues), end(aValues));
    }

    auto t2 = std::chrono::high_resolution_clock::now();
    auto elapsed_time = std::chrono::duration_cast<std::chrono::seconds>(t2 - t1).count();
    assert(elapsed_time >= 5 && elapsed_time <= 20);

    std::cout << "Elapsed time: " << elapsed_time << " seconds\n";

    return 0;
}
