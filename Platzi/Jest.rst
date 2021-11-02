====
Jest
====

Jest es un framework de JavaScript para pruebas.

¿Qué es un test?
================

Como developers tenemos que garantizar que el codigo escrito cumpla con
ciertos requisitos/expectativas. Esto lo hacemos por medio de una prueba
(test).

Esto nos asegura:

-  Nuestro codigo cumple con el standar.
-  Enviamos a producción sin errores.

Tipos de pruebas
----------------

Debemos tener en cuenta que existen dos tipos de pruebas:

-  

   Funcionales.
      -  Pruebas Unitarias.- Se prueban pequeñas partes de nuestro
         codigo asegurandonos así que cumplen con lo que se desea. (En
         una pagina web las pruebas se traducen a probar cada sección de
         la pagina y todas las interacciones en ellas).

-  No funcionales.

Instalación
===========

Para instalarlo lo hacemos desde npm:

.. code:: bash

   npm install jest --save-dev

Dentro de la carpeta src colocaremos una carpeta en su interior llamada
\__test__, la cual tendrá un archivo llamado global.test.js:

.. code:: javascript

   |-- package.json
   ``-- src
       |-- index.js
       ``-- __test__
           ``-- global.test.js

   2 directories, 3 files

Las pruebas se harán desde global.test.js
-----------------------------------------

En el archivo global.test.js Jest esperará una función llamada test, que
recibirá un string y una funcion anónima:

.. code:: javascript

   test('string', ()=> {
       expect(text).toMatch(/patron/);
   })

Recuerda agregar el comando jest a los scripts de npm:

.. code:: javascript

   "scripts": {
     "test": "jest"
   },

Promesas
========

Las pruebas en promesas se llevan a cabo de la siguiente manera:

.. code:: javascript

   test('Prueba de una promesa', ()=> {
       return myPromise('texto').then(texto=>{
           expect(texto).toBe('resultado');
       })
   })

O usando async y await:

.. code:: javascript

   test('probar async/await', async()=> {
       const string = await myPromise('texto');
       expect(string).toBe('resultado');
   })

Ejecutar código después de cada prueba
======================================

Para ejecutar código despus de cada prueba o despues de todas las
pruebas usamos:

.. code:: javascript

   afterEach(()=>{})
   afterAll(()=>{})

Ejecutar código antes de cada prueba
====================================

Y para ejecutar codigo antes de cada prueba o antes de todas las
pruebas:

.. code:: javascript

   beforeEach(()=>{})
   beforeAll(()=>{})

Describe
========

Describe nos permite crear una serie de test:

.. code:: javascript

   describe('Probar muchas pruebas', ()=>{
       test('Test uno', ()=>{})
       test('Test uno', ()=>{})
       test('Test uno', ()=>{})
   })

watch
=====

Podemos pedirle a jest que se quede vigilando las pruebas con el flag
--watch:

.. code:: javascript

   "scripts": {
     "test:watch": "jest --watch"
   },

coverage
========

Podemos revisar la porción del código cubierto por las pruebas con el
flag --coverage:

.. code:: javascript

   "scripts": {
     "test:coverage": "jest --coverage"
   },

De la misma manera creará una carpeta nueva llamada coverage, con un
reporte en html que muestra las partes del código no cubiertas por las
pruebas.

Instalación de otras dependencias
=================================

Necesitamos instalar las dependencias necesarias para hacer test a los
componentes, estas son:

.. code:: bash

   npm i -D jest enzyme enzyme-adapter-react-16

-  enzyme: Es una librería creada por airbnb para facilitar el test a
   componentes en React
-  enzyme-adapter-react-16: Es un adaptador para la versión de React que
   estemos utilizando.

Más información en la documentación

Configuración en package.json

Le pasamos la configuración del adaptador al projecto en package.json:

.. code:: javascript

   "devDependencies": {...},
   "jest": {
     "setupFilesAfterEnv": [
       "<rootDir>/src/__test__/setupTest.js"
     ]
   }

Si queremos que jest muestre las descripciones de cada prueba añadiremos
el atributo verbose igual a e en la configuración:

.. code:: javascript

   "devDependencies": {...},
   "jest": {
     "verbose": true,
     "setupFilesAfterEnv": [
       "<rootDir>/src/__test__/setupTest.js"
     ]
   }

Enzyme nos ayudará a montar el componente, y podemos traer el componente
directo de nuestra aplicacinó y usar el componente montado para nuestras
pruebas:

.. code:: javascript

   import React from 'react';
   import { mount } from 'enzyme';
   import Footer from '../../components/Footer';

   describe('<Footer/>', ()=>{
       test('Render del component Footer', ()=> {
           const footer = mount(<Footer/>);
           expect(footer.length).toEqual(1);
       });
   });

Sin embargo recordemos que Enzyme no reconoce estilos, por lo que
necesitamos emular la función de estos estilos usando Mock

Mock
====

Para esto creamos una carpeta dentro del proyecto llamada \__mocks_\_ y
agregamos un archivo que exportará un objeto vacio

.. code:: javascript

   module.exports = {};

Ahora agregaremos esa configuración al archivo package.json, junto con
el resto de la configuración de jest.

.. code:: javascript

   "jest": {
     "setupFilesAfterEnv": [
       "<rootDir>/src/__test__/setupTest.js"
     ],
     "moduleNameMapper": {
       "\\.(styl|css)$": "<rootDir>/src/__mocks__/styleMock.js"
     }
   }

Todos los archivos terminados en styl o css coincidirán con la búsqueda
y serán reemplazados por styleMock.js

Sobre el scope de los components
================================

Para asegurarnos que los componentes estén disponible para todas
nuestras funciones test, debemos colocarlos dentro de la función
principal de describe():

.. code:: javascript

   describe('<Footer/>', ()=>{
       const footer = mount(<Footer/>);
       test('Render del component Footer', ()=> {
           expect(footer.length).toEqual(1);
       });
       test('Render del título', ()=>{
           expect(footer.find(".Footer-title").text()).toEqual("Platzi Store")
       });
   });

Testear con BrowserRouter y Redux
=================================

Para testear un componente que cuenta con un estado y un router
necesitamos crear un componente con un mockup que englobe a nuestro
componente a testear:

.. code:: javascript

   import React from 'react';
   import { createStore } from 'redux';
   import { Router } from 'react-router-dom';
   import { Provider } from 'react-redux';
   import { createBrowserHistory } from 'history';
   import initialState from '../initialState';
   import reducer from '../reducers';

   const store = createStore(reducer, initialState);

   const history = createBrowserHistory();

   const ProviderMock = props => {
       <Provider store={store}>
           <Router history={history}>
               {props.children}
           </Router>
       </Provider>
   }

   export default ProviderMock;

Shallow y Mount
===============

¿Cuándo utilizar mount y cuándo utilizar shallow?

-  mount se usa cuando necesitas el DOM
-  shallow permite traer elementos y probarlos como una unidad. Es útil
   cuando solo necesitamos algo particular de ese componente y no
   necesitamos toda su estructura y elementos del DOM. Shallow ni
   siquiera realiza el DOM rendering que hace React

Snapshots
=========

Es para componentes estáticos que solo representan una estructura
visual. De gran utilidad para asegurarnos que la UI no cambia.

Para usarlo necesitamos instalar la librería react-test-renderer:

.. code:: bash

   npm install react-test-renderer --save-dev

A continuación instalamos create del mismo paquete:

.. code:: javascript

   import { create } from 'react-test-rendered';

   //...
   describe('Footer Snapshot', ()=>{
       test('Comprobar la UI del componente Footer', ()=> {
           const footer = create(<Footer/>);
           expect(footer.toJSON()).toMatchSnapshot();
       })
   })

Creamos el Footer con create y luego lo transformamos en un JSON para
compararlo con el snapshot. Si el snapshot no existe se creará al
momento de correr las pruebas.

Reescribiendo el snapshot
=========================

Si queremos reescribir el snapshot basta con correr este comando:

.. code:: bash

   jest --updateSpapshot

Probar actions
==============

Para probar actions necesitamos probar el payload:

.. code:: javascript

   import actions from '../../actions/';
   import ProductMock from '../../__mocks__/ProductMock';

   describe('Actions', ()=>{
       test('addToCart action', ()=>{
           const payload = ProductMock;
           const expected = {
               type: 'ADD_TO_CART',
               payload
           };
           expect(actions.addToCart(payload)).toEqual(expected)
       });
   });

Probar reducers
===============

Para probar reducers probamos así mismo lo que devuelve cada uno de
ellos:

.. code:: javascript

   import reducer from '../../reducers';
   import ProductMock from '../../__mocks__/ProductMock';


   describe('Reducers', ()=>{
       test('Retornar initial State', ()=>{
           expect(reducer({}, '')).toEqual({});
       })
   })

en el caso de arriba, como el reducer recibe un estado y devuelve otro,
le pasamos un objeto vacio y una cadena vacia (que no coincidirá con
ningún caso) y retornar el objeto vacio.

Probar Fetch
============

Para probar fetch necesitamos reemplazar el global fetch en nuestro
archivo de configuración setupTest.js:

.. code:: javascript

   import { configure } from 'enzyme';
   import Adapter from 'enzyme-adapter-react-16';

   configure({ adapter: new Adapter() });

   global.fetch = require('jest-fetch-mock');

Ahora que la función ha sido reemplazarda, necesitamos sustituir el
valor que devolvería la función fetch como respuesta. Ahora cada
petición deóvolverá un objeto con la propiedad data igual a 12345, el
cual podemos usar para las pruebas:

.. code:: javascript

   import getData from '../../utils/getData';

   describe('Fetch API', ()=>{
       beforeEach(()=>{
           fetch.resetMocks();
       });
       test('Llamar una API y retornar datos', ()=> {
           fetch.mockResponseOnce(JSON.stringify({ data: '12345'}));
           getData('https://example.org')
           .then((response)=> {
               expect(response.data).toEqual('12345');
           })
           expect(fetch.mock.calls[0][0]).toEqual('https://example.org')
       })
   })

Métodos utiles de pruebas
=========================

Para comparar un string usamos toMatch

.. code:: javascript

   expect('string').toMatch(/rin/);

Para corroborar que un array cuente con un elemento usamos toContain

.. code:: javascript

   expect([banana, limon, pera]).toContain('banana');

Para comparar dos elementos números usamos toBeGreaterThan

.. code:: javascript

   expect(10).toBeGreaterThan(9);

Para ver si un valor es truthy usamos toBeTruthy

.. code:: javascript

   expect(true).toBeTruthy();
