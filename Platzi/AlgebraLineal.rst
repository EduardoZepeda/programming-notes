==============
Algebra lineal
==============

Un vector es una lista finita de números. Los encontramos en dos presentaciones:

* Vector columna (vertical)
* Vector renglón (horizontal)

La dimension o longitud es la cantidad de elementos que tiene el vector. 

Si nos referimos a un elemento del vector se le llamará escalar, si está dentro del vector se le llamará coeficiente.

El vector siguiente tiene 3 coeficientes.

:math:`{1,2,3}` 


Igualdad
========

Sean a,b dos vectores  a = b si ai=bi con 0<i<n-1. Si cada entrada o subindice es igual.

Bloque o stack de vectores
==========================

Podemos tener un stack de vectores 

Por ejemplo: 

:math:`a = {b,c,d}`

Siendo b, c y d subvectores de a y vectores por si mismos.

Y para expresarlo se van a poner en orden, siendo m la longitud de b, n la longitud de c y p la longitud de d:

:math:`a = {b0... bm, c0...cn, d0...cp}` 

Para referirnos a un subvector usaremos la notación 

:math:`ar:s = (ar, ar+1, ..., as)` 

El subíndice r:s se llama índice de rango por lo que, el primer ejemplo quedaría de la siguiente manera:

:math:`b = a0:(m-1) c=am:(m+n-1) d=a(m+n):(m+n+p-1)` 

Convenciones
============

Generalmente se usan letras griegas para escaleras y letras minúsculas para vectores. 

Respecto a la indexación, correr los n-vectores desde i = 0 hasta i = n, aunque también es aceptado empezar desde 0, como un array. 

Cero vector es un vector donde todos sus elementos son igual a 0, se escribe como 0n o 0.

Los uno vectores son n-vectores en las cuales todas sus entradas son igual a 1, se representa como 1n o como 1.

Vector unitario. El vector unitario es aquel donde todas sus entradas son cero, salvo la i-ésima. Se nombran como e0, e1 y e2 para:

:math:`e0={1,0,0} e1={0,1,0} e2={0,0,1}` 
Una forma de representarlos es 

:math:`(ei)j = {1, si i=j o 0 si i!=j}` 

Modelo aditivo RGB
==================

Es un modelo donde cada color se representa con un vector de 3 dimensiones (R, G, B)

El color rojo se forma con (255, 0, 0)
El color verde con (0, 255, 0)
El color azul con (0, 0, 255)

Y la combinación de diferentes colores se logra sumando esos vectores.

El amarillo, por ejemplo es (255, 255, 0).

Suma de vectores 
================

Para sumar vectores ambos deben tener la misma dimensión y simplemente se sumando elemento a elemento a sus entradas.

:math:`{0,1,2} + {2,3,-1} = {2,4,1}` 

Propiedades de la suma
----------------------

* Conmutativa, a + b = b + a
* Asociativa, (a + b) + c = a + (b + c)
* La suma de 0 no afecta el vector, a + 0 = a = 0 + a = a
* Sumar un vector con su inverso es cero, a - a = 0