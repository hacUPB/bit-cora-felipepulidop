# Actividad 4

## Objetivo
Diseñar un programa que compare el valor almacenado en la dirección de memoria 5 con el valor constante 10, y según el resultado, almacene un valor en la dirección de memoria 7.

## Condición del problema
- Si el valor en la dirección 5 es **menor que 10**, se guarda el valor **1** en la dirección 7.
- Si el valor en la dirección 5 es **mayor o igual a 10**, se guarda el valor **0** en la dirección 7.

## Metodología de simulación

### 1. Predicción
Se espera que el programa lea el valor almacenado en la dirección 5, lo compare con el valor 10 y, dependiendo del resultado de la comparación, almacene 1 o 0 en la dirección 7.

### 2. Ejecución
El programa carga el valor de la memoria, realiza la comparación usando una resta y emplea instrucciones de salto para decidir qué valor guardar.

### 3. Observación
Se observa cómo el flujo del programa cambia según el resultado de la comparación, ejecutando una u otra sección del código.

### 4. Reflexión
El uso de saltos condicionales permite controlar el flujo del programa y tomar decisiones, lo cual es fundamental para la lógica de cualquier sistema computacional. 

Un apartado interesante es como el programa al no reconocer numeros negativos y al manejarse a 16 bits los representa en el caso del -5 como 65531, ya que el computador lo entiendo por medio de los binarios 

![alt text](image.png)