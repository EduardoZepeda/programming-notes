===================================================
Go avanzado: concurrencia, patrones de diseño y net
===================================================

Race conditions
===============

Sucede cuando dos diferentes procesos leen y modifican un mismo dato, podemos tener resultados impredecibles dependiendo de que proceso modifique primero. Por ejemplo un programa que determina el saldo total leyendo el saldo inicial y sumandole un valor, si ambos procesos leen un saldo X y le suman el depósito, puede ocurrir que tengamos un resultado igual a X + Y o X + Z, cuando el resultado correcto debería ser X + Y + Z.

Sync Mutex: Lock y Unlock
=========================

Podemos ver si nuestro programa crea una condición de carrera con el comando build.

.. code-block:: go

    go build --race main.go

Para solucionar el problema de las condiciones de carrera, creamos una variable de tipo *sync.Mutex*

.. code-block:: go

    var lock sync.Mutex

    func (wg *sync.WaitGroup, lock *sync.Mutex)

Dentro de la función usaremos un modelo de candado para bloquear la modificación de los datos que son accesados desde diferentes goroutines.

.. code-block:: go

    lock.Lock()

El lock es un candado que bloquea el programa en determinada linea hasta que ocurra un Unlock.

Para desbloquear llamamos al método Unlock.

.. code-block:: go

    lock.Lock()
    // Todo lo que está aquí está bloqueado para el resto de las goroutines
    lock.Unlock()

Mutex de lectura y escritura
----------------------------

Go provee locks que permiten una sola goroutine que escriba y múltiples lectores por medio de RWMutex

.. code-block:: go

    var lock sync.RWMutex

Ahora podemos llamar a los métodos de Lectura: 

.. code-block:: go

    lock.RLock()
    //
    lock.RUnlock()

El contenido dentro del candado de lectura puede ser leído múltiples veces.

Patrones de diseño 
==================

Acomodo y las relaciones entre objetos de código entre sí que ofrecen soluciones estándar para problemas recurrentes. Popularizados por el libro "Design Patterns" de Erich Gamma, Richard Helm, Ralph Johnson y John Vlissides.

* Creacionales: Creación de objetos de manera reutilizable
* Estructurales: Modo de creación de objetos en estructuras grandes 
* Comportamiento: Comunicación entre objetos y la asignación de sus responsabilidades
  
Factory
-------

`Patrones en Go <https://refactoring.guru/es/design-patterns/go>`_ 