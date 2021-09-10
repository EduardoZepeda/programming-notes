======
Nextjs
======

React es una librería que nos da bastante libertad para desarrollar.
Muchas veces mejorando cada aspecto de la aplicación de manera personal
no agregamos valor al proyecto del cliente, sino que solo estamos
optimizando sin mejorar la experiencia de los usuarios. Con Nextjs
podemos ahorrarnos el trabajo de configuración de React y su ecosistema.

Cost of ownership
=================

Al crear tan personalizado estamos creando un framework personalizado,
que muchas veces tiene un alto costo de mantenimiento que no se ve
compensado con el valor de la aplicación.

¿Por qué usar Next.js?
======================

NextJS es un framework que se encarga de muchos aspectos, inclusive del
deploy.

-  Un sistema de enrutamiento intuitivo basado en páginas (con soporte
   para rutas dinámicas)
-  La representación previa, tanto la generación estática (SSG) como la
   representación del lado del servidor (SSR) son compatibles por página
-  División automática de código para cargas de página más rápidas
-  Enrutamiento del lado del cliente con captura previa optimizada
-  Compatibilidad con CSS y SASS incorporada, y compatibilidad con
   cualquier biblioteca CSS-in-JS
-  Entorno de desarrollo con soporte Fast Refresh
-  Rutas de API para crear endpoints de API con funciones sin servidor
-  Totalmente ampliable

Instalación
===========

Instalar dependencias
---------------------

Recomendable tener las versiones más actualizadas de Node.

.. code:: javascript

   npm init -y

Luego instalaremos las dependencias de next junto con next

.. code:: javascript

   npm install next react react-dom

Crear carpeta pages
-------------------

Nextjs requiere una carpeta llamada pages en el root del proyecto

.. code:: bash

   mkdir pages

Cambiar scripts
---------------

.. code:: javascript

   "scripts": {
       "dev": "next",
       "build": "next build",
       "start": "next start"
   }

Rutas básicas
=============

Nextjs tomará los archivos index.js como los home de cada carpeta. Es un
routing basado en file system. Por lo que las pedidas a /about,
renderizarán el archivo about.js. Mientras que las que dirijan a
/product, irán al archivo index.js de la carpeta product.

.. code:: javascript

   pages
   |-- about.js
   |-- index.js
   //`-- product

Páginas dinámicas
=================

Se crean usando una sintaxis que involucra corchetes y dentro de ellos
la variable a capturar. Si este archivo estuviera dentro de una carpeta
llamada carpeta, capturaria cualquier ruta del tipo carpeta/loQueSea

.. code:: javascript

   [nombre_de_variable_a_capturar].js

Para acceder a la variable existe en nextjs un paquete llamada useRouter

.. code:: javascript

   import React from 'react'
   import { useRouter } from 'next/router'

   const Componente = () => {
     const router = useRouter()

     return(
       <div>Esta es la pagina de {router.query.nombre_de_variable_a_capturar}</div>
     )
   }

   export default Componente

Lo que viene despues de la propiedad query será el nombre de nuestro
archivo.

Setup y páginas
===============

En los scripts del archivo *package.json* build se encarga de compilar,
mientras que start inicia el servidor de node.

.. code:: javascript

   "scripts": {
       "dev": "next",
       "build": "next build",
       "start": "next start"
   }

Enlazando páginas
=================

Para enlazar páginas de manera dinámica se lleva acabo con el componente
Link que proviene de *next/link*. Es necesario colocar una etiqueta
anchor en el interior de Link. También se puede notar que el atributo
href se encuentra dentro de la etiqueta Link.

.. code:: javascript

   import Link from 'next/link'

   const Componente = () => {

     return(
       <Link href="/"><a></a></Link>
     )
   }

   export default Componente

Nextjs hace un prefetch al hacer hover en un enlace y descarga la
información, de esta manera mejora la optimización.

Link y Proxy
============

A partir de Nextjs 10 podemos duplicar rutas sin necesidad de duplicar
las carpetas. Rewrites nos permite solucionar este problema.

Creamos un archivo de next.config.js en la raiz donde especificaremos
las opciones.

.. code:: javascript

   module.exports = {
       async rewrites(){
           return [
               {
                   source: '/product/:path*',
                   destination: '/item/:path*'                
               }
           ]
       }
   }

API
===

Las Api deben de ir dentro de una carpeta llamada Api,
*obligatoriamente*. La forma de crear rutas es la misma.

Nextjs esperará una función que reciba en el primer parámetro el request
y el segundo el response. Tal cual lo haría Nodejs

.. code:: javascript

   import { IncomingMessage, ServerResponse } from 'http'

   const allData = async (request: IncomingMessage, response: ServerResponse) => {
     response.end(JSON.stringify({ status: "ok" }))
   }

   export default allData

Objetos response y request
--------------------------

Nextjs tiene objetos que fueron extendidos para manejar las respuestas y
peticiones web, estos son:

-  NextApiRequest
-  NextApiResponse

Podemos importarlos directo de next

.. code:: javascript

   import { NextApiRequest, NextApiResponse } from 'next'

Nextjs también incluye helpers para facilitar el envio de respuestas.

.. code:: javascript

   response.statusCode = 200
   response.end(JSON.stringify({ data: entry }))

La siguiente linea es equivalente a las dos anteriores, pero mucho más
limpia.

.. code:: javascript

   response.status(200).json({data: entry})

Personalización de NextJS
=========================

Document es el documento principal, dentro de esta se encuentra App y
dentro de esta se encuentra la aplicación.

Extendiendo document
--------------------

Para modificar el document creamos un archivo, dentro de la carpeta
pages/, llamado \_document.tsx o \_document.js , ya sea que estemos
trabajando con typescript o javascript, respectivamente. Cualquier
cambio que se haga va a aplicar a todos los documentos

En su documentación, Nextjs nos da una [plantilla
base](https://nextjs.org/docs/advanced-features/custom-document) para
poder personalizar lo que necesitamos.

Este archivo es ideal para colocar elemento adicionales en la etiqueta
Head, tales como favicons, webfonts o estilos personalizados

.. code:: javascript

   import Document, { Html, Head, Main, NextScript } from 'next/document'

   class MyDocument extends Document {
     static async getInitialProps(ctx) {
       const initialProps = await Document.getInitialProps(ctx)
       return { ...initialProps }
     }

     render() {
       return (
         <Html>
           <Head>
           {/*favicons*/}
           {/*webfonts*/}
           {/*stylesheets*/}
           {/*scripts*/}
           <Head />
           <body>
             <Main />
             <NextScript />
           </body>
         </Html>
       )
     }
   }

   export default MyDocument

Extendiendo App
---------------

Igual que document, Nextjs proporciona una
[plantilla](https://nextjs.org/docs/advanced-features/custom-app) que
podemos usar para personalizar la App

Para hacer uso de esta personalización debemos colocar un archivo
\_app.tsx o \_app.js, si trabajamos con typescript o javascript,
respectivamente.

Esta personalización es para crear temas personalizados, providers,
hacer un layout común o pasar props adicionales a todas las páginas.

Aquí es uno de los mejores lugares para colocar un React.contextProvider

.. code:: javascript

   //import App from 'next/app'

   function MyApp({ Component, pageProps }) {
     return <Component {...pageProps} />
   }

   // Only uncomment this method if you have blocking data requirements for
   // every single page in your application. This disables the ability to
   // perform automatic static optimization, causing every page in your app to
   // be server-side rendered.
   //
   // MyApp.getInitialProps = async (appContext) => {
   //   // calls page's `getInitialProps` and fills `appProps.pageProps`
   //   const appProps = await App.getInitialProps(appContext);
   //
   //   return { ...appProps }
   // }

   export default MyApp

Por ejemplo, si quisieramos que todos las páginas conteniera un Navbar y
un footer podemos envolver el componente que devuelve app dentro de otro
componente.

.. code:: javascript

   import {AppProps} from 'next/app'
   import Layout from '../components/Layout/layout'

   function MyApp({Component, pageProps}: AppProps) {
     return (<Layout>
       <Component {...pageProps}/>
     </Layout>)
   }

   // Only uncomment this method if you have blocking data requirements for
   // every single page in your application. This disables the ability to
   // perform automatic static optimization, causing every page in your app to
   // be server-side rendered.
   //
   // MyApp.getInitialProps = async (appContext) => {
   //    calls page's `getInitialProps` and fills `appProps.pageProps`
   //   const appProps = await App.getInitialProps(appContext);
   //
   //   return { ...appProps }
   // }

   export default MyApp

El componente Layout recibiría un Children que colocaría debajo del
Navbar y arriba del footer.

.. code:: javascript

   import React from 'react'
   import Navbar from '../Navbar/Navbar'


   const Layout: React.FC= ({children}) => {
     return (
       <div>
             <Navbar/>
             {children}
             <footer>This is the footer</footer>
       </div>
     )
   }

   export default Layout

Path Alias
==========

Para evitar la repeticion de salir de componentes una y otra vez

.. code:: javascript

   import Component from '../../../../components/component'

Para simplificar los paths podemos modificarlos con un archivo
tsconfig.json o jsconfig.json, para typescript o javascript,
respectivamente.

.. code:: javascript

   "compilerOptions": {
     "baseUrl": ".",
     "paths": {
       "@database": ["database/db.ts"],
       "@cors": ["cors-middleware.ts"],
       "@components/*": ["components/*"],
       "@store/*": ["store/*"]
     },

La diagonal y el asterisco despues de cada componente indica que es el
acceso a muchos archivos

CSS
===

Nextjs se muestra totalmente agnóstico sobre que tipo de implementación
de CSS se debería usar.

1) Global CSS (.css)
2) Module CSS (.module.css)
3) CSS-in-JS Styled JSX (Mantenida por los creadores de NextJS y Vercel)

Glocal CSS
----------

Podemos integrarlo directo en el archivo \_app.tsx, de esta manera
estará disponible en todas las páginas-

.. code:: javascript

   import '../styles.css'

Ahora los estilos disponibles en el archivo styles.css deben estar
disponibles para todos las páginas.

Module CSS
----------

El module.css se aplica por componente. Module css aplica hashes para
evitar colisiones dentro de los archivos.

.. code:: javascript

   import styles from './layout/module.css'

   <div className={styles.container}></div>

CSS-in-JS
---------

Tenemos que colocar una etiqueta estile con el atributo jsx y dentro los
estilos que queremos especificicar. De la misma manera NextJS creará
hashes para evitar colisiones de nombres.

.. code:: javascript

   <div className="container"></div>
   <style jsx>{`
     .container {
       background: salmon;
     }
   `}
   </style>

Usando SASS
-----------

Para los que usamos SCSS o SASS 1) Debemos instalar las dependencias
@zeit/next-sass node-sass 2) Crear un archivo con el nombre
next.config.js en el root del proyecto 3) Pegar dentro del archivo
next.config.js\* el siguiente código

.. code:: javascript

   const withSass = require('@zeit/next-sass')
   module.exports = withSass({
     cssModules: true
   })

Esto funciona para estilos globales y modulares.

Adicional a esto, si quieren importar fuentes locales a su proyecto: 1)
Debemos instalar la dependencia npm install --save nextjs-fonts 2)
Dentro del archivo next.config.js escribir el siguiente código

.. code:: javascript

   const withSass = require('@zeit/next-sass');
   const withFonts = require('nextjs-fonts');

   module.exports = withSass(withFonts({
     webpack(config, options) {
      return config;
     },
   }));

Contenido estático
==================

Nextjs espera una carpeta llamada **public** dentro del root del
proyecto. Podemos servir los contenidos estáticos de esta carpeta
pasando la ruta directamente. La carpeta public puede contener otras
subcarpetas también

.. code:: html

   <img src="/tu-imagen-en-public.jpg" alt=""/>
   <img src="/subcarpeta/tu-imagen.jpg" alt=""/>

A partir de NextJS se incorpora un componente de imagen que se encarga
de optimizar la carga de las imágenes de manera perezosa, además de
crear diferentes tamaños para reducir la carga de transferencia.

.. code:: javascript

   import Image from 'next/image'

   <Image src="/profile-picture.jpg" width="400" height="400" alt="Profile Picture">

El ancho y largo se forzan, para minimizar el impacto en el cumulative
layour shift

Pre-render modes
================

Nextjs nos provee dos maneras de servir el contenido SSG (Static Site
Generation) y SSR (Server Side Rendering)

SSR
===

El useEffect de React siempre se ejecuta en el navegador, por lo que
siempre va a tomar la función de SSR.

Hay que recordar que con este método pasamos la petición de la api del
lado del cliente al lado del servidor. Cada request que se hace al
servidor implica una petición web, por lo que siempre recibirá el
contenido actualizado, este método es ideal para contenido que se
actualiza constantemente.

getServerSideProps
------------------

Su función es comunicar los props de nuestro componente con código que
ejecutamos antes de que Next.js responda al cliente. Esta función se
exporta desde una página, es imposible usarla desde cualquier otro
componente. La función debe ser async y debe retornar los props. Este
método no se ejecutará en modo desarrollo, para verla en acción
deberemos hacer un build y correrlo con npm run build y npm run start.

.. code:: javascript

   export const getServerSideProps = async (params) => {
       return {
           props: {
               ourProps
           }
       }
   }

Para esto debemos pasarle los props que retornará getServerSideProps

.. code:: javascript

   const Component = ({ourProps}) => {...}

Dado que el servidor no tiene el objeto window podemos usar la librería
isomorphic-fetch para reemplazar todas las llamadas a windows.fetch por
fetch. *Fetch solamente aceptará url absolutas*

   .. code:: javascript

      import fetch from 'isomorphic-fetch'

      export const getServerSideProps = async (params) => {
          const response = await fetch('url-absoluta')
          const data = await response.json()

          return {
              props: {
                  data
              }
          }
      }

SSG
===

Este método creará páginas estáticas para servir por medio de Nextjs. En
este caso se hará una única petición y se generará un contenido
estático. Este método es ideal para contenido que no cambia con
frecuencia.

getStaticProps
--------------

Esta función se exporta desde una página, es imposible usarla desde
cualquier otro componente. Este método no se ejecutará en modo
desarrollo, para verla en acción deberemos hacer un build y correrlo con
npm run build y npm run start.

.. code:: javascript

   import { getStaticProps } from 'next'

   export const getStaticProps = async (params) => {
       return {
           props: {
               ourProps
           }
       }
   }

Así mismo debemos cambiar todos los métodos que no existen en el
servidor, como en la el SSR

.. _páginas-dinámicas-1:

Páginas dinámicas
-----------------

Estas páginas cambiarán

.. code:: javascript

   import { getStaticProps } from 'next'

   export const getStaticProps = async ({ params }) => {
       const id = params?.id as string
       const response = await fetch(`https://tu-url-absoluta.com/api/${id}`)

       const {data: ourProps } = await response.json()

       return {
           props: {
               ourProps
           }
       }
   }

getStaticPaths
--------------

NextJs requiere que le digamos de antemano todas las páginas que
necesitará renderizar. Esta función debe retornar un objeto con la
propiedad paths, con los id de las páginas que se van a generar. El
objeto path, debe ser una lista de objetos con los id o valor dinámico
de las páginas a generar. La diferencia entre getStaticProps y
getStaticPaths radica en que el primero obtiene la información del
componente (props), y el segundo, le dice a Next.js cuántas y qué
páginas se producirán.

.. code:: javascript

   // [id].js
   import { getStaticPaths } from 'next'

   export const getStaticPaths = async () => {
       return {
           paths: [
               {id: ...}, // podría ser variable para un archivo [variable].js
               {id: ...} //
           ]
       }

   }

Podemos usar métodos como map, para generar estas rutas de manera
dinámica a partir de una petición a una api.

.. code:: javascript

   import { getStaticProps } from 'next'

   export const getStaticPaths = async () => {
       const response = await fetch('https://tu-ruta-dinamica.com/api')
       const {data: ourProps} = await response.json

       const paths = ourProps.map((data)=>({
           params: {
               id: data.id
           }
       }))

       return {
           paths: paths, // o paths usando el shortcut,
       }

   }

Hay un segunda propiedad a indicar en el return. La propiedad se llama
fallback. Lo que hace es que cualquier página que no se especifique en
paths nos llevará a un error 404.

.. code:: javascript

   import { getStaticProps } from 'next'

   export const getStaticPaths = async () => {
       const response = await fetch('https://tu-ruta-dinamica.com/api')
       const {data: ourProps} = await response.json

       const paths = ourProps.map((data)=>({
           params: {
               id: data.id,
               fallback: false
           }
       }))

       return {
           paths: paths, // o paths usando el shortcut,
       }

   }

Deploy
======

Además de hacer deploy con Vercel se puede hacer un deploy de estáticos
haciendo un export por medio de next. Al usar next export se producirán
archivos planos de HTML, CSS y JavaScript desde Next.js

.. code:: javascript

   "scripts": {
       ...,
       "export": "next export"
       ...,
   }

Tras correr el comando nos generará una carpeta llamada out. Esta
carpeta contiene páginas estáticas en html completamente planas. Estás
páginas podemos usarlas con cualquier servidor que sirva html plano.

Diferencia entre next build y next export
=========================================

El primero construye una aplicación lista para producción de Node. El
segundo produce archivos estáticos.

Métricas
========

NextJs nos permite obtener métricas al exportar la funcion
reportWebVitals desde el archivo \_app.js o \_app.tsx. Estas podemos
mostrarlas o procesarlas de la manera en la que nosotros querramos.

.. code:: javascript

   export function reportWebVitals(metric){
       console.log(metric)
       process(metric)
   }
