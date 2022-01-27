===================================
NextJS: Sitios estáticos y Jamstack
===================================

Jamstack es una arquitectura de desarrollo web moderna basada en JavaScript del lado del cliente, API reutilizables y marcado predefinido, en donde el contenido prerenderizado es servido por un CDN y se vuelve dinámico usando APIs y serverless functions. 

Existen dos tipos de formas de renderizar una aplicación:

* Navegador
* Servidor

Tipos de renderizado
====================

Procesamiento de fragmentos de código y datos para mostrar un resultado. Por ejemplo de JS a HTML.

Modos de rendering:

* Client-side: El rendering sucede en el navegador. Ejemplo: create-react-app

* Server-side: El servidor de backend se encarga del renderizado, ya sea total o parcial. Ejemplos con Python (Django), PHP, etc.

* Static rendering: Rendering por compilado de la aplicación. Este proceso se ejecuta una sola vez. Por ejemplo: Nextjs, Jekyll, Gatsby, Hugo.

Next.js permite crear aplicaciones híbridas, con uno o varios de los tipos de renderizado.

Arquitectura
============

La arquitectura general de una aplicación Jamstack es la siguiente:

Datos-> Generador estático -> Html/CSS

Para este ejemplo podemos usar un CMS, entre las opciones están: 

* contentful
* Prismic
* Sanity
* storyblock
* directus

Instalación del contentful-cli
==============================

Primero necesitamos instalar el cli de contentful, por lo que lo haremos usando npm

.. code:: bash

    npm install -g contentful-cli

Necesitaremos pasarle una configuración con la siguiente forma:

.. code:: json

    {
      "spaceId": "space_id",
      "managementToken": "CFPAT-token",
      "contentFile": "import/contentful-platzipedia.json"
    }

Ahora importamos la configuración directo desde nuestro archivo.

.. code:: bash

    contentful space import --config import/config.json

Autogeneración de data con graphql
==================================

Es posible generar tipos de typescript usando graphql con el siguiente recurso:

https://www.graphql-code-generator.com/


getStaticProps
==============

Get static props permite efectuar el renderizado en el servidor. useEffect no es compatible con el renderizado en el servidor por lo que debe reemplazarse por el método getStaticProps. Para Typescript le pasamos el tipo GetStaticProps que nos provee nextjs.

.. code:: javascript

	import { GetStaticProps } from 'next'

	type HomeProps = { plants: Plant[]}

	export const getStaticProps: GetStaticProps<HomeProps> = async () => {

	const plants = await getPlantList({ limit: 10 })

	  return {
	    props: {
	      plants
	    }
	  }
	}
	
De la misma manera usamos  InferGetStaticPropsType, unido con typeof para obtener el tipo de los props dinámicamente de getStaticProps


.. code:: javascript
	
	import { GetStaticProps, InferGetStaticPropsType } from 'next'
	
	// ...
	
	export default function Home({plants}: InferGetStaticPropsType<typeof getStaticProps>) {

      return  (
      <Layout>
        <PlantCollection plants={plants} variant="square"/>
      </Layout>
      )
    }


Ventajas y desventajas de SSG
=============================

Ventajas de SSG
---------------

Archivos estáticos que son faciles de subir para servidor por cualquier servidor. Esto mejora el SEO y la velocidad de carga.

Desventajas de SSG
------------------

No todos los sitios se pueden volver archivos estáticos, sobre todos aquellos que requieren datos actualizados desde la base de datos.

El tiempo de compilado puede incrementarse en proporción directa al número de páginas. Por lo que en sitios con demasiadas páginas tendremos problemas con el compilado.

Incremental Site Regeneration
=============================

Permite escalar el sitio sin importar el número de páginas por medio de la generación dinámica de páginas estáticas. Se construye un número bajo de páginas estáticas y las demás páginas se generan bajo demanda. 

Con SSG se tienen que construir todas las páginas en tiempo de compilación (build time); con ISG solo un fragmento, y el resto se hace incrementalmente en producción.

ISG permite regenerar las páginas cada cierto periodo de tiempo para actualizarlas, para hacerlo agregamos un parámetro revalidate dentro de nuestra función getStaticProps, que le dice a Nextjs durante cuanto tiempo serán válidas las páginas.

.. code:: javascript

    export const getStaticProps: GetStaticProps<HomeProps> = async () => {

      const plants = await getPlantList({ limit: 10 })
      const authors = await getAuthorList()

      return {
        props: {
          plants,
          authors,
        },
        revalidate: 5 * 60
      }
    }
    
Para páginas que no cambien es bueno ponerle valores altos, pero para páginas que cambien seguido o que requieran un estado constante de actualización podemos ponerle valores muy bajos, de hasta 1 segundo.

Leyendo desde el sistema de archivos
------------------------------------

En lugar de recibir la información de una API, podemos recibirla desde el sistema de archivos. Lo anterior es posible porque nextjs ejecuta getStaticProps desde el servidor.

.. code:: javascript

    import fs from 'fs'
    import path from 'path'
    export const getStaticProps: GetStaticProps<HomeProps> = async () => {
        const plantEntriesToGenerate = fs.readFileSync(path.join(process.cwd(), 'paths.txt'), 'utf-8').toString()
        const plantEntries = plantEntriesToGenerate.split('\n')
        // ...
    }
Fallback
========

El parámetro fallback de getStaticPaths puede tomar tres valores, 'blocking', false o true.

.. code:: javascript

    export const getStaticPaths: GetStaticPaths = async () => {

      const entries = await getPlantList({ limit: 10 })

      const paths: PathType[] = entries.map(plant=>({
        params: {
          slug: plant.slug,
        }
      }))

      return {
        paths,
        fallback: 'blocking'
      }
    }

* false: Devuelve 404 si la página no está prerendrizada.
* blocking: Si una página no existe, la busca la página en el servidor y la devuelve usando SSR. Peticiones futuras servirán la página desde la caché. Ideal cuando el prerendrizado no demora mucho tiempo.
* true: Avisa del estado de carga del servidor, útil para devolver estados de loading donde avisamos que la página está siendo procesado, esto por medio de la propiedad isFallback del objeto router que nos provee nextjs

.. code:: javascript

    const router = useRouter()

    if(router.isFallback){
        return <Spinner/>
        }
        
        
Enfoque stale-while-revalidate
==============================

Cada vez que un usuario ingresa nextjs responde con páginas listas, si el contenido en contentful cambia. Nextjs empieza a descargar la página nueva, mientras sigue devolviendo la página antigua, una vez terminada la nueva página. Todo lo anterior se realiza sin que el usuario lo sepa, de manera que el usuario siempre reciba una respuesta.

Trade-offs de ISG
=================

Requiere un servidor de Node.js
El build-time no aumenta con el número de páginas
No podemos ajustar tiempos de revalidación ante un enlace que se vuelve viral
No es apto para todas las páginas, por ejemplo dashboard, información en tiempo real, como bancaria, bolsa de valores
ISG no brinda ningún beneficio para sitios con pocas páginas, quizás hasta 1000 páginas.

SSR ventajas y desventajas
==========================

Nextjs SSR Ventajas
-------------------
    
* La información siempre estará actualizada
* Poder modificar la respuesta con base en la petición puede ser muy conveniente

Nextjs SSR desventajas
----------------------

* Golpea el servidor por cada petición y puede ser costoso. (consume recursos y consume dinero)

Nextjs Export
=============

Nextjs exporta un renderizado HTML, CSS y Javascript, por lo que el contenido puede servirse con un servidor de archivos estáticos.

sin embargo se pierden las funcionalidades de SSR como ISG, SSR, rutas, i18n, optimización de imágenes, revalidación, etc.
