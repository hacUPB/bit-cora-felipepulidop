# Actividad 1

## Nand2Tetris 

En esta actividad nos acercamos la curso **Nand2Tetris**, el cual propone entender cómo funciona un computador desde su nivel más básico hasta la ejecución de programas completos. 

Al revisar la arquitectura del computador **Hack**, entendí mejor el papel central de la **CPU** como el componente encargado de ejecutar instrucciones y controlar el flujo del programa. La CPU no trabaja de forma aislada, sino que depende constantemente de la **memoria**, donde se almacenan tanto los datos como las instrucciones, y de los **buses**, que permiten la comunicación entre todos los componentes.

Un punto clave para mí fue comprender la diferencia entre el **bus de datos** y el **bus de direcciones**. Mientras el primero transporta la información que se lee o escribe, el segundo define *dónde* ocurre esa operación. Esta distinción aclara cómo una instrucción puede operar sobre una posición específica de memoria sin ambigüedad.

También entendí que los **periféricos** (pantalla y teclado en Hack) no son elementos externos “mágicos”, sino que hacen parte del mismo sistema de memoria y se comunican con la CPU usando los mismos mecanismos que los demás componentes. Esto ayuda a desmitificar la interacción entre hardware y usuario.

En general, esta actividad me permitió ver el computador como un sistema coherente de partes simples que, al combinarse, logran comportamientos complejos. Este entendimiento será clave para las siguientes actividades del curso, especialmente al trabajar con lenguaje ensamblador y control explícito de la memoria.

# Actividad 2

## Ciclo Fetch–Decode–Execute (Hack)

En esta actividad trabajé con un programa sencillo en lenguaje ensamblador del computador **Hack**, lo cual me permitió entender de forma práctica cómo la CPU ejecuta instrucciones mediante el ciclo **Fetch–Decode–Execute**.

### Análisis del programa dado

Al ejecutar el programa en el simulador de la CPU Hack, entendí que su objetivo principal es **sumar los valores 1 y 2 y almacenar el resultado en la dirección de memoria 16**.

Paso a paso, el programa:
- Carga el valor `1` en el registro **D**.
- Luego carga el valor `2` y lo suma con el contenido previo del registro **D**.
- Finalmente, guarda el resultado de la suma en la posición **RAM[16]**.
- El programa entra en un ciclo infinito usando una etiqueta `(END)` para evitar que la CPU continúe ejecutando memoria basura.

El valor almacenado en la dirección de memoria **16** es **3**, lo cual tiene sentido porque es el resultado de `1 + 2`.

### Observaciones sobre el ciclo Fetch–Decode–Execute

Al observar la ejecución paso a paso en el simulador, noté que en cada instrucción ocurre lo siguiente:
- **Fetch:** la CPU lee la instrucción desde la memoria ROM usando el contador de programa (PC).
- **Decode:** la instrucción se interpreta (por ejemplo, si es una instrucción A o C).
- **Execute:** se actualizan los registros (A, D) o la memoria RAM según la instrucción.

Me resultó interesante ver cómo **cada línea del programa se ejecuta en un ciclo independiente**, y cómo pequeños cambios en los registros afectan directamente el estado de la memoria.

---

### Segundo experimento: suma de 5 y 10

En el segundo experimento escribí un programa en ensamblador que suma los valores **5** y **10** y almacena el resultado en la dirección de memoria **20**. Al ejecutarlo en el simulador, confirmé que el valor final almacenado en **RAM[20]** es **15**, lo que valida el correcto funcionamiento del programa y refuerza la lógica vista en el primer ejercicio.

Este ejercicio ayudó a reforzar la idea de que incluso operaciones simples requieren varios pasos explícitos en lenguaje ensamblador.

---

### Diferencia entre ROM y RAM

Una conclusión clave de esta actividad fue entender claramente la diferencia entre **ROM** y **RAM**:

- **ROM (Read Only Memory):** almacena las instrucciones del programa. Su contenido no cambia durante la ejecución.
- **RAM (Random Access Memory):** almacena datos temporales y resultados de operaciones. Su contenido sí cambia mientras el programa se ejecuta.

Esta separación deja claro cómo el computador distingue entre *qué hacer* (programa) y *con qué datos hacerlo* (información).

---

### Conclusión

Esta actividad me permitió comprender que el ciclo Fetch–Decode–Execute no es solo un concepto teórico, sino un proceso visible y repetitivo que ocurre en cada instrucción. Ver este ciclo en acción facilita entender cómo una CPU transforma instrucciones simples en comportamientos más complejos, y prepara el terreno para trabajar con programas más elaborados en ensamblador.

# Actividad 3  
## Explorando la arquitectura del computador Hack

En esta actividad analicé un programa más complejo en lenguaje ensamblador del computador **Hack**, el cual integra varios conceptos fundamentales de la arquitectura del sistema. A diferencia de las actividades anteriores, este programa no solo realiza operaciones aritméticas, sino que interactúa con el **teclado**, la **pantalla**, implementa **condiciones** y utiliza **bucles** de forma explícita.

---

## Uso de la ALU

Una instrucción que hace uso directo de la **ALU** es:

`D=D-A`

En esta instrucción, la ALU realiza una operación aritmética de **resta** entre el contenido del registro `D` y el registro `A`, almacenando el resultado nuevamente en `D`. Esta operación se utiliza para realizar comparaciones y controlar el flujo del programa.

---

## Función del registro PC

El **PC (Program Counter)** es el registro encargado de almacenar la dirección de la siguiente instrucción que la CPU debe ejecutar en la memoria ROM. Durante la ejecución normal, el PC avanza secuencialmente, pero puede cambiar cuando se ejecutan instrucciones de salto, permitiendo la implementación de bucles y condiciones.

---

## Diferencia entre `@i` y `@READKEYBOARD`

- `@i` hace referencia a una posición de **memoria RAM** utilizada como variable para almacenar datos temporales.
- `@READKEYBOARD` es una **etiqueta** que indica una dirección en la **memoria ROM**, usada como punto de salto dentro del programa.

En resumen, `@i` se usa para datos y `@READKEYBOARD` para control del flujo.

---

## Lectura del teclado y escritura en pantalla

El teclado se lee accediendo a la dirección especial `@KBD`, cuyo valor cambia dependiendo de si una tecla está presionada.  
La pantalla se controla escribiendo directamente en la memoria mapeada a `SCREEN`, lo que demuestra que la salida gráfica se maneja mediante escritura en memoria RAM.

---

## Identificación de un bucle

El bucle principal del programa inicia en la etiqueta `READKEYBOARD` y se mantiene gracias a saltos incondicionales que hacen que la CPU repita continuamente la lectura del teclado y la actualización de la pantalla.

---

## Identificación de una condición

Una condición clave se presenta cuando el programa evalúa si una tecla está presionada. Dependiendo del valor leído desde `KBD`, se decide si el flujo del programa continúa normalmente o salta a otra sección del código.

---

## Conclusión

Este ejercicio permitió comprender cómo funcionalidades como entrada de usuario, salida gráfica, condiciones y bucles se construyen desde instrucciones básicas en ensamblador, reforzando la relación directa entre hardware y software en el computador Hack.
