#include "FuncClass.h"

double FuncClass::FuncA(double x) {
    double sum = 0.0;
    for (int i = 0; i < 3; ++i) {
        double numerator = std::pow(-1, i) * factorial(2 * i);
        double denominator = std::pow(4, i) * std::pow(factorial(i), 2);
        sum += (numerator / denominator) * std::pow(x, i);
    }
    return sum;
}
