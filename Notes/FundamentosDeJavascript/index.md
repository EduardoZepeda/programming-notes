# 1. Fundamentos de Javascript



## 1.1 Variables

El objeto global es accesible a través de:

``` javascript
window.nombre
```

Las variables constantes no pueden cambiarse y se escriben en mayúsculas
como convención:

``` javascript
const PI = 3.14159
```

## 1.2 Objetos

Los objetos que se pasan a las funciones se pasan por referencia y, por
lo tanto, se modifican.

Para prevenir eso podemos devolver un objeto diferente, para esto se
usará la siguiente sintaxis:

``` javascript
function cumpleanos(persona){
    return
        ...persona,
        edad: persona.edad +1
}
```

## 1.3 Debugger

Se detendrá la ejecución del programa cada que se encuentre la palabra
debbuger:

``` javascript
while(sacha.peso > META){
    debugger
}
```

## 1.4 This dentro de las arrow function

El this dentro de una arrow function apunta al this afuera de la
función, que en el espacio global es window, por lo que no es posible
referenciar objetos usando las arrow function

## 1.5 Asincronia

En Javascript hay dos pilas, las del programa principal y la de las
tareas pendientes, todas las funciones asincronas mandan sus callbacks a
la pila de tareas pendientes, esta última no se ejecutará hasta que se
haya terminado la pila del programa principal. Por esta razón hay que
tener cuidado de programas muy pesados, pues los callbacks se ejecutarán
después del cuello de botella:

``` javascript
setTimeout(()=>console.log("Ejecutado"), 2000)
for(var i=0; i<10000000; i++){    
}
```

En el caso anterior el console.log será ejecutado hasta que se termine
el ciclo, lo cual puede tardar minutos completos.

## 1.6 Promesas

Hay una funcion que ejecuta un array de promesas:

``` javascript
Promise
    .all(promesas)
    .then(personajes => console.log(personajes))
    .catch(onError)
```

Async-await es la manera más simple y clara de realizar tareas
asíncronas. Await detiene la ejecución del programa hasta que todas las
promesas sean resueltas. Para poder utilizar esta forma, hay que colocar
async antes de la definición de la función, y encerrar el llamado a
Promises.all() dentro de un bloque try … catch.

## 1.7 Memoización

La memoización permite guardar valores que cuestan mucho tiempo, para
poder utilizarlos más tarde sin volver a incurrir en el costo de
procesamiento. El valor de cache se guarda en la memoria de la función.
incluso después de haber sido ejecutada una vez:

``` javascript
function factorial(n){
   if (n < 0){
        return 'Entrada no válida, solo numeros positivos'
    }

    if (!this.cache){
        this.cache = {}                
    }

    if (this.cache[n]){
        return this.cache[n]
    }
    if (n === 1 || n === 0){
        this.cache[n] = 1
        return this.cache[n]
    }

    this.cache[n] = n * factorial(n - 1)
    return this.cache[n] 
}
```

## 1.8 Closures

Un closure, básicamente, es una función que recuerda el estado de las
variables al momento de ser invocada, y conserva este estado a través de
reiteradas ejecuciones. Un aspecto fundamental de los closures es que
son funciones que retornan otras funciones:

``` javascript
function crear_saludo (final_de_frase) {
    return function (nombre) {
        console.log(`hola ${nombre} ${final_de_frase}`)
    }
}

const saludoArgentino = crear_saludo('che')
const saludoMexicano = crear_saludo('wey')
const saludoColombiano= crear_saludo('parce')

saludoArgentino('Jose')
saludoMexicano('Jose')
saludoColombiano('Jose')
```

## 1.9 Cambiando el Contexto de una funcion

El contexto (o alcance) de una función es por lo general, window. Así
que en ciertos casos, cuando intentamos referirnos a this en alguna
parte del código, es posible que tengamos un comportamiento inesperado,
porque el contexto quizás no sea el que esperamos.

Existen al menos tres maneras de cambiar el contexto de una función.

-   Usando el método .bind, enviamos la referencia a la función sin
    ejecutarla, pasando el contexto como parámetro.
-   Usando el método .call, ejecutamos inmediatamente la función con el
    contexto indicado
-   Usando el método .apply, es similar a .call pero los parámetros
    adicionales se pasan como un arreglo de valores

## 1.10 Casos especiales donde se debe usar punto y coma

El punto y coma es opcional en JavaScript, excepto en algunos casos:

-   Cuando usamos varias instrucciones en una mísma línea
-   Al comenzar la próxima línea con un array
-   Al comenzar la próxima línea con un template string
## ¿Cómo ejecutar una función al cargar un script?

Cuando queremos ejecutar una función una vez que se haya cargado una librería de terceros.

```javascript
window.addEventListener('load', checkJSLoaded)

function checkJSLoaded() {
    let script = document.createElement('script');
    
    script.addEventListener('load', (event) => {
        console.log('<third-party-library>.js was loaded');
    });
    script.src = '<third-party-library>.js';
    document.body.appendChild(script);
}
```