===================================================
Go avanzado: concurrencia, patrones de diseño y net
===================================================

Patrones de diseño 
==================

Acomodo y las relaciones entre objetos de código entre sí que ofrecen soluciones estándar para problemas recurrentes. Popularizados por el libro "Design Patterns" de Erich Gamma, Richard Helm, Ralph Johnson y John Vlissides.

Puedes pensar en ellos como planos de problemas de diseño de software que podemos adaptar a nuestras necesidades.

* Creacionales: Creación de objetos de manera reutilizable
* Estructurales: Modo de creación de objetos en estructuras grandes 
* Comportamiento: Comunicación entre objetos y la asignación de sus responsabilidades

Singleton
---------

Hace posible trabajar con una sola instancia que pueda ser accesada de manera global.
  
Factory
-------

La definición de una familia de clases base que permite que las subclases alteren los comportamientos de manera especīfica. Una de las desventajas de usar Factory es que puede complicar ligeramente el código.

Observer
--------

Nos permite que un objeto esté pendiente de un evento que va a ocurrir en otro objeto.

Strategy
--------

Cuando se tiene una familia de algoritmos que persiguen objetivos similares y se requiere que sean intercambiados en tiempo de ejecución.

Adapter
-------

Nos permite crear código que no tenga la necesidad de reescribir las interfaces que ya existen

Otros patrones de diseño
------------------------

`Patrones en Go <https://refactoring.guru/es/design-patterns/go>`_ 

Race conditions
===============

Sucede cuando dos diferentes procesos leen y modifican un mismo dato, podemos tener resultados impredecibles dependiendo de que proceso modifique primero. Por ejemplo un programa que determina el saldo total leyendo el saldo inicial y sumandole un valor, si ambos procesos leen un saldo X y le suman el depósito, puede ocurrir que tengamos un resultado igual a X + Y o X + Z, cuando el resultado correcto debería ser X + Y + Z.

Netcat
======

Netcat es una librería que nos permite leer y escribir de una conexión TCP especificada.

Conectarse con netcat
---------------------

Netcat nos permite conectarnos por medio de su método Dial 

.. code-block:: go

    conn, err := net.Dial("tcp", fmt.Sprintf("%s:%d", *site, port))
    if err != nil {
        return
    }

Servir contenido con netcat
---------------------------

También nos permite escuchar conexiones usando su método Listen

.. code-block:: go

    listener, err := net.Listen("tcp", fmt.Sprintf("%s:%d", *host, *port))
    if err != nil {
        log.Fatal(err)
    }

Una vez creado el listener de conexiones, podemos escucharlas usando un bucle infinito. Mira como si ocurre un error continuamos el bucle en lugar de terminar el programa. Además, para evitar bloqueos del programa las conexiones son manejadas de manera concurrente.

.. code-block:: go

    for {
            conn, err := listener.Accept()
            if err != nil {
                log.Print(err)
                // continue is needed instead of return,
                //otherwise the chat server will finish its execution
                continue
            }
            go HandleConnection(conn)

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
