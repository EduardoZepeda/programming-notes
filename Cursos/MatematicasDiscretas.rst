=====================
Matemáticas discretas
=====================

Conjuntos
=========

No distinguen orden.

Nos interesa la relación de dependencia, que se expresa con el símbolo
∈.

Determinación de un conjunto y cardinalidad
-------------------------------------------

Se pueden expresar por

-  Extensión: A = {2,4,6,8}
-  Compresión A = {x|x es un entero par, positivo ∩ 1 < x < 9}

Pueden ser: \* Finitos \* Infinitos

Cardinalidad
~~~~~~~~~~~~

La cardinalidad es el número de elementos que componen un conjunto \* #A
= 4 \* \|A\| = 4

Subconjuntos
~~~~~~~~~~~~

Si todo elemento de un conjunto (A) está contenido dentro de otro (B) se
dice que ese A es subconjunto de B

Conjuntos especiales
--------------------

Conjunto nulo
~~~~~~~~~~~~~

Cuando el conjunto no contiene elementos

A = {Numeros pares 1<x<1.5} No existe un número par que cumpla esas
condiciones.

Conjunto unitario
~~~~~~~~~~~~~~~~~

Cuando el conjunto solo contiene un elementos

A = {2}

Conjunto universal
~~~~~~~~~~~~~~~~~~

A = {1,3} B = {5,6,7} C = {1,3,5,7,9}

U = {x|x es un numero natural <10}

Operaciones entre conjuntos
---------------------------

A = {5,6,7,8,9,10}

B = {2,4,6,8,10}

U = {1,2,3,4,5,6,7,8,9,10}

Simbología
----------

La simbología para los conjuntos son los siguientes:

⋃ Union ⋂ Intersección -- Resta ∈ Pertenencia ∉ No es un elemento de ⊂
Subconjunto estricto ⊃ Superconjunto estricto \|A\| Cardinalidad #A
Cardinalidad Cª = C' Complemento

Union
~~~~~

Es la unión, de ambos conjuntos. No se repiten elementos.

A ⋃ B = {2,4,5,6,7,8,9,10}

Intersección
~~~~~~~~~~~~

La Intersección de dos conjuntos A y B son aquellos elementos que se
encuentran tanto en A como en B.

A ⋂ B = {6,8,10}

Resta
~~~~~

En la Resta de conjuntos a diferencia de la unión y la intersección, si
importa el orden de los conjuntos, por ejemplo, la Resta de un conjunto
B a un conjunto A retira los elementos que contiene B que se encuentran
en el conjunto A.

A - B = {5,7,9} B - A = {2,4}

Complemento
~~~~~~~~~~~

Por ultimo el Complemento de un conjunto son todos los elementos que le
faltan al conjunto para volverse el conjunto universal.

A'= {1,2,3,4} B'= {1,3,5,7,9}

Representación gráfica de conjuntos
-----------------------------------

Cuando representamos gráficamente algún conjunto utilizamos figuras
geométricas como los círculos, cuadrados o triángulos. Representar
gráficamente los conjuntos nos sirve mucho al momento de identificar las
operaciones entre conjuntos. El complemento de algún conjunto también
puede ser expresado como la resta del conjunto al conjunto universal.

Ley de Morgan
~~~~~~~~~~~~~

La ley de Morgan nos da las siguientes equivalencias.

(A ⋃ B)' = A'⋂ B' (A ⋂ B)' = A'⋃ B'

Teoría de grafos
================

El concepto básico de un gráfico es, un modelo matemático que sirve para
representar las relaciones entre objetos de un conjunto. Un gráfico o
grafo es un conjunto de vértices, o nodos, que están conectados a través
de aristas, líneas o conexiones.

Hay varios tipos de grafos, el primero de todos es el nodo simple donde
tenemos los nodos y las conexiones gracias a las cuales nos podemos
mover fácilmente a través del grafo.

-  El Multígrafo tiene varias conexiones entre dos nodos, permitiendo
   tener dos rutas distintas para estos nodos.
-  Un Pseudografo al igual que el multígrafo puede tener múltiples
   conexiones entre dos nodos y, además, una de estas conexiones puede
   partir y terminar en el mismo nodo.
-  El Grafo Ponderado cuenta con un valor dentro de las conexiones, esto
   puede verse como el costo, o recurso, de una ruta de nodos.
-  El Grafo Dirigido establece una dirección en las conexiones, esta
   dirección se representa con una flecha.
-  Multígrafo Dirigido que cuenta con dirección en las conexiones y
   puede haber múltiples conexiones entre dos nodos.

Grafos caminos y cadenas
------------------------

¿Qué es el grado de un vértice? Es el número de aristas que tiene un
nodo con otros nodos.

Existe una propiedad matemática que nos dice que la sumatoria de todos
los grados de los vértices de un grafo es igual al doble de las aristas.
Otra propiedad nos indica que si tenemos más de dos vértices con grado
impar es imposible recorrer de una sola vez todo el grafo sin repetir un
camino. \* Una cadena es una sucesión de vértices y de conexiones entre
sí. \* Un camino a diferencia de una cadena es una sucesión de vértices
y conexiones donde no puedes repetir ningún vértice ni conexión, \* En
un ciclo el vértice de inicio es igual al vértice donde termina. \* Un
grafo conexo es aquel donde todos los nodos están unidos entre sí.

Caminos y ciclos eulerianos
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ya sabes que un camino es una sucesión de vértices y conexiones donde no
pasas dos veces por el mismo vértice, y un ciclo es una sucesión de
vértices y conexiones donde el nodo de inicio es igual al nodo final.

Pues un Camino Euleriano es aquel camino que recorre todo el grafo sin
repetir una conexión, esto se cumplirá siempre y cuando **un grafo no
tenga más de dos vértices con grado impar.**

Un Ciclo Euleriano es aquel ciclo que recorre todo el grafo sin repetir
una conexión, este se cumplirá solo cuando **todos los vértices del
grafo son grado par.**

Caminos y ciclos hamiltonianos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A diferencia de los caminos y ciclos eulerianos, los caminos y ciclos
hamiltonianos buscaran recorrer los nodos una sola vez sin importar el
camino que utilicemos.

Para afirmar que hay un camino hamiltoniano se debe cumplir la condición
donde la suma del grado de dos vértices seleccionados es mayor o igual
al número de vértices menos uno, de otra forma puede que exista el
camino hamiltoniano, pero **no se podrá afirmar.**

Si hay un camino hamiltoniano, pero no un ciclo, entonces el grafo no es
hamiltoniano.

Matriz de adyacencia
--------------------

Cuando un grafo se vuelve muy complejo es recomendable usar una matriz
de adyacencia. En esta se estableceran las conexiones que tiene cada
nodo en forma de tabla.

.. figure:: img/MatematicasDiscretas/matriz_adyacencia_a.png
   :alt: image

   image

La imagen anterior puede representarse por medio de la siguiente matriz.
Donde el grado es la sumatoria de todas las conexiones.

+---+---+---+---+---+-------+
|   | a | b | c | d | Grado |
+---+---+---+---+---+-------+
| a | 1 | 1 | 1 | 0 | 3     |
+---+---+---+---+---+-------+
| b | 1 | 0 | 1 | 2 | 4     |
+---+---+---+---+---+-------+
| c | 1 | 1 | 0 | 1 | 3     |
+---+---+---+---+---+-------+
| d | 0 | 2 | 1 | 0 | 3     |
+---+---+---+---+---+-------+

Si la matriz **no es simétrica** entonces podremos hablar de un grafo
dirigido

En la matriz de adyacencia asimétrica, si sumamos las filas de cada nodo
nos dirá la cantidad de conexiones que inciden en el nodo, y si miramos
las columna nos dirá sobre que nodo inciden los nodos.

Matriz de incidencia
--------------------

Antes de construir una matriz de incidencia deberás darle un nombre o
identificador a cada conexión de tu grafo. Estas conexiones van a
representar las columnas de tu matriz y los nodos van a representar las
filas.

Colocaremos un 1 en las celdas donde una conexión incida en un nodo, si
no incide en el nodo entonces colocaremos un 0.

.. figure:: img/MatematicasDiscretas/matriz_adyacencia_b.png
   :alt: image

   image

En la siguiente matriz e1 incide sobre a y sobre c, e2 incide sobre a y
b...

En esta matriz solo habrá 1 y 0, a diferencia de la anterior.

+---+----+----+----+-----+----+----+
|   | e1 | e2 | e3 | de4 | e5 | e6 |
+---+----+----+----+-----+----+----+
| a | 1  | 1  | 0  | 0   | 0  | 0  |
+---+----+----+----+-----+----+----+
| b | 0  | 1  | 0  | 0   | 1  | 1  |
+---+----+----+----+-----+----+----+
| c | 1  | 0  | 1  | 0   | 0  | 1  |
+---+----+----+----+-----+----+----+
| d | 0  | 0  | 0  | 1   | 1  | 1  |
+---+----+----+----+-----+----+----+
| e | 0  | 0  | 1  | 1   | 0  | 0  |
+---+----+----+----+-----+----+----+

Árboles
=======

Los Árboles nos permiten organizar o estructurar información. Si tenemos
un nodo A y un nodo B, solo existirá una conexión entre ellos.

Los árboles son usados frecuentemente para expresar relaciones de
jerarquía.

Existen diferentes tipos de árboles:

Tipos de árboles
----------------

-  Libre: no es claro cual es el nodo principal o nodo raíz dentro de
   este árbol.
-  Raíz: se ve una estructura clara de los nodos. Todos parten de un
   mismo nodo.
-  Expansión: es similar al grafo empoderado, la conexión entre los
   nodos tiene un recurso asociado.
-  Binario: en cada uno de los niveles del árbol se tiene un máximo de
   dos conexiones.

Dentro de los árboles existe el nivel y la altura, los valores de estos
cambiaran dependiendo del nodo que tomes como raíz.

El nivel de un árbol es igual al máximo nivel posible de un nodo, el
nivel de un nodo se define por el número de conexiones entre el nodo y
la raíz más uno.

La altura de un árbol es igual al nivel del árbol más el nivel raíz.

Subárbol
--------

Un subárbol es una parte de un árbol que hace parte de un árbol más
grande. Nos referimos a ellos como sub árbol raiz "b"

Vértice
-------

Un vértice terminal es aquel nodo que ya no tiene más hijos o donde el
árbol ya no se expande. Por otro lado, los vértices internos son
aquellos que tienen hijos, ya sea uno o dos.

Árbol de expansión mínimo
-------------------------

Un árbol de expansión mínimo es aquel árbol que partiendo de una raíz
pueda conectar todos los vértices buscando los caminos de menor costo.
Para sacar el costo mínimo del árbol solo basta con ir sumando el valor
que tiene cada conexión nivel por nivel, luego sumar todos los niveles.

.. figure:: img/MatematicasDiscretas/arbol_expansion_minima.png
   :alt: image

   image

Hecho el árbol podriamos utilizar el vértice del costo mínimo como la
raiz del árbol.

.. figure:: img/MatematicasDiscretas/arbol_expansion_minima_raiz_g.png
   :alt: image

   image

Árbol binario
-------------

Un árbol binario es aquel donde tenemos un máximo de dos hijos por cada
uno de los vértices.

Tipos
~~~~~

Existen dos tipos de arboles binarios:

-  Completo
-  Lleno

El primero de ellos es el árbol binario completo donde cada uno de los
vértices tiene sus dos ramas bien definidas o no tiene ninguna. El árbol
binario lleno es aquel donde todos los nodos llegan a un mismo punto y
al final todas sus ramas son terminales.

.. figure:: img/MatematicasDiscretas/arbol_binario_tipos.png
   :alt: image

   image

El árbol degenerado es donde la mayoría de sus nodos tienen solo un
hijo.

.. figure:: img/MatematicasDiscretas/arbol_binario_degenerado.png
   :alt: image

   image

Recursividad
~~~~~~~~~~~~

Un árbol binario es una estructura recursiva pues puede llamarse a si
misma, puedes descomponerlo en partes más pequeñas.

.. figure:: img/MatematicasDiscretas/arbol_binario_recursivo.png
   :alt: image

   image

Recorrido de árboles
~~~~~~~~~~~~~~~~~~~~

Al momento de representar un árbol debemos elegir el orden en el cual
vamos a recorrer dicho árbol. Dependiendo de qué orden se elija será la
forma en que se va a representar el árbol.

Existen tres formas de recorrer un árbol:

-  Pre orden: se inicia leyendo el nodo raíz, luego se pasa al hijo
   izquierdo y por ultimo al derecho.
-  In orden: inicia leyendo el hijo izquierdo, luego la raíz y por
   último el hijo derecho.
-  Pos orden: comienza por el hijo izquierdo para posteriormente ir al
   hijo derecho y por último al nodo raíz.

Cuando nos encontremos con que el hijo izquierdo o derecho son a su vez
un nodo raiz habrá que desarrolloarlos tomándolos a ellos mismos como la
raiz.

Expresiones aritméticas
-----------------------

Los árboles también nos sirven para representar expresiones aritméticas,
para ello debe cumplir con las siguientes condiciones:

-  Los vértices terminales son operandos.
-  Los vértices internos son operadores.
-  La raíz siempre debe ser un operador.

Así como vimos las diferentes formas para recorrer un árbol, las
expresiones aritméticas tienen también sus propias formas:

**Nota: El nombre indica la posición de la raiz; pre, para primera
posición; in, para posición media; pos, para posición final. Después se
escriben izquierda y derecha, siempre en ese orden.**

-  Pre fijo: raíz-izquierda-derecha
-  In fijo: izquierda-raíz-derecha
-  Pos fijo: izquierda-derecha-raíz

.. figure:: img/MatematicasDiscretas/arbol_operaciones_aritmeticas.jpg
   :alt: image

   image

Algoritmos
----------

Algoritmo de Prim
~~~~~~~~~~~~~~~~~

Encuentra el menor costo de recorrer todos los vértices de un árbol de
expansión.

1. Escogemos un vértice al azar.
2. Escogemos la arista con menor coste.
3. Repetimos el paso 2, incluyendo las opciones del nuevo vértice.
4. Evitar la creación de ciclos
5. El algoritmo termina cuando hemos conectado todos los vértices con
   n-1 aristas, donde n es la cantidad de vértices.

Algoritmo de Dijkstra
~~~~~~~~~~~~~~~~~~~~~

El algoritmo de Dijkstra va a buscar la ruta optima o de menor coste
entre dos vértices.

1. Asignar el valor infinito a cada noto no visitado
2. Mantener un registro de los nodos visitados
3. Calcular la distancia a cada nuevo nodo sumando la distancia anterior
4. Si la nueva distancia calculada es menor que la anterior, se debe
   reemplazar en el nodo, sino dejar la anterior
5. Se finalizará cuando se llega al nodo final.

Algoritmo de Kruskal
~~~~~~~~~~~~~~~~~~~~

El algoritmo de Kruskal al igual que el algoritmo de Prim sirve para
buscar el árbol de expansión mínimo, la diferencia es que el algoritmo
de Kruskal inicia seleccionando la arista de menor valor y después en
cada iteración se agrega la arista de menor valor del conjunto
disponible.

1. Seleccionar arista con menor coste, en caso de repetir no importa
   porque en el siguiente paso se elegirá.
2. En cada iteracion agregar la arista de menor longitud del conjunto de
   arcos disponibles. **No aceptaremos ninguna arista que cause un
   bucle**
3. El algoritmo finaliza cuando todos los vertices esten conectados con
   n-1 arcos.

Algoritmo de Fleury
~~~~~~~~~~~~~~~~~~~

El algoritmo de Fleury va a encontrar un ciclo euleriano. Recordemos que
un ciclo euleriano es un ciclo donde inicias y terminas en el mismo
punto, pasando por todas las aristas una sola vez.

1. Verificar grado del grafo para que sea un ciclo. (Todos los vértices
   deben ser pares)
2. Realizar un circuito cerrado
3. En cada nueva iteración realizar un nuevo camino cerrado visitando
   aristas que no han sido visitadas
4. Reemplazar cada nuevo circuito en el inicial hasta visitar todas las
   aristas.

Para corroborar, el número de veces que se visita cada vértice debe ser
la mitad de su grado. Exceptuando el nodo inicial y terminal, que son el
mismo.

Algoritmo de flujo máximo
~~~~~~~~~~~~~~~~~~~~~~~~~

Encuentra el camino de un punto A a un punto B, en un **grafo
dirigido**, con la mayor cantidad de flujo.

1. Establecer un grafo dirigido.
2. Establecemos todos los vértices en 0
3. Establecer caminos desde el punto A hasta el punto B.
4. Encontramos la conexión con menor capacidad, pues ésta es quien le
   dice al camino la capacidad máxima.
5. Hacemos esta iteración hasta que no hayan más caminos, ante una
   eleccion seleccionar el mayor flujo.
6. De cada ruta obtenemos un flujo, sumando todos los flujos obtendremos
   el flujo máximo.
