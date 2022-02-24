==============
i18n en Nextjs
==============

i18n
====

Se refiere a la adecuación del idioma, formato fechas, monedas, números, zonas horarias, de acuerdo a un país y región.

Anatomia de un Locale
=====================

Consta de 3 secciones. La primera es el lenguaje, la segunda la representación del lenguaje y la tercera se refiere a la región 

Por ejemplo: la-Scr-RE

* language (ISO 639)
* [Script] (ISO15924)
* [Region] (ISO 3166-1)

Generalmente la segunda sección, el script, suele omitirse.


Arquitectura
============

Existe información dinámica e información estática, es decir, texto hardcodeado en el html.

Podemos separar el contenido:

* CMS - Contentful: proveniente del servidor. Debe proveer de una API con soporte para locale.
* APP - React: Manejará los labels y los timezone.

Estrategias de rutas i18n
=========================

Hay dos estrategias que podemos tomar al respecto

* sub-atch routing: /es/productos
* domain routing: .es/productos

Configuración de locales en nextjs.config.js
============================================

Especificamos dentro de la propiedad i18n los valores de locales y defaultLocale, para especificar los idiomas disponibles y el valor por defecto, respectivamente.

.. code:: javascript

    const config = {
      future: {
        webpack5: true,
      },
      images: {
        domains: ['images.ctfassets.net'],
      },
      i18n: {
        locales: ['en-US', 'es'],
        defaultLocale: 'en-US'
      }
    }

En contenful podemos crear locales en settings>locale. El valor de fallback será el valor por defecto, si no tenemos todas las traducciones del locale activado, usará este.

Para especificar un parámetro, lo pasamos como parámetro a graphql a nuestra consulta. 

.. code:: javascript

    getItemCollection (limit: 10, skip: 100, locale: "es"){}
    
La función getStaticProps recibe el parámetro locale que fijamos en nextjs.config.js, por lo que si queremos especificarlo de acuerdo a la url 

.. code:: javascript

    export const getStaticProps: GetStaticProps<myProps> = async ({ locale }) => {
        getItemCollection (limit: 10, skip: 100, locale){}
    }

Podemos crear traducciones en la sección Content de Contentful.

i18n en páginas dinámicas
=========================

Para usar i18n en páginas dinámicas necesitamos generar los paths correspondientes por cada locale existente, junto con sus respectivos params.

.. code:: javascript

    // pages/blog/[slug].js
    export const getStaticPaths = ({ locales }) => {
    return {
        paths: [
        // if no `locale` is provided only the defaultLocale will be generated
        { params: { slug: 'post-1' }, locale: 'en-US' },
        { params: { slug: 'post-1' }, locale: 'fr' },
        ],
        fallback: true,
    }
    }


i18n en páginas no dinámicas
============================

getStaticPaths recibe *locales* (en plural) como parámetro

.. code:: javascript

    export const getStaticPaths: GetStaticPaths = async ({ locales }) => {}

Si usas typescript recuerda agregarlo al tipo de salida 

.. code:: javascript

    type PathType = {
      params: {
        slug: string
      },
      locale: string
    }
    
Podemos usar flatMap para aplanar el array y dejar un objeto con la forma

.. code:: javascript

    export const getStaticPaths = ({ locales }) => {
      return {
        paths: [
          { params: { slug: 'post-1' }, locale: 'en-US' },
          { params: { slug: 'post-1' }, locale: 'fr' },
        ],
        fallback: true,
      }
    }
    
Detección automática con Nextjs
===============================

Nextjs detecta automáticamente el idioma usando el header de preferencia "Accept-language" que elige el navegador. Podemos desactivar la función colocando el parámetro localDetection en false

.. code:: javascript

    module.exports = {
        i18n: {
            localeDetection: false,
        }
    }
    
El componente Link que provee nextjs redirige automáticamente a la url con el locale activo.

Si queremos modificar el comportamiento podemos hacer un router.push

.. code:: javascript

    router.push(
        url: string,
        as?: string, 
        { locale: 'br'}
    )
    
También podemos eshabilitar la opción modificando el prop del componente Link

.. code:: javascript

    <Link href="/br/about-us" locale={ false }/>
    
i18n cookie
-----------

Nextjs también puede colocar una preferencia de idioma por medio de la cookie llamada NEXT_LOCALE, que sería leída por Nextjs. La cookie NEXT_LOCALE tiene prioridad de la detección automática de Nextjs.

.. code:: javascript

    setCookie('NEXT_LOCALE', 'es')
    
Arquitectura de i18n para labels
================================

Todo el texto se extrae del código y se mueve a un archivo JSON (locales/es.json)

Se crea un archivo para cada idioma. Se carga el archivo según el local.

.. code:: javascript 

    function myComponent(){
         <h3>{myText.key}</h3>
    }
    
Separamos cada traducción por componente. Es decir, algo parecido a:

.. code:: javascript 

    // locale/es/componente.json
    {
      "buy": "Comprar",
      "vender": "Vender" 
    }
    
Podriamos crear un componente similar a 

.. code:: javascript 

    function useTranslate(){
        const ctx = useContext(localeContext)
        const locale = ctx.getCurrentLocale()
        const labels = ctx.labels.get(locale)
        return labels
    }
    
Librerías de i18n en React
--------------------------

Ya existen librerías que manejan la i18n en react.

* react-intl
* react-i18next
* lingui
* rosetta
* next-intl

i18n con next-i18next
=====================

Primero debemos envolver nuestra app en la función appWithTranslation que nos provee la librería.


.. code:: javascript 

    import { appWithTranslation } from 'next-i18next'

    export function index(){}

    export default appWithTranslation(index)
    
Para implementar SSR debemos asegurarnos de devolver la configuración de i18n en nuestra función getStaticProps:

.. code:: javascript 

    import { serverSideTranslations } from 'next-i18next/ServerSideTranslations'
    export const getStaticProps: GetStaticProps<OurProps> = async({locale}) => {

        const i18nConf = await ServerSideTranslations(locale!)

        return {
            props: {
                items, 
                ...i18nConf
                }
            }
        
    }

Tras lo anterior ya podemos usar el hook para marcar las cadenas que queremos traducir. Solo tenemos que indicarle, por medio de un array, el componente o los componentes en los que se encuentran las traducciones del componente.

.. code:: javascript 

    import { useTranslation } from 'next-i18next'
    
    export function componente(){
        const {t} = useTranslation(['common'])
        return <h2>{t('pages')}</h2>
    }

