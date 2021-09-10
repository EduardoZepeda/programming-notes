===============
CSS Grid Layout
===============

Es un modelo de rejillas donde declaramos un número de filas y columnas
para organizar nuestro contenido

CSS en el navegador se interpreta como cajas dentro de las cuales van
nuestro contenido, pero al final del día son cajas dentro de cajas que
están alineadas y organizadas como nosotros queremos.

Gracias a CSS Grid podemos distribuir el contenido a nuestra
disposición. Conceptos claves

-  Grid container: Elemento padre donde se asigna un {display: grid;}
-  Grid Item: Hijos *directos* de una grid container.
-  Grid Line: es una grilla (lineas divisorias horizontales y
   verticales) tambien se incluye el contorno del grid
-  Grid track: espacio entre dos lineas adyacentes; filas y columnas
-  Grid cell: Espacio en dos filas adyacentes y 2 columnas adyacentes,
   mejor conocidos como celdas
-  Grid area: Espacio que rodeado por 4 grid lines arbitrarias que
   nosotros decidimos

Columnas
========

Dentro de la clase container especificamos la propiedad
*grid-template-columns*, donde especificamos el ancho de cada columna,
los grid items excedentes irán acomodandose. Podemos combinar diferentes
unidades.

.. code:: css

   .container {
       display: grid;
       grid-template-columns: 25% 200px 25%;

   }

Filas
=====

Dentro de la clase container especificamos la propiedad
*grid-template-rows*, donde especificamos la altura de cada fila. Las
filas excedentes no se verán afectadas por los tamaños que
especifiquemos

.. code:: css

   .container {
       display: grid;
       grid-template-columns: 25% 200px 25%;
       grid-template-rows: 300px 300px;

   }

Grid template
=============

Para declarar un template donde especifiquemos ambos podemos separarlos
en css usaremos la siguiente sintaxis filas/columnas.

.. code:: css

   .container{
       display: grid;
       grid-template: 10px 10px 10px / 20px 50% 10px; /*1fr 1fr 1fr*/
   }

Anidación de grids
==================

Los grids pueden anidarse especificando nuevamente una atributo *grid*,
con otro de *grid-template*

.. code:: css

   .sub-grid {
       display: grid;
       grid-template-columns: 50% 50%;
       grid-template-rows: 100px 100px;

   }

Espaciado entre filas y columnas
================================

Podemos especificar los de columnas así *grid-column-gap*

.. code:: css

   .container{
       ...
       grid-column-gap: 30px;
       ...
   }

En el caso de filas usamos la propiedad *grid-column-row*

.. code:: css

   .container{
       ...
       grid-column-row: 50px;
       ...
   }

O podemos especificar para ambos con la propiedad grid-gap usando la
sintaxis filas columnas

.. code:: css

   .container{
       ...
       grid-gap: 10px 100px;
       ...
   }

Repetidores areas
=================

Las unidades Fr representan fracciones, en este caso son 0.33, puede
sustituirse usando la función repeat(3, 1fr). La función repeat también
acepta funciones para especificar el minimo y maximo.

.. code:: css

   .container {
       display: grid;
       grid-template: repeat(3, 1fr)/ repeat(2, 1fr);
   }

También podemos especificar un mínimo y un máximo

.. code:: css

   .container {
       display: grid;
       grid-template: repeat(3, 1fr)/ repeat(3, minmax(200px, 1fr));
   }

Podemos definiar las areas de contenido

.. code:: css

   .container {
       display: grid;
       grid-template: repeat(3, 1fr)/ repeat(2, 1fr);
       grid-template-areas: "header header"  
                            "left contenido" 
                            "footer footer";
   }

Como header se repite solamente tendrá un solo espacio

Tamaño de las columnas
======================

Los hijos del grid tienen los siguientes atributos para "unir" columnas
donde especificaremos el inicio y el final. Los valores corresponden *a
las lineas*

.. code:: css

   .item:nth-of-type(2) {
       grid-column-start: 1;
       grid-column-end: 3;
   }

Lo anterior es reemplazable por la sintaxis más corta

.. code:: css

   .item:nth-of-type(2) {
       grid-column: 1/3;
   }

También puede especificar que use todas las columnas con indices
negativos

.. code:: css

   .item:nth-of-type(3) {
       grid-column: 1 / -1;
   }

O especificar un ancho determinado de columnas con

.. code:: css

   .item:nth-of-type(4) {
       grid-column: 1 / span 2;
   }

Definiendo tamaño de filas
==========================

Lo anterior también aplica para las filas, solo se debe usar *grid-row*

.. code:: css

   .item:nth-of-type(2) {
       grid-row: 1/span 2;
   }

Definiendo nombre de lineas
===========================

También es posible asignarle nombre a las lineas separadoras de esta
manera

.. code:: css

   .container{
       display: grid;
       grid-template-columns: 
                       [inicio] 1fr
                       [linea2] 1fr 
                       [linea3] 1fr 
                       [destacado-end] 1fr 
                       [linea5] 1fr 
                       [destacado2-end] 1fr 
                       [linea7] 1fr [final];

       grid-template-rows: 
                       [inicio] 200px 
                       [inicio2] 200px [final];
   }

Para luego referirte a ellas de manera específica en cada hijo

.. code:: css

   .item: nth-of-type(3) {
       grid-row: inicio / inicio2;
       grid-column: linea2 / destacado-end;
   }

El nombre de las lineas puede especificarse colocandolo entre corchetes

.. code:: css

   .container{
       display: grid;
       grid-template: [inicio] 1fr [linea2] 1fr [linea2] 1fr [linea2] 1fr/ 1fr 1fr 1fr 1fr;    
   }

Para que el acomodo especificado sea por columna, en lugar de por fila
(el valor por default)

.. code:: css

   .container{
       display: grid;
       grid-template: [inicio] 1fr [linea2] 1fr [linea2] 1fr [linea2] 1fr/ 1fr 1fr 1fr 1fr; 
       grid-auto-flow: column;   
   }

Para especificar los filas sobrantes y asignarles una altura
predeterminada

.. code:: css

   .container{
       ...
       grid-auto-rows: 200px 200px;
       ...
   }

Para especificar los columnas sobrantes y asignarles un ancho
predeterminado

.. code:: css

   .container{
       ...
       grid-columnas-rows: 50px 100px;
       ...
   }

Alineado de contenido
=====================

Podemos usar justify-items para que el contenido se alinee como queramos
de manera horizontal. Esta propiedad puede tomar los valores de stretch,
start, end y center.

.. code:: css

   .container{
       ...
       justify-items: start;
       ...
   }

Por otro lado justify-items alinea el contenido de manera vertical. Esta
propiedad puede tomar los valores de stretch, start, end y center.

.. code:: css

   .container{
       ...
       justify-items: start;
       ...
   }

Alineación individual
---------------------

Para aplicar los estilos anteriores a elementos individuales usamos
align-self y justify-self individualmente.

.. code:: css

   .item: nth-of-type(5) {
       align-self: start;
       justify-self: start;
   }

Alineación de la grilla
=======================

Para esto usaremos justify-content y align-content, los cuales puedem
adoptar los valores center, end, space-around, space-between,
space-events.

.. code:: css

   .container{
       ...
       justify-content: start;
       ...
   }

Esquemas más complejos
======================

También es posible asignar esquemas más complejos donde una columna
abarque 3 espacios y sea ocupada por un elementoA, la segunda columna
sea ocupada en un 66% por un elemento B y en un 33% por E y la tercera
columna tenga tres elementos diferentes

.. code:: css

   .container{
       grid-template-areas: 'columnA columnB columnC'
                            'columnA columnB columnD'
                            'columnA columnE columnF'    
   }

Y más tarde especificamos las clases de cada uno de estos

.. code:: css

   .columnA{
       ..    
   }
   .columnB{
       ..
   }
   ...
