==========
HTML y CSS
==========

Hay una nueva propiedad llamada Flex que viene a solucionar muchísimos
problemas previos, desde el alineado vertical hasta el reacomodo de
elementos al redimensionar.

.. code-block:: css

    .container{
        display: flex;
    */  flex-direction: column | row /*
        flex-wrap: wrap; */ nowrap | wrap-reverse /*
        justify-content: space-evenly; */ space-around-center /*
        align-items: center; */ Para alineado vertical /*
        height: 1000px;
    }
    .cajas{
        height: 200px;
        width: 200px;
        border: 1px solid pink;
        flex-shrink: 0; */ 0 significa que no se pueden redimensionar los elementos, 1 que sí/*
    }

CSS compuesto
=============

CSS nos permite componer varios elementos de CSS para lograr diferentes comportamientos.

Selecciona cada elemento "a" que le siga a un "div".

.. code-block:: css

    div + a 
    {
    */ /*
    }

Selecciona todos y cada unode los elementos "b" que le sigan a un div.

.. code-block:: css


    div ~ b 
    {
    */ /*
    }


Selecciona todos los B que sean hijos directos de A.

.. code-block:: css

    A > B
    {
    */ /*
    }

Selecciona todo lo que tenga o no tenga el atributo especificado.

.. code-block:: css

    A[attribute]{
    */  /*
    }

Los atributos pueden soportar algunas expresiones regulares.

.. code-block:: css

    A[attribute="valor"]
    {
    */ A[attribute^="val"] Que empieza con val /*
    */ A[attribute$="val"] Que termina con val /*
    */ A[attribute*="val"] Contenga val /*
    }


Selecciona cada elemento vacio.

.. code-block:: css

    :empty{
    */ /*
    }


Negación, puede usarse con clases, ids, y combinaciones div:not(:first-child).

.. code-block:: css

    :not(X){
    */ /*
    }

La posición en el orden de cada etiqueta de cada tipo.

.. code-block:: css

    :first-child, only-child, last-child, nth-child(A), nth-last-child(A), first-of-type, nth-of-type(A), last-of-type

Cada ""n" elementos, contando e incluyendo desde el segundo.

.. code-block:: css

    nth-of-type(6n+2) */ /*

Solo si el elemento es unico dentro de su padre

.. code-block:: css

    only-of-type */ /*

Root en CSS
===========

Hay una nueva notación de CSS para especificar variables:

.. code-block:: css

    :root {
        --nombre_variable: #fafafa;
    }

Y podemos usarla posteriormente en otro lugar usando la función var():

.. code-block:: css

    .clase{
        color: var(--nombre_variable)
    }
    
¿Cómo generar diferentes vistas de diferentes dispositivos?
===========================================================

Podemos generar vistas de como se ve una página HTML en diferentes resoluciones y dispositivos en estas páginas

* `Device shoots <https://deviceshots.com/>`_ 
* `Mockuphone <https://mockuphone.com/>`_
* `Mockerup <https://mockerup.net>`_  

Validación
==========

Podemos validar usando HTML colocando el atributo pattern y especificando un patrón REGEX.

.. code-block:: html
    
    <input pattern="regex">

Escalado de imágenes
====================

Para escalar imágenes usamos la propiedad CSS llamada image-rendering.

.. code-block:: html

    image-rendering: auto;
    image-rendering: crisp-edges;
    image-rendering: pixelated;