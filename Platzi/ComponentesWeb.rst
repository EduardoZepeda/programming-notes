===============
Componentes web
===============

Los Web Components son un conjunto de tecnologías para desarrollar aplicaciones de frontend utilizando tecnologías nativas que soporta cualquier navegador, hechos para ser reutilizables sin la necesidad de una librería o framework.

Pueden entenderse como piezas de lego, hechas de código, que se combinarán para crear una aplicación web. La diferencia con los frameworks es que, al estar basadas en estándares web, no es necesario que pertenezcan al mismo framework o librerías.

¿Qué son los web component?
===========================

Primitivos de bajo nivel que te permiten definir tus propias etiquetas HTML.

Y para poder construirlos necesitamos un set de webAPIs.

* HTML templates
* Custom Elements
* Shadow DOM
* ES Modules

webAPIs
=======

HTML5 es el estandar principal de etiquetas donde cada etiqueta es interepretada por el navegador.

Custom Elements
---------------

Son etiquetas HTML personalizadas que el navegador es capaz de interpretar.

Mínimo dos palabras separadas por un guión, con el fin de que no entren en conflicto con las etiquetas HTML5

HTMLTemplate 
------------

Se refiere a la etiqueta <template>, una plantilla flexible para rellenar el Shadow DOM. La cual no es renderizada en la página web, sino que solo va a retornar un document fragment, que requiere Javascript para renderizarse.

Shadow DOM
----------

Se refiere al encapsulamiento del código para que incorporen cierta funcionalidad sin tener que escribirla. Por ejemplo la etiqueta <video>: Incorpora múltiples funcionalidades por defecto, como un botón de play, de pausa y una barra de progreso. Toda esa funcionalidad está encapsulada y no fue escrita al momento de utilizar la etiqueta.

ES Modules
----------

Se refiere a las importaciones de código usando ECMA script 6

Beneficios de usar webcomponents
================================

Reutilización
-------------

Permite seguir la máxima de DRY. Pues podemos reutilizar los componentes previamente escritos.

Legibilidad
-----------

Favorece la semántica y la legibilidad

Mantenibilidad
--------------

Al ser unidades aisladas es posible testearlas de manera independiente.

Interoperabilidad y consistencia 
--------------------------------

Es posible combinar diferentes web componentes entre sí, o incluso dentro de frameworks.

Ciclo de vida de un componente
==============================

El ciclo de vida de un componente consiste en:

* constructor: Cuando se crea el componente,  directamente desde el JavaScript Engine, el constructor definirá y cargará las variables a usar. Es mala práctica pintar el componente en esta etapa.
* connectedCallback: Cuando el componente ya es un nodo del DOM.
* attributeChangedCallback: Se dispara cuando un atributo de nuestro componente se modifica.
* disconnectedCallback: Se ejecuta cuando el componente es eliminado del DOM.
* adoptedCallback: Es un caso extremedamente raro, ocurre cuando el componente se adopta dentro de un iFrame.


Crear custom Elements
===================== 

Algunos métodos útiles para recordar

* document.createElement: Crea una nueva etiqueta en memoria.
* element.setAttribute: Establece un atributo a alguna etiqueta.
* element.getAttribute: Obtiene el atributo de una etiqueta.
* element.textContent: Establece el contenido en texto de una etiqueta.
* element.innerHTML: Establece el contenido HTML de una etiqueta. **Usarlo con input del usuario, o de alguna fuente que no se controle, se considera mala práctica**
* element.appendChild: Inserta esa etiqueta que estaba en memoria al DOM real.

Importación
-----------

Primero importemos el archivo que contendrá nuestros módulos de web components

.. code-block:: html

    <script type="module" src="./elements.js">

Y dentro de este archivo crearemos una clase que herede de HTMLElement.

.. code-block:: javascript

    class myEtiqueta extends HTMLElement {
        constructor () {
            super()
        }
    }

Creación del componente
-----------------------

Para crearlo especificaremos el nombre de la etiqueta y posteriormente la clase en el método define de customElements

.. code-block:: javascript

    customElements.define('mi-etiqueta', myEtiqueta)

Una vez hecho esto ya podemos añadirla a nuestro archivo HTML

.. code-block:: html

    <mi-etiqueta>

Agregar etiquetas HTML, bajo nivel
----------------------------------

Podemos crear propiedades para usar en nuestro componente usando la palabra this y luego usarlas cuando querramos.

.. code-block:: javascript

    class myEtiqueta extends HTMLElement {
        constructor () {
            super()
            this.p = document.createElement('p')
        }
        connectedCallback() {
            this.p.textContent = "Hola mundo con append"
            this.appendChild(this.p)
        }
    }

Agregar etiquetas con innerHTML, bajo nivel
-------------------------------------------

También es posible agregar estilos directamente.

.. code-block:: javascript

    const template = document.createElement('div')
    template.innerHTML = `
        <p>Hola mundo con innerHTML</p>
        <style></style>
    `
    class myEtiqueta extends HTMLElement {
    // ...
        connectedCallback() {
            //...
            this.appendChild(template)
        }
    }

Templates
=========

Para simplificar la creación de elementos y volverlo más escalable y repetible usamos la etiqueta contenedora <template>, dentro de la cual podemos colocar código HTML.

.. code-block:: html

    <template>
        <h2>Título</h2>
        <p>Texto</p>
    </template>

Si solo la usamos así, sin renderizar, obtendremos un #document-fragment. Para renderizarlo necesitamos Javascript.

Agregando contenido con clonedNode
----------------------------------

Es posible clonar el contenido y añadirlo usando appendChild, seguido del método clonedNode del contenido de la etiqueta <template>.

.. code-block:: javascript

    class myEtiqueta extends HTMLElement {
        constructor () {
            super()
        }

        getTemplate() {
            const template = document.createElement('template')
            template.innerHTML = `<h2>Subtitulo</h2>`
        }

        render() {
            this.appendChild(this.getTemplate().content.clonedNode(true))
        }

        connectedCallback() {
            this.render();
        }
    }


ShadowDom
=========

Puede entenderse como un DOM independiente del DOM global, por lo que se evitan los conflictos entre ellos.

.. code-block:: javascript

    class myEtiqueta extends HTMLElement {
        constructor () {
            super()
            this.attachShadow({ mode: "open" })
        }
    }

Esto retornará un #shadow-root (open) dentro del código HTML, creará una capa extra, por lo que para acceder a este shadowRoot necesitamos acceder directamente a la propiedad del mismo nombre de nuestro componente.

Al usar un shadowDOM se crea un DOM independiente, por lo que cualquier cambio al DOM principal quedará anulado y evitaremos errores por reescrituras de estilos y otros problemas similares.

.. code-block:: javascript

    this.appendChild(...) //Ya no hace nada
    this.shadowRoot.appendChild(...) // Esto sí

¿Dónde encontrar web components?
================================

Es posible encontrar múltiples web components escritos por la comunidad o incluso por empresas como Google en el `Sitio web oficial de web components <https://www.webcomponents.org/>`_ 