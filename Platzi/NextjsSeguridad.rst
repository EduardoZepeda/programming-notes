===============================
Next.js Seguridad web con OWASP
===============================

OWASP es una organización que aboga por las buenas prácticas de seguridad en las aplicaciones web, su `sitio web <https://owasp.org>`_ contiene una serie de recomendaciones; generales, para cada aspecto de un sitio web, desde la recuperación de contraseña hasta el loggeo; y específicas, destinadas a una sola tecnología como docker o ruby on rails.

A1: Injection
=============

Es el agregar parte de una consulta para crear instrucciones extras que serán ejecutadas en el lado del servidor.

.. code-block:: bash

    'Name'); DROP TABLE USERS;

Generalmente estos errores suceden al usar consultas sql por medio de vanilla js, python, etc.

Prevención de Injection
-----------------------

* Evitar usar el intérprete.
* Usar herramientas ORM como Prisma, TypeORM.
* Validar siempre los datos de entrada.

A7: Cross-site scripting o XSS
==============================

Son un tipo de ataque donde se logra ejecutar código en los navegadores de los usuarios que acceden a un sitio web legítimo. Por ejemplo, la inserción de etiquetas script para ejecutar código arbitrario o simplemente con propósitos intrusivos como alerts y confirms de javascript. 

Prevención de XSS 
-----------------

* Validación en formularios por medio de HTML5 (usando los tipos de input) o Yup.
* El texto debe ser usado para fines de presentación.

Sanitize HTML
-------------

Sanitize HTML nos permite sanear el texto que recibimos de los usuarios.

.. code-block:: javascript

    const safeHTML = sanitizeHTML(value)

    const safeHTMLWithTags = sanitizeHTML(value, {
        allowedTags: ['strong', 'a', 'em', 'b'],
        allowedAttributes: {
            a: ['href', 'target']
        }
    })

Otras reglas de prevención
==========================

* Evitar el uso de eval
* Evitar document.write, inner.HTML y outerHTML
* Usar con precaución node.innerText
* Preferir usar node.textContent

Broken Authentication
=====================

Recomendaciones, usar oAuth, OpenID

Protección de sesiones en el cliente
====================================

Para proteger una sesión creamos 

.. code-block:: javascript

    if (session == null) {
        return <p>Acceso denegado</p>
    }

Oauth en nextjs se encargará de escuchar los cambios en la sesión y devolverá el componente que le indiquemos.

Es buena práctica crear un componente separado para manejar el contenido protegido

.. code-block:: javascript

    <Protected>Contenido Protegido</Protected>

¿Donde guardar una sessión?
===========================

Podemos guardarlo en las cookies o en el local storage, cada cual con sus fortalezas y debilidades. 

El sessión ID no debe ser obvio, estar expuesto en la URL o dar información sobre las tecnologías o frameworks del cual provienen.

Cookies
=======

Hay algunos atributos muy útiles para manejar la seguridad de nuestras cookies.

Es la opción preferida, además tenemos múltiples atributos que nos ayudan con la seguridad.

Atributo secure
---------------

Para mandar la cookie solo por una conexión segura de HTTPS.

Atributo HttpOnly
-----------------

Las cookies serán accesibles únicamente por http, no por código javascript.

Atributo SameSite
-----------------

Controla si una cookie de terceros debe enviarse en peticiones entre sitios.

Sus atributos son:

* None: Las cookies se pueden usar entre sitios
* Lax: Permite a las peticiones GET accesar a las cookies, pero no a las POST.
* Strict: Deshabilitará el envío de las cookies a cualquier sitio web de terceros. Las cookies se enviarán solo si el dominio es el mismo que el path, para el cual la cookie ha sido colocada.

Path 
----

Limita el alcance de la cookie usando el flag *Path*.

Expiration 
----------

Usa una fecha de expiración tan corta como sea posible.

Web Storage
===========

* LocalStorage. Persistente a través de sesiones en páginas del mismo origen. **Nunca debe usarse para guardar información sensible**
* SessionStorage. Persiste solo mientras la pestaña está abierta.

¿Dónde guardar un token JWT?
============================

JWT en Cookies
--------------

Estaremos seguros contra ataques XSS, pero inseguros contra CSRF.

Session Storage
---------------

Nos mantendremos seguros contra ataques de CSRF, pero estaremos inseguros contra ataques XSS.

Recomendaciones de OWASP
------------------------

La recomendación para sesiones es

* Guardar tokens en el sessiónStorage.
* Fingerprint adicional contra XSS

La recomendación para cookies es

* Si se usan cookies usar los atributos Secure y HttpOnly.
* PRotección adicional contra CSRF.

Next Auth
---------

Nextjs se encarga de realizar la Autenticación en el navegador. 
Los JWT se crea en el server y se manda como cookie con los atributos Secure y HttpOnly.
Además, Next Auth usa CSRF para páginas de login y logout.

Guardar tokens
--------------

Podemos usar un webworker para interceptar las peticiones web y adjuntarles un token, de la misma manera puede recibir las peticiones y limpiarlas de datos sensibles. Una desventaja es que no todos los navegadores tienen soporte para estos, además es sensible al mismo tipo de vulnerabilidades.

Estrategia de las dos cookies
=============================

Peter Locke propone llevar a cabo la autenticación diviendo el JWT en dos cookies:

* header.payload. Con atributo secure y duración de 30 minutos. Pueden leerse por el frontend.
* signature. Con atributo secure y HttpOnly. No disponible para el frontend y que se pierde una vez se cierra el browser.

Más información en su `post en medium <https://medium.com/lightrail/getting-token-authentication-right-in-a-stateless-single-page-application-57d0c6474e3>`_ 

Sensitive data exposure
=======================

Todo tipo de información sensible jamás debe de mandarse en un token que persista en el tiempo ni almacenarse en el local storage.

¿Cuánto tiempo debería durar un access_token?
---------------------------------------------

A mayor tiempo de existencia de duración mayor peligro. Pero depende del tipo de aplicación. Se tiene que encontrar un balance. No es lo mismo el tiempo de sesión para un banco o una red social. El primero querra un tiempo muy corto, mientras que el segundo lo más largo posible.

OWASP recomienda tiempos muy cortos de almacenaje.

Session Storage es ideal para bancos, páginas de trading u otra información sensible pues la sesión dura hasta que se cierra el navegador.

Ajustar tiempo con Next Auth
----------------------------

.. code-block:: javascript

    const options: NextAuthOptions = {
    session: {
        jwt: true,
        MaxAge: 60 * 15 
        }
    }

Token firmados y encriptados en Nextjs
======================================

En NextAuth, de manera predeterminada, el token es firmado pero no encriptado.

Tiempo de sesión
----------------

Para cambiar el secreto del JWT.

.. code-block:: javascript

    const options: NextAuthOptions = {
    session: {
        jwt: true,
        MaxAge: 60 * 15
        },
    jwt: {
        secret: process.env.AUTH_JWT_SECRET
        }
    }

Donde AUTH_JWT_SECRET debe ser una llave SHA de 256 bits.

Llave de firmado
----------------

También podemos definir la llave que se usa para firmar en el mismo objeto jwt en NextAuthOptions

.. code-block:: javascript

    const options: NextAuthOptions = {
    session: {
        jwt: true,
        MaxAge: 60 * 15
        },
    jwt: {
        secret: process.env.AUTH_JWT_SECRET,
        signingKey: process.env.AUTH_JWT_SIGNING_KEY
        }
    }

Estas llaves pueden crearse con el paquete de npm llamado *node-jose-tools*.

.. code-block:: bash

    jose newkey -s 256 -t oct -a HS512
    # {kty: "oct", kid: "", alg: "HS512", k: ""}

El resultado se pasa tal cual como un objeto.

También podemos crear una llave simétrica para encriptar

.. code-block:: javascript

    const options: NextAuthOptions = {
        session: {
            jwt: true,
            MaxAge: 60 * 15
        },
        jwt: {
            secret: process.env.AUTH_JWT_SECRET,
            signingKey: process.env.AUTH_JWT_SIGNING_KEY,
            encryption: true,
            encryptionKey: process.env.AUTH_ENCRYPTION_KEY
            }
    }

De la misma manera que en el ejemplo anterior, es posible generar la AUTH_ENCRYPTION_KEY con el paquete *node-jose-tools*

.. code-block:: bash

    jose newkey -s 256 -t oct -a A256GCM
    # {...}

Para especificar otros algoritmos de cifrado cambiamos la opción *decryptionOptions*.

.. code-block:: javascript

    jwt: {
        decryptionOptions = {
            algorithms: ['A256GM']
        }
    }

También existen hooks para especificar nuestras propias opciones de cifrado

.. code-block:: javascript

    jwt: {
        async encode({secret, token, maxAge}) {},
        async decode({secret, token, maxAge}) {},
    }