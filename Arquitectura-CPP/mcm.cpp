#include <iostream>
#include <cstdlib> // Para abs()

using namespace std;

// Función auxiliar para calcular el MCD (necesaria para el MCM)
template <typename T>
T calcular_mcd(T a, T b) {
    while (b != 0) {
        T temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

// Función principal para calcular el MCM
template <typename T>
T min_mult(T a, T b) {
    if (a == 0 || b == 0) {
        return 0; // El MCM de 0 y cualquier número es 0
    }
    return abs(a * b) / calcular_mcd(a, b);
}

int main() {
    // Ejemplo con enteros
    int num1 = 12, num2 = 18;
    cout << "MCM de " << num1 << " y " << num2 << " es: " << min_mult(num1, num2) << endl;

    // Ejemplo con números más grandes (long)
    long num3 = 15, num4 = 25;
    cout << "MCM de " << num3 << " y " << num4 << " es: " << min_mult(num3, num4) << endl;

    return 0;
}
