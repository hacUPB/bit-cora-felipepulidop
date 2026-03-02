# Actividad 9: Objetos con miembros estáticos y variables de instancia

## Ejecución del programa

La salida del programa es:

```
Contador creado. total de Contadores = 1
Contador creado. total de Contadores = 2
Contador creado. total de Contadores = 3
c1.valor = 6
c2.valor = 11
c3->valor = 16
Contador destruido. valor = 16   ← c3, destruido por el delete
Contador destruido. valor = 11   ← c2, destruido al salir del main
Contador destruido. valor = 6    ← c1, destruido al salir del main
```

Lo primero que llama la atención es que `total` sube con cada objeto creado, sin importar si es `c1`, `c2` o `c3`. Eso ya da una pista de que `total` no pertenece a ningún objeto en particular, sino a la clase entera.

---

## Observación en Memory 1

Al escribir `&c1` en Memory 1, se ven los bytes del objeto. Solo aparece el contenido de `valor` (por ejemplo `05 00 00 00` para el valor 5). El miembro `total` **no aparece** en la memoria del objeto porque no vive ahí, vive en otra parte.

Si se intenta buscar `Contador::total` usando el Watch (click derecho → Add Watch), el depurador lo muestra como una variable separada, con su propia dirección de memoria completamente distinta a la de `c1` o `c2`.



---

## ¿Dónde está almacenado cada miembro?

- **`valor`** vive dentro de cada objeto. Cada `Contador` tiene su propio `valor` en su propio espacio de memoria.
- **`total`** es estático, así que vive en el segmento de datos del programa (memoria estática/global), no dentro de ningún objeto. Es una sola variable compartida por todos.

---

## Reflexión

### 1. ¿Qué se puede concluir sobre los miembros estáticos vs. de instancia?

Los **miembros de instancia** como `valor` existen una vez por objeto. Cada `Contador` tiene su propio `valor` independiente, y viven junto al objeto en la memoria. Cuando el objeto se destruye, `valor` desaparece con él.

Los **miembros estáticos** como `total` son distintos: existe una sola copia para toda la clase, sin importar cuántos objetos se creen. No viven dentro de ningún objeto sino en el segmento de datos del programa, y persisten durante toda la ejecución.

**Ventajas de los miembros estáticos:**
- Sirven para guardar información compartida entre todos los objetos, como un contador global.
- Se puede acceder a ellos sin necesidad de tener un objeto creado (`Contador::total`).

**Desventajas:**
- Al ser compartidos, si un objeto los modifica, afecta a todos. Esto puede generar errores difíciles de rastrear si no se tiene cuidado.
- Ocupan memoria durante toda la ejecución del programa, aunque no se estén usando.

**¿Cuándo usarlos?** Cuando se necesita algo que pertenezca a la clase en general y no a un objeto específico. El ejemplo clásico es exactamente este: contar cuántas instancias de una clase se han creado.

---

### 2. ¿En qué segmento de memoria están almacenados c1, c2, c3 y Contador::total?

- **`c1` y `c2`** están en el **stack**. Se declararon como variables locales dentro del `main`, así que el compilador les asigna espacio en el stack automáticamente.

- **`Contador::total`** está en el segmento de **datos estáticos** (o datos globales). Fue inicializado explícitamente con `int Contador::total = 0;` fuera de cualquier función, lo que lo coloca en esa región de memoria que existe durante toda la vida del programa.

- **`c3`** hay que pensarlo con cuidado porque tiene dos partes:
  - La variable `c3` en sí (el puntero) está en el **stack**, porque se declaró como variable local en el `main`.
  - El objeto al que apunta `c3`, el que se creó con `new Contador(15)`, está en el **heap**. El `new` es justamente lo que lo manda ahí, y por eso hay que llamar a `delete c3` para liberarlo manualmente.

