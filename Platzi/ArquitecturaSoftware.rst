========================
Arquitectura de Software
========================

Etapas del desarrollo de Software
=================================

El proceso de desarrollo tradicional sigue un modelo donde cada salida es la entrada del siguiente paso, como un pipeline.

Análisis de requerimientos: Necesitamos entender cuál es el problema que queremos resolver, es decir, la necesidad del negocio.

Diseño de la solución: Análisis profundo de los problemas y sus posibles soluciones. El resultado de esto debe ser el detalle de la solución, a través de requerimientos, modelado, etc.

Desarrollo y evolución: Implementación de la solución. Al final de esta etapa tendremos software como salida.

Despliegue: Aquí vamos a necesitar de infraestructura y de roles de operación para poner a disponibilidad nuestro software.

Mantenimiento y evolución: Estamos en espera de mejoras. El software permanecerá en esta etapa hasta que concluya su periodo de vida.

Dificultades en el desarrollo de software
=========================================

Cuando estamos identificando los problemas que queremos resolver, podemos dividir los problemas en 2

Esenciales: Los podemos dividir en 4.

* La complejidad: Cuando el problema es complejo en si mismo, por ejemplo del problema del vendedor viajero aplicado. Manejo del problema de complejidad: Usar un sistema existente o aprovechar código Open Source.
* La conformidad: en qué contexto se usa el software y cómo se adapta al entorno. Manejo del problema: Prototipado rápido, feedback e iteraciones rápidas para soluciones pequeñas, generalmente usando metodologías ágiles.
* Tolerancia al cambio: Cambio de el mismo software y el contexto donde se usa. Manejo del problema: Desarrollo Evolutivo, desarrollos pequeños. Paso a paso pero de manera firme e ir haciendo crecer el software.
* Invisibilidad: Problemas de tangibilidad nula.
Manejo del problema: Grandes diseñadores, Arquitectos que saben abtraer el problema y que realiza soluciones elegantes, de manera eficiente.

Accidentales:

Está relacionado con la plataforma que vamos a implementar, tecnología, lenguajes, frameworks, integraciones, entornos, etc.

Roles en metodologías tradicionales y ágiles
============================================

Se tiene que separar el rol del puesto de trabajo. Una misma persona puede desempeñar varios roles.

Experto del dominio: En una metodología tradicional, es la persona a la que acudimos para entender las necesidades del negocio. En metodologías Ágiles --> stakeholders.

Analista: La persona responsable de los requerimientos. En el caso de Ágiles el dueño del producto es quien arma las historias y que nos acompaña en el proceso de construcción del software.

Administrador de sistemas / DevOps: Se refiere a operaciones y desarrollo, responsables de toda la infraestructura y comunicar el feedback.

Equipo de desarrollo: QA / Testing, que se encargan del testeo del Software. Desarrolladores, para implementar funcionalidades. Y Arquitecto, diseña la solución y análisis de los requerimientos, es un papel más estratégico.

Gestor del proyecto / facilitador: Acompañan al equipo a través de las iteraciones, para entender y motivar al equipo.

¿Qué es arquitectura de software?
=================================

Hay diferentes definiciones para definir el término de arquitectura de Software. 

El libro Software Architecture in Practice se enfoca en la estructura y los elementos del sistema.

    “La estructura del sistema, compuesta por elementos de software, sus propiedades visibles y sus relaciones”

    Software Architecture in Practice

Mientras que el libro Software Architecture: Foundations, Theory and Practice se centra más bien en las decisiones.

    “El conjunto de decisiones principales de diseño tomadas para el sistema”

    Software Architecture: Foundations, Theory and Practice

La importancia de la comunicación - Ley de Conway
=================================================

La ley de Comway dice que:

    “Cualquier pieza de software refleja la estructura organizacional que la produjo.”

Por lo que un equipo único producirá un monolito, mientras que un equipo separado producirá una aplicación modularizada.

Objetivos del Arquitecto
========================

Cada uno de los stakeholder tiene que ser conectado por el Arquitecto con sus requerimientos.

Stakeholder -> Arquitecto -> Requerimientos = Implementaciónes en el Sistema.

Los Requerimientos de cada stakeholder afectan de forma única el sistema.

* Cliente: Entrega a tiempo y dentro del presupuesto.
* Manager: Permite equipos independientes y comunicación clara.
* Dev: Que sea fácil de implementar y de mantener.
* Usuario: Es confiable y estará disponible cuando lo necesite.
* QA: Es fácil de comprobar.

La unión de todos estos requerimientos llevarán al arquitecto a tomar sus decisiones.

Entender el problema
====================

Es muy importante separar la comprensión del problema de la propuesta de solución. 

Problema
--------

Detalla lo que queremos resolver, no entra en detalles del como, y el alcance de nuestro problema, además de como va a agregar valor a nuestros usuarios

* Idea: ¿Qué queremos solucionar?
* Criterios de éxito: ¿Cómo sabremos si resolvemos el problema?
* Historias de usuario: Enfasis en los beneficios del usuario respecto a su problema.

Solución
--------

Entra y aisla los detalles sobre como se va a resolver el problema teniendo en cuenta todos los detalles técnicos del problema.

Consta de:

* Diseño: Planificacion del software, desde diseño UI, UX hasta diseño de sistemas.
* Desarrollo: escribir el codigo, configuraciones y contrataciones de servicios.
* Evaluación: medir la eficiencia y eficacia del software frente al problema.
* Criterios de aceptación: medir el impacto del software centrado en el usuario.
* Despliegue (deploy): lanzar el software en ambientes productivos y mejorar por medio de iteraciones.

Requerimientos
==============

Requerimientos de producto
--------------------------

Se puede dividir en 3.

Requerimientos de negocio
^^^^^^^^^^^^^^^^^^^^^^^^^

Son las reglas de negocio 

Capa del usuario
^^^^^^^^^^^^^^^^

El desenvolvimiento del usuario en el sistema

Capa funcional
^^^^^^^^^^^^^^

Son los requisitos que tienen ocurrir cuando la aplicación esté operando

Requerimientos de proyecto
--------------------------

Tienen que ver más con el rol de gestor de proyectos, se usan para dar prioridad a los requerimientos del producto.

Estos dos mundos de requerimientos hablan de las prioridades del equipo de trabajo del proyecto.

Requerimientos de acuerdo a funcionalidad
-----------------------------------------

De acuerdo a su personalidad, existen requisitos funcionales, relacionados con las historias de usuario, y requisitos no funcionales, que tienen que ver con las características del sistema, están muy relacionados con la arquitectura. Actualmente, los requisitos funcionales se relacionan con los no funcionales.


Riesgos
=======

Es necesario identificar los riesgos para poder **priorizarlos** y atacarlos en orden y asegurar que las soluciones arquitectónicas que propongamos resuelvan los problemas más importantes.

Podemos usar un framework para identificar los riesgos:

* Toma de Requerimientos (Requerimientos funcionales)
Se calificará de acuerdo a su dificultad o complejidad.
* Atributos de calidad (Requerimientos NO funcionales):
Se calificará de acuerdo a la incertidumbre que genere, a mayot incertidumbre mayor riesgo.
* Conocimiento del dominio:
Riesgo prototípico, son aquellos que podemos atacar de forma estándar.

Una vez identificados debemos priorizarlos para resolver aquellos riesgos que ponen en riesgo el éxito de la solución.No todos los riesgos podrán cubrirse en un inicio.

Reestricciones
==============

Las limitaciones a las opciones de diseño disponibles para desarrollar no se limitan a la parte tecnológica, pueden ser también legales o relacionadas con el contexto de negocio.

Estilos de arquitectura
=======================

Citando a Software Architecture: Foundations, Theory and Practice (Taylor, 2010)

    Un estilo de arquitectura es una colección de decisiones de diseño, aplicables en un contexto determinado, que restringen las decisiones arquitectónicas específicas en ese contexto y obtienen beneficios en cada sistema resultante.

Existen diferentes estilos de arquitectura: 

Llamado y retorno
-----------------

Los componentes invocan a componentes externos y reciben la información que les proporcionan.

Llamadas y subrutinas
^^^^^^^^^^^^^^^^^^^^^

se tiene una rutina y se manda a llamar otra subrutina en donde la subrutina puede retornar o no un resultado, pero la rutina principal continua hasta que acabe la subrutina.

Orientado a objetos 
^^^^^^^^^^^^^^^^^^^

Tratamos de juntar el estado de la aplicación creando objetos los cuales tienen una interfaz publica y los objetos interactuan entre si.

Arquitectura multinivel 
^^^^^^^^^^^^^^^^^^^^^^^
Son diferentes componentes que se van a comunicar en un orden en especifico donde un componente principal crea el llamado a un componente inferior en algún momento, un ejemplo de esto son las aplicaciones cliente-servidor.


Flujo de datos
--------------

Este estilo se utiliza cuando tenemos un proceso con una salida clara; la salida puede segmentarse en partes. 

Secuencial
^^^^^^^^^^

Se basa en dividir el trabajo en subproceso llamados lotes los cuales se procesan uno tras otro y dan un resultado que sirve como entrada para el siguiente

Tubos y filtros
^^^^^^^^^^^^^^^

Igualmente se divide el trabajo en subproceso pero la principal ventaja es que es continuo, y puede haber procesos en paralelo además se pueden añadir o remover procesos sin afectar el comportamiento del resto.

Centrados en datos
------------------

Pizarrón
^^^^^^^^

Múltiples componentes que interactuan con un componente central, cada componente tiene la responsabilidad de procesar, calcular o recibir un dato y escribirlo al componente central; el pizarrón. El pizarrón puede o no devolver una salida de acuerdo a su propia lógica. Es un estilo poco común.

Centrado en datos 
^^^^^^^^^^^^^^^^^

Ideal para aplicaciones con base de datos que tienen una segunda aplicación con la misma base de datos. Los componentes **no se comunican entre sí**, estos directamente utilizan la base de datos y así pueden leer que hizo el otro componente.

Experto o basado en reglas
^^^^^^^^^^^^^^^^^^^^^^^^^^

El componente de tipo cliente se comunica con un segundo componente, que intentará inferir  si recibe una regla o una consulta, para saberlo consulta con con el tercer componente; la base de datos de reglas o knowledge database. Generalmente usado en Inteligencia Artificial.


Componentes independientes
--------------------------

Se trata de un estilo que busca el desacoplamiento de los componentes. 

Existen dos tipos: invocación implícita e invocación explicíta.

Invocación implícita
^^^^^^^^^^^^^^^^^^^^

Se suele basar en eventos. Los componentes pueden comunciarse sin saber a quien le está hablando.

Es parecido al patrón observer, con un bus central de eventos sobre el cual escriben los componentes, el bus comunica los eventos a los componentes adecuados.

Existen buses sencillos donde un componente publica un evento y los componentes suscritos reciben la notificación

También hay buses con lógica (Enterprise Service Bus). El cual tiene componentes registrados que interactuan con el bus, los componentes no se conocen entre si, pero están programados para cumplir con su objetivo.

Invocación explícita
^^^^^^^^^^^^^^^^^^^^

Componentes desarollados individualmente pero que se concen entre sí. 


¿Cómo elegir un estilo?
=======================

Se dividen en estilos monolíticos y distribuidos

monolíticos
-----------

Sencillos pues todos los componentes están en un mismo lugar.

Distribuidos
------------

Más complicados pues cada parte es un despliegue diferente y quizás deban tenerse consideraciones al momento de comunicarse por red. Se puede considerar a cada servicio individual es como un monolito.