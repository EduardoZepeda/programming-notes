============
React Router
============

Las dependencias son

.. code:: bash

   npm install react-router react-router-dom --save

BrowserRouter
=============

El primer componente que debemos ver a fondo y manipular será el
BrowserRouter, este enrutador cuenta con diferentes propiedades (props)
para ser configurado:

-  basename: configura la url base de todas las rutas.
-  getUserConfirmation: recibe una función con la cual puedes validar si
   el usuario quiere dejar la pagina en la que se encuentra.
-  forceRefresh: es un booleano, como su nombre lo indica en caso de ser
   verdadero se forzará a que el navegador recargue cuando se navegue.
-  keyLength: un key es el id único que recibe cada movimiento en la
   navegación, keyLength se encarga de configurar la longitud de cada
   key y por defecto tiene una longitud de 6 caracteres.
-  children: es lo que estará dentro de nuestro BrowserRouter.

Podemos importarlo de

.. code:: javascript

   import { BrowserRouter } from 'react-router-dom' 

Tipos de Enrutadores
====================

React Router es una librería más que añadimos a nuestro stack, lo más
básico que debemos aprender de React Router son sus distintos
enrutadores:

-  BrowserRouter: Es el enrutador que quizá más tiempo utilices como
   frontend, usa el HTML5 history API lo que quiere decir que es el
   enrutador que nos da la posibilidad de cambiar las rutas en el
   navegador.
-  HashRouter: Funciona similar al BrowserRouter, pero usa un hash (#)
   al inicio de cada url.
-  MemoryRouter: Mantiene el historial de búsqueda en memoria y te sirve
   para realizar pruebas sin navegador. En este curso no haremos pruebas
   unitarias por lo tanto no veremos este enrutador.
-  StaticRouter: Nunca cambia de dirección, es perfecto para realizar
   Server Side Render.
-  NativeRouter: Es el router que nos servirá si queremos usar React
   Native, NO lo veremos en este curso. Es recomendable usar en su lugar
   React Navigation.

Link y NavLink
==============

BrowserRouter no hará mucho si no esta acompañado de enlaces y rutas,
empecemos hablando de los enlaces que se llaman Link y NavLink. Estos
funcionan de manera similar a las anclas de HTML.

Link cuenta con las siguientes propiedades:

-  to: similar al href de , puede recibir un string indicando la ruta a
   donde va a mandar o bien recibir un objeto con: pathname, un string
   que representa la ruta a donde se dirige; search, un string que
   representa el query de una url; hash, un hash para poner en la url; y
   por último state, un objeto que representa un estado en la
   navegación.
-  replace: similar a to, pero en lugar de añadir una nueva ruta al
   stack del historial de navegación, reemplaza la ultima ruta por la
   nueva ruta.
-  innerRef: es una forma de obtener el elemento HTML del componente,
   funciona igual que el ref de React.

NavLink es una versión especial de Link, cuenta con varias
características más poderosas como, por ejemplo:

-  activeClassName: cuando se navegue a la ruta que dirija el NavLink,
   esta propiedad añadirá al className del componente el string que le
   pasemos.
-  activeStyle: similar a activeClassName, pero con estilos en línea.
-  isActive: es una función que se mandara cuando naveguemos a la ruta
   del NavLink.
-  exact: recibe un booleano, sirve para marcar si dirige a una ruta
   exacta. Se vera a mayor profundidad cuando manejemos rutas.
-  strict: recibe un booleano, sirve para marcar si dirige a una ruta
   estricta. Se vera a mayor profundidad cuando manejemos rutas.
-  location: sirve para poder hacer la comparación de isActive con
   alguna otra ruta.

.. code:: html

   <NavLink exact to="/" activeClassName="is-selected">Enlace</NavLink>

Route
=====

Aun no estas cambiando nada dentro de la interfaz, solamente se esta
cambiando la url. Para poder cambiar la interfaz acorde a la url
usaremos Route, algunas propiedades son:

-  component: que componente quieres renderizar.
-  path: indica la ruta en la cual va a renderizar el componente que le
   pases.
-  render: es una alternativa a componente, puedes hacer un renderizado
   en forma de función como en los componentes de React.
-  children: son los hijos o componentes que tenga anidado.
-  exact: recibe un booleano, si le indicas que es verdadero solo hará
   match si la ruta coincide exactamente con la ubicación, no hará caso
   a ninguna sub-ruta.
-  strict: recibe un booleano, si le indicas que es verdadero solo hará
   match si la ruta a la que te diriges es idéntica a la ruta del Route.
-  sensitive: recibe un booleano, si le indicas que es verdadero
   activara el case sensitive para la ruta.

Redirect-Switch
===============

Switch se encarga de solo renderizar el primer componente que haga match
con la ruta que estés designando.

El componente Redirect nos ayudara para realizar un redireccionamiento
en el navegador, sus principales parámetros son from y to que sirven
para indicar de que ruta van a redirigir hacía que ruta van a realizar
el redireccionamiento.

.. code:: html

   <Redirect from="/v" to="/videos"></Redirect>

Prompt, validación antes de dejar la página
===========================================

El componente Prompt cuyos parámetros que recibe son when que recibe un
booleano para indicar si muestra el mensaje del navegador y message que
recibe un string que será el mensaje que reciba el usuario.

.. code:: html

   <Prompt
   when={props.value}
   message="¿Estás seguro de querer dejar la página?. Tienes una búsqueda en proceso"/>

Manipulando el historial
========================

Dentro de los componentes que renderizamos a través de Route encontramos
en sus props un objeto llamado history, este objeto cuenta con multiples
propiedades y métodos como:

-  go: es un método que te permite ir a cierto momento en el historial
   de navegación, recibe como parámetro un número, dependiendo de la
   cantidad es cuanto avanzara en el historial y si es positivo o
   negativo será la dirección que tome.
-  goBack: es un método que te permite navegar una pagina hacia atrás,
   funciona de forma similar a que si llamáramos a go(-1).
-  goForward: es un método que te permite navegar una pagina hacia
   adelante, funciona de forma similar que si llamáramos a go(1).
-  push: te permite añadir una nueva ruta al stack de navegación.

Podremos ejecutar los métodos así

.. code:: javascript

   this.props.go(1)
   this.props.goBack()
   this.props.goForward()

A parte del history hay otra propiedad llamado location con más datos.
Las propiedades son:

-  hash
-  keyLength
-  pathname
-  search
-  state

Obteniendo el historial desde cualquier componente
==================================================

El history, location y match son unas propiedad que le llegan a
componentes que son renderizados por el componente padre Route, ¿qué
pasa con los componentes que no son paginas o qué simplemente no forman
parte de ninguna ruta?

Existe un High Order Component llamado withRouter que te permite añadir
estas propiedades. Este componente funciona como un decorador en Python

.. code:: javascript

   import {withRouter} from 'react-router'
   ...
   export default withRouter(componente)

Configurando Webpack para server render
=======================================

El SSR (Server Side Rendering) permite renderizar el código desde el
servidor y mandarlo como la respuesta HTTP por medio de Node

Primero habrá que configurar webpack

.. code:: javascript

   entry: {...},
   target: 'node',
   output: {
       path: ...,
       filename: "app.js",
       libraryTarget: 'commonjs2'
   }

En el *package.json* podemos crear un comando para transpilar

.. code:: javascript

   "scripts": {    
       "build:server": "webpack --env.NODE_ENV=local"
   }

En el SSR *no puede usarse el BrowserRouter pues no tiene nada de la API
de HTML 5*; no tiene un DOM. Por la razón anterior se usará
*StaticRouter*.

Para que el StaticRouter pueda decidir que componente renderizar con
base en la url debemos pasarle la url del http request por medio del
parámetro location.

.. code:: bash

   npx babel-node src/server.js --presets react, es2015, stage-2

Después instalamos babel

.. code:: bash

   npm install babel-cli –save-dev
   npm install babel-watch –save-dev

Al momento de renderizar nuestros componentes en React hemos estado
utilizando el método render de reactDOM, pero este método solo funciona
en el navegador. Para poder renderizar en el servidor haremos uso de
reactDOMServer, cuenta con cuatro métodos de los cuales dos se utilizan
dentro de un stream, los otros dos métodos son:

   -  renderToString: te sirve para hacer server render y re-renderizar
      en el navegador.
   -  renderToStaticMarkup: este método te sirve si quieres hacer un
      server render que NO utilice un renderizado en el navegador.

Para nuestro proyecto usaremos renderToString.

StaticRouter cuenta con un parámetro necesario llamado location, este
parámetro le va a indicar que ubicación se va a renderizar. En nuestro
servidor le pasaremos a StaticRouter el parámetro location a través de
la url que venga en el request.

Babel por defecto no va a entender React, entonces al momento correr
babel-node debemos de indicarle que presets utilizar, tal como en el
siguiente comando que añadiremos al package.json:

::

   babel-node src/server.js –presets react,es2015,stage-2

Hay que refactorizar el código para excluir cualquier cosa que tenga que
ver con el navegador (llamadas a document, window), exportarlo con
webpack y luego pasarselo a express u otro servidor por medio de la
función reactDOM.render()

.. code:: javascript

   import express from 'express';
   import React from 'react';
   import  App  from '../dist/ssr/app';
   import { StaticRouter } from 'react-router';
   import reactDOMServer from 'react-dom/server';

   const app = express();

   app.get('*', (req, res)=>{
       const html = reactDOMServer.renderToString(
           <ReactRouter.StaticRouter location={req.url}>
               <App/>
           </ReactRouter.StaticRouter>) 
       res.write(...<body>${html}</body></html>)
       res.end()     
       })

   app.listen(3000)

Sí solo mandamos el código anterior capturará las rutas que terminen en
css y también las imágenes y mostrará el mismo contenido, pues encajan
en la wildcard \*. Para evitar problemas con nuestros archivos estáticos
de CSS e imágenes debemos configurar nuestro servidor de express
añadiendo las siguientes líneas de código

.. code:: javascript

   import express from 'express';
   import React from 'react';
   import  App  from '../dist/ssr/app';
   import { StaticRouter } from 'react-router';
   import reactDOMServer from 'react-dom/server';

   const app = express();

   app.use(express.static(‘dist’));
   app.use(‘/images’, express.static(‘images’));

   app.get('*', (req, res)=>{
       const html = reactDOMServer.renderToString(
           <ReactRouter.StaticRouter location={req.url}>
               <App/>
           </ReactRouter.StaticRouter>) 
       res.write(...<body>${html}</body></html>)
       res.end()     
       })

   app.listen(3000)
