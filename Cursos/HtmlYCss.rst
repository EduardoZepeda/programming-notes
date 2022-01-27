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

Aquí hay un excelente repaso de varias cosas de CSS:

.. code-block:: css

    https://flukeout.github.io/

    div + a 
    {

    */ selecciona cada a que le siga a un div/*
    }

    div ~ b 
    {

    */ selecciona TODOS los b que le siga a un div/*
    }

    A > B
    {

    */ selecciona todos los B que sean hijos directos de A/*
    }


    A[attribute]{

    */ Todo lo que tenga o no tenga el atributo /*

    }

    A[attribute="valor"]
    {

    */ A[attribute^="val"] Que empieza con /*
    */ A[attribute$="val"] Que termina con /*
    */ A[attribute*="val"] en cualquier momento /*
    }

    :empty 

    {

    */ selecciona cada elemento vacio/*
    }

    :not(X){

    */ Negación, puede usarse con clases, ids, y combinaciones div:not(:first-child)/*
    }

    :first-child, only-child, last-child, nth-child(A), nth-last-child(A), first-of-type, nth-of-type(A), last-of-type

    only-of-type */ Solo si el elemento es unico dentro de su padre/*
    nth-of-type(6n+2) */ Cada 6 elementos, contando e incluyendo desde el segundo/*

CSS
===

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
    
¿Cómo generar diferentes vistas de diferentes disposivitos?
===========================================================

Podemos generar vistas de como se ve una página HTML en diferentes resoluciones y dispositivos en estas páginas

* `Device shoots <https://deviceshots.com/>`_ 
* `Mockuphone <https://mockuphone.com/>`_
* `Mockerup <https://mockerup.net>`_  