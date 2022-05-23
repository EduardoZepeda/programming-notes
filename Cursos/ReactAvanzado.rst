==============
React avanzado
==============

Webpack
=======

Webpack empaquetará la aplicación y permitirá que podamos usar los
módulos EcmaScript para resolver dependencias.

Instalación de webpack
----------------------

Procedemos a instalar webpack, webpack-cli y webpack-dev-server para su
uso como dependencias de desarrollo

.. code:: bash

   npm i webpack webpack-cli webpack-dev-server --save-dev

A continuación vamos a instalar el plugin de html que se encarga de
crearnos un index.html como punto de entrada

.. code:: bash

   npm i html-webpack-plugin

Configurar webpack
------------------

La configuración de webpack consiste en especificar un modo, un archivo
de salida y la lista de plugins que debe usar. El archivo de entrada
será, de manera predeterminada, src/index.js en la raiz del proyecto.

.. code:: javascript

   const HtmlWebpackPlugin = require('html-webpack-plugin')

   module.exports = {
       mode: 'development',
       output: {
           filename: 'app.bundle.js'
       },
       plugins: [
           new HtmlWebpackPlugin()
       ]
   }

Una vez configurado podemos crear nuestros scripts en package.json para
tener un servidor de webpack. Build compilará nuestro código javascript,
mientras que dev iniciará el servidor de desarrollo en el puerto 8080

.. code:: javascript

   "scripts": {
     "build": "webpack",
     "dev": "webpack serve"
   }

Instalación de react
====================

React es la librería en si misma y react-dom nos permite usar los
componentes de react en el DOM

.. code:: bash

   npm i react react-dom

Creamos un punto de entrada para nuestra aplicación en un nuevo archivo
src/index.html con un div con un id que querramos, usaremos app

.. code:: bash

   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>Petgram</title>
   </head>
   <body>
       <div id="app"></div>
   </body>
   </html>

Y le indicaremos al html-webpack-plugin que use ese archivo a través del
webpack.config.js

.. code:: javascript

   plugins: [
       new HtmlWebpackPlugin({
           template: 'src/index.html'
       })
   ]

Ahora le pediremos a react que renderize en nuestro punto de entrada

.. code:: javascript

   import React from 'react'
   import ReactDOM from 'react-dom'

   ReactDOM.render('Hello', document.getElementById('app'))

Instalación de Babel
====================

Para crear código compatible con todos los navegadores usaremos Babel.
Lo instalamos como dependencia de desarrollo

.. code:: javascript

   npm i @babel/core @babel/preset-env @babel/preset-react babel-loader --save-dev

Añadimos Babel a la configuración de webpack.config.js

.. code:: javascript

   module: {
       rules: [{
           test: /\.js$/,
           exclude: /node_modules/,
           use: {
               loader: 'babel-loader',
               options: {
                   presets: [
                       '@babel/preset-env', 
                       '@babel/preset-react'
                       ]
               }
           }
       }]
   }

StandardJS
==========

Unas reglas para lintar nuestro código. A pesar de lo que diga su
nombre, Standard, no es oficial, sin embargo es bastante popular entre
la comunidad de usuarios de Javascript

Instalacion
-----------

El linter standard se instala con

.. code:: bash

   npm i standard --save-dev

Modificamos el archivo package.json. Ignoramos /api/. Agregamos el
comando lint para que nos muestre los errores y agregamos la
configuración para que los editores de código los detecte.

.. code:: javascript

   "standard": {
     "ignore": [
       "/api/**"
     ]
   },
   "scripts": {
     "build": "webpack",
     "dev": "webpack serve",
     "lint": "standard"
   },
   "eslintConfig": {
     "extends": ["./node_modules/standard/eslintrc.json"]
   }

Deploy con Vercel
=================

Instalamos vercel. Dado que vercel cambia la configuración de sus
archivos e instrucciones es mejor revisar la documentación oficial al
momento de hacer el deploy

.. code:: bash

   npm i -g vercel

.. code:: bash

   vercel init

   Vercel CLI 23.0.1
   > Select example: (Use arrow keys)
   ❯ amp 
     angular 
     blitzjs 
     brunch 
     create-react-app 
     custom-build 
     docusaurus 
     docusaurus-2 
     dojo 
     eleventy 
     ember 
     gatsby 
     gridsome 
     hexo 
     hugo 
   (Move up and down to reveal more choices)

Styled components
=================

Librería que nos permite estilar de forma muy sencilla, siguiendo CSS y
usando los tags de HTML que queramos usar en nuestra aplicación y
cualquier componente que acepte una prop className.

Se encarga de evitar colisiones de nombres y te permite colocar el css
directamente en el archivo js o ts. Así como el renderizado condicional
de CSS

.. code:: bash

   npm i styled-components

Para crear un estilo usaremos la siguiente sintaxis

.. code:: javascript

   import styled from 'styled-components'

   export const Anchor = styled.a``
       display: flex;
       text-align: center;
       text-decoration: none;
       flex-direction: column;
       width: 75px;
   ``

Estos estilos pueden usarse directamente en los archivos o exportarse
como componentes para usar en nuestros archivos

.. code:: html

   <Anchor href="#"/>

Styled componentes también acepta componentes como argumento.

.. code:: javascript

   import styled from 'styled-components'
   import { Link } from '@reach/router'

   export const Anchor = styled(Link)``
   ``

Estilos globales
----------------

Creamos un archivo globalStyles

.. code:: javascript

   import { createGlobalStyle } from 'styled-components'

   export const GlobalStyle = createGlobalStyle````
       html {
               box-sizing: border-box;
               font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
       }
   ````

Después importamos ese archivo y lo colocamos en el nivel superior de la
app, en el componente APP en este ejemplo.

.. code:: javascript

   import { GlobalStyles } from './GlobalStyles'

   export const App = () => (
     <>
       <GlobalStyles />
       <MainComponent/>
     </>
   )

Creando animaciones
-------------------

Podemos crear animaciones reutilizables usando keyframes directamente de
la librería de styled-components.

.. code:: javascript

   import {keyframes, css} from 'styled-components'

   export const fadeIn = ({time = '1s', type='ease'} = {}) => css``
       animation: ${time} ${fadeInKeyframes} ${type};
   ``

   const fadeInKeyframes = keyframes``
       from {
           filter: blur(5px);
           opacity:0;
       }
       to {
           filter: blur(0px);
           opacity:1;
       }

   ``

Una vez creadas podemos usarlas en los estilos de nuestros componentes

.. code:: javascript

   export const Img = styled.img``
       ${fadeIn()}
       box-shadow: 0 10px 14px rgba(0,0,0,0.2);
   ``

Hooks
=====

Para ver los hooks principales revisa los apuntes de React básico.

useRef
------

El hook useRef nos permite guardar una referencia, esta referencia puede ser a cualquier elemento.

useRef al componente
^^^^^^^^^^^^^^^^^^^^

useRef nos permite capturar la referencia al elemento en el DOM. Ref no hace referencia al elemento en el cual se crea, sino a aquel que se lo colocamos como un prop.

.. code:: javascript

   import {useRef} from 'react'

   const Component = () => {
       const ref = useRef(null)
   }

Por ejemplo, la variable ref contendrá una referencia a la etiqueta article.

.. code:: javascript

   import {useRef} from 'react'

   const Component = () => {
       const ref = useRef(null)
       return (<article ref={ref}>...<article/>)
   }

Y para acceder directamente a la etiqueta necesitamos llamar a la propiedad current de la referencia.

.. code-block:: javascript

   haz_algo(ref.current)

UseRef al estado
^^^^^^^^^^^^^^^^

También podemos referenciar un estado de React. Esto es bastante útil al mezclarlo con useEffect en ocasiones donde queremos asignar un callback, pero el estado (state) aún se encuentrará vacio.

Por ejemplo:

.. code-block:: javascript

   useEffect(()=> {
    // fetch data and set state
    socket.onmessage = (event) => {
         const messageJson = JSON.parse(event.data)
         // si realizamos esto dentro de un useEffect
         setState([messageJson.payload, ...state])
         }
      }
   })

El estado (state) va a estar vacio y el callback se creará con el estado vacio, dejándonos con un estado vacio.

En cambio, si guardamos una referencia usando un doble useEffect, podemos guardar el nuevo estado en nuestra referencia usando un useEffect que solo se ejecutará cuando cambie nuestra información (en este caso data).

.. code-block:: javascript

  useEffect(()=>{
    // this sets a reference to posts and saves it in current
    stateRef.current = data
  }, [data])
  
  useEffect(()=>{
      // fetch data
      socket.onmessage = (event) => {
            const messageJson = JSON.parse(event.data)
            // si realizamos esto dentro de un useEffect
            setState([messageJson.payload, ...stateRef.current])
         }
      }
   }

Usando este acomodo podemos crear un callback que funcionará de manera correcta usando la referencia que hemos creado hacia el estado.


Context
-------

Context nos permite acceder a datos sin usar las Props por medio de un
contexto global.

Para usarlo necesitamos importar el createContext de React

El Context nos va a proporcionar 2 componentes:

-  Provider: componente que debe envolver a nuestra aplicación.
-  Consumer: nos va a permitir acceder a las render props que declaremos
   en el Provider.

.. code:: javascript

   import { createContext } from 'react'

   export const Context = createContext()

Luego usaremos ese componente para envolver nuestra aplicación

.. code:: javascript

   ReactDOM.render(<Context.Provider value={{isAuth: true}}><App /></Context.Provider>, document.getElementById('app'))

Y envolveremos el componente que querramos que tenga acceso al contexto
que creamos.

.. code:: javascript

   <Context.Consumer>
     {
           ({ isAuth }) => isAuth
             ? <Router>
               <UserProfile path='/user' />
             </Router>
             : <Router>
               <LoginScreen path='/user' />
             </Router>
                     }
   </Context.Consumer>

Custom hooks
------------

Sirven para poder reutilizar la lógica en diferentes componentes. Para
poder utilizarlos, deben empezar por la palabra use (useMiNombreDeHook).
Los custom hooks pueden usar otros hooks incluso, otros custom hooks.

Intersection observer
~~~~~~~~~~~~~~~~~~~~~

Un uso común del intersection observer es revisar si el elemento
referenciado está en el viewport del usuario. En la función useEffect de
abajo, creamos un observador y le pedimos que observe el elemento que
estamos referenciando, en este caso ref.current. Podemos ver el estado
directamente en las propiedades de entries

.. code:: javascript

   useEffect(()=>{
     const observer = new window.IntersectionObserver((entries)=>{
     const { isIntersecting } = entries[0]
     if(isIntersecting){
       setShow(true)
       observer.disconnect()
     }
     })
     observer.observe(ref.current)
   }, [ref])

Hay que recordar un par de cosas. La primera es que, para que pueda
seguirse detectando el elemento con ref, es necesario devolver un
componente con el prop ref. Es decir, no podemos ejecutar ternarias u
operadores && para condicionar la renderización de componentes. La
segunda es que si un elemento no tiene una altura, todos van a estar en
el viewport al cargar la página. Por lo anterior es bueno dotar de
height o min-height a los elementos a observar.

.. code:: javascript

   //Si show es false ya no va a existir ref
   show && <article ref={ref}>...<article/>

   //Podemos reemplazarlo por
   <article ref={ref}>{show&&<contenido/>}<article/>

RenderProps
===========

Es una técnica para compartir código entre componentes en React que
utiliza una prop (cómo children u otra de otro nombre, aunque
normalmente se usa render) como función, que recibe como parámetro
información y devuelve el componente que queremos que renderice.

.. code:: javascript

   <DataProvider render={data => (
     <h1>Hello {data.target}</h1>
   )}/>

También funciona con children

.. code:: javascript

   <Mouse children={mouse => (
     <p>The mouse position is {mouse.x}, {mouse.y}</p>
   )}/>

Ya sea pasándole el parmáetro children como prop o directamente
colocándolo como un children

.. code:: javascript

   <Mouse>
     {mouse => (
       <p>The mouse position is {mouse.x}, {mouse.y}</p>
     )}
   </Mouse>

Graphql
=======

GraphQL es un lenguaje creado por Facebook para obtener solo los datos
que necesitamos.

React Apollo es un cliente que nos va a permitir conectarnos a un
servidor GraphQL.

.. code:: javascript

   npm install @apollo/client graphql

En nuestro archivo donde renderizamos con ReactDOM.render() importamos
las librerias necesarias, y creamos una constante cliente, la cual va a
contener el endpoint de nuestro graphql. Posteriormente, envolvemos el
componente de nuestra aplicación en el component ApolloProvider,
pasándole como un prop llamado client, la constante que acabamos de
crear.

.. code:: javascript

   import React from 'react'
   import ReactDOM from 'react-dom'
   import { App } from './App'
   import { ApolloClient, ApolloProvider, InMemoryCache } from "@apollo/client";

   const client = new ApolloClient({
     uri: "https://react-avanzado-testing-eduardozepeda.vercel.app/graphql/",
     cache: new InMemoryCache(),
   });

   ReactDOM.render(<ApolloProvider client={client}><App /></ApolloProvider>, document.getElementById('app'))

Ahora para usarlo, importamos las funciones requerias de @apollo/client
y creamos las consultas

.. code:: javascript

   import { useQuery, gql } from "@apollo/client"

   const withPhotos = gql``
     query getPhotos {
       photos {
         id
         categoryId
         src
         likes
         userId
         liked
       }
     }
   ``

Ahora podemos usar la functión useQuery para obtener los datos

.. code:: javascript

   const { loading, error, data } = useQuery(whitPhotos);

Parámetros con graphql
----------------------

Las queries tambien pueden recibir parámetros

.. code:: javascript

   const withPhotos = gql``
     query getPhotos($categoryId:ID) {
       photos(categoryId: $categoryId) {
         id
         categoryId
         src
         likes
         userId
         liked
       }
     }
   ``

Para que detecte los queries deberemos pasárselos dentro de la propiedad
variables del objeto que le pasaremos a la función useQuery como segundo
parámetro.

.. code:: javascript

   const { loading, error, data } = useQuery(withPhotos, { variables: { categoryId } });

Mutaciones
----------

Las mutaciones nos permiten modificar datos y darles seguimiento.
Además, al igual que con useQuery, el hook de las mutaciones nos
devuelve el estado de error o carga de nuestra petición

.. code:: javascript

   import { gql, useMutation } from '@apollo/client'

   const REGISTER = gql``
       mutation signup($input: UserCredentials!){
           signup(input: $input)
       }
   ``
   export const useRegisterMutation = (email,password) => {
     const [registerMutation, { loading: mutationLoading, error: mutationError }] = useMutation(REGISTER, {variables: {input:{email, password}}})
     return { registerMutation, mutationLoading, mutationError }
   }

React router
============

Reach Router es una versión simplificada y mejor optimizada de React
Router, su creador es Ryan Florence el mismo creador de React Router. Se
anunció que los dos paquetes se iban a unir, pero su API se va a parecer
más a Reach Router.

Al momento de escribir este apunte se instala así

.. code:: javascript

   npm i @reach/router

Y su uso es más simple que React/router. Aquí podemos indicarle la path
en la que se renderizará un componente directamente en el componente.
También cuenta con un componente redirect que redirige de una ruta a
otra.

.. code:: javascript

   <Router>
       <Home path='/'/>
       <Home path='/pet/:id'/>
       {!isAuth && <Redirect from='/favs' to='/login' />}
   </Router>

Debemos cambiar la configuración de webpack

.. code:: javascript

   output: {
     filename: 'app.bundle.js',
     publicPath: '/'
   },

Y el script de package.json que corre el servidor de desarrollo

.. code:: javascript

   "dev": "webpack serve --history-api-fallback",

Componente Link
---------------

Funciona igual que el de react router

.. code:: javascript

   import { Link } from '@reach/router'

   <Link to={path}>

   </Link>

Obtener la página activa
~~~~~~~~~~~~~~~~~~~~~~~~

@reach/router le añade el atributo aria-current="page" al componente
Link activo. Lo que nos permite darle estilos directamente buscando la
propiedad del componente y aplicandole estilos condicionales.

Renderizado condicional de rutas
--------------------------------

Renderizar rutas de acuerdo a parametros tales como el estado de loggeo
se hace creando un componente que envolverá a otros componentes. En este
caso el componente UserLogged regresa el children y le pasa como
paramétro un objeto con isAuth.

.. code:: javascript

   const UserLogged = ({ children }) => {
     return children({ isAuth: false })
   }

Nos asegurarnos de definir a children como una función, que reciba
parámetros y que retorne componentes. Usaremos el resultado del
parámetro creado para renderizar nuestros componentes envueltos en el
mismo objeto Router, como si se tratara de un router adicional al
principal.

.. code:: javascript

   <UserLogged>
     {
           ({ isAuth }) => isAuth
             ? <Router>
               <UserProfile path='/user' />
             </Router>
             : <Router>
               <LoginScreen path='/user' />
             </Router>
                     }
   </UserLogged>

También es posible user el contexto para tener un código más ordenado

.. code:: javascript

   import React, {useContext} from 'react'
   import Context from './Context'

   const {isAuth} = useContext(Context)
   <Router>
       {!isAuth && <Redirect from='/favs' to='/login' />}
   </Router>

Páginas 404
-----------

React router puede especificar una página como default si no se
encuentra ninguna ruta colocandole un prop que diga default.

.. code:: javascript

   import { PageNotFound } from './pages/PageNotFound'

       <Router>
           <PageNotFound default/>
       </Router>

React Helmet
============

Helmet nos permite reemplazar el title y colocar cualquier otro
contenido dentro de la etiqueta head. Para usarlo primero hay que
instalarlo desde

.. code:: javascript

   npm i react-helmet

Una vez instalado podemos usarlo colocándole el contenido que querramos
en el archivo que querramos.

.. code:: javascript

   import { Helmet } from 'react-helmet'

   export default Component = () => {
   return (
   <>
     <Helmet>
       {title && <title>Petgram | {title}</title>}
       {description && <meta name='description' content={description} />}
     </Helmet>
     <OtrosComponentes/>
   </>
   )
   }

React helmet es muy versátil. Incluso podemos crear subcomponentes que
incluyan a Helmet y modifiquen su comportamiento

.. code:: javascript

   import { Helmet } from 'react-helmet'

   export const Layout = ({ children, title, description, showTitle = false, showDescription = false }) => {
     return (
       <>
         <Helmet>
           {title && <title>Petgram | {title}</title>}
           {description && <meta name='description' content={description} />}
         </Helmet>
         <div>
           {(title && showTitle) && <h1>{title}</h1>}
           {(description && showDescription) && <div>{description}</div>}
           {children}
         </div>
       </>
     )
   }

React Lazy
==========

React lazy se encarga de importar de manera dinámica los componentes
como se van necesitando. Para lograrlo necesitamos pasarle a la función
React.lazy, como parámetro, una función que devuelva un import.

.. code:: javascript

   const Favs = React.lazy(() => import('./pages/Favs')) // Recuerda que el import lleva paréntesis, ya que es una función

   export const App = () => {
       return(
       <Router>
           <Favs path='/favs' />
       </Router>
       )
   }

Otro requisito consiste en que el componente a importar debe estar
exportado como default.

.. code:: javascript

   export default () => {...}

Además necesita estar envuelto en un componente Suspense, que recibirá
un prop llamado fallback. Fallback se refiere al componente que
renderizará mientras se cargar el import dinámico.

.. code:: javascript

   import React, { useContext, Suspense } from 'react'
   import { Spinner } from './components/Spinner'

   <Suspense fallback={<Spinner/>}>
       <Router>
           <Favs path='/favs' />
       </Router>
   </Suspense>

Si todo funcionó correctamente podrás ver que al acceder al componente,
este realiza una petición al código que necesita para renderizarse. De
esta manera, se reduce el tamaño del bundle principal y el resto del
código se va cargando conforme se necesite.

PropTypes
=========

Solia ser parte de React, pero fue separada. Es bastante similar al
tipado que ofrece Typescript.

.. code:: javascript

   npm i prop-types --save-dev

Ahora podemos verificar las props que recibe un componente creando un
objeto

.. code:: javascript

   import { PropTypes } from 'prop-types'

   SingleComponent.propTypes = {
     liked: PropTypes.bool.isRequired,
     likes: PropTypes.number.isRequired,
     onClick: PropTypes.func.isRequired,
     disabled: PropTypes.bool
   }

Podemos especificar si es un prop requerido agregando isRequired al tipo
de dato

De la misma manera que especificabamos el tipo, podemos establecer la
forma de los subtipos de datos que contiene una estructura, como el caso
de los arrays

.. code:: javascript

   ListOfSomethingComponent.propTypes = {
     favs: PropTypes.arrayOf(
       PropTypes.shape({
         id: PropTypes.string,
         src: PropTypes.string
       }))
   }

Node es un proptype que se refiere a componentes de React
---------------------------------------------------------

Hay ciertos componentes que reciben como prop un componente. En este
caso el tipo de dato será node, que se refiere a cualquier cosa que
React pueda renderizar.

.. code:: javascript

   import React from 'react'
   import { Button } from './styles'
   import { PropTypes } from 'prop-types'


   export const SubmitButton = ({ children, disabled, onClick }) => {
     return <Button disabled={disabled} onClick={onClick}>{children}</Button>
   }

   SubmitButton.propTypes = {
     children: PropTypes.node.isRequired,
     onClick: PropTypes.func.isRequired,
     disabled: PropTypes.bool
   }

PropTypes personalizados
------------------------

También podemos crear validaciones de props personalizadas, para
componentes más complejos. Creando una función que recibe los props, el
nombre del Prop (propName) y el nombre del componente (componentName).
Podemos asignarle validación propia haciendo que retorne un objeto Error
con nuestra propia descripción

.. code:: javascript

   import { PropTypes } from 'prop-types'

   PhotoCard.propTypes = {
     id: PropTypes.string.isRequired,
     liked: PropTypes.bool.isRequired,
     src: PropTypes.string.isRequired,
     likes: function (props, propName, componentName) {
       const propValue = props[propName]
       if (propValue == undefined){
         return new Error(``${propName} value must be defined``)
       }

       if (propValue<0){
         return new Error(``${propName} value must be greater than zero``)
       }
     }
   }

PWA
===

.. code:: javascript

   npm i webpack-pwa-manifest --save-dev

Para usarlo necesitamos agregarlo al archivo de configuraciónd de React

.. code:: javascript

   const WebpackPwaManifest = require('webpack-pwa-manifest')

Ahora agregaremos un objeto nuevo en la sección de plugins de
*webpack.config.js*. El array sizes creará iconos para cada una de los
tamaños especificados. Asegúrate de tener un archivo en la ruta
especificada o dará error.

.. code:: javascript

   plugins: [
       new WebpackPwaManifest({
             name: 'Nombre',
             short_name: 'Nombre corto',
             description: 'Tu propia descripción',
             background_color: '#ffffff',
             theme_color: '#2196f3',
             crossorigin: 'use-credentials', //can be null, use-credentials or anonymous
             icons: [
               {
                 src: path.resolve('src/assets/img/icon.png'),
                 sizes: [96, 128, 192, 256, 384, 512] // multiple sizes
               },
               {
                 src: path.resolve('src/assets/img/icon.png'),
                 size: '1024x1024' // you can also use the specifications pattern
               },
               {
                 src: path.resolve('src/assets/img/icon.png'),
                 size: '1024x1024',
                 purpose: 'maskable'
               }
             ]
           }),
   ]

Lo anterior creará un archivo manifest en la misma carpeta de salida del
bundle que se genera con webpack.

Soporte offline como PWA
------------------------

Para crear soporte como PWA google nos ofrece una aplicación llamada
workbox-webpack-plugin

.. code:: javascript

   npm i workbox-webpack-plugin --save-dev

Ahora lo requerimos en el archivo de *webpack.config.js*

.. code:: javascript

   const WorkboxWebpackPlugin = require('workbox-webpack-plugin')

Ahora en la sección de plugins colocamos una serie de caches donde cada
uno parte de una expresión regular.

-  urlPattern: Se refiere al patrón de expresiones regulares que
   definiremos, sus reglas se definirán abajo.
-  cacheName: Indica al nombre de la cache.
-  CacheFirst: Establece que se busque primero en la cache antes de
   intentar acceder a la red
-  NetworkFirst: Prioriza el acceso a la red para buscar información,
   esto con la finalidad de tener siempre datos actualizados.

.. code:: javascript

   new WorkboxWebpackPlugin.GenerateSW({
        swDest: 'service-worker.js',
        clientsClaim: true,
        skipWaiting: true,
        maximumFileSizeToCacheInBytes: 5000000,
        runtimeCaching: [
          {
            urlPattern: new RegExp(
              'https://(res.cloudinary.com|images.unsplash.com)'
            ),
            handler: 'CacheFirst',
            options: {
              cacheName: 'images'
            }
          },
          {
            urlPattern: new RegExp(
              'https://react-avanzado-testing-b39h5jmoy-eduardozepeda.vercel.app/'
            ),
            handler: 'NetworkFirst',
            options: {
              cacheName: 'api'
            }
          }
        ]
      })

A pesar de que la configuración ya está lista y que se está generando un
service-worker, necesitamos incluirlo en nuestro archivo html.

.. code:: javascript

   <script>
       if('serviceWorker' in navigator){
           window.addEventListener('load', function(){
               navigator.serviceWorker.register('/service-worker.js')
               .then(registration => {
                   console.log('SW registrado')
               })
               .catch(registrationError => {
                   console.log('SW no registrado')
               })
           })
       }
   </script>

Recuerda que cualquier cambio en la configuración de webpack requiere el
reinicio del server.

Testing con cypress
===================

.. code:: javascript

   npm i cypress --save-dev

Ahora agregamos un comando nuevo a *package.json*

.. code:: javascript

   "scripts": {
       "test": "cypress open"
   }

Se creara una carpeta llamada cypress, dentro de la cual habrá una
carpeta llamada integration que es donde pondremos nuestras pruebas.

.. code:: javascript

   //cypress/integration/nuestro_projecto/test_specs.js

   describe('Mi primer test', function(){
       it('para ver si funciona', function(){
           expect(true).to.equal(true)
       })
   })

Al ejecutar nuestro comando test se nos abrirá una GUI desde donde
seleccionaremos el archivo que querramos ejecutar. Basta darle click
para que se ejecuten las pruebas.

.. code:: javascript

   npm run test

Configurar cypress
------------------

Al momento de ejecutar las pruebas se crea un archivo llamado
cypress.json, dentro de la raiz del directorio. En este archivo podremos
especificar una serie de parámetros para facilitar nuestras pruebas.

.. code:: javascript

   {
       "baseUrl": "https://react-avanzado-testing-eduardozepeda.vercel.app/", 
       "chromeWebSecurity": false,
       "viewportWidth": 500,
       "viewportHeight": 800
   }

Pruebas
-------

El objeto cy nos dotará de una serie de métodos que nos ayudarán a
visitar sitios y scrapear el DOM

.. code:: javascript

   it('Prueba si tras visitar el primer enlace de la navbar nos redirige al home de la app', function(){
       cy.visit('/objecto/1') // visita una página
       cy.get('nav a').first().click() // Clickea en el primer anchor de la navbar
       cy.url().should('eq', Cypress.config().baseUrl) // Revisa si ahora la url es /
   })
   it('Prueba si la ruta favs muestra dos formularios', function() {
       cy.visit('/favs') //Visita la ruta /favs
       cy.get('form').should('have.length', 2) //Obten los elementos form del DOM y asegúrate de que sean 2
   })
