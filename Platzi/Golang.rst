======
Golang
======

Go es un lenguaje compilado desarrollado por google. Es un lenguaje bastante apreciado según los desarrolladores de acuerdo a las últimos encuestas de Stackoverflow (2021).

Go está fuertemente orientado a las buenas prácticas de código. El compilador de Go fuerza buenas prácticas en el código, impidiendo que el código compile si hay variables que no se usan, o si falta documentación en structs públicos.

La mascota oficial es una ardilla de tierra. La comunidad ama tanto su mascota que creó una herramienta para crear avatares personalizados en `Gopherizme <https://gopherize.me>`_ y es apreciado por la comunidad. Sin embargo el `logo oficial de go <https://blog.golang.org/go-brand>`_  ya ha sido definido.

Instalación
===========

Go se encuentra en la mayoría de los repositorios de las distribuciones de GNU/Linux. En debian se instala como cualquier otro paquete.

.. code-block:: bash

    sudo apt install golang

Archivo principal
=================

Go requiere una función main y una linea que establezca el nombre del paquete. 

.. code-block:: go

    package main

    import "fmt"

    func main() {
        fmt.Println("Hello world")
    }

Ejecutar un archivo de go
=========================

Debido a que go es un lenguaje compilado, requiere que se ejecute un compilado antes de poder ejecutar el código. El compilado se realiza con el comando build.

.. code-block:: bash

    go build src/main.go

También es posible compilar y correr el código en un solo paso usando run en lugar de go.

.. code-block:: bash

    go run src/main.go

Diferencias entre run y build
-----------------------------

Go run compila el código y lo ejecuta desde un directorio temporal, posteriormente limpia los archivos generados. Si agregamos la opción --work, podremos ver la ubicación de este directorio.

.. code-block:: bash

    go run --work src/main.go
    # WORK=/tmp/go-build983014220

Variables, constantes y zero values
===================================

Variables 
---------

Go permite definir variables especificando el tipo de dato y la keyword var.

.. code-block:: go

    var gravedad int = 123

También es posible dejar que go intuya el tipo de dato con el operador walrus. Este tipo de asignación **solo es posible dentro del scope de una función**.

.. code-block:: go

    gravedad := 123

Se puede declarar una variable y asignarle un valor más tarde.

.. code-block:: go

    var gravedad int

No puedes asignar una variable al valor nulo de go; nil.

.. code-block:: go

    var gravedad = nil // error

Constantes
----------

Con las constantes funciona de manera similar, pero se caracterizan porque no pueden modificarse. Se usa la keyword const.

.. code-block:: go

    const gravedad int = 123

Si no especificamos un tipo de constante go intentará intuirlo. 

.. code-block:: go 

    const pi = 3.14159

Zero values
-----------

Si no asignamos un valor go usará valores predeterminados diferentes para cada tipo de dato.

* int: 0
* float: 0
* string: ""
* bool: false

Valor nulo
----------

Go usa la palabra nil para referirse a un valor nulo.

comentarios
===========

Los comentarios se marcan usando dos diagonales seguidas

.. code-block:: go

    // Este es un comentario en go.

Los comentarios multilinea se realizan con una diagonal seguida de asterisco

.. code-block:: go

    /*
    Este es un comentario multilinea
    */

Operadores aritméticos en go 
============================

Los operadores de go son similares al resto de los lenguajes.

* +, suma 
* -, resta
* \*, multiplicación
* /, división
* <, menor que
* <=, menor o igual que
* >, mayor que
* >=, mayor o igual que
* %, el módulo o residuo
* !=, inequivalencia
* ==, igualdad
* !, negación
* &&, operador AND
* ||, operador OR
* ++, incremental
* --, decremental

Tipos primitivos de datos
=========================

Los datos primitivos de go nos permiten definir un tipo de dato para una constante o varible.

Entero
------

Para valores enteros con o sin signo.

* int, se asigna de acuerdo al SO (32 o 64 bits)
* int8, 
* int16
* int32
* int64

Entero sin signo
----------------

Para valores sin signo, es decir, positivos.

* uint, se asigna de acuerdo al SO (32 o 64 bits)
* uint8
* uint16
* uint32
* uint64

Decimal
-------

Para números decimales 

* float32
* float64

Textos
------

Para textos existe únicamente string 

Boolean
-------

Para valores true or false

Números complejos
-----------------

Permite manejar números reales e imaginarios:

* Complex64
* Complex128

Por ejemplo: c:=100+2i

Funciones
---------

Las funciones pueden ser un tipo de dato en un struct.

.. code-block:: go

    table := []struct {
                id               int
                dni              string
                mockFunc         func()
                }

Paquete fmt
===========

Es el paquete encargado de manejar entradas y salidas en la terminal. Incluye todo lo necesario para lidiar con caracteres especiales, como el idioma chino.

Println
-------

Print que agrega un salto de linea al final, es posible separar variables por comas.

.. code-block:: go

    fmt.Println("Hello wired")

Printf
------

Permite agregar operadores de posición

.. code-block:: go

    fmt.printf("Hello %s %d", texto, numero)

Sprintf
-------

No imprime en la terminal, sino que genera un string con los operadores de posición.

.. code-block:: go

    var message string = fmt.printf("Hello %s %d", texto, numero)

Operadores de posición
----------------------

Hay algunos operadores de posición destacables.

* %T, tipo de variable
* %v, valor en el formato predeterminado
* %t, la palabra false o true
* %x, número de base 16
* %o, número de base 8
* %e, notación científica
* %9.2f, flotante con ancho de 9 y precisión de 2
* %.2f, flotante con ancho predeterminado y precisión de 2

Puedes ver más en la `página oficial de go <https://pkg.go.dev/fmt>`_ 


Funciones en Go
===============

Las funciones se declaran con la siguiente sintaxis

.. code-block:: go

    func suma(){
    
    }

Los argumentos requieren tipo de dato y pueden separarse por comas 

.. code-block:: go

    func suma(a int, b int){
    
    }

Es posible asignar dos argumentos a un mismo tipo de dato omitiendo el tipo de la primera.

.. code-block:: go

    func suma(a, b int){
    
    }

Para retornar valores se usa la variable return

.. code-block:: go

    func suma(a, b int){
        return a + b
    }

Go requiere establecer un tipo de retorno después de los argumentos.

.. code-block:: go

    func suma(a, b int) int{
        return a + b
    }

Para especificar dos valores como retorno usamos parentesis 

.. code-block:: go

    func suma(a, b int) (int, int){
        return a, b
    }

Es posible retornar dos valores con una función separándolos por comas. 

.. code-block:: go

    func double(a, b int){
        return a * 2, b * 2
    }

Una función puede retornar una función pasándole el tipo de dato func()

.. code-block:: go

    func returnFunction() func() {
        return func() {
            fmt.Println("gola")
        }
    }


    func main() {
        returnFunction()()
    }


Y podemos asignar esos valores en dos variables diferentes llamando a la función

.. code-block:: go

    value1, value2 = double(2, 3)

returns sin nombre
------------------

Una función puede implementar que retorne lo que pe pasamos como tipo por defecto. En este caso le indicamos que devolverá una variable x y una variable y de tipo int. Si go detecta que no hay nada después de la palabra return, devolverá x y y.

.. code-block:: go

    func split(sum int) (x, y int) {
        x = sum * 4 / 9
        y = sum - x
        return
    }

Cantidad variable de argumentos
-------------------------------

Si no sabemos la cantidad de argumentos que va a recibir una función, colocamos el nombre del argumento, seguido del operador ... y a continuación el tipo de variable.

.. code-block:: go

    func Sum(nums ...int) int {
        res := 0
        for _, n := range nums {
            res += n
        }
        return res
    }

Paquete strings
===============

Este paquete tiene múltiples funciones para trabajar con strings, aquí dejo algunas de las más importantes

* func Contains(s, substr string) bool Revisa si una cadena de texto se encuentra en otra.
* func Count(s, substr string) int Cuenta las ocurrencias de una cadena de texto en otra.
* func HasPrefix(s, prefix string) bool Revisa si un string empieza un string
* func HasSuffix(s, suffix string) bool Revisa si un string termina con otro string
* func Join(elems []string, sep string) string Une todos los elementos de una lista en un string, usando un separador entre cada par de elementos
* func Split(s, sep string) []string Separa un string en una lista por un separador que le indiquemos
* func Index(s, substr string) int Devuelve el indice de una cadena de texto en otra
* func Replace(s, old, new string, n int) string Reemplaza la primera ocurrencia de una cadena de texto por otra 
* func ReplaceAll(s, old, new string) string Reemplaza todas las ocurrencias de una cadena de texto por otra 
* func ToLower(s string) string Convierte en minúsculas
* func ToUpper(s string) string Convierte en mayúsculas
* func Trim(s, cutset string) string Remueve los espacios al principio y al final

Revisa las funciones completas en `la documentación de strings en go <https://pkg.go.dev/strings>`_ 

Paquete strconv
===============

Permite convertir strings en otros tipos de datos

* func Atoi(s string) (int, error) convierte un string en un entero
* func Itoa(i int) string convierte un número entero en un string
* func ParseBool(str string) (bool, error) Convierte 1, t, T, TRUE, true, True en True o 0, f, F, FALSE, false, False en False

Mira el resto de funciones en `la documentación de strconv en go <https://pkg.go.dev/strconv>`_ 


Función len()
=============

La función len se encarga de devolver el número de elementos que tiene un string, un slice, un array, un channel. Sin embargo, en el caso de los strings, devuelve el número de bytes, para caracteres que no formen parte de utf-8, para solucionar este problema usamos el método RuneCountInString.

.. code-block:: go

    package main

    import (  
        "fmt"
        "unicode/utf8"
    )

    func main() {  
        data := "♥"
        fmt.Println(len(data)) // Imprime 3
        fmt.Println(utf8.RuneCountInString(data)) // imprime 1

Ignorando variables 
===================

Para ignorar una variable le pasamos un guión bajo o underscore y el compilador no tendrá en cuenta si la usamos o no.

.. code-block:: go

    value1, _ = double(2, 3)

godoc
=====

Godoc es una página que nos muestra detalles de cada función que compone un paquete, así como un parseo de la información de github. Para hacerlo debemos ir a la `sección packages <https://golang.org/pkg/>`_ de la página oficial de golang. 

Ciclos
======

En go solamente existen los ciclos for, hay varios tipos de ciclos for. 

Con condicional
---------------

Es el clásico ciclo en el que existe un contador y el código se ejecuta mientras se cumpla un contador

.. code-block:: go

    for i:= 0; i < 10; i++ {

    }

Con condición
-------------

El ciclo se ejecuta mientras se cumpla una condición

.. code-block:: go

    counter := 0
    for counter < 10 {
        counter ++
    }


counterForever
--------------

El ciclo se ejecuta indefinidamente

.. code-block:: go

    counterForever := 0
    for {
        counterForever++
    }

Condicional if 
==============

Usado para manejar el flujo del código de acuerdo a una condición

.. code-block:: go

    num := 9
	if num % 2 == 0 {
		fmt.Println("es par")
	} else {
		fmt.Println("es impar")


Switch
======

Para manejar múltiples casos para una condición específica

.. code-block:: go

    var mes int8 = 10
	switch {
	case mes <= 3:
		fmt.Println("Primer Trimestre")
	case mes > 3 && mes <= 6:
		fmt.Println("Segundo Trimestre")
	case mes > 6 && mes <= 9:
		fmt.Println("Tercer Trimestre")
	case mes > 9 && mes <= 12:
		fmt.Println("Cuarto Trimestre")
	default:
		fmt.Println("Este no es un mes valido")
	}

defer, break y continue
=======================

defer
-----

Se usa para retrasar la ejecución de código hasta el final de la operación. Ideal para cerrar base de datos u operaciones que necesitas que se ejecuten siempre.

.. code-block:: go

    defer CloseDatabase()

break
-----

Se usa para romper un ciclo

.. code-block:: go

    counter := 0
    for counter < 10 {
        counter ++
        if counter == 9 {
            break
        }
    }

Es posible designar un nombre de un ciclo para luego usar break en ese ciclo.

.. code-block:: go

    loop:
        for {
            switch {
                case true:
                    break loop
                }
            }

continue
--------

Se usa para interrumpir una iteración de un ciclo y continuar con la siguiente iteración

.. code-block:: go

    counter := 0
    for counter < 10 {
        counter ++
        if counter == 2 {
            continue
        }
        // lo siguiente no se ejecutará si counter es igual a 2
    }

Array y slices 
==============

Los array y los slices son estructuras para manejar colecciones de tipos de datos.

Array
-----

Los arrays son inmutables, debemos definir un tamaño y un tipo de dato. Una vez creados no se pueden modificar. 

.. code-block:: go

    var array [4]int

Podemos asignar valores haciendo referencia a la posición del array.

.. code-block:: go

    array[0] = 1
    array[1] = 2

slices
------

Los slices son colecciones mutables de tipos de datos. No tenemos que especificar una longitud.

.. code-block:: go

    list := []int{0,1,2,3,4,5}

Los slices pueden partirse en un estilo similar al de Python, especificando una posición incluyente para el primer digito y excluyente para el segundo. 

Si no especificamos uno de los dos, tomará la primera posición para el primer digito y la última para el segundo digito.

.. code-block:: go

    list[3:] 
    list[:4]
    list[2:3]

Append
^^^^^^

Los slices son mutables, por lo que es posible agregar nuevos elementos. Esto se hace con append, y recibe cualquier número de elementos, separados por comas.

.. code-block:: go

    list = append(list, 6)
    list = append(list, 5, 6, 7)

Podemos crear un nuevo slice a partir de la desestructuración de un slice. La desestructuración se lleva a cabo poniendo tres puntos (...) al final del slice.

.. code-block:: go

    otherSlice :=[]int{7, 8, 9}
    slice = append(slice, otherSlice...)

Recorriendo slices con range 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parecido a la sintaxis de Python, podemos recorrer un array donde asignamos cada elemento a una variable.

.. code-block:: go

    slice := []string = ["aldo", "javier", "marti"]
        for i:= range slice {
    }

make
====

La función make asigna e inicializa un objeto del tipo slice, map o chan.

Maps 
====

Los maps son el equivalente de los diccionarios, son una estructura de datos tipo llave, valor. Se crean usando la función make y definiendo el tipo de llave y el tipo de valor que tendrá el map.

.. code-block:: go

    diccionario := make(map[string]int)
    diccionario["hidrogeno"] = 1
    diccionario["Helio"] = 2
    
Si intentamos acceder a una llave que no existe, go nos devolverá su respectivo zero value

.. code-block:: go

    diccionario := make(map[string]int)
    fmt.Println(m["no_existe"])
    // 0

Capacidad opcional
------------------

Para establecer uan capacidad máxima en un map, le pasamos la máxima capacidad como segundo argumento.

.. code-block:: go
    
    m := make(map[string]int,99)

delete
------

La función delete borra una llave del diccionarios

.. code-block:: go

    delete(diccionario, "Helio")

Recorrer map con range
----------------------

De la misma manera que con un slice, podemos recorrer los maps con range, asignando una variable para la llave y otra para el valor. El contenido no se devolverá con un orden en particular.

.. code-block:: go

    for k, v := range m {
        (k,v)
    }

Recuerda que se puede ignorar el valor de una llave o valor con el guión bajo o underscore.

.. code-block:: go

    for _, v := range m {
        fmt.Println(v)
    }

Structs 
=======

Los structs son colecciones de campos, se definen con el keyword type seguido del nombre a asignar y la palabra struct.

.. code-block:: go

    type Videogame struct {
        Genre string
        Year int
    }

Creación de un struct
---------------------

Para crear un struct existen dos maneras 

.. code-block:: go

    myVideogame := videogame{genre: "Horror", year: 2021}

También es posible primero declarando el tipo de dato y después accediendo a los campos. Si no especificamos un valor go le asignará el respectivo zero value al tipo de variable.

.. code-block:: go

    var myVideogame videogame
    myVideogame.genre = "Horror"

campos anónimos
---------------

Es posible no especificar el tipo de campo de nuestro struct y dejarlo abierto. No funciona para structs múltiples campos del mismo tipo. Los campos adoptan el nombre del tipo de dato y podemos acceder a ellos usándolos.

.. code-block:: go

    type Videogame struct {
        string
        int
    }

    myVideogame := Videogame{string: "Titulo", int: 2000}
    fmt.Println(myVideogame)
    // imprime {Titulo 2000}


Privacidad en structs, funciones y variables
============================================

Para marcar un struct, función o variable como privada o pública, igual que sus respectivos campos para el struct. Basta con especificar los campos con mayúsculas o minúsculas, para público y privado, respectivamente. **Al intentar acceder a una entidad privada desde otro módulo el compilador la procesará como si no existiera, devolviéndo un error**.

* mayúsculas, público
* minúsculas, privado


Si queremos declarar un struct como público necesitaremos agregar un comentario en su parte superior o el compilador marcará error.

.. code-block:: go

    // Videogame struct que representa a videogame
    type Videogame struct {
        Genre string
        Year int
    }
    
Manejo de errores con go
========================

Go nos permite manejar errores creando una segunda variable de retorno para la función que queremos probar. Si ocurre un error lo obtendremos y err será diferente de nil.

.. code-block:: go

    message, err := greetings.Hello("")
    if err != nil {
        log.Fatal(err)
    }


Variables de entorno de go
==========================

Go maneja dos variables de entorno:

* GOROOT, establece donde está localizado el SDK. Solo debe cambiarse para usar diferentes versiones de go. 
* GOPATH, define la raliz del espacio de trabajo. Por defecto es un directorio llamado go, dentro de home. Aquí se descargan los paquetes.

Importacion de paquetes con go mod
==================================

En go no existen las importaciones relativas. Se debe usar la ruta absoluta considerando la variable de entorno GOPATH o usar go mod 

go mod 
------

Go mod permite establecer un directorio afuera de GOPATH para tomar los paquetes. Esto creará un archivo go.mod en donde lo ejecutemos. El nombre mypackage será la base de la ruta desde la que importaremos nuestros paquetes.


.. code-block:: go

    go mod init mypackage 

Es buena práctica colocar el path completo de la dirección de github

.. code-block:: go

    go mod init github.com/usuario/paquete

Nos quedará una ruta con la siguiente estructura. D

.. code-block:: go

    ├── go.mod
    └── src
        ├── main.go
        └── mymodel
            └── mymodel.go
    

Dentro de go.mod se especificará el nombre del modulo, a partir del cual crearemos la ruta de importación, así como la versión de go.

.. code-block:: go

    module demoproject

    go 1.15

Ahora podemos crear un modelo en model.go 

.. code-block:: go

    package mymodel

    type Videogame struct {
        Id          int32
        Title       string
    }

Para referirnos a ese modelo hacemos referencia a la ruta mypackage/src/model, observa como la ruta empieza con el nombre que aparece en el archivo *go.mod*

.. code-block:: go

    package main

    import (
        "mypackage/src/mymodel"
        "fmt"
    )

    func main() {
        var videojuego = model.Videogame{
            Id:          1,
            Title:       "Life is strange"
        }
        fmt.Println(videojuego.Title)
    }


Alias al importar paquetes 
--------------------------

Podemos declarar un alias a la hora de importar un paquete anteponiendo el alias antes de la importación

.. code-block:: go 

    import nuestroAlias "ruta/a/paquete"
    
Structs y punteros
==================

Cuando se crea una variable se le asigna una dirección de memoria, a la que podemos acceder con el operador ampersand

.. code-block:: go

    a := 50
    b := &a

Para modificar la variable usamos el caracter de desestructuración.

.. code-block:: go

    *b = 100

Composición en Go
=================

Para acceder a instancias de structs en las  funciones necesitamos pasarle un parentesis antes del nombre de la función, que contiene el nombre que usaremos para acceder al struct seguido del nombre del struct.

.. tip:: Recuerda que debes cuidar la privacidad de la función, si la declaras con minúsculas no podrás acceder a ella desde un archivo externo.

.. code-block:: go

    func (myStructVariable Videogame) Ping{
        fmt.Println(myStructVariable.Title)
    }


Podemos acceder a sus valores mediante punteros lo pasamos dentro del parentesis con el caracter de desestructuración.

.. code-block:: go

    func (myStructVariable *Videogame) IncreaseYear{
        myStructVariable.year = myStructVariable.year + 1
    }

Para posteriormente llamar al método a través de una instancia del struct.

.. code-block:: go

    videogame.IncreaseYear()

Constructor en structs
----------------------

Go no tiene un mecanismo de constructores implementados. Pero puede crearse una función que devuelva un objeto ya inicializado con los parámetros que querramos aplicar.

.. code-block:: go

    func NewWorker(id int, workerPool chan chan Job) *Worker {
        return &Worker{
            Id:         id,
            WorkerPool: workerPool, // workerPool al que pertenece
            JobQueue:   make(chan Job),  // Crea una cola de jobs
            Quit:       make(chan bool), // Channel para finalizar los jobs
        }
    }

Herencia en structs
-------------------

Para que un struct en go posea todos los campos que declara otro struct, le pasamos este último como un campo anónimo.

.. code-block:: go

    type Persona struct {
        Name string
        Sexo string
    }

    type Profesor struct {
        Persona
    }


Interfaces y polimorfismo
=========================

Las interfaces son un método para compartir métodos entre structs y evitar repetir códigos. Una interface se encargará de llamar al método que le especificamos correspondiente a su tipo de struct.

.. code-block:: go

    type figuras4Lados interface{
        area() float64
    }

Teniendo múltiples structs, llamará al método area de cada uno.


.. code-block:: go

    type rectangulo struct {
        base float64
        altura float64
    }

    type cuadrado struct {
        base float64
        altura float64
    }

    func (c cuadrado) area() float64 {
        return c.base * c.base 
    }

    func (r rectangulo) area() float64 {
        return r.base * r.base 
    }

La función que crearemos recibirá cualquiera de nuestros structs, ejecutará su respectivo método area.

.. code-block:: go

    func calcular (f figuras4Lados) {
        fmt.Println("Area", f.area())
    }

Para llamar al método respectivo solo llamamos la función pasándole una instancia del struct

.. code-block:: go

    miCuadrado := cuadrado{base: 2}
    calcular(cuadrado)
    miRectangulo := rectangulo{base:2, altura: 4}
    calcular(miRectangulo)
    
String en structs
=================

La función para personalizar el output en consola en los structs debe llamarse String()    


slice de interfaces
-------------------

Existen los slice de interfaces, que nos permiten guardar diferentes tipos de datos en un solo slice. Un slice de interfaces lleva doble par de llaves

.. code-block:: go

    myInterface := []interface{}{"Hola", 1, 3.4}
    fmt.Println(myInterface...)

Concurrencia
============

Uno de las mejores características del lenguaje. A las corrutinas de go se les conoce como goroutines. La función main se ejecuta dentro de una goroutine.

Ejecutar una goroutine basta con agregar el keyword go antes de una función.

.. code-block:: go

    fmt.Println("hey")
    go write("hey again")

sync
----

Creamos un WaitGroup, que acumula un conjunto de goroutines y las va liberando paulatinamente. El método Wait, esperará a que se ejecuten todas las gorotuines. 

.. code-block:: go

    var wg sync.WaitGroup
    wg.add(1)
    wg.Wait()

El método add dice cuantas goroutinas queremos añadirle al gestor al WaitGroup.

Para indicarle cuando se ha finalizado llamaremos al método done.

.. code-block:: go

    go say("hey again", &wg)

Dentro de esa función usamos defer sobre el método done para garantizar que sea lo último que se ejecute.

.. code-block:: go

    say(text string, wg *sync.WaitGroup) {
        defer wg.done()
        fmt.Println(text)
    }

funciones anónimas en gorotuines
--------------------------------

Se usan frecuentemente en goroutines.

.. code-block:: go

    go func() {
    }()

Los parentesis del final reciben los argumentos.

.. code-block:: go

    go func(text string) {
    }("Texto")

Channels
========

Son un conducto que permite manejar un único tipo de dato. Los channels permiten a las goroutines comunicarse entre ellas. Podemos pasarle como un argmento extra la cantidad límite de datos simultaneos que manejará ese canal.

.. code-block:: go

    c := make(chan string, 1)

cuando querramos hacer referencia al canal como argumento de otra función tenemos que pasar el tipo de dato

.. code-block:: go

    func say(text string, c chan string) {
    
    }

El tipo de dato de un canal también puede ser uno definido en un struct.

.. code-block:: go

    func say(text string, c chan MiStruct) {
    
    }

Y para indicar la entrada de datos a través del channel usamos <-

.. code-block:: go

    func say(text string, c chan string) {
        c <- text
    }

Para obtener la respuesta del canal invertimos el orden de <-

.. code-block:: go

    fmt.Println(<-c)

También podemos definir un canal como entrada o salida únicamente.

Para identificarlos, observa el flujo de la flecha alrededor de la palabra chan; una entra a chan y la otra sale de chan. 

Este de entrada.

.. code-block:: go

    func say(text string, c chan<- string) {
        
    }

Y este es un canal de salida.

.. code-block:: go

    func say(text string, c <-chan string) {
        
    }

En ocasiones es importante definir el tipo de canal pues, con los canales bidireccionales corremos el riesgo de ocasionar un bloqueo en nuestro programa.


canal de canales
----------------

Es posible tener un canal de canales

.. code-block:: go

    type Worker struct {
        WorkerPool chan chan Job
    }


Operaciones bloqueantes
=======================

Las operaciones que mandan o reciben valores de canales son bloqueantes dentro de su propia goroutine.

* Si una operación recibe información de un canal, se bloqueará hasta que la reciba.
* Si una operación manda información a un canal, esperará hasta que la información enviada sea recibida.

.. code-block:: go

    package main

    import (
        "fmt"
    )

    func main() {
        n := 2

        out := make(chan int)

        // La llamamos como una goroutine
        go multiplyByTwo(n, out)

        // Una vez que se reciba el resultado del canal out, se puede proceder
        fmt.Println(<-out)
    }

    func multiplyByTwo(num int, out chan<- int) {
        result := num * 2

        // redirige el resultado al canal out
        out <- result

La función que imprime el canal bloqueará la ejecución del código hasta que reciba la información del canal out.

Range, close y select en channels
=================================

La función len nos dice cuantas goroutines hay en un channel y cap nos devuelve la capacidad máxima, respectivamente.

.. code-block:: go

    c := make(chan string, 2)
    c <- "dato1"
    c <- "dato2"
    fmt.Println(len(c), cap(c))

close
-----

close cierra el canal, incluso aunque tenga capacidad

.. code-block:: go

    c :=make(chan string, 2)
    c <- "dato1"
    c <- "dato2"
    close(c)

Range 
-----

Range es ideal para iterar sobre los datos de los canales.

.. code-block:: go

    for message := range c {
    
    }

Sin embargo **noexiste certeza sobre que dato recibiremos**

Select
------

Select nos permite definir acciones diferentes para cada canal, a esto se le llama **multiplexación**. Por lo que es importante conocer el número de canales y de datos para poder procesarlos.

.. code-block:: go

    func message(text string, c chan string) {
        c <- text
    }
    funct main() {
        email1 := make(chan string)
        email2 := make(chan string)

        go message("mensaje1", email1)
        go message("mensaje2", email2)

        for i:= 0; i < 2; i++ {
            select {
                case m1 := <- email1:
                    fmt.Println("Recibido email1", m1)
                case m2 := <- email2:
                    fmt.Println("Recibido email1", m2)
            }
        }
    }

Go get: manejador de paquetes  
=============================

El equivalente de pip y npm pero en go.

Para obtener paquetes se obtienen corriendo el comando go get en consola. **Recuerda configurar el GOPATH o correr go mod init proyecto** en la raiz de tu proyecto antes de obtener los paquetes.

.. code-block:: go

    go get golang.org/x/website/tour

Si quieres más nivel de verbosidad agrega la opción -v.

Librerías 
---------

Hay un directorio de frameworks, librerías y utilidades en `Awesome go <http://awesome-go.com/>`_ 

Go modules: Ir más allá del GoPath con Echo
===========================================

Para reemplazar librerías hacemos un git clone de la libreríaa que necesitamos, lo editamos y, posteriormente, usamos replace. Esto creará una redirección en el archivo go.mod

.. code-block:: go

    go mod edit -replace github.com/usuario/proyecto=./libreriaLocal

Para cancelar un replace usamos dropreplace y especificamos cual queremos cancelar.

.. code-block:: go

    go mod edit -dropreplace github.com/usuario/proyecto

Si queremos verificar los modulos

.. code-block:: go

    go mod verify

Imprime las dependencias del módulo actual.

.. code-block:: go

    go list -m all

Para empaquetar todo el código del proyecto, incluyendo librerías de terceros y el código de go, usamos vendor.

.. code-block:: go

    go mod vendor

Esto creará una carpeta vendor con los archivos necesarios para que el proyecto se pueda ejecutar de la manera correcta.

.. code-block:: go

    vendor/
    ├── github.com
    │   ├── golang-jwt
    │   │   └── jwt
    │   │       ├── claims.go


En go.sum se listarán todos los archivos y sus hashes.

.. code-block:: go

    github.com/davecgh/go-spew v1.1.0/go.mod h1:J7Y8YcW2NihsgmVo/mv3lAwl/skON4iLHjSsI+c5H38=


El comando para limpiar librerías no utilizadas.

.. code-block:: go

    go mod tidy


Librerías de desarrollo web
===========================

* `Hugo <https://gohugo.io/>`_ 
* `Hugo themes <https://themes.gohugo.io/>`_ 
* `Echo <https://echo.labstack.com/>`_ 
* `Gin gonic <https://gin-gonic.com/>`_ 
* `Beego <https://beego.me/>`_
* `Revel <https://revel.github.io/>`_  
* `Buffalo <https://gobuffalo.io/en/>`_ 

Enlaces útiles
==============

* `Atour of go <http://tour.golang.com/>`_ 
* `Play with go <https://play-with-go.dev/>`_ 
* `Go by example <https://gobyexample.com/>`_ 
* `Comunidad go slack <http://gophers.slack.com/>`_ 
* `Podcast de go <https://open.spotify.com/show/2cKdcxETn7jDp7uJCwqmSE?si=q88UkEYQTxS0t1QVws22tw&amp;nd=1>`_ 

