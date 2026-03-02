# Actividad 10: Explorando el ciclo de vida de un objeto

## Parte 1: Stack vs Heap — ciclo de vida básico

### Salida del programa

```
Inicio del bloque
Constructor: Punto(100, 200) creado.
Punto(100, 200)
Destructor: Punto(100, 200) destruido.   ← se destruye al cerrar la llave
Fuera del bloque
Constructor: Punto(300, 400) creado.
Punto(300, 400)
Destructor: Punto(300, 400) destruido.   ← se destruye con delete
```

### 1. Ciclo de vida: stack vs heap

Un objeto en el **stack** nace cuando se declara y muere cuando el bloque `{}` donde fue creado termina. No hay que hacer nada para destruirlo, el compilador lo maneja solo. En este caso, `pBloque` se crea al entrar al bloque y desaparece en cuanto se cierra la llave, antes incluso de llegar a la línea `"Fuera del bloque"`.

Un objeto en el **heap** es distinto. Nace con `new` y no muere hasta que se llama `delete` explícitamente. No le importa si salió del bloque, si la función terminó o lo que sea — sigue ahí hasta que el programador lo libere. Si nunca se llama `delete`, el objeto queda ocupando memoria hasta que el programa termina, lo que se conoce como *memory leak*.

---

## Parte 2: El código que no compila

```cpp
{
    Punto* pBloque2 = new Punto(500, 600);
    pBloque2->imprimir();
}
pBloque2->imprimir();   // ← error
delete pBloque2;        // ← error
```

### 1. ¿Compila? ¿Por qué?

No compila. El problema es que `pBloque2` se declaró dentro del bloque `{}`, así que su **scope** (alcance) es ese bloque y solo ese. Fuera de las llaves, esa variable simplemente no existe para el compilador. Al intentar usarla en `pBloque2->imprimir()` después del bloque, el compilador directamente no la reconoce y lanza un error.

Hay que aclarar algo importante aquí: aunque el objeto en el heap no se destruye al salir del bloque, el **puntero** `pBloque2` sí desaparece porque vivía en el stack. El objeto quedaría huérfano en el heap sin forma de accederlo ni liberarlo.

---

## Parte 3: Declarar el puntero fuera, inicializar dentro

```cpp
Punto* pBloque2 = nullptr;
{
    cout << "Inicio del bloque 2" << endl;
    pBloque2 = new Punto(500, 600);
    pBloque2->imprimir();
}
pBloque2->imprimir();
delete pBloque2;
```

### Salida

```
Inicio del bloque
Constructor: Punto(100, 200) creado.
Punto(100, 200)
Destructor: Punto(100, 200) destruido.
Fuera del bloque
Constructor: Punto(300, 400) creado.
Punto(300, 400)
Destructor: Punto(300, 400) destruido.
Inicio del bloque 2
Constructor: Punto(500, 600) creado.
Punto(500, 600)
Punto(500, 600)         ← funciona fuera del bloque
Destructor: Punto(500, 600) destruido.
```

Ahora sí compila y funciona bien. Al declarar `pBloque2` fuera del bloque, su scope es el `main` completo. Dentro del bloque se asigna con `new`, y al salir el puntero sigue siendo accesible. El objeto en el heap no se tocó para nada al cerrar la llave.

### 1. ¿Por qué `pBloque` se destruye al salir del bloque y `pBloque2` no?

`pBloque` es un **objeto directo** en el stack. Su memoria está ligada al bloque donde fue creado, así que cuando ese bloque termina, el objeto se destruye automáticamente.

`pBloque2` en cambio **no es un objeto**, es un puntero. Lo que vive en el stack es solo la variable que guarda una dirección. El objeto real fue creado con `new` en el heap, y el heap no sabe nada de bloques ni de scopes. El objeto persiste hasta que alguien llame `delete`.

### 2. ¿En qué parte de la memoria se almacena `pBloque2`?

La variable `pBloque2` (el puntero en sí) está en el **stack**, porque se declaró como variable local dentro del `main`.

### 3. ¿En qué parte de la memoria se almacena el objeto al que apunta `pBloque2`?

El objeto `Punto(500, 600)` está en el **heap**, porque fue creado con `new`. Esa memoria no se libera sola, por eso es necesario el `delete pBloque2` al final.

# Actividad Integradora


## 1. Diagnóstico del problema

### Error 1: Fuga de memoria (memory leak) — falta el destructor

**¿Cuál es el error?**
La clase `Personaje` reserva memoria dinámica con `new int[3]` en el constructor, pero nunca la libera. No existe destructor.

**¿Por qué ocurre?**
Cuando se crea un `Personaje`, el array `estadisticas` se aloja en el heap. La variable `estadisticas` (el puntero) vive en el stack del objeto, pero el bloque de 3 enteros en el heap no tiene dueño que lo libere. Cuando el objeto se destruye al salir de `simularEncuentro`, el stack se limpia y el puntero desaparece, pero el heap no sabe que esa memoria ya no sirve. Queda ahí ocupando espacio para siempre.

**¿Cuál es la consecuencia?**
Cada vez que se llame a `simularEncuentro` o se creen objetos `Personaje`, se van acumulando bloques de memoria en el heap que nunca se liberan. En un videojuego que crea y destruye NPCs constantemente, esto explica perfectamente por qué el juego consume cada vez más RAM con el tiempo.

---

### Error 2: Doble liberación (double free) — copia superficial del puntero

**¿Cuál es el error?**
La línea `Personaje copiaHeroe = heroe;` genera una copia del objeto usando el constructor de copia que C++ crea automáticamente. Ese constructor copia los miembros uno a uno, lo que incluye copiar el valor del puntero `estadisticas`.

**¿Por qué ocurre?**
Después de la copia, tanto `heroe` como `copiaHeroe` tienen su `estadisticas` apuntando al **mismo bloque de memoria** en el heap. Son dos punteros distintos en el stack, pero apuntan a la misma dirección. Si en ese momento se agregara un destructor que hiciera `delete[] estadisticas`, al salir del bloque se destruiría primero `copiaHeroe` y liberaría el array. Luego se destruiría `heroe` e intentaría liberar la misma memoria que ya fue liberada. Eso es un *double free*, que causa un crash inmediato con comportamiento indefinido.

**¿Cuál es la consecuencia?**
Crashes impredecibles, exactamente como describe el enunciado. El programa puede funcionar bien algunas veces y explotar en otras dependiendo del estado de la memoria en ese momento.

---

## 2. Solución: clase Personaje refactorizada

La solución que se busca en esta unidad no es la Regla de los Tres (agregar constructor de copia y operador de asignación), sino evitar el problema desde la raíz: **no usar memoria dinámica manual cuando no es necesario**.

Si se reemplaza el array dinámico `int*` por variables de instancia normales, desaparecen ambos problemas de golpe. No hay heap, no hay fuga, no hay doble liberación.

```cpp
#include <iostream>
#include <string>

class Personaje {
public:
    std::string nombre;
    int vida;
    int ataque;
    int defensa;

    Personaje(std::string n, int v, int atk, int def)
        : nombre(n), vida(v), ataque(atk), defensa(def) {
        std::cout << "Constructor: nace " << nombre << std::endl;
    }

    ~Personaje() {
        std::cout << "Destructor: muere " << nombre << std::endl;
    }

    void imprimir() {
        std::cout << "Personaje " << nombre
                  << " [Vida: " << vida
                  << ", ATK: " << ataque
                  << ", DEF: " << defensa
                  << "]" << std::endl;
    }
};

void simularEncuentro() {
    std::cout << "\n--- Iniciando encuentro ---" << std::endl;
    Personaje heroe("Aragorn", 100, 20, 15);

    Personaje copiaHeroe = heroe;
    copiaHeroe.nombre = "Copia de Aragorn";

    heroe.imprimir();
    copiaHeroe.imprimir();

    std::cout << "Saliendo del encuentro..." << std::endl;
}

int main() {
    simularEncuentro();
    std::cout << "\nSimulación terminada." << std::endl;
    return 0;
}
```

### Salida del programa corregido

```
--- Iniciando encuentro ---
Constructor: nace Aragorn
Personaje Aragorn [Vida: 100, ATK: 20, DEF: 15]
Personaje Copia de Aragorn [Vida: 100, ATK: 20, DEF: 15]
Saliendo del encuentro...
Destructor: muere Copia de Aragorn
Destructor: muere Aragorn

Simulación terminada.
```

---

## 3. Justificación de los cambios

**Reemplazar `int* estadisticas` por tres variables `int` separadas**

Este es el cambio central. Las variables `vida`, `ataque` y `defensa` son miembros de instancia normales que viven dentro del objeto, en el stack. No se reserva nada en el heap, así que no hay nada que liberar. El error 1 (memory leak) desaparece completamente porque nunca se llama a `new`.

**El error 2 también desaparece como consecuencia**

Cuando C++ copia el objeto con `Personaje copiaHeroe = heroe`, ahora copia tres enteros simples, no un puntero. Cada objeto tiene sus propios valores independientes en su propio espacio de memoria. No hay ningún puntero compartido, así que no hay riesgo de double free.

**Agregar el destructor**

Se agrega el destructor explícitamente para que sea visible que el ciclo de vida del objeto está controlado. Aunque en esta versión no tiene trabajo extra que hacer (no hay heap que limpiar), deja la clase lista para el futuro y sirve como documentación clara de que se pensó en el ciclo de vida del objeto.

**En resumen:** el origen de ambos problemas era el uso innecesario de memoria dinámica para guardar tres números fijos. Eliminar ese `new` resuelve los dos errores críticos sin necesidad de agregar complejidad extra a la clase.