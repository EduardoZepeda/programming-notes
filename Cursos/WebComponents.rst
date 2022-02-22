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

Primero importemos el archivo que contendrá nuestros módulos de web components. **Recuerda que la importación debe ocurrir debajo del web component.** También es importante que uses un servidor durante el desarrollo, de otra manera al acceder a elementos externos tendremos un error de cors. Por ejemplo: `http-server <https://www.npmjs.com/package/http-server>`_  

.. code-block:: html

    <script type="module" src="./elements.js">

Dentro de este archivo crearemos una clase que herede de HTMLElement.

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        constructor () {
            super()
        }
    }

Creación del componente
-----------------------

Para crearlo especificaremos el nombre de la etiqueta y posteriormente la clase en el método define de customElements

.. code-block:: javascript

    customElements.define('mi-etiqueta', MiEtiqueta)

Una vez hecho esto ya podemos añadirla a nuestro archivo HTML

.. code-block:: html

    <mi-etiqueta>

Agregar etiquetas HTML, bajo nivel
----------------------------------

Podemos crear propiedades para usar en nuestro componente usando la palabra this y luego usarlas cuando querramos.

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
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
    class MiEtiqueta extends HTMLElement {
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

Agregando contenido con cloneNode
---------------------------------

Es posible clonar el contenido y añadirlo usando appendChild, seguido del método cloneNode del contenido de la etiqueta <template>.

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        constructor () {
            super()
            this.attachShadow({ mode: "open" })
        }

        getTemplate() {
            const template = document.createElement('template')
            template.innerHTML = `<h2>Subtitulo</h2>`
            return template
        }

        render() {
            this.appendChild(this.getTemplate().content.cloneNode(true))
        }

        connectedCallback() {
            this.render();
        }
    }


ShadowDom
=========

Puede entenderse como un DOM independiente del DOM global, por lo que se evitan los conflictos entre ellos.

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        constructor () {
            super()
            this.attachShadow({ mode: "open" })
        }
    }

Esto retornará un #shadow-root (open) dentro del código HTML, creará una capa extra, por lo que para acceder a este shadowRoot necesitamos acceder directamente a la propiedad del mismo nombre de nuestro componente.

Al usar un shadowDOM se crea un DOM independiente, por lo que cualquier cambio al DOM principal quedará anulado y evitaremos errores por conflictos en estilos y otros problemas similares.

Y, cualquier referencia al anterior deberá hacerse por medio del objeto **shadowRoot** en lugar de **document**.

.. code-block:: javascript

    this.appendChild(...) //Ya no hace nada
    this.shadowRoot.appendChild(...) // Esto sí


Content Slot
============

Es una etiqueta que nos permite darle interactividad al componente, para pasarle información de manera dinámica.

.. code-block:: html

    <my-etiqueta>Contenido a pasar</my-etiqueta>

Para usarlo pasamos la etiqueta <slot> al contenido de nuestro template en el shadowRoot.

.. code-block:: javascript

    template.innerHTML(`
        <h2>
            <slot></slot>
        </h2>
    `)
    
Multi content slots
===================

Para agregar múltiples slots podemos asignarles un nombre 

.. code-block:: javascript

    // código javascript
    <h2><slot name="newTitle"></slot></h2>
    <p><slot name="content"></slot></p>

Y ahora en nuestro HTML hacemos referencia a esos nombres

.. code-block:: html

    <!-- Código HTML-->
    <mi-etiqueta>
        <span slot="newTitle">Titulo</span>
        <span slot="content">Contenido</span>
    </mi-etiqueta>


Atributos a las etiquetas
=========================

Es posible usar los atributos en nuestras etiquetas personalizadas y acceder a ellas con Javascript. Es un concepto parecido a los props.

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        constructor() {
            // ...
            this.newTitle = this.getAttribute("newTitle")
            this.content = this.getAttribute("content")
            this.img = this.getAttribute("img")
        }
        getTemplate(){
            const template = document.createElement("template")
            template.innerHTML = `
                <section>
                    <h2>${this.newTitle}</h2>
                    <p>${this.content}</p>
                    <img src=${this.img}/>
                </section>
            `
            return template
        }
    }

En el código HTML le pasamos esos atributos a la etiqueta personalizada.

.. code-block:: html

    <mi-elmento newTitle="titulo" content="contenido" img="https://example.org/example.jpg"></mi-elemento>


attributeChangedCallback
========================

Para vigilar cuando cambien los atributos necesitamos crear un observador llamado *observedAttributes*, que retorne la lista de atributos a observar, el resto de atributos se ignorarán. **Recuerda observarlos en minúsculas, recuerda que los atributos que recibe el componente HTML se pasan a minúsculas.**

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        // ...
        static get observedAttributes() {
            return ['newtitle', 'content', 'img']
        }
    }

Ahora ya podemos reemplazar el método *attributeChangedCallback*. Recibe tres parámetros:

* valor actual
* valor antiguo
* nuevo valor

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        // ...
        static get observedAttributes() {
            return ['newtitle', 'content', 'img']
        }
        attributeChangedCallback(attribute, currentValue, newValue) {
            this[attr] = newValue
            // ...
        }
    }

Es importante **No usar atributos que ya forman parte de HTML (como title) o se generará un error Maximum call stack size exceeded.** 

connectedCallback
=================

Ocurre cuando el elemento se agrega al DOM. 

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        // ...
        connectedCallback() {
            console.log("El componente se carga en el DOM")
        }
    }

disconnectedCallback
====================

Es el último paso del ciclo de vida de un componente. **Es importante desvincular *eventListeners* antes de que un componente se desmonte** del DOM.

.. code-block:: javascript

    class MiEtiqueta extends HTMLElement {
        // ...
        disconnectedCallback() {
            console.log("El componente se separa del DOM")
        }
    }

:host
=====

Es una pseudoclase que sirve para darle estilos al componente web. Adentro de host colocamos todos los estilos querramos. Sirve como el :root de un componente. La pseudoclase requiere **de manera forzosa** la presencia del shadowRoot.


.. code-block:: javascript

    constructor() {
        // ...
        this.attachShadow({ mode: "open" })
    }

    getTemplate() {
        return `
        
            ${this.getStyles()}
        `
    }

    getStyles() {
        return `
            <style>
                :host {
                    width: 100%;
                }
            </style>
        `
    
    }

    render() {
        this.shadowRoot.appendChild(this.getTemplate().content.cloneNode(true))
    }

Clases en :host
---------------

Podemos pasarle clases a nuestro web component

.. code-block:: html

    <mi-etiqueta class="blue"></mi-etiqueta>

Para posteriormente verificar si le fue pasada  y personalizar el estilo de manera condicional

.. code-block:: javascript

    :host(.blue) {
        background: blue;
    }

Atributos en :host
------------------

Si queremos usar atributos 

.. code-block:: html

    <mi-etiqueta green></mi-etiqueta>

Para posteriormente verificar si le fue pasada  y personalizar el estilo de manera condicional

.. code-block:: javascript

    :host([green]) {
        background: green;
    }

Contexto en :host
-----------------

Este contexto se refiere al padre del web component.

.. code-block:: html

    <article class="card">
        <mi-etiqueta>
    </article>


.. code-block:: javascript

    :host-context(article.card) {
        display: flex;
    }


Es decir, los estilos se aplicarán a cualquier componente que se encuentre dentro de una etiqueta article con una clase card.
Verifica si tu navegador es compatible primero ya que **no todos los navegadores dan soporte para :host-context**. A la última fecha de revisión de este apunte, ni Firefox ni Safari ofrecen compatibilidad para esta función.

Custom properties
-----------------

Es posible generar variables dentro de :host para evitar repetir valores, estas variables se comportarán similar a :root en CSS.

.. code-block:: javascript

    getStyles {
        return `
            <style>
                :host {
                    --primary-color: salmon;
                    --secondary-color: Seashell;
                }
                section {
                    background: var(--primary-color);
                }
                section div {
                    background: var(--secondary-color);
                }
            </style>
        `
    }

Para reescribir los estilos externamente basta con reescribir los estilos en CSS o la etiqueta style referenciando al nombre de la etiqueta, como si se tratara de cualquier otra.

.. code-block:: css

    mi-etiqueta {
        --primary-color: green;
        --secondary-color: black;    
    }


::slotted
=========

Pseudoelemento que sirve para poder agregar estilos específicos al contenido dinámico, es decir dentro de etiquetas slot, que provenga de fuera del componente y se vaya a inyectar en las etiquetas slot.

No puede usarse de forma dinámica solo con el shadow DOM.

.. code-block:: javascript

    getStyles {
        return `
            <style>
                ::slotted(span) {
                    font-size: 1.5rem;
                }
                ::slotted(.text) {
                    color:red;
                }
            </style>
        `
    }

Esto dotará de estilos a las clases anidadas en nuestro web component

.. code-block:: html

    <mi-etiqueta>
        <span>Texto grande</span>
        <span class="text">Texto rojo</span>
    </mi-etiqueta>


¿Dónde encontrar web components?
================================

El `Sitio web oficial de web components <https://www.webcomponents.org/>`_ ofrece múltiples web components escritos por la comunidad o incluso por empresas como Google.
