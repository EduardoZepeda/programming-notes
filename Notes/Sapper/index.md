# 1. Sapper

Permite crear aplicaciones de alto rendimiento y manejo de rutas para
[Svelte](../Svelte/1.-Svelte.md).


## 1.1 Caracteristicas principales:

-   Añade a svelte manejo de rutas
-   Trabajar con SSR y capa de SEO
-   Incorpora Service Worker para PWA
-   Exportar sitio a estaticos
-   Compilar y enviar a produccion

## 1.2 Instalación

Podemos usar poka o express para servir los archivos.

``` bash
npm install sapper --save-dev
npm install polka compression sirv
```

Ahora con un archivo server.js

``` javascript
import sirv from 'sirv';
import compression from 'compression';
import polka from 'polka';
import * as sapper from '@sapper/server';

const { PORT, NODE_ENV } = process.env;
const dev = NODE_ENV === 'development';

polka()
  .use(
    compression({ threshold: 0 }),
    sirv('static', { dev }),
    sapper.middleware()
  )
  .listen(PORT, err => {
    if (err) console.log('error', err);
  });
```

Donde PORT y NODE_ENV provienen de un archivo .env en la raiz de nuestra
aplicación

``` bash
NODE_ENV=development
PORT=3000
```

y un archivo client.js

``` javascript
import * as sapper from '@sapper/app';

sapper.start({
  target: document.querySelector('app')
});
```

## 1.3 Crear el template

Ahora en nuestro archivo HTML template que definamos deberemos colocar
las siguientes etiquetas

``` html
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  %sapper.base%
  <link rel="stylesheet" href="global.css">
  %sapper.styles%
  %sapper.head%
</head>

<body>
  <app>%sapper.html%</app>
  %sapper.scripts%
  <script src="https://kit.fontawesome.com/OPCIONAL_AQUI_TU_API.js" crossorigin="anonymous"></script>
</body>
</html>
```

Debemos configurar webpack

``` javascript
const webpack = require('webpack');
const path = require('path');
const config = require('sapper/config/webpack.js');
const pkg = require('./package.json');

const mode = process.env.NODE_ENV;
const dev = mode === 'development';

const alias = { svelte: path.resolve('node_modules', 'svelte') };
const extensions = ['.mjs', '.js', '.json', '.svelte', '.html'];
const mainFields = ['svelte', 'module', 'browser', 'main'];

module.exports = {
  client: {
    entry: config.client.entry(),
    output: config.client.output(),
    resolve: { alias, extensions, mainFields },
    module: {
      rules: [
        {
          test: /\.(svelte|html)$/,
          use: {
            loader: 'svelte-loader',
            options: {
              dev,
              hydratable: true,
              hotReload: false
            }
          }
        }
      ]
    },
    mode,
    plugins: [
      new webpack.DefinePlugin({
        'process.browser': true,
        'process.env.NODE_ENV': JSON.stringify(mode)
      }),
    ].filter(Boolean),
    devtool: dev && 'inline-source-map'
  },

  server: {
    entry: config.server.entry(),
    output: config.server.output(),
    target: 'node',
    resolve: { alias, extensions, mainFields },
    externals: Object.keys(pkg.dependencies).concat('encoding'),
    module: {
      rules: [
        {
          test: /\.(svelte|html)$/,
          use: {
            loader: 'svelte-loader',
            options: {
              dev,
              css: false,
              generate: 'ssr'
            }
          }
        }
      ]
    },
    mode: process.env.NODE_ENV,
    performance: {
      hints: false
    }
  },
};
```

## 1.4 Rutas

Creamos una carpeta llamada *routes*, dentro de esa carpeta tendremos el
punto de entrada a la aplicación, el archivo index.svelte. Dentro de
routes, cada archivo será una ruta. También podemos optar por tener
carpetas para ejemplificar rutas

Es decir, un archivo about.svelte significará la ruta
<http://dominio/about>, mientras que una carpeta settings con un archivo
about.svelte dentro será <http://dominio/settings/about>

``` html
<script>
  import { onMount } from "svelte";
  import Header from "../components/Header.svelte";
  import Main from "../components/Main.svelte";
  import Sidebar from "../components/Sidebar.svelte";
  import TimeLine from "../components/TimeLine.svelte";

  let data = {};
  const API = "https://us-central1-pugstagram-co.cloudfunctions.net/data";

  onMount(async () => {
    const response = await fetch(API);
    data = await response.json();
  });
</script>

<Header />
<Main>
  <TimeLine posts={data.posts} />
  <Sidebar {...data.user} />
</Main>
```

## 1.5 Conectando el template

Creamos una carpeta llamada *static* y dentro colocamos un archivo
*global.css* ahora lo vinculamos a nuestro template por medio de un
link. Sapper automáticamente buscará un archivo *global.css* dentro de
la carpeta static.

``` css
@import url("https://fonts.googleapis.com/css?family=Lato:300,400&display=swap");
@import url("https://fonts.googleapis.com/css?family=Pacifico&display=swap");

body {
  background-color: #fafafa;
  color: rgba(38, 38, 38, 0.7);
  font-family: "Lato", sans-serif;
  margin: 0;
  padding: 0;
}

h1, h2, h3 {
  margin: 0;
  padding: 0;
}
```

Ahora dentro de rutas podemos especificar los layouts colocando un guión
bajo antes del nombre \_layout para que no se consideren como una
sección.

``` html
<main>
  <slot />
</main>
```

El componente main va a ser el componente principal dentro del cual irá
la aplicación.

Hay que modificar el archivo *package.json* para que llegue así

``` javascript
"dependencies": {
  "compression": "^1.7.4",
  "polka": "^0.5.2",
  "sirv": "^0.4.2"
},
"devDependencies": {
  "svelte": "^3.18.2",
  "sapper": "^0.27.12",
  "svelte-loader": "^2.13.6",
  "webpack": "^4.41.6"
}
```

## 1.6 Manejo de .gitignore

Es recomendable excluir las siguientes rutas

``` bash
src/node_modules
__sapper__
```

## 1.7 Segment

Segment nos permite obtener datos sobre las rutas para hacer
validaciones. Esta variable la pasaremos al componente para poder
acceder a ella.

``` html
<script>
    export let segment
<script/>
<Componente {segment}/>
```

Y luego podemos acceder a ella en el componente que nosotros necesitemos
para hacer validaciones personalizadas.

## 1.8 Aplicando las rutas

Para poder usar una ruta simplemente usamos una etiqueta *anchor* normal
que tenga un href con el mismo nombre que el componente que se encuentre
en *routes* que querramos renderizar.

``` html
<a aria-current={segment === 'profile' ? 'page' : undefined} href='profile'></a>
```

En el código de arriba se va a renderizar nuestro archivo
profile.svelte, con el contenido que nosotros le hayamos especificado.

Por ejemplo

``` html
<script>
  import Main from '../components/Main.svelte'
</script>

<style>
.Profile {
  padding: 4em 0 0 0;
}
</style>

<svelte:head>
  <title>Configuración del Perfil</title>
</svelte:head>

<Main>
  <div class="Profile">
    <h2>Configuración del perfil</h2>
  </div>
</Main>
```

### 1.8.1 Manejo de errores y 404

Podemos manejar los errores (incluyendo el 404) con un componente
*\_error.svelte* dentro de la carpeta *routes*. Podemos acceder al tipo
de error y el status a partir de las variables error y status,
respectivamente. Podemos colocar errores que solo se muestren en
desarrollo por medio de etiquetas if.

``` html
<script>
  import Main from '../components/Main.svelte'
  export let status
  export let error

  const dev = process.env.NODE_ENV === 'development'
</script>

<style>
    .Error {
        padding: 4em 0 0 0;

    }
    h1, p {
        margin: 0 auto;
    }
    h1 {
        font-size: 2.8em;
        font-weight: 700;
        margin: 0 0 0.5em 0;        
    }
</style>


<svelte:head>
  <title>{status}</title>
</svelte:head>

<Main>
  <div class="Error">
    <h1>{status}</h1>
    <p>{error.message}</p>
    {#if dev && error.stack}
        {pre}{error.stack}</pre>
    {/if}
  </div>
</Main>
```

## 1.9 Prefetch

Prefetch precarga los componentes para que estén listos a usarse cuando
el usuario haga click en ellos, lo logra llevando a cabo un seguimiento
del mouse. Para hacer uso de esta herramienta simplemente agregamos un
atributo llamado rel con el valor de "prefetch".

``` html
<a aria-current={segment === 'profile' ? 'page' : undefined} rel="prefetch" href='profile'></a>
```

## 1.10 goto

goto nos permite llevar a un usuario a otra ruta, la diferencia con
anchor es que esta podemos usarla como parte de la lógica de la
aplicación, ya sea tras una llamada API o algun otro proceso

``` html
<script>
    import {goto} from "@sapper/app"

    const navigateHome = async () => {
        await goto('/')
    }
</script>


<Componente>
    <h1 on:click={navigateHome}>Home</h1>
</Componente>
```

## 1.11 SSR

Especificamos otra etiqueta script a la cual le vamos a asignar la
función preload() de un module, exportamos una function que se encargará
de proveer los datos que necesitaremos para nuestra aplicación. Es
importante señalar que *no estamos usando la función fetch nativa de
javascript*, sino una modificada, por eso proviene de this.

``` html
<script context="module">
    export async function preload(){
        let data = {}
        const response = await this.fetch(NUESTRA_URL)
        data = await response.json();
        return {data}    
    }
</script>
```

Si desactivamos javascript desde el navegador podremos observar que el
contenido está siendo mandado desde el servidor.

## 1.12 Service worker

Para transformar la aplicación en una PWA creamos un archivo llamado
*service-worker.js* dentro de src/ con el siguiente contenido:

``` javascript
import { timestamp, files, shell, routes } from '@sapper/service-worker';

const ASSETS = `cache${timestamp}`;
const to_cache = shell.concat(files);
const cached = new Set(to_cache);

self.addEventListener('install', event => {
  event.waitUntil(
    caches
      .open(ASSETS)
      .then(cache => cache.addAll(to_cache))
      .then(() => {
        self.skipWaiting();
      })
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(async keys => {
      for (const key of keys) {
        if (key !== ASSETS) await caches.delete(key);
      }
      self.clients.claim();
    })
  );
});

self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET' || event.request.headers.has('range')) return;
  const url = new URL(event.request.url);
  if (!url.protocol.startsWith('http')) return;
  if (url.hostname === self.location.hostname && url.port !== self.location.port) return;
  if (url.host === self.location.host && cached.has(url.pathname)) {
    event.respondWith(caches.match(event.request));
    return;
  }

  if (event.request.cache === 'only-if-cached') return;

  event.respondWith(
    caches
      .open(`offline${timestamp}`)
      .then(async cache => {
        try {
          const response = await fetch(event.request);
          cache.put(event.request, response.clone());
          return response;
        } catch (err) {
          const response = await cache.match(event.request);
          if (response) return response;

          throw err;
        }
      })
  );
});
```

Después modificamos el archivo webpack.config.js

``` javascript
serviceworker: {
  entry: config.serviceworker.entry(),
  output: config.serviceworker.output(),
  mode: process.env.NODE_ENV
}
```

Después deberemos crear un archivo manifest.json dentro de la carpeta
static/

``` json
{
  "background_color": "#ffffff",
  "theme_color": "#333333",
  "name": "Proyecto",
  "short_name": "proyecto",
  "display": "minimal-ui",
  "start_url": "/",
  "icons": [
    {
      "src": "logo-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "logo-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

Hay que recordar agregar los favicons e iconos que estamos especificando
en la configuración.

Luego en el archivo que estamos usando como plantilla *template.html*
crearemos una meta etiqueta para el manifest

``` html
<head>
    ...
    <link rel="manifest" href="manifest.json" crossorigin="use-credentials"/>
    <link rel="icon" type="image/png" href="favicon.ico"/>
</head>
```

Podremos apreciar si el manifest está funcionando en las herramientas de
desarrollador en el navegador.

## 1.13 Deploy con Sapper Export

Sapper puede compilar y exportar todo el sitio para exportarlo de forma
estática, sin necesidad de un servidor. Para ver los resultados de
manera local podemos usar el commando sapper export.

Una vez que nos aseguremos que funciona podremos subirlo a github y usar
netlify para ponerlo en producción.

Si tenemos un error debemos modificar el archivo *netlify.toml*

``` html
bash
        command = "npm run export"
        publish = "__sapper__/export"
```
