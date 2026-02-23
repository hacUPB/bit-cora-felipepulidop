# Actividad 4 

voy a ir experimento por experimento explicando que pasó y por qué creo que pasó eso.

---

## Experimento 1 - tocar el segmento de código

lo que hace este código es buscar la dirección donde está guardada la función `main` y tratar de escribir un 0 ahí. o sea, está intentando modificar las instrucciones del programa mientras corre.

lo que pasa es que el programa se rompe. tira un error y se cierra solo. en windows sale algo como "access violation" o una pantalla de error.

esto pasa porque el segmento de código es de **solo lectura**. el sistema operativo no deja que nadie escriba ahí mientras el programa está corriendo. tiene sentido porque si pudieras modificar las instrucciones del programa desde adentro del mismo programa sería un caos total, cualquier bug podría corromper el código.

---

## Experimento 2 - tocar la constante global

acá se intenta modificar el contenido del string `"Hola, memoria de solo lectura"` usando un puntero. el nombre ya lo dice todo honestamente.

pasa lo mismo que en el experimento 1: el programa explota con un error de acceso. el string literal está guardado en una zona de memoria protegida (solo lectura igual que el código) y el sistema operativo no deja escribir ahí.

lo importante a notar es que `mensaje_ro` es `const char* const`, o sea que ni el puntero ni lo que apunta se puede cambiar. pero incluso si intentaras hacer el cast para saltarte eso, el hardware igual te bloquea porque la página de memoria donde vive ese string está marcada como no escribible.

---

## Experimento 3 - tocar variables globales normales

este experimento es diferente a los dos anteriores porque acá sí funciona todo bien.

primero imprime:
```
global_inicializada: 42
global_no_inicializada: 0
```

después de modificarlas imprime:
```
global_inicializada: 69
global_no_inicializada: 666
```

funciona porque estas variables están en el segmento `.data` o `.bss` que sí es de lectura y escritura. no son constantes ni son código, son datos normales que el programa puede cambiar cuando quiera.

lo curioso es que `global_no_inicializada` empieza en 0 y no en basura. eso es porque el sistema operativo inicializa en 0 todo lo que va al segmento `.bss` automáticamente.

---

## Experimento 4 - acceder a var_estatica desde afuera de su función

este código ni siquiera compila. el compilador se queja antes de que puedas correrlo.

el error es algo como: `'var_estatica' was not declared in this scope`

y tiene sentido. `var_estatica` está declarada **adentro** de `funcionConStatic()`, entonces su nombre solo existe dentro de esa función. desde `main()` no se puede acceder a ella directamente porque está fuera de su scope.

esto es importante entenderlo: que una variable `static` viva en el segmento `.data` y no en el stack **no significa** que se pueda acceder desde cualquier parte. el alcance (scope) sigue siendo el mismo bloque donde fue declarada. la diferencia con una variable normal es solo el tiempo de vida, no la visibilidad.

**¿qué pasa con las variables locales normales al entrar y salir de una función?**

se crean cuando la función empieza y se destruyen cuando termina. cada llamada crea una copia nueva desde cero.

**¿y con las variables estáticas?**

se crean la primera vez que la función se llama y se quedan vivas para siempre hasta que el programa termina. si la función se llama de nuevo, la variable todavía tiene el valor que tenía la última vez.

---

## Experimento 5 - estática vs no estática en un loop

la salida del programa es esta:

```
Iteración 0
var_no_estatica: 100
var_estatica: 100
Iteración 1
var_no_estatica: 100
var_estatica: 101
Iteración 2
var_no_estatica: 100
var_estatica: 102
Iteración 3
var_no_estatica: 100
var_estatica: 103
Iteración 4
var_no_estatica: 100
var_estatica: 104
```

`var_no_estatica` siempre vale 100 porque cada vez que entra a la función se crea de nuevo con ese valor. cuando sale de la función se destruye y la próxima llamada empieza de cero.

`var_estatica` en cambio empieza en 100 solo la primera vez. después de cada llamada se incrementa y mantiene ese valor. en la segunda llamada ya vale 101, en la tercera 102 y así.

la diferencia es clara: la no estática vive en el stack y muere cada vez que la función termina. la estática vive en `.data` y sobrevive entre llamadas.

---

## Experimento 6 - usar memoria del heap después de liberarla

el programa libera el array con `delete[]` y después intenta leer `arrayHeap[0]`.

lo que puede pasar es:
- el programa imprime algún número raro (basura)
- o el programa se cae con un error

esto se llama **use after free** y es uno de los bugs más peligrosos que existen en C++. cuando haces `delete[]` le estás diciendo al sistema que ya no necesitas esa memoria, pero el puntero sigue apuntando a la misma dirección. si lees o escribes ahí después estás accediendo a memoria que ya no te pertenece.

**diferencias entre heap y stack:**

el stack se maneja solo, las variables aparecen y desaparecen automáticamente. el heap hay que manejarlo a mano con `new` y `delete`. si te olvidas del `delete` la memoria queda ocupada para siempre mientras el programa corra.

**¿qué pasa si no liberas la memoria?**

se produce un **memory leak**. la memoria queda reservada pero ya nadie la usa ni puede usarla. en un programa pequeño no se nota, pero en uno grande o que corre mucho tiempo puede llegar a consumir toda la RAM disponible.

**¿por qué usar `delete[]` y no solo `delete`?**

porque `new int[tam]` reservó un arreglo, no un solo entero. `delete[]` le dice al sistema que tiene que liberar todos los elementos del arreglo. si usas solo `delete` puede que solo libere el primero y el resto quede perdido, lo que causaría un memory leak parcial o comportamiento indefinido.