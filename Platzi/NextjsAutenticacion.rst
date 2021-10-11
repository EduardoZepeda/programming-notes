========================
Autenticación con Nextjs
========================

Autenticación clásica y moderna
===============================

Existen dos modelos de autenticación: clásica y la moderna.

Clásica
-------

Se realiza por cookies. Se crea un objeto en el servidor que persiste en todos los request del cliente. Generlamente usada por los frameworks de PHP, Django y sistemas antiguos. 

Es stateful, porque el servidor mantiene y controla por completo las sesiones.

Moderna
-------

Se crea un token firmado por el servidor y enviado al cliente. El cliente puede leer algunas partes del token, pero no crear nuevos. El servidor se encarga de verificar el token y otorgarle acceso.

Es stateless, por que el servidor no lleva un registro del número de tokens creados. La verificación se basa en la firma criptográfica.

Tiene la ventaja de que se ahorra espacio, pues no se necesita guardar los tokens en el servidor.

Oauth
=====

Estandar abierto para la delegación de acceso.

Patrones de autenticación
=========================

1. validar en el cliente
2. validar desde el servidor

Servicios de autenticación
==========================

Para el lado del cliente.

* Firebase
* Magic
* Auth0

Para el lado del servidor, compatibles con cualquier DB

* Iron/
* iron-session
* Auth0

Nextauth.js
===========

Open source y construido para next.js siguiendo buenas prácticas de seguridad.

Configuración
-------------

Instalar next-auth

.. code-block:: go

    npm i next-auth

Crear una variable de entorno en .env o .env.local

.. code-block:: javascript

    NEXTAUTH_URL=http://localhost:3000

Envolver todos los componentes que queramos que tengan acceso a la sesión, para eso es conveniente usar el archivo *_app.tsx*. Le pasamos el objeto *session* que recibimos desde nextjs como un prop a nuestro componente.

.. code-block:: javascript

    import { Provider as AuthProvider } from 'next-auth/client'

    const NextApp = ({pageProps}) => {

    <AuthProvider session={pageProps.session}>
        <App>
    <AuthProvider>
    }

A continuación creamos un archivo dentro de la carpeta *pages/api/auth* para tener una ruta dinámica, este archivo se llamará *[...nextauth].ts* y tendrá un objeto llamado options que le pasaremos a NextAuth. 

.. code-block:: javascript

    import NextAuth from "next-auth";
    import type { NextAuthOptions } from "next-auth";

    const options: NextAuthOptions = {
        theme: 'light',
        debug: true,
        session: {},
        jwt: {},
        providers: [],
    }

    export default NextAuth(options)

El objeto options tendrá una propiedad llamada providers que se refiere a los diferentes métodos de autenticación. Hay muchos proveedores de autenticación que se encuentran disponibles en la `documentación de NextAuth <https://next-auth.js.org/configuration/providers#oauth-providers>`_ 

Autenticación manual
====================

Provider usa oauth por debajo para manejar la autenticación. Si accedemos a la propiedad *Credentials* seremos nosotros quienes nos encargaremos de la autenticación.

.. code-block:: javascript

    providers: [Providers.Credentials({
        name: 'Nombre',
        credentials: {
            password: {
                type: 'password',
                label: 'Nunca pares de...'
            }
        },
        async authorize(credentials) {
            console.log(credentials)
        }
    })]

Creando una pantalla de login 
-----------------------------

El campo credentials será un objeto con diferentes atributos html5, aqui especificamos el password y el label. 
Nextjs se encargará de crear automáticamente la página.

La configuración anterior creará una pantalla de loggeo de manera automática en la ruta */api/auth/signin*

.. image:: ./img/NextjsAuth/NextjsAuthSignin.png

Función authorize
-----------------

Dado que especificamos 'Nombre' como la propiedad name en el objeto *providers* de *NextAuthOptions*, crearemos un archivo con el mismo nombre dentro de *pages/api/auth/*, llamado Nombre.ts que contendrá la función que usaremos para autentificar al usuario. En caso de que la autenticación sea exitosa, retornaremos un usuario. Por favor **no uses el mismo esquema que aquí, pues se compara el password directamente, sin hashear**

.. code-block:: javascript

    import { NextApiHandler } from 'next'

    const credentialsAuth: NextApiHandler<User> = (request, response) => {
        if (request.method!=='POST') {
            response.status(405).end()
            return
        }

        if (request.body.password === 'aprender') {
            const platziUser : User = {
                email: 'Platzi student',
                name: 'student@platzi.com',
                image: ''
            }
            return response.status(200).json(platziUser)
        }
        response.status(401).end()
    }

    export default credentialsAuth

Cookies de Nextjs
=================

Si ahora nos loggeamos en la pantalla creada por nextjs y la autenticación es exitosa, tendremos una cookie de sesión llamada *next-auth.session-token*. Esta cookie viene con la propiedad de HttpOnly y SameSite, por lo que es innaccesible para el código javascript del frontend.

La propiedad Secure se utilizará solo cuando la conexión sea por HTTPS. 

El token es firmado por defecto (JWS) pero no es encriptado (JWE)

.. code-block:: bash

    next-auth.session-token=eyJhbG...


Objeto sessión
==============

El objeto de sesión que viene en la cookie *next-auth.session-token* es innaccesible desde el frontend, por su propiedad HttpOnly, por lo que, para acceder a los datos de sesión usaremos el hook useSession, que hace una petición a la api */api/auth/session* que retorna los datos de la sesión.

.. code-block:: javascript

    {
    "user": {
        "name": "usuario",
        "email": "usuario@correo.com",
        "image": null
    },
        "expires": "2021-11-09T20:11:42.029Z"
    }

Cierre de sesión
================

Nextjs provee métodos para abrir y cerrar sesiones. Podemos usar estos métodos para crear componentes con funcionamiento personalizado.

.. code-block:: javascript

    import { signIn, signOut, useSession } from "next-auth/client";

    function LoginLogout() {
        const [session] = useSession()
        console.log(session)
        if (session == null) {
            return <Button onClick={ () => signIn()}>Login</Button>
        }
            return <Button onClick={ () => signOut()}>Logout</Button>
    }


Manejando el flash of unauthenticated
=====================================
 
Este flash sucede justo despúes del cambio de estado entre un estado de sesión iniciada. El hook *useSession* contiene también un estado de loading que podemos obtener. De esta manera, si se está cargando react no renderizará el componente original

.. code-block:: javascript

    const [session, loading] = useSession()

    if(loading){return null}

Autenticando con Github
=======================

Creamos un Oauth application en `Github <https://github.com/settings/apps>`_ y especificamos el callback como `api/auth/callback/github <http://localhost:3000/api/auth/callback/github>`_ Nextjs ya entiende como manejar esta url.


Ahora agregamos un Provider a la configuración en [...nextauth].ts

.. code-block:: javascript

    providers: [
        Providers.GitHub({
            clientId: process.env.AUTH_GITHUB_ID,
            clientSecret: process.env.AUTH_GITHUB_SECRET
        }),
    ]

Tras agregar los valores en nuestro archivo de variables de entorno. Tendremos un nuevo botón en la página de signin creada por nextjs en *api/auth/signin*

JWT
===

si no existe una base de datos, se utiliza JWT almacenando el token en una cookie. 



