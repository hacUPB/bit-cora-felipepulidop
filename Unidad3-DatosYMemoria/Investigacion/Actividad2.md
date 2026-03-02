# Actividad 2 

## 1. Implementación de la  funcion `swap`

```cpp
#include <iostream>
using namespace std;

void swapPorValor(int a, int b) {
    int temp = a;
    a = b;
    b = temp;
}

void swapPorReferencia(int &a, int &b) {
    int temp = a;
    a = b;
    b = temp;
}

void swapPorPuntero(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main() {
    int x = 5;
    int y = 10;

    cout << "Valores iniciales:" << endl;
    cout << "x = " << x << ", y = " << y << endl;
    
    cout << "\nLlamando a swapPorValor(x, y)..." << endl;
    swapPorValor(x, y);
    cout << "Despues de swapPorValor: x = " << x << ", y = " << y << endl;

    cout << "\nLlamando a swapPorReferencia(x, y)..." << endl;
    swapPorReferencia(x, y);
    cout << "Despues de swapPorReferencia: x = " << x << ", y = " << y << endl;

    swapPorReferencia(x, y);

    cout << "\nLlamando a swapPorPuntero(&x, &y)..." << endl;
    swapPorPuntero(&x, &y);
    cout << "Despues de swapPorPuntero: x = " << x << ", y = " << y << endl;

    return 0;
}

```

## 2️. Resultados esperados

Si los valores iniciales son:

x = 5  
y = 10  

### 🔹 swapPorValor(x, y)

Después de la llamada:

x = 5  
y = 10  

No se modifican los valores originales porque la función trabaja con copias.

---

### 🔹 swapPorReferencia(x, y)

Después de la llamada:

x = 10  
y = 5  

Los valores sí se intercambian porque la función recibe referencias a las variables originales.

---

### 🔹 swapPorPuntero(&x, &y)

Después de la llamada:

x = 10  
y = 5  

También se intercambian porque se modifica directamente el contenido en memoria usando punteros.

---

