#include "FuncClass.h"
#include <cmath> 


double factorial(int num) {
    //auxiliary function 
    if (num == 0 || num == 1) return 1;
    double result = 1;
    for (int i = 2; i <= num; ++i) {
        result *= i;
    }
    return result;
}

double FuncClass::FuncA(int n, double x) {
    // n - amount of iteration
    // x - var for func
    double sum = 0.0;
    for (int i = 0; i < n; ++i) {
        double numerator = std::pow(-1, i) * factorial(2 * i);
        double denominator = std::pow(4, i) * std::pow(factorial(i), 2);
        sum += (numerator / denominator) * std::pow(x, i);
    }
    return sum;
}