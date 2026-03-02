# Actividad 11: Autoevaluación

---

## Parte 1: Recuperación de conocimiento

### 1. Stack y Heap

El **stack** es una región de memoria que se gestiona automáticamente. Cuando se llama a una función, se reserva espacio para sus variables locales, y cuando la función termina, ese espacio se libera solo. Es rápido y ordenado, pero limitado en tamaño.

El **heap** es una región mucho más grande donde la memoria se reserva manualmente con `new` y se libera con `delete`. El programador tiene control total, pero también toda la responsabilidad. Si se olvida el `delete`, esa memoria queda ocupada hasta que el programa termina.

---

### 2. Las tres formas de pasar parámetros

**Por valor:** Se crea una copia del objeto o variable. Lo que pase dentro de la función no afecta al original. Se usa cuando no se quiere modificar el argumento y el costo de copiar es bajo (tipos simples como `int` o `float`). En memoria, se asigna espacio nuevo en el stack para la copia.

**Por referencia:** La función recibe un alias del objeto original. No se crea ninguna copia, ambos nombres apuntan al mismo espacio en memoria. Se usa cuando se necesita modificar el argumento original, o cuando el objeto es grande y copiar sería costoso. Se escribe con `&`.

**Por puntero:** La función recibe la dirección de memoria del objeto. Igual que la referencia, trabaja sobre el original, pero de forma más explícita. En memoria, el puntero ocupa espacio en el stack de la función (guarda una dirección), y a través de él se accede al objeto real. Se usa con `*` y `->`.

---

### 3. Variable local, global y local estática

**Variable local:** vive en el stack de la función donde fue declarada. Nace cuando se entra a la función y muere cuando esta termina. Segmento: **stack**.

**Variable global:** se declara fuera de cualquier función. Existe durante toda la ejecución del programa y es accesible desde cualquier parte del código. Segmento: **datos estáticos / globales**.

**Variable local estática:** se declara dentro de una función con la palabra `static`. A diferencia de una local normal, no muere cuando la función termina: conserva su valor entre llamadas. Solo se inicializa una vez. Segmento: **datos estáticos**, igual que las globales, aunque su scope está limitado a la función.

---

### 4. Un objeto en C++ desde la perspectiva de memoria

Un objeto en C++ es simplemente un bloque de memoria que contiene los valores de sus miembros de instancia almacenados de forma contigua. Si el objeto está en el stack, ese bloque vive ahí. Si se creó con `new`, vive en el heap.

Los **miembros de instancia** viven dentro del objeto, en su bloque de memoria. Cada objeto tiene su propia copia.

Los **miembros estáticos** no forman parte de ningún objeto. Viven en el segmento de datos estáticos y existe una sola copia compartida entre todos los objetos de esa clase.

---

## Parte 2: Transferencia y análisis

### 1. Problemas en el código

**Problema 1 — Memory leak por falta de destructor:**
Dentro del constructor se reserva memoria dinámica con `armas = new int[3]`. La clase no tiene destructor, así que ese array en el heap nunca se libera. Dentro del for de `crearEscuadron`, se crean 5 objetos `soldado` en el stack. Al terminar cada iteración del ciclo, el objeto se destruye (sale del scope), pero el array de `armas` en el heap queda huérfano. Eso son 5 leaks por cada llamada a `crearEscuadron`, y el main la llama dos veces: 10 bloques de memoria sin liberar en total.

**Problema 2 — `totalEnemigos` no se decrementa al destruir objetos:**
El contador `totalEnemigos` sube con cada objeto creado en el constructor, pero nunca baja. Los objetos `soldado` se destruyen al final de cada iteración del for, pero como no hay destructor, no hay ningún punto donde se reste del contador. Esto hace que `totalEnemigos` refleje cuántos objetos se han creado en total a lo largo de la ejecución, no cuántos existen en un momento dado.

---

### 2. Predicción del valor de `totalEnemigos`

El programa mostrará `"Escuadrón creado. Total enemigos: 5"` después de la primera llamada, y `"Escuadrón creado. Total enemigos: 10"` después de la segunda.

Cada llamada a `crearEscuadron` crea 5 objetos `Enemigo`, cada uno incrementa `totalEnemigos` en el constructor. Como nunca se decrementa, después de dos llamadas el total es 10, aunque en realidad no existe ningún `Enemigo` vivo en ese momento.

---

### 3. Versión corregida

```cpp
#include <iostream>
using namespace std;

class Enemigo {
public:
    static int totalEnemigos;
    int vida;
    int arma1, arma2, arma3;

    Enemigo(int v) : vida(v), arma1(10), arma2(15), arma3(20) {
        totalEnemigos++;
    }

    ~Enemigo() {
        totalEnemigos--;
    }
};

int Enemigo::totalEnemigos = 0;

void crearEscuadron() {
    for (int i = 0; i < 5; i++) {
        Enemigo soldado(100);
        soldado.vida -= 10;
    }
    cout << "Escuadrón creado. Enemigos activos: " << Enemigo::totalEnemigos << endl;
}

int main() {
    crearEscuadron();
    crearEscuadron();
    return 0;
}
```

**Cambios y por qué:**

- **Se eliminó `int* armas` y se reemplazó por tres `int` normales:** el array dinámico era innecesario para guardar tres valores fijos. Al eliminar el `new`, desaparece el memory leak sin necesitar destructor complejo.
- **Se agregó el destructor con `totalEnemigos--`:** ahora el contador refleja cuántos enemigos existen realmente. Al salir del scope, el destructor baja el conteo. Después de cada `crearEscuadron` el valor vuelve a cero.

---

## Parte 3: Reflexión metacognitiva

### 4. El concepto más crítico

El ciclo de vida de los objetos y la responsabilidad sobre la memoria del heap. Es fácil entender el stack porque es automático, pero el heap requiere disciplina. En un programa real, olvidar un `delete` o compartir un puntero sin cuidado son los errores que generan los bugs más difíciles de reproducir y encontrar. Entender exactamente cuándo nace y muere cada objeto es lo que separa un código que funciona de uno que funciona por ahora.

---

### 5. Cómo cambió la idea de "objeto" al comparar C++ con C#

Antes de comparar los dos lenguajes, un objeto era una idea abstracta: algo con datos y métodos. Después de hacer estas actividades quedó claro que en C++ un objeto es literalmente un bloque de bytes en una dirección de memoria, y que `p` en C++ contiene esos bytes directamente, mientras que `p` en C# es solo un puntero que guarda la dirección de donde vive el objeto real en el heap.

La implicación práctica es importante: en C++ copiar un objeto copia todos sus datos, en C# copiar una variable solo copia la referencia y ambas variables terminan apuntando al mismo objeto. Eso cambia completamente cómo se piensa el código.

---

### 6. Por qué importa entender la gestión de memoria

Entender la memoria es entender qué hace realmente el computador con tu código, no solo qué resultado produce. En lenguajes como C++ un error de memoria puede tumbar el programa de formas que no tienen ninguna relación visible con el bug real, y encontrarlo sin saber cómo funciona el heap o el stack es casi imposible. Incluso en lenguajes con recolector de basura como C# o Java, saber esto ayuda a escribir código más eficiente y a entender por qué ciertos patrones existen.