#include <iostream>
using namespace std;

void swap(int &a, int &b) {
    int temp = a;
    a = b;
    b = temp;
}

int partition(int arr[], int low, int high) {
    int pivot = arr[high]; // pivote
    int i = low - 1;        // índice del menor elemento

    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }

    swap(arr[i + 1], arr[high]); // mover pivote al centro
    return i + 1; // nueva posición del pivote
}

void quickSort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high); // índice de partición

        quickSort(arr, low, pi - 1);  // ordenar izquierda
        quickSort(arr, pi + 1, high); // ordenar derecha
    }
}

int main() {
    int arr[] = {30, 10, 40, 20, 50};
    int n = sizeof(arr) / sizeof(arr[0]);

    quickSort(arr, 0, n - 1);

    cout << "Arreglo ordenado: ";
    for (int i = 0; i < n; i++)
        cout << arr[i] << " ";
    cout << endl;

    return 0;
}
