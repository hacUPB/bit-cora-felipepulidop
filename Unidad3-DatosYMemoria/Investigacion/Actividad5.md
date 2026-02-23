# Actividad 5

## Lo que hice

Corrí los dos programas, puse breakpoints en la creación de `original` y en la línea donde se hace la copia, y fui observando qué pasaba con cada variable en la pestaña Autos del depurador.

---

## Lo que pasó en C++

Al ejecutar el programa la salida fue esta:

```
Constructor: Punto original (70, 80) creado.
Punto original(70, 80)
Punto copia(100, 200)
Punto original(70, 80)
Punto p(300, 400)
Punto p(300, 400)
Destructor: Punto p(300, 400) destruido.
Destructor: Punto copia(100, 200) destruido.
```

Lo primero que noté es que el constructor se llama solo una vez, cuando se crea `original`. Cuando se hace `Punto copia = original` no aparece el mensaje del constructor. Eso me pareció raro al principio, pero después entendí que C++ usa algo llamado constructor de copia que se encarga de eso sin que nosotros lo escribamos explícitamente.

Lo importante es que `copia` es una copia completamente independiente de `original`. Cuando le cambié los valores a `copia` (x=100, y=200), `original` no se vio afectado para nada. Eso lo confirmé al llamar `original.imprimir()` después.

Después con el puntero `p` fue diferente. `p` apunta a `original`, entonces cuando hice `p->x = 300` en realidad estaba modificando `original` directamente. Por eso al final `original.imprimir()` muestra los valores 300 y 400. El puntero no es una copia, es una referencia a la misma dirección de memoria.

Al final del programa aparecen dos destructores, uno para `p` (que en realidad es `original` con el nombre cambiado) y otro para `copia`. Tiene sentido porque los dos objetos viven en el stack y se destruyen solos cuando `main` termina.

---

## Lo que pasó en C#

La salida fue:

```
Constructor: Punto original(70, 80) creado.
Punto original(70, 80)
Punto copia(100, 200)
Punto copia(100, 200)
```

Acá la diferencia es grande. Cuando hago `Punto copia = original` en C#, no se está copiando el objeto, se está copiando la **referencia**. Los dos, `original` y `copia`, apuntan al mismo objeto en el heap.

Entonces cuando cambio `copia.x = 100`, en realidad estoy cambiando el mismo objeto al que apunta `original`. Por eso cuando llamo `original.Imprimir()` después de modificar `copia`, me muestra los valores de `copia` (100, 200), no los originales (70, 80).

Esto es exactamente lo contrario a lo que pasó en C++.

---

## Respuestas a las preguntas

**1. ¿Qué ocurre al copiar un objeto en C++ y en C#?**

En C++ cuando hacés `Punto copia = original` se crea una copia real del objeto. Los datos se duplican en memoria y los dos objetos son completamente independientes. Modificar uno no afecta al otro.

En C# cuando hacés `Punto copia = original` no se copia el objeto, se copia la referencia. Los dos apuntan al mismo objeto en el heap. Modificar uno modifica el otro porque en realidad son el mismo.

La diferencia tiene que ver con cómo C++ y C# manejan los objetos. En C++ un objeto puede vivir directamente en el stack como un valor. En C# las clases son tipos por referencia y siempre viven en el heap, entonces lo que se copia es la dirección, no el contenido.

**2. ¿Qué es `copia` en cada lenguaje?**

En C++, `copia` es un objeto independiente que vive en el stack. Tiene sus propios valores y su propio espacio en memoria. Cambiar `copia` no cambia `original`.

En C#, `copia` es una variable que guarda la misma referencia que `original`. No es un objeto nuevo, es otra forma de llegar al mismo objeto. Cambiar `copia` cambia `original` también porque son el mismo objeto visto desde dos nombres distintos.


# Actividad Integradora

---

## A. Predicción

### 1 y 2. Salida esperada

Antes de correr el programa analicé función por función para predecir la salida.

`val_A` se pasa por valor, entonces dentro de `sumaPorValor` se modifica la copia pero el original queda igual. `val_B` se pasa por referencia, así que el cambio sí afecta a la variable original. `val_C` se pasa por puntero, mismo efecto que la referencia, el original cambia.

Para `ejecutarContador`, `contador_estatico` empieza en 0 y se incrementa cada llamada, recordando el valor anterior.

Mi predicción de salida:

```
--- Experimento con paso de parámetros ---
Valor inicial de val_A: 20
  -> Dentro de sumaPorValor, 'a' ahora es: 30
Valor final de val_A: 20

Valor inicial de val_B: 20
  -> Dentro de sumaPorReferencia, 'a' ahora es: 30
Valor final de val_B: 30

Valor inicial de val_C: 20
  -> Dentro de sumaPorPuntero, '*a' ahora es: 30
Valor final de val_C: 30

--- Experimento con variables estáticas ---
  -> Llamada a ejecutarContador. Valor de contador_estatico: 1
  -> Llamada a ejecutarContador. Valor de contador_estatico: 2
  -> Llamada a ejecutarContador. Valor de contador_estatico: 3
```

### 3. Mapa de memoria conceptual (justo antes de que main finalice)

```
+--------------------------------------------------+
|               SEGMENTO DE CÓDIGO                 |
|  - main()                                        |
|  - sumaPorValor()                                |
|  - sumaPorReferencia()                           |
|  - sumaPorPuntero()                              |
|  - ejecutarContador()                            |
+--------------------------------------------------+
|          DATOS GLOBALES Y ESTÁTICOS              |
|  - contador_global = 100      (.data)            |
|  - contador_estatico = 3      (.data)            |
+--------------------------------------------------+
|                    HEAP                          |
|  (vacío, no se usó new en este programa)         |
+--------------------------------------------------+
|                   STACK                          |
|  [Frame de main()]                               |
|  - val_A = 20                                    |
|  - val_B = 30                                    |
|  - val_C = 30                                    |
|                                                  |
|  [Frame de sumaPorValor() - ya destruido]        |
|  - parámetro 'a' = 30 (copia, ya no existe)      |
+--------------------------------------------------+
```

El parámetro `a` de `sumaPorValor` ya no existe en el stack cuando `main` está por terminar porque esa función ya retornó. Lo puse igual para aclarar que vivió ahí mientras duró.

---

## B. Verificación y análisis

### 4. Comparación con la predicción

La salida real fue exactamente igual a mi predicción, así que no hubo sorpresas en ese sentido.

Los puntos de interés donde puse breakpoints fueron:

- Al inicio de `main`, para ver los valores iniciales de `val_A`, `val_B` y `val_C`.
- Dentro de `sumaPorValor`, para observar que `a` es una copia independiente.
- Dentro de `sumaPorReferencia`, para confirmar que `a` y `val_B` son la misma variable.
- Dentro de `sumaPorPuntero`, para ver que `*a` apunta directamente a `val_C`.
- Al inicio de cada llamada a `ejecutarContador`, para ver cómo cambia `contador_estatico`.

En el depurador, en la pestaña Autos, pude verificar que:

- Cuando estaba dentro de `sumaPorValor` y modificaba `a`, el valor de `val_A` en el frame de `main` no cambiaba. Son dos variables distintas en el stack.
- Cuando estaba dentro de `sumaPorReferencia`, `a` y `val_B` mostraban la misma dirección de memoria. Cualquier cambio en uno se reflejaba en el otro inmediatamente.
- Lo mismo para `sumaPorPuntero`: el puntero `a` contenía la dirección de `val_C`, y al hacer `*a = *a + 10` se modificaba el valor en esa dirección.

### 5. Qué demuestran las capturas sobre el paso de parámetros

El depurador deja ver algo que el código solo muestra indirectamente: las direcciones de memoria.

En `sumaPorValor`, el parámetro `a` tiene una dirección diferente a `val_A`. Son dos espacios distintos en el stack. Por eso cuando `a` cambia a 30, `val_A` sigue siendo 20.

En `sumaPorReferencia`, la dirección de `a` dentro de la función es exactamente la misma que la de `val_B` en `main`. Eso confirma que la referencia no crea una copia, es un alias del mismo espacio de memoria.

En `sumaPorPuntero`, el puntero `a` contiene como valor la dirección de `val_C`. Al hacer `*a` estamos yendo a esa dirección y modificando lo que hay ahí. El resultado es el mismo que con la referencia, pero el mecanismo es diferente: en la referencia el compilador maneja la indirección automáticamente, con el puntero lo hacemos nosotros con `*`.

### 6. Por qué contador_estatico "recuerda" su valor

Cuando una variable local se declara sin `static`, vive en el stack. Cada vez que la función se llama, se crea un nuevo frame en el stack, la variable se inicializa de nuevo y cuando la función termina ese frame se destruye junto con la variable. La próxima llamada empieza de cero.

`contador_estatico` es diferente porque aunque está declarada dentro de `ejecutarContador`, la palabra `static` hace que el compilador la trate como una variable global internamente. Vive en el segmento de datos estáticos (`.data`), no en el stack. La línea `static int contador_estatico = 0` solo se ejecuta la primera vez que la función es llamada. En las llamadas siguientes esa línea se ignora y la variable conserva el valor que tenía.

Por eso en la primera llamada vale 1, en la segunda 2 y en la tercera 3. No se reinicia porque nunca se destruye entre llamadas.

La diferencia con una variable local normal es justamente esa: el tiempo de vida. Una variable local existe solo mientras su función está activa. Una variable estática local existe durante toda la ejecución del programa, igual que una global, pero solo es accesible desde dentro de la función donde fue declarada.