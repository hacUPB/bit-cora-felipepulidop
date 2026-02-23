# Actividad 3

## Análisis del programa de la Actividad 3

A partir del código proporcionado, se puede construir el siguiente mapa de memoria indicando dónde se ubica cada variable, constante y función del programa.

---

## Mapa de Memoria

```
+-----------------------------------------------+
|           SEGMENTO DE CÓDIGO (Text)            |
|   - Instrucciones compiladas de:               |
|     · main()                                   |
|     · suma()                                   |
|     · funcionConStatic()                       |
|     · crearArrayHeap()                         |
+-----------------------------------------------+
|     ZONA DE SOLO LECTURA (Read-Only Data)      |
|   - mensaje_ro → "Hola, memoria de solo        |
|     lectura"  (el contenido de la cadena)      |
+-----------------------------------------------+
|   VARIABLES GLOBALES E INICIALIZADAS (.data)   |
|   - global_inicializada = 42                   |
|   - var_estatica = 100  (static local)         |
+-----------------------------------------------+
|   VARIABLES GLOBALES NO INICIALIZADAS (.bss)   |
|   - global_no_inicializada                     |
+-----------------------------------------------+
|                    HEAP                        |
|   (crece hacia arriba ↑)                       |
|   - arrayHeap → int[10] creado con new         |
|     (liberado con delete[] al final)           |
|                                                |
|                                                |
+-----------------------------------------------+
|                   STACK                        |
|   (crece hacia abajo ↓)                        |
|                                                |
|   [Frame de main()]                            |
|   - a = 10                                     |
|   - b = 20                                     |
|   - c = 30  (resultado de suma)                |
|   - tamArray = 10                              |
|   - arrayHeap (puntero, no el array)           |
|                                                |
|   [Frame de suma(a, b)]                        |
|   - parámetro a = 10                           |
|   - parámetro b = 20                           |
|   - variable local c = 30                      |
|                                                |
|   [Frame de funcionConStatic()]                |
|   - (sin variables locales normales;           |
|     var_estatica NO está aquí, está en .data)  |
|                                                |
|   [Frame de crearArrayHeap(tam)]               |
|   - parámetro tam = 10                         |
|   - puntero local arr (apunta al Heap)         |
+-----------------------------------------------+
```

---

## Descripción detallada por segmento

### Segmento de Código (Text)
Aquí residen todas las **instrucciones compiladas** del programa. Las funciones `main()`, `suma()`, `funcionConStatic()` y `crearArrayHeap()` se almacenan en esta región. Es de **solo lectura** durante la ejecución para evitar modificaciones accidentales.

### Zona de Solo Lectura
El contenido literal de la cadena `"Hola, memoria de solo lectura"` se guarda en esta sección. El puntero `mensaje_ro` (declarado como `const char* const`) apunta hacia aquí. Intentar modificar el contenido a través de ese puntero causaría un error en tiempo de ejecución.

### Variables Globales Inicializadas (.data)
- `global_inicializada = 42`: es una variable global con valor explícito, por lo que va al segmento `.data`.
- `var_estatica = 100`: aunque está declarada **dentro** de `funcionConStatic()`, la palabra clave `static` hace que su valor persista entre llamadas. Por eso se almacena en esta sección y **no** en el Stack.

### Variables Globales No Inicializadas (.bss)
- `global_no_inicializada`: no tiene un valor asignado explícitamente, por lo que el sistema operativo la ubica en el segmento `.bss` y la inicializa automáticamente en `0`.

### Heap (Memoria Dinámica)
- `arrayHeap`: el operador `new int[10]` reserva espacio para 10 enteros en el Heap. El **puntero** `arrayHeap` vive en el Stack (es una variable local de `main()`), pero los **datos** a los que apunta viven en el Heap. Esta memoria debe liberarse manualmente con `delete[]`, como se hace al final del programa.

### Stack (Pila de Llamadas)
En el Stack se crean y destruyen automáticamente los **marcos de llamada** (frames) de cada función:

| Función             | Variables en el Stack                          |
|---------------------|------------------------------------------------|
| `main()`            | `a`, `b`, `c`, `tamArray`, puntero `arrayHeap` |
| `suma(int a, int b)`| parámetros `a`, `b`; variable local `c`        |
| `funcionConStatic()`| (ninguna variable normal; `var_estatica` está en `.data`) |
| `crearArrayHeap(int tam)` | parámetro `tam`; puntero local `arr`     |

---

## Conclusión

| Elemento del programa              | Segmento de memoria          |
|------------------------------------|------------------------------|
| `main()`, `suma()`, etc.           | Código (Text)                |
| `"Hola, memoria de solo lectura"`  | Solo lectura (Read-Only)     |
| `global_inicializada = 42`         | Globales inicializadas (.data)|
| `var_estatica = 100`               | Globales inicializadas (.data)|
| `global_no_inicializada`           | Globales no inicializadas (.bss)|
| `new int[10]` (datos del array)    | Heap                         |
| Variables locales de `main()`      | Stack                        |
| Variables locales de `suma()`      | Stack                        |
| Puntero `arr` en `crearArrayHeap()`| Stack                        |
| Puntero `arrayHeap` en `main()`    | Stack                        |