========================
Ecuaciones diferenciales
========================

La ecuaciones diferenciales nos sirven para crear modelos matemáticos de
cosas que existen en la realidad que dependen de alguna variable como el
tiempo, un ejemplo de esto sería saber la variación en la temperatura de
un objeto a lo largo de diferentes rangos de tiempo.

:math:`A_\text{c} = (\pi/4) d^2`.

Que es una ecuación diferencial
===============================

Son ecuaciones con las que podemos representar problemas, que cambian en
el tiempo y que tienen alguna dependencia con otras variables. Es una
igualdad en la que relacionamos una función, variables y derivadas. Las
derivadas nos expresan como la función y las variables cambian en el
tiempo. Relacionamos estos tres aspectos en una sola ecuación.

Tipos de variables
------------------

-  Variable dependiente: siempre que estemos derivando con respecto a
   una función, esa será nuestra variable dependiente.
-  Variable independiente: es aquella cuyo valor no depende del de otra
   variable.

Tipos de ecuaciones diferenciales
---------------------------------

-  Ecuaciones diferenciales ordinarias (EDO): Tienen una sola variable
   independiente.
-  Ecuaciones diferenciales parciales (EDP): Tienen más de una variable
   independiente.

Tipos de ecuaciones diferenciales por orden y linealidad
--------------------------------------------------------

Para saber el tipo de ecuación, dependerá de dos factores, el orden y la
linealidad:

-  Orden: Se refiere a la máxima derivada que aparece en la ecuación
-  Linealidad: Nos basaremos en la variable dependiente, si la variable
   dependiente nos esta modificada y no tiene exponentes, la ecuación
   será lineal.

Que significa solucionar una ecuación diferencial
-------------------------------------------------

Cuando tenemos una ecuación normal, solucionarla significaba encontrar
ese número que satisfacía la igualdad de la ecuación:

:math:`y+5=2`.

:math:`y=-3`.

Cuando hablamos de ecuaciones diferenciales, no vamos a buscar un
número, vamos a buscar una función. Un conjunto de funciones que me
satisfagan esa igualdad.

Es encontrar una función donde la variable dependiente cambie con
respecto a la variable independiente.

Tipos de soluciones
-------------------

-  Solución general: Se produce cuando tenemos varias soluciones para
   una misma ecuación, donde la constante © puede tener cualquier valor,
   que no afectara a la solución de la ecuación.
-  Solución especifica: Cuando nos dan una condición inicial, ya no
   valdrá cualquier valor de la constante como posible solución, si no
   ese valor en especifico es el que le dará la solución a la ecuación.

Métodos de resolución
=====================

Estos metodos son para resolver ecuaciones de primer orden:

   1. Separación de variables
   2. Homogéneas
   3. Ecuaciones lineales
   4. Ecuaciones exactas
   5. Ecuación de Bernoulli

Ecuaciones Diferenciales Separables
===================================

Son las E.D. más sencillas, se dan cuando podemos expresar la ecuación
de manera que tengamos en cada término únicamente expresiones de una
variable de manera que podamos integrar directamente.

:math:`\frac{dy}{dx} = f(x,y)`.

:math:`\frac{dy}{dx} = g(x)p(y)`.

:math:`\frac{dy}{p(y)} = g(x)dx`.

:math:`\frac{1}{p(y)} = h(y)`.

:math:`h(y)dy = g(x)dx`.

Procedimiento para saber si una ecuación es separable
-----------------------------------------------------

Asignaremos valores a (x, y), tal que la función de (x,y) sea diferente
de cero. Calcularemos una nueva función en la que multiplicaremos el
resultado de cambiar la variable (x) por el nuevo valor y multiplicarlo
por la variable (y). Haremos lo mismo para el nuevo valor de (y) que lo
multiplicaremos por (x). Comprobar si la función del primer paso con los
nuevos valores por la función inicial, es igual a la ecuación obtenida
en el segundo paso.

Lo que estamos haciendo es comprobar si

:math:`f(xo, yo) f(x,y) = f(xo,y) f(x,yo)`.

Si los tres pasos salen correctos sabremos si la ecuación es separable o
no.

Método de sustitución lineal
============================

Aplicable para ecuaciones de la forma

:math:`\frac{dy}{dx}=f(x+y+c)`.

:math:`v = x+y+c`.

:math:`dv=d(x+y+c)`.

:math:`dv=dx+dy`.

:math:`\frac{dv}{dx}=\frac{dx}{dx}+\frac{dy}{dx}`.

:math:`\frac{dv}{dx}=1+\frac{dy}{dx}`.

:math:`\frac{dy}{dx}=1-\frac{dv}{dx}`.

:math:`\frac{dv}{dx}-1=f(x+y+c)`.

:math:`\frac{dv}{dx}-1=f(v)`.

:math:`\frac{dv}{dx}=f(v)+1`.

:math:`dv=(f(v)+1)dx`.

:math:`\frac{dv}{f(v)+a}=dx`.

:math:`\int \frac{dv}{f(v)+a}=\int dx`.

:math:`ln(v+1)=x+C`.

:math:`v=x+y+4`.

:math:`ln(x+y+4+1)=x+C`.

:math:`e^{ln(x+y+4+1)}=e^{x+c}`.

:math:`x+y+5=e^{x+c}`.

:math:`y=e^xC-x-5`.

Ecuaciones diferenciales exactas
================================

Estas ecuaciones cumplen dos condiciones:

1. Puedan ser representadas de la forma

:math:`M(x, y)dx + N(x, y)dy = 0`.

2. La derivada de M con respecto a la derivada de y sea igual a la
   derivada de N con la derivada de x

:math:`\frac{dM}{dy} = \frac{dN}{dx}`.

Para resolver una ecuación exacta primero debemos verificar que, si sea
una ecuación exacta, una vez verificada debemos integrar a M o a N.

Una vez integrada M o N, debemos derivar a F con respecto a la otra
variable que no integramos.

Por último, integramos la ecuación para obtener nuestra solución.

Funciones homogeneas
====================

Cuando tenemos una función homogenea todos los términos de la ecuación
tienen el mismo grado y podemos generar una ecuacinó diferencial
separable.

:math:`M(x,y)dx+N(x,y)dy=0`.

:math:`f(tx,ty)=t^nf(x,y)`.

Antes de llegar a la ecuación homogénea deberemos observar las
siguientes características de la ecuación:

   Separación -> ecuación separable Lineal -> ecuación lineal Exacta ->
   ecuación exacta

En caso de que no se cumplan estas características, pasaremos a
comprobar si es homogénea.

Una vez hemos confirmado que la ecuación es homogénea, realizaremos los
siguientes pasos:

Cambiaremos una de las variables:

:math:`x = yv`.

:math:`y = xv`.

Realizaremos una sustitución: No solo remplazaremos la variable, si no
también su derivada, que será la derivada del producto de dos funciones.

:math:`x = y*v -> dx = ydv + vdy`.

Una vez conseguimos su ecuación separable, integraremos.

Ecuaciones con coeficientes lineales
====================================

Para reconocer esta ecuación veremos que al igual que las ecuaciones de
sustitución lineal, la ecuación con coeficientes lineales cuenta un x, y
y una constante, además los coeficientes que acompañan esas variables
son constantes.

La sustitución lineal nos funciona cuando tenemos un solo polinomio que
reemplazar, en este caso al encontrarnos con dos polinomios queda
totalmente descartado el método de sustitución lineal.

Para resolver esta ecuación debemos reemplazar la variable x por una
nueva variable más una constante, hacemos lo mismo con la variable y
para poder obtener una ecuación homogénea y con ello poder buscar una
ecuación separable que nos dará la solución.

Aunque parezca una ecuación lineal, no podemos hacer una sustitución
lineal porque tenemos más de una polinomio.

Entonces realizaremos una traslación de ejes con cambio de variable.

La traslación consiste en substituir (x) o (y) por una nueva variable
mas una constante.

Con este proceso obtendremos una ecuación homogénea.
