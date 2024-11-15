# Typescript

Es un superconjunto tipado de javascript, que compila a javascript.

-   Lenguaje de programación tipado
-   Lenguaje de alto nivel
-   Genera como resultado código JavaScript
-   Código abierto.
-   Desarrollo desde cualquier sistema.

Previene cerca del 15% de los bugs según un [estudio
científico](http://earlbarr.com/publications/typestudy.pdf)

## Instalación de herramientas

Typescript requiere Nodejs para su funcionamiento

### Compilador de Typescript tsc

``` bash
npm install -g typescript
```

## Uso del compilador

El compilador creará un archivo js de salida usando un archivo ts de
entrada

``` bash
tsc hello.ts
```

La opción --watch vigilará el archivo y escuchará por cambios en el
archivo

``` bash
tsc --watch hello.ts
```

## Archivo de configuración

Nos permite especificar la raiz de nuestro proyecto. Así como diferentes
opciones para el compilador

Podemos crear un archivo de configuración usando la opción --init

``` bash
tsc --init
```

Algunos valores tales como el ECMA script al que compila, que carpetas
incluir, cuales excluir, así como directorios y archivos de salida.

``` bash
{
    "compilerOptions": {
        "target": "es5",
        "module": "commonjs",
        "strict": true,
        "removeComments": true,
        "outFile": "./",                       
        "outDir": "./",                        
        "rootDir": "./",    
    },
    "include": [],
    "exclude": [
        "node_modules"    
    ]
}
```

Una vez creado el archivo de configuración podemos ejecutar tsc y el
compilador buscará el archivo de configuración.

``` bash
tsc
```

## Tipado

Typescript requiere que se especifique el tipo de dato

``` bash
nombreDeVariable: tipoDeVariable
```

En el caso de const debemos declararla y asignarla al mismo tiempo

``` javascript
const nombreDeVariable: tipoDeVariable = valor
```

En el caso de let podemos declararla únicamente

``` javascript
let nombreDeVariable: tipoDeVariable
```

### Tipos de datos

Los tipos de datos disponbiles para asginar son los siguientes. Deben de
colocarse en minúsculas

-   Number
-   Boolean
-   String
-   Array
-   Tuple
-   Enum
-   Any
-   Void
-   Null
-   Undefined
-   Never
-   Object
-   Awaited

#### Number

Soporta enteros, flotantes, hexadecimales (0x), binario (0b)

#### Boolean

Recibe true o false

#### String

Cadenas de texto con comillas simples o dobles así como template strings
usando backticks.

#### Any

Ideal para *valores dinámicos o valores que cambian con el paso del
tiempo*; API, librerías de terceros. Debe usarse como último recurso.
**Si no especificamos un tipo el compilador asignará any de manera
automática.**

#### Void

Si any es cualquier tipo, entonces void es la ausencia de tipo. Se
utiliza en la declaración de funciones, en el caso de que no retornen
nada

#### Never

Representa a funciones que tiran excepciones o nunca retornan un valor.
La diferencia entre void y never es que la primera termina su código
pero no retorna datos, mientras que la segunda no termina y, por lo
tanto, nunca retorna.

#### Null

Cuando queremos asignar un valor a null.

``` javascript
let nullVariable: null;
nullVariable = null;
```

#### Undefined

``` javascript
let undefinedVariable: undefined 
```

La opción strictNullChecks, desactivada por default, en el archivo de
configuración *tsconfig.json*, permite asignar null y undefined a un
variable de tipo any o sus tipos respectivos.

#### unknown

El tipo desconocido, ideal para garantizar manejar tipos desconocidos, como los que obtendrías de respuesta de una API.
Este tipo requiere que se revise explícitamente el tipo

``` typescript
let response: unknown
if typeof response === "function" {}
if typeof response === ...
if response instanceof Date ...
// ...
```

#### object

Escrito object, con minúsculas. Representa un dato con un valor que no
es primitivo (string, number, boolean, undefined, any, undefined). No se
puede acceder a las propiedades del objeto.

``` javascript
let state: object 
state = {id: 1, ...}

console.log(state.id) // Error del compilador.
```

#### Object (Con mayúscula inicial)

Object, con mayúscula inicial. Es una instancia de la clase Object de
Javascript

``` javascript
const myObj = {
    id: 1,
};
const isInstance = myObj instanceof Object; 
console.log(myObj.id) // Correcto
```

#### Array

Para especificar un array uniform colocamos el tipo de datos seguido de
corchetes.

``` javascript
let list: string[]
list = ['string1', 'string2', 'string3']
```

No podemos asignar tipos de datos distintos del que especificamos

``` javascript
list = [1, false, 'string'] // Error del compilador.
```

De igual manera podemos optar por una notación alternativa

``` javascript
const months: Array<string> = ["Enero", "Febrero"];
```

Esta última notación es muy popular cuando se usan hooks en React

``` javascript
export const getStaticProps: GetStaticProps<HomeProps|null> = async () => {}
```

#### Tuplas

Para especificar tuplas asignamos cada valor individualmente. Los tipos
deben ser diferentes para cada una de las posiciones.

``` javascript
let user: [number, string]
```

También podemos hacer un arreglo de tuplas

``` javascript
let user: [number, string][]
```

#### Enum

Ideales para valores limitados, tales como colores, paises, opciones.

``` javascript
enum DiasLaborales = {
  Lunes = 'Mon',
  Martes = 'Tue',
  Miercoles = 'Wed',
  Jueves = 'Thu',
  Viernes = 'Fri'
}
```

Para usarlos asignamos el nombre del enum y accedemos a su propiedad.

``` javascript
const dia: DiasLaborales = DiasLaborales.Lunes
```

#### Union de tipos

Se pueden unir tipos usando el caracter pipe "\|". En el ejemplo
siguiente la variable aceptará valores tanto number como string.

``` javascript
let idUser: number | string
```

#### Promesas

Awaited nos retorna el tipo que retornan las promesas

``` javascript
type A = Awaited<Promise<string>>
```

En este caso será string.

### ReturnType

Nos da el tipo que retorna una función

``` javascript
type A = ReturnType<typeof function>
```

#### Parameters

Devuelve el tipo de los parámetros, se le puede particionar como si fuera una lista

``` javascript
type A = Parameters<ReturnType<typeof function>>[0]
```

#### NonNullable

Remueve los tipos nullos como undefined o null de la respuesta

``` javascript
type A = NonNullable<Parameters<typeof function>[0]>
```

## Alias de tipos

Los tipos se crearán usando la palabra type

``` javascript
type idUser = number | string
let username: idUser
```

También podemos especificar con texto

``` javascript
type dimensionesAceptadas = '100 x 100' | '200 x 200'
let dimension: dimensionesAceptadas = '200 x 200'
```

## Aserciones de tipo

Para hacerlo colocamos el tipo dentro de los simbolos de mayor que y
menor que.

Esto nos permite decirle al compilador que confie en lo que le
indicamos, nos permite usar métodos de un tipo de dato.

``` javascript
let message: string = (<string>username).length >5 ? '':''
```

Existe otra sintaxis a usar, la cual es usar la palabra "as"

``` javascript
let message = (username as string).length >5 ? '': ''
```

Se puede forzar la sintaxis "as" modificando el archivo de configuración

``` javascript
{
  rules: {
      "no-angle-bracket-type-assertion": true
        }
}
```

Es recomendable usar la sintaxis "as" para evitar ambigüedades en
archivos jsx.

## Funciones

Debemos especificar el tipo de los argumentos que recibirá una función.

``` javascript
type sizes = '100x100' | '400x400' | '800x800'

function uploadImage(url: string, dimensions: sizes){

}
```

Podemos especificar el tipo de retorno de la función colocándolo después
de los argumentos.

``` javascript
const uploadImg = (url: string, dimensions: sizes): object => return {url, dimensions, sizes}
```

``` javascript
const handleUploadError = (code: number, message: string): never | string =>{
if(message === 'MAX SIZE'){
    throw new Error("File too large")
}else{
    return 'Something went wrong'
}
}
```

## Interfaces

Las interfaces son una forma de definir la estructura de un objeto en
POO. Anteriormente los types eran mucho más limitados que las
interfaces, pero actualmente son bastante equivalentes en su mayoría.

``` javascript
interface Sale {
    total: number;
    date: string;
    productIds: number[];
}
```

Ahora podemos usarlo en una función o donde queramos

``` javascript
function(sale: Sale){...}
```

### Extendibilidad

Difieren con los tipos en que pueden extenderse, además puedes
duplicarlas y el compilador mezclará sus propiedades. Las interfaces
trabajan mejor con objetos y métodos, los types son mejor para funciones
o tipos complejos.

``` javascript
interface Song {
  artistName: string;
};

interface Song {
  songName: string;
};

const song: Song = {
  artistName: "Freddie",
  songName: "The Chain"
};
```

### Recomendaciones de interfaces

Siempre usa las interfaces para la definición de API's públicas, le
permitará a los consumidores extenderlas si faltan algunas definiciones.

Considera usar types para los props de tus componentes de react y el
estado, por consistencia.

### Atributos opcionales

Podemos definir atributos opcionales colocando el símbolo de
interrogación tras el nombre de la variable.

``` javascript
interface Sale {
     total: number;
     date: string;
     productIds: number[];
     discount?: number;
 }
```

### Atributos de solo lectura

Para especificar atributos de solo lectura usamos la palabra reservada
readonly antes del nombre del atributo.

``` javascript
interface Sale {
    readonly total: number;
    date: string;
    productIds: number[];
    discount?: number;
}
```

### Extension de interfaces

Podemos extender las interfaces, como si se tratara de herencia de
clases en POO.

``` javascript
interface Person {
    name: string;
    lastName: string;
}

interface Avatar extends Person {
    username: string;
}
```

## Clases

Para las clases debemos declarar previamente las variables en el cuerpo,
el contructor debe contener así mismo el tipo de dato de las variables.

``` javascript
class Picture {
    id: number;
    description: string;
    size: number;
    tags: Tag[];

    constructor(id:number, description: string, size: number, tags: Tag[]){
      this.id = id;
      this.description = description;
      this.size = number;
      this.tags = tags;
    }
}
```

### Clases miembros públicos

Todas las variables son públicas por defecto. Sin embargo podemos
especificarlo de manera explícita.

``` javascript
class Picture {
    public id: number;
    public description: string;
    public size: number;
    public tags: Tag[];

    public constructor(id:number, description: string, size: number, tags: Tag[]){
      this.id = id;
      this.description = description;
      this.size = number;
      this.tags = tags;
    }
}
```

### Clases miembros privados

Los miembros privados de una clase se especifican usando la variable
private.

``` javascript
class Picture {
    private id: number;
    private description: string;
    private size: number;
    private tags: Tag[];

    public constructor(id:number, description: string, size: number, tags: Tag[]){
      this.id = id;
      this.description = description;
      this.size = size;
      this.tags = tags;
    }
}
```

Es bastante obvio, pero lo especificaré de todas maneras, si el
constructor se cambia a método privado será imposible crear nuevos
objetos.

Typescript nos mostrará un error si intentamos acceder a propiedades
privadas de manera directa.

``` javascript
console.log(picture.id) // Error del compilador
```

#### Sintaxis alternativa

Podemos declarar elementos privados usando el caracter hashtag antes del
nombre del atributo.

``` javascript
class Picture {
    #id: number;
    #description: string;
    #size: number;
    #tags: Tag[];

    public constructor(id:number, description: string, size: number, tags: Tag[]){
      this.#id = id;
      this.#description = description;
      this.#size = size;
      this.#tags = tags;
    }
}
```

Para usar esta notación es necesario tener activadas las opciones del
compilador para ES6 en el archivo *tsconfig.json*.

``` javascript
"compilerOptions": {
    "target": "es6"
}
```

### Métodos get y set

Métodos que permiten controlar el acceso a cada miembro.

El compilador nos dará un error si tenemos una función con el mismo
nombre de una propiedad, por lo que deberemos cambiar el nombre de las
propiedades

``` javascript
class Picture {
    private _id: number;
    private _description: string;
    private _size: number;
    private _tags: Tag[];

    public constructor(id:number, description: string, size: number, tags: Tag[]){
      this._id = id;
      this._description = description;
      this._size = size;
      this._tags = tags;
    }

    get id(){
      return this._id
    }

    set id(id: number){
      this._id = id
    }
}
```

Ahora, en lugar de leer los valores typescript hará un llamado a las
funciones correspondientes. Por lo que si intentamos acceder
directamente en nuestro código **no** nos saltará un error.

``` javascript
picture.id = 100 
//Llamado a la función set id() con el parámetro 100
console.log(picture.id)
//Llamado a la función get id() sin parámetro
```

## Herencia de clases y propiedades estáticas

### Atributos protected

Este tipo de atributo en una clase padre, permite que sus clases hijas
puedan acceder a los atributos asignados.

``` javascript
protected _id: number;
```

### Método super

Para invocar al constructor de una super clase usamos la función super.
De esta manera nos aseguramos de que se ejecute el constructor de la
clase super

``` javascript
constructor(id:number, description: string){
    super(id, description)
}
```

### Herencia

Para crear una clase hija usamos la palabra reservada extends

``` javascript
class Dog extends Animal{
...    
}
```

### Clases abstractas

Una clase abstracta es aquella que no queremos instanciar, pero que
queremos usar para que otras clases deriven de ella

``` javascript
abstract class Animal{
...    
}
```

### Atributos estáticos

``` javascript
static modified: boolean;
```

A través de la palabra reservada **static** se puede definir un miembro
visible únicamente a nivel de clase

## Generics

Los generics son marcadores de posición para tipos. La forma más simple
de un generic es esta:

``` javascript
function identity<Type>(a: Type): Type {
   return a;
}
```

La cual simplemente acepta un argumento de un tipo y retorna un valor
del mismo tipo.

``` javascript
const variableString = identity<string>("I'm a string")
const variableBoolean = identity<boolean>("string") //  Error porque "string" no es un booleano
```

Lo que nos permite crear genéricos que acepten cualquier tipo de
valores.

``` javascript
type GenericProps<GenericValue> = {
   list: GenericValue[];
   onChange: (element: GenericValue) => void;
};
```

Pero ahora tendremos que si en el código accedemos a una propiedad de
nuestro genericValue, typescript nos dará un error porque no estamos
especificando que nuestro *GenericValue* cuente con esa propiedad

``` javascript
<Componente>{props.algo.id}</Componente>
```

Podemos crear una base que extienda de nuestro valor genérico y usarla.

``` javascript
type Base = {
   id: string;
   title?: string;
}

export const GenericComponent = <GenericValue extends Base>(props: GenericProps<GenericValue>) => {}
```

## keyof

La palabra keyof toma un objeto y devuelve un *union* de sus keys

``` javascript
type Videojuego = {
   id: string;
   titulo: string;
   descripcion: string;
}

type VideojuegoKeys = keyof Videojuego;
```

*VideojuegoKeys* será igual a la unión *"id" \| "titulo" \|
"descripcion"*

## Type Guard

Es una condicional en la que nos aseguramos de que el tipo de un valor
sea uno en especifico, para poder devolver el tipo correcto.

``` javascript
const getStringFromValueOrId = <GenericValue extends Base>(value: GenericValue) => {
if (typeof value === 'string') {
   return value;
}
return value.id;
};
```

## const assertion

Un const assertion se refiere a tratar un elemento como si fuera una
constante. Es decir, no podrán modificarse, ni ampliarse y serán de solo
lectura, para declararlo pasamos las palabras *as const*.

``` javascript
let arrayConstante = ["Videojuego", "Film"] as const;
```

Además, cualquier comprobación de un elemento que no se encuentre en la
declaración de este tipo hará que typescript nos devuelva un error.

``` javascript
// El bloque de abajo devolverá un error
arrayConstante.forEach(element => {
   if (element === 'Libro') console.log(element)
})
```

Exceptuando archivos *.tsx* la notación con brackets está permitida

``` javascript
let arrayConstante = <const>["Videojuego", "Film"];
```

## typeof

El operador *typeof* funciona igual que el de javascript, pero con
types, en lugar de con valores.

``` javascript
const opciones = ['Videojuegos', 'Peliculas', 'Libros'];
type Opciones = typeof opciones; // Opciones será un array de strings: string[];

const opciones = ['Videojuegos', 'Peliculas', 'Libros'] as const;
type Opciones = typeof opciones; // Opciones será ['Videojuegos' | 'Peliculas' | 'Libros'];
```

## Indexed access type

Lo usamos cuando queremos declarar un type usando el subtype de un type
en particular.

``` javascript
type Videojuego = { 
   lanzamiento: number; 
   titulo: string; 
   disponible: boolean 
};
type Lanzamiento = Videojuego["lanzamiento"];
```

En el ejemplo de abajo Lanzamiento será de tipo *number*

Si tenemos un array y le pasamos la palabra *number* nos devolverá el
tipo correespondiente al elemento del array.

``` javascript
const MyArray = [
   { title: "Nier", lanzamiento: 2018 },
   { title: "Twister Metal", lanzamiento: 1991 },
   { title: "Subahibi", lanzamiento: 2007 },
];

type OtroVideojuego = typeof MyArray[number];
```

## Buenas prácticas

Es mejor dividir el código en archivos y/o carpetas para dejar una única
responsabilidad a cada archivo. Una vez separados podemos llamarlos por
medio de importaciones.

## Resolución de modulos

Al importar un modulo en typescript el compilador puede seguir dos
estrategias: clasic o node. Estas estrategias le dirán la ruta que
seguirá al intentar importar un módulo. Podemos especificar el modulo
directo desde la consola.

``` javascript
tsc --moduleResolution node
tsc --moduleResolution classic
```

También podemos llevar a cabo la confifuración desde el archivo de
configuración.

``` javascript
"compilerOptions":{
  "moduleResolution": "node" || "classic",
  "traceResolution": true
}
```

### Estrategia clasic

En el import relativo el compilador buscará un archivo que termine en
.ts o .d.ts en la ruta actual.

En el import absoluto el compilador buscará un archivo que termine en
.ts o .d.ts primero en la ruta actual, después subirá un directorio
dentro de la estructura, si no lo encuentra volverá a subir un
directorio y repetirá el proceso.

### Estrategia node

En el import relativo el compilador buscará un archivo que termine en
.ts o .d.ts o **.tsx** en la carpeta actual. Así mismo podría buscar un
archivo llamado package.json, que incluya instrucciones para encontrar
la ruta, en una carpeta con el mismo nombre del modulo

``` javascript
typescript/app/module/package.json
```

En el import no relativo el compilador buscará un archivo que termine en
.ts o .d.ts o **.tsx**. Así mismo puede buscar un archivo llamado
package.json, que incluya instrucciones para encontrar la ruta, en una
carpeta del mismo nombre del modulo. Todo esto **dentro de la carpeta
node_modules**. Si no lo encuentra intentará subir un nivel.

## Webpack

Para usar webpack debemos inicializar un archivo de configuración de
node

``` bash
npm init
```

Así mismo debemos instalar webpack, webpackcli, ts-loader y typescript.
La opción --save-dev permitirá agregar las dependencias al archivo
*package.json*

``` bash
npm install webpack webpack-cli typescript ts-loader --save-dev
```

A continuación creamos nuestro archivo *webpack.config.json*. El archivo
debe contar con una propiedad llamada module y esta asi mismo una
llamada rules donde especifiquemos que use *ts-loader* para los archivos
que terminen en *.ts*. Es necesario excluir *node_modules* para que no
los incluya en el procesamiento.

``` javascript
module.exports = {
  mode: 'production',
  entry: './src/main.ts',
  devtool: 'inline-source-map',
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader',
        exclude: /node_modules/
      }
    ]
  }
  resolve: {
    extensions: ['.ts', '.js'],
  }
  output: {
    filename: 'bundle.js'
  }
}
```

Podemos agregar un script en el archivo *package.json*

``` javascript
"scripts": {
  "build": "webpack"
}
```

## Typescript para React

En React existen casos donde necesitamos especificar children como parte
de los props.

``` javascript
interface propsWithChildren {
   children: React.ReactNode
}

const funcion = ({children}: propsWithChildren) => {}
```

Existe también otra opción, que agrega un tipo implícito a React,
llamada React.FunctionComponent, o su abreviación llamada React.FC. Sin
embargo estos dos tipos no están bien vistos por parte de los
desarrolladores pues, al manejar datos implicitos, se consideran una
mala práctica que empeora la legibilidad del código.

``` javascript
// Incluso si no colocamos children, estará accesible para el código
const funcion: React.FC = ({children}) => {}
```

Para marcar el retorno de un elemento de JSX usamos el atributo Element
de JSX.

``` javascript
const funcion = ({children}: propsWithChildren): JSX.Element => {}
```

Los cambios en los input requieren el método ChangeEvent de react y
pasarle como parámetro un HTMLInputElement.

``` javascript
const handleChange = (event: React.ChangeEvent<HTMLInputElement>): void => {
    setEmail(event.target.value as string)
    setValidEmail(validateEmail(event.target.value as string))
}
```

## Distribución de paquetes

Si queremos incluir declaraciones de tipos en nuestros paquetes podemos
agregar la configuración del archivo en forma de *ts.config.json*,
además de uno o varios archivos de definiciones en el mismo nivel que
nuestros archivos.

Por ejemplo:

``` bash
<archivo>.js
<archivo>.d.ts
```

Estos archivos se pueden generar automáticamente por el compilador
cuando el flag "definitions" o "declaration", en *ts.config.json* es
igual a true.

El contenido del archivo con terminación d.ts serán las definiciones de
nuestros elementos

``` bash
export declare function <funcion>(argumento: type): type
```

## Utility types

TypeScript proporciona varios tipos de utilidades para facilitar las transformaciones de tipos comunes. Estas utilidades están disponibles globalmente. Solo he escrito las que considero las más importantes.

Para ver la lista completa visita [la documentación de typescript](https://www.typescriptlang.org/docs/handbook/utility-types.html)

### Awaited<Type>

Este tipo está pensado para modelar operaciones como await en funciones async, o el método .then() en Promises - específicamente, la forma en que recursivamente desenvuelven Promises.

``` typescript
type C = Awaited<boolean | Promise<number>>;
    
type C = number | boolean
```

### Pick<Type, Keys> 

Pick te permite crear un nuevo tipo eligiendo propiedades específicas (`Keys`) de un tipo existente (`Type`). Pick es útil para limitar los tipos a sólo las propiedades que nos son importantes

``` typescript
type NewType = Pick<Type, Keys>;

interface Person {
     name: string;
     age: number;
     gender: string;
     address: string;
}

type PersonDetails = Pick<Person, 'name' | 'age'>;

const person: PersonDetails = {
     name: 'John Doe',
     age: 39,
};
```

### Omit<Type, Keys>

Construye un tipo seleccionando todas las propiedades de Tipo y eliminando las Claves (literal de cadena o unión de literales de cadena). Lo contrario de Pick.

### Partial<Type>

Construye un tipo con todas las propiedades de Type establecidas como opcionales. Esta utilidad devolverá un tipo que representa todos los subconjuntos de un tipo dado.

### Required<Type>

Construye un tipo consistente en todas las propiedades de Type establecidas como requeridas. Lo contrario de Partial.

### ReturnType<Type>

Construye un tipo consistente en el tipo de retorno de la función Tipo.