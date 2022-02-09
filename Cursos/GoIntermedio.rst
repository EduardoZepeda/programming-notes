=============
Go intermedio
=============

Testing en go
=============

Go ya cuenta con un modulo de testing en su librería estándar que está
lista para nuestro uso, solo hace falta importarla y usarla.

Preparación del testing en go
-----------------------------

Para que se lleven a cabo los tests necesitamos:

-  Un archivo que termine en \__test.go\_
-  Correr el comando *go test*

Si vas a asignarle un nombre a tu módulo **, nunca uses el nombre testing**. ¿Por qué? si lo haces, go revisará
primero su propio modulo *testing* con el tuyo, devolviéndote esos
resultados en lugar de los tuyos.

.. code-block:: go

   .├── go.mod
   ├── main.go
   └── testing
       ├── main.go
       └── main_test.go

   1 directory, 5 files

Dentro del archivo *testing/main_test.go* vamos a crear nuestros tests;
una función que reciba de argumento nuestro paquete de testing con el
carácter de desestructuración.

.. code-block:: go

   package main

   import "testing"

   func TestDivision(t *testing.T) {
       total := Division(10, 2)
       if total != 5 {
           t.Errorf("División incorrecta, obtuvimos %d pero se esperaba %d", total, 5)
       }
   }

Dentro de *testing/main.go* colocamos nuestra función a probar.

.. code-block:: go

   package main

   func Division(a int, b int) int {
       return a / b
   }

Ejecutar los tests
------------------

Para ejecutar los tests necesitamos estar en el directorio donde se
encuentran nuestros archivos terminados en \__test.go\_ y correr el
comando *go test*. Si el test aprueba obtendremos este resultado:

.. code-block:: go

   cd testing/
   go test

   PASS
   ok      main/testing    0.001s

Si modificamos la función para que falle, obtendremos:

.. code-block:: go

   --- FAIL: TestDivision (0.00s)
       main_test.go:14: División incorrecta, obtuvimos 12 pero se esperaba 5
   FAIL
   exit status 1
   FAIL    main/testing    0.001s

Manejo de casos con tablas
--------------------------

En el ejemplo anterior necesitariamos una función por cada test, pero
eso se puede volver tedioso si los casos a manejar son demasiados. Para
ello podemos usar un array compuesto de structs, donde cada struct
representa un caso a probar.

En el código siguiente, observa como cada struct de nuestra lista son
solo tres números; los primeros dos representan los argumentos, y el
último el resultado.

.. code-block:: go

       tables := []struct {
           x int
           y int
           r int
       }{
           {100, 10, 10}, // 100 / 10 = 10
           {200, 20, 10}, // 200 / 20 = 10
           {300, 30, 10},
           {1000, 100, 10},
       }

De seguro ya notaste que no estamos cubriendo la división entre cero,
pero déjalo así por ahora.

Ya que contamos con nuestro array de structs, iteraremos sobre cada uno de sus elementos usando range 

.. code-block:: go

   for _, table := range tables {
           total := Division(table.x, table.y)
           if total != table.r {
               t.Errorf("División de %d entre %d incorrecta, obtuvimos: %d, pero el resultado es: %d.", table.x, table.y, total, table.r)
           }
       }

Si todo salió bien, pasaremos todas las pruebas.

Coverage
--------

Coverage ya forma parte del código en go, por lo que no necesitamos
librerías externas. Si no sabes que es Coverage, piensa en él como el
porcentaje de tu código que pasa por pruebas.

Para calcular el coverage basta con agregar el flag *-cover* al comando
*go test*

.. code-block:: bash

   go test -cover

   PASS
   coverage: 100.0% of statements
   ok      _/home/eduardo/Programacion/goTesting/testing   0.002s

Como nuestra función es muy corta, obtenemos un resultado de 100%, sin
desglosar, de coverage

Exportar resultados de coverage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Podemos mandar el toda la información en bruto de nuestro test de
coverage a un archivo externo con el flag *-coverprofile*.

.. code-block:: bash

   go test -coverprofile=coverage.out

   mode: set
   /home/eduardo/Programacion/goTesting/testing/main.go:3.33,5.2 1 1

Este archivo, de nombre *coverage.out* , que fue generado, es un archivo
que contiene información en bruto y que **será necesario para visualizar
los resultados** de una manera más detallada.

Visualización de resultados con go tool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para resumir de una manera más legible la información del archivo que
contiene nuestro test de coverage, usaremos el comando tool, acompañado
del flag *-func* , seguido del nombre del archivo. Lo que nos devolverá
un resultado de coverage desglosado.

.. code-block:: bash

   go tool cover -func=coverage.out

   /home/eduardo/Programacion/goTesting/testing/main.go:3: Division        100.0%
   total:                                                  (statements)    100.0%

Go también nos permite visualizar el coverage en formato HTML, con
colores, directo en nuestro navegador. Para ello usamos la opción -html,
seguido del archivo con los datos de coverage.

Al ejecutar el comando, se abrirá una pestaña de nuestro navegador y nos
mostrará los resultados testeados en verde y los no testeados en rojos.

.. code-block:: bash

   go tool cover -html=coverage.out

Si decidimos modificar nuestra función para que maneje los casos de la
división por cero, y corremos los tests de coverage de nuevo,
obtendremos un esquema diferente al anterior. Ahora sí aparece una
sección de código no cubierto por los tests en colo rojo y nuestro
coverage bajó a 50%.


Profiling
---------

go nos permite perfilar la eficiencia de nuestro código analizando el desempeño del código.

.. code-block:: go

    go test -cpuprofile=cpu.out

Para ver el resumen del uso de cpu usamos tool pprof.

.. code-block:: go

    go tool pprof cpu.out

Nos devolverá una consola, si escribimos top veremos el comportamiento de los programas. 

.. code-block:: go

    (pprof) top

Dentro de pprof podemos inspeccionar el tiempo promedio de ejecución de cada línea de una función, usando: 

.. code-block:: go

    list <nombre_funcion>

Con web podemos ver una visualización de nuestros resultados en el navegador.

.. code-block:: go

    (pprof) web

Y exportarlo a pdf con 

.. code-block:: go

    (pprof) pdf

Mock 
----

Si queremos emular el comportamiento de base de datos api usamos una función mock.

Para eso vamos a declararla en nuestro struct como tipo de dato func() y a continuación vamos a ponerle un contenido que retorne lo que necesitamos para emular la respuesta.

.. code-block:: go

    package main

    import "testing"

    func TestGetFullTimeEmployeeById(t *testing.T) {
        table := []struct {
            id               int
            dni              string
            mockFunc         func()
            expectedEmployee FullTimeEmployee
        }{
            {
                id:  1,
                dni: "12345678",
                mockFunc: func() {
                    GetEmployeeByID = func(id int) (Employee, error) {
                        return Employee{
                            Id:       1,
                            Position: "CEO",
                        }, nil
                    }

                    GetPersonByDNI = func(dni string) (Person, error) {
                        return Person{
                            Name: "John Doe",
                            Age:  30,
                            DNI:  "12345678",
                        }, nil
                    }
                },
            },
        }

    }

Asincronía en go
================


Unbuffered channels y buffered channels
---------------------------------------

Es un canal sin una capacidad máxima definida. Un canal sin buffer transmite un mensaje en cuanto lo recibe. Tenemos que estar seguros de que hay una función lista para recibir los datos del canal. 

.. code-block:: go

    // no se imprime el 1 
    // Error: fatal error: all goroutines are asleep - deadlock!
    c := make(chan int)
    c <- 1
    fmt.Println(<-c)

Un buffered channel es una cola que cuenta con una cantidad fija de espacios, sirve para imitar la cantidad de GoRoutines siendo ejecutadas. Mientras que un canal con buffer recibe su capacidad total y no se bloquea esperando la función.

.. code-block:: go

    // Se imprime el 1
    c := make(chan int 3)
    c <- 1
    fmt.Println(<-c)

Waitgroups
----------

Los Waitgroups sirven para sincronizar las goroutines.

Podemos crear un grupo de espera a través del paquete sync

.. code-block:: go

    var wg sync.WaitGroup

.. warning:: Los valores de wg como argumento a funciones deben pasarse por referencia.

.. code-block:: go

    var wg sync.WaitGroup
    myFuncion(&go)
    func(wg *sync.WaiGroup)

Con el método Add podemos añadir un contador al WaitGroup

.. code-block:: go

    wg.Add(1)

Para remover un contador usamos el método Done

.. code-block:: go

    wg.Done()

El método wg.Wait detendrá la ejecución del código hasta que no haya más contadores.

.. code-block:: go

    wg.Wait()


canales de lectura y escritura
------------------------------

Canal de solo escritura: Flecha <- a la derecha de chan. Como si entrara en el canal 

.. code-block:: go

    func Generator(c chan<- int)

Canal de solo lectura: Flecha <- a la izquierda de chan como si saliera del canal. 

.. code-block:: go

    func Print(c <-chan int)

Worker pools
------------

Es un modelo que permite que un conjunto de workers, implementados con goroutines, efectuen tareas en una cola de tareas, implementada con channels. 

.. code-block:: go

    func Worker(id int, jobs <-chan int, results chan<- int) {
        for j := range jobs {
            fmt.Println("worker", id, "started  job", j)
            fib := Fibonacci(j)
            results <- fib
            fmt.Println("worker", id, "finished job", j, "result", fib)
        }
    }

Primero definimos las tareas a ejecutar, creamos los canales.

.. code-block:: go

    // numeros de fibonacci 
    tasks := []int{2, 3, 4, 5, 7, 10, 12, 35, 37, 40, 41, 42}

    // tareas
	nWorkers := 3
	jobs := make(chan int, len(tasks))
	results := make(chan int, len(tasks))

Inicializamos los workers

.. code-block:: go

	for w := 1; w <= nWorkers; w++ {
		go Worker(w, jobs, results)
	}

Les asignamos las tareas

.. code-block:: go

	// give the workers jobs
	for _, t := range tasks {
		jobs <- t
	}
	close(jobs)

Multiplexación
--------------

Se usa la palabra reservada select y case en conjunto para identificar canales y actuar en consecuencia.

.. code-block:: go

    select {
            case res := <-c1:
                fmt.Println("Received", res, "from c1")
            case res := <-c2:
                fmt.Println("Received", res, "from c2")
            }
        }

Patrón workers, jobs y dispatchers
==================================

Jobs
----

Un job representa una tarea a ser ejecutada. Posee un nombre, un tiempo de duración entre jobs y un número.

.. code-block:: go

    type Job struct {
        Name   string        // nombre del job
        Delay  time.Duration // retraso entre cada job
        Number int           // número que se procesará 
    }

Worker
------

Un worker representa la unidad que se va a encargar de obtener los jobs del JobQueue y procesarlos usando su método Start. En el método Start se ejecutará la función encargada de procesar los números, en este caso fibonacci

.. code-block:: go

    type Worker struct {
        Id         int           
        JobQueue   chan Job      // Jobs a procesar
        WorkerPool chan chan Job // Pool de workers (canal de canales de Job)
        Quit       chan bool     // Finalizar worker
    }


Dispatcher
----------

El dispatcher se encarga de asignar jobs a los workers.

.. code-block:: go

    type Dispatcher struct {
        WorkerPool chan chan Job // Pool de workers
        MaxWorkers int           // Máximo número de workers
        JobQueue   chan Job      // Trabajos a ser procesados
    }

NewWorker
---------

Crea un nuevo worker con id y su pool de workers. 

.. code-block:: go

    func NewWorker(id int, workerPool chan chan Job) *Worker {
        return &Worker{
            Id:         id,
            WorkerPool: workerPool, // workerPool al que pertenece
            JobQueue:   make(chan Job),  // Crea una cola de jobs
            Quit:       make(chan bool), // Channel para finalizar los jobs
        }
    }

Método Start del Worker
-----------------------

Comienza la ejecución de los workers. 

.. code-block:: go

    func (w Worker) Start() {
        go func() {
            for {
                w.WorkerPool <- w.JobQueue // Agregar un Job de la cola de Jobs al pool de workers

                // Multiplexing
                select {
                case job := <-w.JobQueue: // Sacar un Job de la cola
                    fmt.Printf("worker%d: started %s, %d\n", w.Id, job.Name, job.Number)
                    fib := Fibonacci(job.Number) // Le pasamos la propiedad Number a la función que procesará nuestros datos
                    time.Sleep(job.Delay) // Dormimos el retraso especificado por cada job
                    // Imprimimos el valor fib que obtuvimos
                    fmt.Printf("worker%d: finished %s, %d with result %d\n", w.Id, job.Name, job.Number, fib)
                case <-w.Quit: // Si el worker tiene quit, lo finalizamos.
                    fmt.Printf("Worker with id %d Stopped\n", w.Id)
                    return
                }
            }
        }()
    }

Método Stop del worker 
----------------------

Cambia la propiedad Quit del worker.

.. code-block:: go

    func (w Worker) Stop() {
        go func() {
            w.Quit <- true
        }()
    }
    
Creador del dispatch
--------------------

Crea un nuevo dispatcher con los argumentos que le pasamos.

.. code-block:: go

    func NewDispatcher(jobQueue chan Job, maxWorkers int) *Dispatcher {
        workerPool := make(chan chan Job, maxWorkers) // Hacemos un pool de workers.
        return &Dispatcher{
            WorkerPool: workerPool,
            MaxWorkers: maxWorkers,
            JobQueue:   jobQueue,
        }
    }

Método dispatch del Dispatcher 
------------------------------

El método dispatch creará un loop infinito, en el cual escuchará por objetos de la cola de Jobs y los asignará a un worker

.. code-block:: go

    func (d *Dispatcher) dispatch() {
        for {
            select {
            case job := <-d.JobQueue: // Obtén un job de la cola de Jobs del dispatcher
                // Asigna el Job a un worker
                go func() {
                    jobChannel := <-d.WorkerPool // Obten un jobChannel del Worker Pool
                    jobChannel <- job // Pasale el job a ese jobChannel 
                }()
            }
        }
    }

Método run del dispatch
-----------------------

Crea un worker hasta que alcancemos el máximo número de workers y córrelo.

.. code-block:: go

    func (d *Dispatcher) Run() {
        for i := 0; i < d.MaxWorkers; i++ {
            worker := NewWorker(i+1, d.WorkerPool) //Asignalo al workerPool del dispatcher
            worker.Start() // Haz que el worker procese los jobs pendientes
        }

        go d.dispatch()
    }


Creando un servidor web
=======================

Creamos una función llamada RequestHandler que reciba un objeto ResponseWriter que escribe en la respuesta HTTP, un objeto Request, que contiene la petición HTTP y una cola de tareas jobQueue.

.. code-block:: go

    func RequestHandler(w http.ResponseWriter, r *http.Request, jobQueue chan Job) {
        if r.Method != "POST" {
            w.Header().Set("Allow", "POST")
            w.WriterHeader(http.StatusMethodNotallowed)
        }

La función parseDuration parsea texto como "3s" y lo transforma en tiempo real. 
El método FormValue devolverá obtendrá valor del argumento que le enviemos.

Si el valor delay es incorrecto, devolverá un error 

.. code-block:: go

        delay, err := time.ParseDuration(r.FormValue("delay"))
        if err != nil {
            http.Error(w, "Invalid delay", http.StatusBadRequest)
            return
        }

La función Atoi transforma un string de un número en su valor númerico.

.. code-block:: go

        value, err := strconv.Atoi(r.FormValue("value"))
        if err != nil {
            http.Error(w, "Invalid value", http.StatusBadRequest)
            return
        }

Revisamos también que no recibamos un string vacio.

.. code-block:: go

        name := r.FormValue("name")
        if name == "" {
            http.Error(w, "Invalid name", http.StatusBadRequest)
            return
        }

Ahora creamos un Job y se lo pasamos a la cola de jobs y devolvemos un estado 201 mediante el objeto http que indica que se creo un job.

.. code-block:: go

        job := Job{Name: name, Delay: delay, Number: value}
        jobQueue <- job
        w.WriterHeader(http.StatusCreated)
    }

Y ahora la función main, que se encargará de crear un jobQueue, un dispatcher y lo correrá.

.. code-block:: go

    funct main () {
        const (
            maxWorkers = 4
            maxQueueSize = 20
            port = ":8081"
        )

        jobQueue := make(chan Job, maxQueueSize)
        dispatcher := newDispatcher(jobQueue, maxWorkers)

        dispatcher.Run()

Por último, la creación de un servidor se hace con el método HandleFunc del objeto http. Este recibe una ruta y necesita como argumento una función que reciba los objetos ResponseWriter y Request, como primer y segundo parámetro, respectivamente. El tercer parámetro será al cola de Jobs.

.. code-block:: go

        http.HandleFunc("/fib", func (w http.ResponseWriter, r*http.Request){
            RequestHandler(w, r, jobQueue)
        })
        log.Fatal(http.ListenAndServe(port, nil)
    }

Middleware en un servidor web
-----------------------------

En Go podemos declarar un middleware como una función que reciba un http.Handler y retorne un http.Handler. Para pasar al siguiente httpHandler vamos a ejecutar el método ServeHTTP del http.Handler que el middleware recibe como argumento.

.. code-block:: go

    func middleware(originalHandler http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            fmt.Println("Running before handler")
            w.Write([]byte("Hijacking Request "))
            originalHandler.ServeHTTP(w, r)
            fmt.Println("Running after handler")
    })
    }

Y ahora basta con envolver nuestra http.Handler original en el middleware. 

.. code-block:: go

    func main() {
        // converting our handler function to handler 
        // type to make use of our middleware 
        myHandler := http.HandlerFunc(handler)
        http.Handle("/", middleware(myHandler)) 
        http.ListenAndServe(":8000", nil)
    }

Para evitar anidar múltiples middlewares podemos usar programación funcional.

Peticiones http
===============

Go puede realizar peticiones http usando su método GET. Observa como se cierra la conexión **solo tras haber verificando que no hubo un error** con la petición, porque si la petición falla, resp será nulo y estaremos llamando a un método de un objeto nulo.

.. code-block:: go

    func main() {  
        resp, err := http.Get("https://example.org")
        if err != nil {
            fmt.Println(err)
            return
        }

        defer resp.Body.Close() //Es necesario cerrar la conexión.

Sin embargo si hay un fallo de redirección ambas respuestas, resp y err, serán no nulas, por lo que es necesario manejar también esa situación

.. code-block:: go

    if resp != nil {
        defer resp.Body.Close()
    }

    if err != nil {
        fmt.Println(err)
        return
    }

Ahora ya podemos leer la respuesta de la propiedad Body.

.. code-block:: go

    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println(err)
        return
    }

    fmt.Println(string(body))

Panic
=====

Podemos recuperarnos de errores tipo panic llamando a la función recover. **recover solo puede usarse dentro de una función con defer directa**, es decir no puede estar dentro de una función que llame a otra función, incluso si la función original tiene el atributo defer.

.. code-block:: go

    defer func() {
            fmt.Println("recovered:",recover())
        }()

JSON
====

Para crear un json usaremos el paquete json y su método Marshal

.. code-block:: go

    package main

    import (
    "encoding/json"
    "fmt"
    )

    objeto = slice | array | map

    nuestroJson, _ := json.Marshal(objeto) 

Podemos convertir cualquiera de los objetos slice, array o map en un json. Sin embargo, si lo creamos, será un array de números. Necesitamos convertirlo primero en un string 

.. code-block:: go

    [123 34 117 110 111 34 58 49 125]

Si queremos obtener la representación real de un objeto JSON usamos el método string para convertirlo.

.. code-block:: go

    jsonString := string(nuestroJson)
    fmt.Println(jsonString)
    //{"uno":1}

Argumentos en Go
================

Go provee un objeto llamado flag para recibir argumentos 

.. code-block:: go

    import "flag"

    var (
        port = flag.Int("p", 3090, "port")
        host = flag.String("h", "localhost", "host")
    )

El método que llama depende del tipo de dato que queremos capturar y cada método toma 3 argumentos: 
1. El nombre del flag
2. El valor por defecto
3. La descripción

Ahora ya podemos llamar a los flags de nuestro programa 

.. code-block:: go

    go run main.go --port 80 --host example.org

