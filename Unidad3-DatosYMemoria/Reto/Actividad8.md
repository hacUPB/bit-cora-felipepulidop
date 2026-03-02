# Actividad 8: Funciones y Objetos en C++

## Parte 1: Paso por valor — `cambiarNombre(Punto p, string nuevoNombre)`

### Salida del programa

```
Constructor: Punto original (70, 80) creado.
Punto original(70, 80)
Constructor: Punto original (70, 80) creado.     ← copia del objeto
Destructor: Punto cambiado(70, 80) destruido.    ← la copia se destruye al salir de la función
Punto original(70, 80)                           ← original no cambió
Destructor: Punto original(70, 80) destruido.    ← original se destruye al salir del main
```

---

### Reflexión

#### 1. ¿Por qué aparece `Destructor: Punto cambiado(70, 80) destruido.`?

Cuando se llama `cambiarNombre(original, "cambiado")`, C++ crea una **copia** del objeto `original` y se la pasa a la función. Esa copia vive en el stack de la función `cambiarNombre`. Dentro de la función, se cambia el nombre de esa copia a `"cambiado"`. Cuando la función termina, la copia sale del scope y se destruye automáticamente, por eso aparece el mensaje del destructor con el nombre `"cambiado"`. El objeto `original` nunca fue tocado.

#### 2. ¿Por qué `original` sigue existiendo luego de llamar `cambiarNombre`?

Porque `original` vive en el stack del `main`, no en el de `cambiarNombre`. La función recibió una copia independiente. Destruir la copia no afecta al original para nada. `original` sigue vivo hasta que el `main` termine.

#### 3. ¿En qué parte del mapa de memoria están `original` y `p`? ¿Son el mismo objeto?

Ambos están en el **stack**, pero en diferentes marcos (frames) de la pila de llamadas:

- `original` vive en el frame del `main`.
- `p` vive en el frame de `cambiarNombre`.

Al revisar con el depurador, sus **direcciones de memoria son distintas**, lo que confirma que no son el mismo objeto. `p` es una copia independiente que se creó al momento de llamar la función.

---

## Parte 2: Paso por referencia — `cambiarNombre(Punto& p, string nuevoNombre)`

```cpp
void cambiarNombre(Punto& p, string nuevoNombre) {
    p.name = nuevoNombre;
}
```

### Salida del programa

```
Constructor: Punto original (70, 80) creado.
Punto original(70, 80)
Punto cambiado(70, 80)                          ← ¡el nombre sí cambió!
Destructor: Punto cambiado(70, 80) destruido.   ← solo un destructor, el del original
```


### ¿Qué ocurre ahora? ¿Por qué?

Ahora la función recibe una **referencia** al objeto original, no una copia. Eso significa que `p` es otro nombre para `original` — apuntan al mismo lugar en memoria. Al hacer `p.name = nuevoNombre`, se está modificando directamente el objeto `original`. Por eso al llamar `original.imprimir()` después, ya muestra `"cambiado"`. Además, ya no aparece un destructor extra porque nunca se creó ninguna copia.

---

## Parte 3: Paso por puntero — `cambiarNombre(Punto* p, string nuevoNombre)`

```cpp
void cambiarNombre(Punto* p, string nuevoNombre) {
    p->name = nuevoNombre;
}

int main() {
    Punto original("original", 70, 80);
    original.imprimir();
    cambiarNombre(&original, "cambiado");
    original.imprimir();
    return 0;
}
```

### Salida del programa

```
Constructor: Punto original (70, 80) creado.
Punto original(70, 80)
Punto cambiado(70, 80)                          ← el nombre también cambió
Destructor: Punto cambiado(70, 80) destruido.   ← solo un destructor
```


### ¿Qué ocurre ahora? ¿Por qué?

El resultado es el mismo que con la referencia: el nombre de `original` cambia a `"cambiado"`. La diferencia es la sintaxis. En lugar de recibir directamente el objeto o un alias de él, la función recibe la **dirección de memoria** del objeto (`&original`). Dentro de la función, se usa `p->name` para acceder al atributo a través del puntero. Como se está trabajando sobre la misma dirección de memoria que `original`, los cambios sí se reflejan en el objeto real.

---

## Resumen: Diferencia entre los tres métodos

| | Por valor | Por referencia | Por puntero |
|---|---|---|---|
| **Sintaxis** | `Punto p` | `Punto& p` | `Punto* p` |
| **¿Crea copia?** |  Sí |  No |  No |
| **¿Modifica el original?** |  No |  Sí |  Sí |
| **¿Llama al destructor extra?** |  Sí (la copia) |  No |  No |
| **Cómo se llama** | `cambiarNombre(original, ...)` | `cambiarNombre(original, ...)` | `cambiarNombre(&original, ...)` |
| **Cómo se usa dentro** | `p.name` | `p.name` | `p->name` |

En resumen: pasar por **valor** es seguro pero hace una copia costosa y no modifica el original. Pasar por **referencia** o **puntero** evita la copia y permite modificar el objeto original, siendo la referencia más cómoda de usar y el puntero más explícito sobre lo que está pasando en memoria.