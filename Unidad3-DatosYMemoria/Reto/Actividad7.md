# Actividad 7: Objetos en el Heap — Creación y Observación

## Análisis del código

Este programa crea dos objetos de la clase `Punto`:

- `pStack`: creado directamente en el **stack**, como en la actividad anterior.
- `pHeap`: creado dinámicamente en el **heap** usando `new`, y accedido a través de un puntero.

Al ejecutar el programa, la salida es:

```
Constructor: Punto(30, 40) creado.
Punto(30, 40)
Constructor: Punto(50, 60) creado.
Punto(50, 60)
Destructor: Punto(50, 60) destruido.   ← lo destruye el delete
Destructor: Punto(30, 40) destruido.   ← lo destruye automáticamente al salir del main
```


---

## Comparación de direcciones de memoria en el depurador

Al detenerme en los breakpoints y revisar las direcciones de memoria, se puede notar algo importante:

- La dirección de `pStack` suele ser algo como `0x00AFFXXX` — una dirección **alta**, típica del stack.
- El valor de `pHeap` (que es la dirección del objeto en el heap) suele ser algo como `0x00A1XXXX` — una dirección **más baja**, típica del heap.

Esto refleja que el stack y el heap son regiones distintas de la memoria del proceso.


---

## Observación de `&pHeap` en Memory 1

Cuando se escribe `&pHeap` en Memory 1, se está viendo la dirección de memoria **donde vive el puntero en sí** (en el stack). El contenido que muestra son los bytes de la dirección a la que apunta `pHeap`, es decir, la dirección del objeto en el heap.

Por ejemplo, si `pHeap` vale `0x00A17B40`, en la memoria de `&pHeap` se verán esos mismos bytes almacenados (en formato little-endian):

```
40 7B A1 00   ← dirección del objeto en el heap, guardada en el puntero
```

Esto confirma que `pHeap` es simplemente una variable que guarda una dirección, y esa dirección apunta al objeto real que vive en el heap.


---

## Reflexión sobre las preguntas

### 1. Diferencia entre objetos creados en el stack y en el heap

La diferencia principal está en **quién maneja la memoria** y **cuándo se libera**:

| | Stack | Heap |
|---|---|---|
| **Creación** | `Punto p(30, 40);` | `Punto* p = new Punto(50, 60);` |
| **Liberación** | Automática al salir del scope | Manual con `delete` |
| **Velocidad** | Más rápido | Un poco más lento |
| **Tamaño** | Limitado | Mucho más grande |
| **Riesgo** | Ninguno | Memory leak si se olvida el `delete` |

En el stack, el objeto nace y muere solo. En el heap, el programador es responsable de crearlo y destruirlo.

---

### 2. `pStack` ¿Es un objeto o una referencia a un objeto?

`pStack` es directamente **el objeto**. Los datos (`x = 30`, `y = 40`) viven justo en la dirección de memoria de `pStack`. No hay ningún nivel de indirección: `pStack` ES el objeto.

---

### 3. `pHeap` ¿Es un objeto o una referencia a un objeto?

`pHeap` es un **puntero**, es decir, una referencia (indirecta) a un objeto. La variable `pHeap` en sí solo guarda una dirección de memoria. El objeto real con los valores `x = 50` y `y = 60` vive en otra parte de la memoria (el heap), y `pHeap` apunta hacia allá.

Para acceder a los datos del objeto se usa `pHeap->x` o `(*pHeap).x`, porque primero hay que "ir" a la dirección que guarda el puntero.

---

### 4. Observación de `&pHeap` en Memory 1 vs el valor de `pHeap` en variables

Cuando escribo `&pHeap` en Memory 1, veo los bytes que están almacenados en la posición donde vive el puntero (en el stack). Esos bytes, leídos en little-endian, forman exactamente el valor que muestra `pHeap` en la ventana de variables del depurador.

Es decir:
- `&pHeap` → dirección del puntero en el stack (donde vive la variable `pHeap`)
- `pHeap` → el valor guardado ahí, que es la dirección del objeto en el heap

Esto deja muy claro que un puntero es simplemente una variable que guarda una dirección. No contiene el objeto, solo sabe dónde encontrarlo.