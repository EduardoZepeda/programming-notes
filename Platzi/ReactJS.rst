=====
React
=====

React cumple su función como biblioteca ya que para utilizar su código
se debe importar. También es un Framework aunque las convenciones de
cómo debe ser organizado todo no son estrictas.

React está estructurado por componentes que son como pequeños bloques de
lego que al ser unidos forman aplicaciones de React. Estos componentes
pueden tener estilos, ser enlazados a eventos y sus estados pueden ser
modificados.

ReactDOM
========

React y ReactDOM trabajarán en conjunto.

-  React como análogo a createElement
-  ReactDOM a appendChild

ReactDOM.render(que, donde) toma dos argumentos: Qué queremos renderizar
y dónde lo queremos renderizar.

Siempre que escribas JSX es requisito importar React.

Creando una app con Create-react-app
====================================

Create-react-app es una aplicación moderna que se usa desde una línea de
comando. Antes de ella se configuraba todo el entorno manualmente lo
cual tomaba mucho tiempo.

Pasos para obtenerlo: Se debe instalar desde la línea de comando usando

.. code:: bash

   npm install create-react-app

Nota: create-react-app *YA NO* da soporte para poder instalarlo de
manera global

Una vez instalado se crea la carpeta del proyecto con

.. code:: bash

   create-react-app nombre del proyecto

En este punto se estará instalando React y otras herramientas, también
se configurará el entorno usando Webpack.

Una vez se instala todo entra a la carpeta src donde estará todo el
código fuente de la aplicación, siendo el más importante index.js que es
el punto de entrada a la aplicación.

Finalmente para correr la aplicación se usa el comando

.. code:: bash

   npm run start

.. _reactdom-1:

ReactDOM
========

ReactDOM.render() toma dos argumentos: Qué queremos renderizar y dónde
lo queremos renderizar.

Siempre que escribas JSX es requisito importar React.

JSX
===

JSX es una extensión de JavaScript creada por Facebook para el uso con
la biblioteca React. Sirve de preprocesador (como Sass o Stylus a CSS) y
transforma el código generado con React a JavaScript.

JSX tiene su alternativa que es React.createElement pero es preferible
JSX porque es mucho más legible y expresivo. Ambos tienen el mismo poder
y la misma capacidad.

React.createElement recibe 3 argumentos:

El tipo de elemento que estamos creando sus atributos o props y el
children que es el contenido.

Componentes
===========

Los componentes en React son bloques de construcción.

No hay que confundir un elemento con un componente. Un elemento es a un
objeto como un componente es a una clase.

Es una buena práctica que los componentes vivan en su propio archivo y
para ello se les crea una carpeta.

Todos los componentes requieren por lo menos el método render que define
cuál será el resultado que aparecerá en pantalla.

El source de las imágenes en React puede contener direcciones en la web
o se le puede hacer una referencia directa importándola. Si se importa
deben usarse llaves para que sea evaluado.

Estilos
=======

Cómo aplicar estilos Para los estilos crearemos una carpeta llamada
Styles y allí vivirán todos los archivos de estilos que tienen que ver
con los componentes. Para usar los estilos es necesario importarlos con
import React funciona ligeramente diferente y para los atributos de
clases **no se utiliza class sino className** Es posible utilizar
Bootstrap con React, sólo debe ser instalado con npm install bootstrap y
debe ser importado en el index.js Existen estilos que son usados de
manera global o en varios componentes, así que deben ser importados en
el index.js

Props
=====

Los props que es la forma corta de properties son argumentos de una
función y en este caso serán los atributos de nuestro componente como
class, src, etc.

Estos props salen de una variable de la clase que se llama this.props y
los valores son asignados directamente en el ReactDOM.render()

.. code:: javascript

   reactDOM.render(<badge firstName="Alan" lastName="Turing" />, container)

Estos props se leerian así:

   this.props.firstName this.props.lastName

Enlazando eventos
=================

React dispone de eventos. Cada vez que se recibe información en un input
se obtiene un evento onChange y se maneja con un método de la clase
this.handleChange

.. code:: javascript

   <input onChange={this.handleChange}/>

   ...

   class BadgeForm extends React.Component{
   handleChange = e => {
       console.log(e)    
       }
   ...
   }

Los elementos button también tienen un evento que es onClick.

Cuando hay un botón dentro de un formulario, este automáticamente será
de tipo submit. Si no queremos que pase así hay dos maneras de evitarlo:
especificando que su valor es de tipo button o manejándolo desde el
formulario cuando ocurre el evento onSubmit.

Manejo de estado
================

Hasta esta clase todos los componentes han obtenido su información a
través de props que vienen desde afuera (otros componentes) pero hay
otra manera en la que los componentes pueden producir su propia
información y guardarla para ser consumida o pasada a otros componentes
a través de sus props. La clave está en que la información del state a
otros componentes pasará en una sola dirección y podrá ser consumida
pero no modificada.

Para guardar la información en el estado se usa una función de la clase
component llamada setState a la cual se le debe pasar un objeto con la
información que se quiere guardar.

.. code:: javascript

   this.setState({
       [e.target.name]: e.target.value,
   })

Aunque no se ve, la información está siendo guardada en dos sitios. Cada
input guarda su propio valor y al tiempo la está guardando en setState,
lo cual no es ideal. Para solucionarlo hay que modificar los inputs de
un estado de no controlados a controlados.

.. code:: javascript

   value = {this.state.valueOfInput}

Si los colocamos nada más así nos sacará un error, hay que inicializar
el estado

.. code:: javascript

   state = {}

Introducción a React Router
===========================

Las aplicaciones que se trabajan en React son llamadas single page apps.
Esto es posible gracias a React Router que es una librería Open Source.
React Router (v4): Nos da las herramientas para poder hacer SPA
fácilmente. Usaremos 4 componentes:

   -  BrowserRouter: es un componente que debe estar siempre lo más
      arriba de la aplicación. Todo lo que esté adentro funcionará como
      una SPA.
   -  Route: Cuando hay un match con el path, se hace render del
      component. El component va a recibir tres props: match, history,
      location.
   -  Switch: Dentro de Switch solamente van elementos de Route. Switch
      se asegura que solamente un Route se renderize.
   -  Link: Toma el lugar del elemento <a>, evita que se recargue la
      página completamente y actualiza la URL.

Divison de la aplicación en rutas
---------------------------------

Tenemos que importar los componentes, dentro de BrowserRouter solo debe
haber un elemento child, esto se soluciona metiendolos en un Switch, que
solo permitirá que se ejecute una sola ruta. El prefijo exact permite
que se muestre el componente solo si la ruta coincide al 100%

.. code:: javascript

   import { BrowserRouter, Route, Switch } from 'react-router-dom'

   function App(){
       return (
           <BrowserRouter>
               <Switch>
                   <Route exact path="/badges" component = {Badges} />
                   <Route exact path="/badges/new" component = {BadgeNew} />
               <Switch>
           </BrowserRouter>  

       )
   }

Es necesario sustituir todos los elementos a por Link, para evitar la
recarga completa de la página

.. code:: javascript

   import { Link } from 'react-router-dom'

   <Link to="ruta/ruta">

Páginas 404
-----------

Esta es un ejemplo de como crear un 404

.. code:: javascript

   import { Redirect, Route } from "react-router-dom";

   <Route path="/404" component={MiComponente404} />
   <Redirect from="*" to="/404" />

Obtención de parametros de rutas
--------------------------------

Los parametros de las rutas pueden obtenerse cuando estamos usando React
Router de la siguiente manera

.. code:: javascript

   this.props.match.params.parametroAObtener

Ciclo de vida de un componentes
===============================

Cuando React renderiza los componentes decimos que entran en escena,
cuando su estado cambia o recibe unos props diferentes se actualizan y
cuando cambiamos de página se dice que se desmontan.

Montaje:
--------

Representa el momento donde se inserta el código del componente en el
DOM. Se llaman tres métodos: constructor, render, componentDidMount.

Actualización:
--------------

Ocurre cuando los props o el estado del componente cambian. Se llaman
dos métodos: render, componentDidUpdate.

Desmontaje:
-----------

Nos da la oportunidad de hacer limpieza de nuestro componente. Se llama
un método: componentWillUnmount.

React.Fragment
==============

React.Fragment es la herramienta que te ayudará a renderizar varios
componentes y/o elementos sin necesidad de colocar un div o cualquier
otro elemento de HTML para renderizar sus hijos. Al usar esta
característica de React podremos renderizar un código más limpio y
legible, ya que React.Fragment no se renderiza en el navegador.

.. code:: javascript

   render(
       <React.Fragment>
           ...
       </React.Fragment>
   )

Portales
========

Hay momentos en los que queremos renderizar un modal, un tooltip, etc.
Esto puede volverse algo complicado ya sea por la presencia de un
z-index o un overflow hidden.

En estos casos lo ideal será renderizar en un nodo completamente aparte
y para esto React tiene una herramienta llamada Portales que funcionan
parecido a ReactDOM.render; se les dice qué se desea renderizar y dónde,
con la diferencia de que ese dónde puede ser fuera de la aplicación.

Hooks
=====

Las funciones no tienen un estado propio que manejar como ciclos de vida
a los que deben suscribirse, mientras tanto las clases sí cuentan con
ello.

Los hooks, disponibles desde la versión 16.8.0 en React, son una nueva
característica de la librería que nos permite tener estado en nuestros
componentes funcionalidades como manejo de estado y ciclo de vida que
anteriormente eran únicos de los class components.

Hooks: Permiten a los componentes funcionales tener características que
solo las clases tienen:

-  useState: Para manejo de estado.
-  useEffect: Para suscribir el componente a su ciclo de vida.
-  useReducer: Ejecutar un efecto basado en una acción.

Custom Hooks: Usamos los hooks fundamentales para crear nuevos hooks
custom. Estos hooks irán en su propia función y su nombre debe comenzar
con la palabra use. Otra de sus características es que no pueden ser
ejecutados condicionalmente (if).

useState regresa un arreglo de dos argumentos.

UseState
--------

UseState es el reemplazo de state en los componentes de React. El método
useState nos provee de dos elementos; el primero, es el valor del
estado; el segundo, es una función para especificar el valor que
querramos que tenga nuestro estado. Así mismo podremos especificar un
valor por defecto para el primer valor, el cual pasaremos como parámetro
a la función useState. Los métodos que nos devuelve useState pueden
tomar cualquier nombre que nosotros especifiquemos.

.. code:: javascript

   import { useState } from 'react'

   const [value, setValue] = useState([])

Para especificar un valor solo usamos setValue

.. code:: javascript

   setValue("Nuevo valor")

Al tomar el nuevo valor se llevará acabo un renderizado del componente.

UseEffect
---------

UseEffect viene a dotar a las funciones de los mismos ciclos de vida que
tiene un componente. useEffect() se ejecutará cada vez que un componente
se renderiza.

.. code:: javascript

   import { useEffect } from 'react'

   useEffect(()=>{
       console.log("Montado o actualizado")    
   })

Como useEffect() se ejecuta cuando hay una actualización o una montura
de un componente, podemos generar memory leaks al usar listeners o
timeOuts. Es por esto que useEffect() ejecutará cualquier funcion que se
retorne de esta misma

.. code:: javascript

   useEffect(() => {
       return(()=> removeEventListener())
     })   

Hay que ser cuidadosos al colocar funciones que modifiquen el estado en
el hook useEffect(), puesto que podemos caer en un loop infinito

.. code:: javascript

   useEffect(() => {
       fetch(`https://api.com/api/${name}`)
         .then(res => res.json())
         .then(ourName => {
           setValueInState(ourName)
         })
     })   

UseEffect() puede recibir un segundo parámetro, mientras el parámetro
que le pasemos no cambie, useEffect() no se ejecutará nuevamente.

.. code:: javascript

   useEffect(() => {
       fetch(`https://api.com/api/${name}`)
         .then(res => res.json())
         .then(ourName => {
           setValueInState(ourName)
         })
     }, [name]) 

Si optamos por pasarle una lista vacia como parámetro useEffect() solo
se ejecutará al montarse o desmontarse nuestro componente.

.. code:: javascript

   useEffect(() => {
       fetch(`https://api.com/api/${name}`)
         .then(res => res.json())
         .then(ourName => {
           setValueInState(ourName)
         })
     }, [name]) 

useContext
----------

useContext sirve para especificar un contexto en común para todos los
componentes y evitar tener que pasar props de un componente a otro. Muy
parecido a lo que hace redux.

.. code:: javascript

   const UserContext = React.createContext();
   // Creamos un contexto

   function App() {
     // Creamos un estado
     const [user] = React.useState({ name: "Fred" });

     return (
       {/* Necesitamos envolver al componente padre con un Provider */}
       {/* Le asignamos un el valor user que creamos con useState */}
       <UserContext.Provider value={user}>
         <Main />
       </UserContext.Provider>
     );
   }

   const Main = () => (
     <>
       <Header />
       <div>Main app content...</div>
     </>
   );

Para consumir el contenido necesitamos envolverlo dentro de un contexto.

.. code:: javascript

   // Ahora especificamos donde queremos consumir el valor
   // Nota que estamos envolviendo esto en una función que generará el componente
   // para tener acceso al objeto user como parámetro de la función
   const Header = () => (

     <UserContext.Consumer>
       {user => <header>Welcome, {user.name}!</header>}
     </UserContext.Consumer>
   );

La función useContext puede simplificar la sintaxis de los componentes.

.. code:: javascript

   const Header = () => {
     // Le pasamos el objecto que creamos con createContext
     const user = React.useContext(UserContext);
     // Y removemos las etiquetas UserContext.Consumer
     return <header>Welcome, {user.name}!</header>;
   };

useCallback
===========

useCallback es un hook de React que se encarga de memoizar las funciones
y que no se rerenderizen al montarse los components. Es muy útil cuando
se transfieren funciones a componentes hijos.

La función useCallback acepta dos argumentos y retorna una función. El
primer argumento es la función a memoizar y el segundo, al igual que
useEffect, es una variable a vigilar, de manera que React no genere una
nueva función mientras esa variable no cambie. Al igual que con
useEffect también podemos dejar el array vacio, en lugar de value.

.. code:: javascript

   import { useCallback } from 'react'

   const MyComponent = ({prop}) => {
     const callback = () => {
       return 'Result'
     };
     const memoizedCallback = useCallback(callback, [prop])
     return <ChildComponent callback={memoizedCallback} />
   }

useMemo
=======

Esta función es un hook de React que sirve para memoizar el valor que
devuelve una función. La función useMemo acepta dos argumentos y retorna
un valor. El primer argumento es la función y el segundo, al igual que
useCallback, es una variable a vigilar, de manera que no se generará un
nuevo valor mientras esa variable no cambie.

.. code:: javascript

   import { useMemo } from 'react'

   // Ideal para funciones costosas de ejecutar, como factoriales o cálculos complejos
   const OtherComponent({value}) => {
     const memoizedValue = useMemo(()=>getExpensiveValue(value), [value])
     return <div>...</div>
   }

Memo
====

Memo **no es un hook**, es un High Order Component (HOC), es decir una
función que toma un componente como parámetro y retorna un nuevo
componente.

Memo revisa si los props del componente que recibe han cambiado, si no
lo han hecho, devolverá el componente memoizado, sin renderizarlo.

.. code:: javascript

   import { memo } from 'react'

   const MyComponent = ({id, title}) => {
       return <div>{id}{title}</div>
   }

   export default memo(MyComponent)

Memo es ideal para componentes que:

   -  Sufren múltiples renderizaciones con el uso de la aplicación y que
      generalmente reciben los mismos props.
   -  Reciben props que cambian con poca frecuencia o simplemente no
      cambian.
   -  Componentes muy voluminosos que tienen un impacto muy grande en el
      rendimiento.

Reducers
========

Los reducers se encargan de tomar un estado previo y una acción y
devolver un objeto actualizado. Generalmente toman la forma de un
switch. Así mismo también son la opción usada por Redux. Podemos usar
los reducers con la función useReducer de React para manejar el estado
de nuestra aplicación. Así mismo podemos combinarlos con useContext para
manejar la información y pasarla a través de nuestros componentes.

.. code:: javascript

   const initialState = { username: "", isAuth: false };

   function reducer(state, action) {
     switch (action.type) {
       case "LOGIN":
         return { username: action.payload.username, isAuth: true };
       case "SIGNOUT":
         // could also spread in initialState here
         return { username: "", isAuth: false };
       default:
         return state;
     }
   }

Ya que tenemos el reducer necesitamos pasarle una acción. Le pasaremos
la acción por medio de una funcion llamada dispatch que nos provee el
método useReducer de React

.. code:: javascript

   function App() {
     // useReducer requiere una función y un estado inicial para funcionar
     const [state, dispatch] = useReducer(reducer, initialState);
     // Tendremos el estado obtenido en el objeto state

     // useReducer nos provee una función llamada dispatch, esta función recibe un parámetro
     // el parámetro es el action que interactuará con el switch del reducer
     function handleLogin() {
       dispatch({ type: "LOGIN", payload: { username: "Ted" } });
     }

     function handleSignout() {
       dispatch({ type: "SIGNOUT" });
     }

     return (
       <>
         Current user: {state.username}, isAuthenticated: {state.isAuth}
         <button onClick={handleLogin}>Login</button>
         <button onClick={handleSignout}>Signout</button>
       </>
     );
   }

Deploy
======

Para hostear una aplicación de node y que esta se mantenga activa
incluso si se presentan errores podemos usar pm2 o forever.

.. code:: bash

   pm2 start npm --name "Mi aplicación" -- run serve -- --port 3001

Esta será accesible y podemos vincularla a un gestor de servicios como
systemd
