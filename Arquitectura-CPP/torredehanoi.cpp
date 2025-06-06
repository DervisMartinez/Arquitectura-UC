#include <iostream>
using namespace std;

// Función recursiva de la Torre de Hanoi
void hanoi(int n, char origen, char destino, char auxiliar) {
    if (n == 1) {
        cout << "Mover disco de " << origen << " a " << destino << endl;
        return;
    }

    hanoi(n - 1, origen, auxiliar, destino);
    cout << "Mover disco de " << origen << " a " << destino << endl;
    hanoi(n - 1, auxiliar, destino, origen);
}

int main() {
    int n;
    cout << "Ingrese el número de discos: ";
    cin >> n;

    hanoi(n, 'A', 'C', 'B');
    return 0;
}
