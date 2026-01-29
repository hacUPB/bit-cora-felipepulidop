# Actividad 6|||

### 1. Ciclo Fetch–Decode–Execute
**Describe con tus palabras las tres fases del ciclo Fetch-Decode-Execute. ¿Qué rol juega el Program Counter (PC) en este ciclo?**

Respuesta: 
- **Fetch:** la CPU lee la instrucción desde la memoria ROM usando PC que es el contador de programas.
- **Decode:** Aqui es donde esa instrucción se interpreta de si es una instruccion **A** o **C**
- **Execute:** Se actualizan los registros o la memoria segun la instrucción.

  
---

### 2. Instrucciones A vs Instrucciones C
**¿Cuál es la diferencia fundamental entre una instrucción-A (`@`) y una instrucción-C (`D`, `M`, `A`, etc.) en el lenguaje ensamblador de Hack? Da un ejemplo de cada una.**

Respuesta: La instruccion `@` se refiere a la direccion de memoria, mientras que una instruccion `C` se refiere a un registro  
  
---

### 3. Componentes del computador Hack
**Explica la función del registro D, el registro A y la ALU.**

Respuesta: 
- **D:** Se refiere a un dato de trabajo que se guarda en un registro aparte. 
- **A:** Este se refiere a la direccion de registro.
- **ALU:** Esta es la unidad que realiza todas las operaciones aritmeticas:
  
---

### 4. Saltos condicionales
**¿Cómo se implementa un salto condicional en Hack? Describe un ejemplo.**

Respuesta: Se implementa usando una instrucción `C` con una condición de salto.
Primero se realiza una operación que deja un resultado en el registro D, y luego se usa una condición como JMP, JLT o JEQ.
Por ejemplo, para saltar si D es mayor que cero, se usa una instrucción como D;JGT.
  
---

### 5. Implementación de loops
**¿Cómo se implementa un loop en el computador Hack? Describe un ejemplo.**

Respuesta: Un loop se implementa usando una etiqueta y un salto condicional o incondicional que vuelve a esa etiqueta.

Por ejemplo, un loop que decrementa un valor hasta llegar a cero salta de nuevo mientras el valor sea mayor que cero.
---

### 6. Diferencia entre `D=M` y `M=D`
**¿Cuál es la diferencia entre estas dos instrucciones?**

Respuesta: En la primera se asigna el valor de la memoria en determinada direccion a el registro que guarda este dato y en la segunda pasa lo mismo pero en viceversa
  
---

### 7. Entrada y salida (KBD y SCREEN)
**Describe brevemente qué se necesita para leer un valor del teclado (`KBD`) y para pintar un pixel en la pantalla (`SCREEN`).**

Respuesta: Para leer el teclado (KBD), se accede a su dirección de memoria mapeada y se lee el valor que representa la tecla presionada.
Para pintar un pixel en la pantalla (SCREEN), se escribe un valor en una dirección específica de la memoria de pantalla, lo que cambia el estado visual de ese pixel.
  
---

## Parte 2: Reflexión sobre tu proceso (Metacognición)

### 1. Mayor desafío
**¿Cuál fue el concepto o actividad más desafiante de esta unidad para ti y por qué?**

Respuesta: Entender como funcionaban los numero negativos dentro de un programa de 16 bits
  
---

### 2. Metodología de trabajo
**¿En qué momento la metodología de predecir, ejecutar, observar y reflexionar te ayudó más a entender un concepto?**

Respuesta: Me ayudo a entender muchisimo mejor cada ejercicio ya que analizaba cada paso
  
---

### 3. Momento “¡Aha!”
**Describe un momento en el que algo hizo clic para ti durante esta unidad.**

Respuesta: Al momento en donde pude entender como funciona internamente o al menos en binarios un sistema de 16 bits
  
---

### 4. Mirando hacia la próxima unidad
**¿Qué harás diferente en tu proceso de estudio para aprender de manera más efectiva?**

Respuesta: Haria lo mismo que hice en un punto en donde analizaba cada parte para poder entender mucho mejor 
  
---
