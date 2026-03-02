# Actividad 6
## Predice

El valor final de sum será la suma de los 10 elementos en el arreglo

## Ejecuta

- Inician los valores de el arreglo desde la dirección 16.

- Se inicia sum = 0.

- Se inicia j = 0.

- El puntero p apunta a la dirección 16.

- Mientras j < 10:

- Lee el valor apuntado por p.

- Se suma a sum.

- Sube de valor p.

- Sube de valor j.

- El ciclo termina cuando j sea igual a 10.

## Observa

Al finalizar sum es igual a `2392`, j igual a `10` y p igual a `26`

## Reflexiona

El recorrido del arreglo se realizó utilizando un puntero que fue subiendo de valor. Cada iteración accede indirectamente a la memoria usando A=M.

# Construcción paso a paso mediante pruebas
## Prueba 1: Inicialización del arreglo

**Objetivo:** Verificar que los valores se guardan correctamente desde la dirección 16.

**Prueba realizada:** Ejecuté solo la parte de inicialización y revisé manualmente las posiciones 16–25 en el simulador.

## Prueba 2: Sumar un solo elemento

**Objetivo:** Verificar que el puntero accede correctamente al primer elemento.
**Prueba realizada:** Ejecuté una sola iteración del ciclo y comprobé que sum tomó el valor 11.

## Prueba 3: Incremento del puntero

**Objetivo:** Verificar que p avanza correctamente.
**Prueba realizada:** Observé que después de una iteración p cambió de 16 a 17.

## Prueba 4: Ejecución completa

**Objetivo:** Verificar que el ciclo recorre los 10 elementos.
**Prueba realizada:** Ejecuté el programa completo y confirmé que:

j = 10

sum = 2392

## Prueba final:

Se ejecutó en el simulador Hack.

Se verificó que el valor almacenado en sum es 2392, confirmando que el recorrido del arreglo fue correcto.