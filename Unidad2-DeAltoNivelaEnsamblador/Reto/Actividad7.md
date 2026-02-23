# Actividad 7


# Recuperación de conocimiento

### 1. ¿Cómo se representa y manipula un puntero en Hack?

Un puntero en Hack no existe como algo especial, no hay una palabra reservada para eso como en C++. En realidad es solo una variable que guarda una dirección de memoria.

Si quiero hacer algo como `p = &a`, lo que hago es cargar la dirección de `a` y guardarla en `p`. Algo así:

```asm
@a
D=A
@p
M=D
```

Ahí estoy guardando la dirección de `a` dentro de `p`.

Y si quiero hacer algo como `*p = 20`, primero tengo que ir a la dirección que está guardada en `p`. Para eso uso `A=M`, porque eso hace que el registro A tome la dirección almacenada en `p`. Luego ya puedo escribir el valor:

```asm
@20
D=A
@p
A=M
M=D
```

Lo que entendí es que la parte importante es usar `A=M`, porque eso es lo que realmente hace que vaya a la dirección apuntada.

---

### 2. ¿Cómo implementarías `arr[j]` en ensamblador?

En Hack, un arreglo no es algo especial, solo son posiciones consecutivas en memoria.

Entonces necesito:
- La dirección base donde empieza el arreglo.
- El índice `j`.

Para acceder a `arr[j]` tengo que sumar la dirección base más el valor de `j`. Eso me da la dirección real del elemento.

Básicamente sería:
- Dirección base + j → dirección del elemento.
- Luego accedo a esa dirección.

El índice `j` sirve para saber cuánto me muevo desde el inicio del arreglo. El arreglo no sabe que es arreglo, solo es memoria continua.

---

# Reflexión sobre mi proceso

### 1. ¿Qué fue lo más difícil de traducir?

Lo más difícil para mí fueron los punteros.

En C++ se ven fáciles, como que solo pones `*p` y ya. Pero en ensamblador tienes que pensar en direcciones y valores por separado. Me confundía mucho entre `D=M`, `D=A` y `A=M`.

Lo que me ayudó fue hacer ejemplos pequeños y ver qué pasaba en la memoria paso por paso.

---

### 2. ¿Cómo ayudó construir el programa paso a paso?

Sí ayudó bastante.

Cuando intentaba hacerlo todo de una vez, me equivocaba y no sabía dónde estaba el error. Pero cuando lo hacía por partes, era más fácil.


---

### 3. ¿Qué concepto de bajo nivel te sientes más seguro de identificar en C++?

Creo que ahora entiendo mejor:

- Los punteros.
- Los arreglos.
- Los ciclos.

Cuando veo un `for`, ya no lo veo como algo mágico, sino como una comparación, un salto y un incremento.

Y con los arreglos ahora sé que en realidad son posiciones consecutivas en memoria.

Todavía me cuesta un poco, pero ya entiendo mejor qué está pasando “por debajo” cuando escribo código en C++.
