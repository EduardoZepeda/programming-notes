======
Travis
======

Continuous integration y continuous delivery
============================================

Continuous integration
----------------------

Integración continua, sirve para preparar y servir un release de forma
sencilla y ágil

Continuous delivery
-------------------

También conocido como despliegue continuo. Es la extensión de la
integración continua. Su objetivo es poder entregar o desplegar nuevos
cambios a los clientes.

.. figure:: img/Travis/CIyCD.png
   :alt: image

   image

Fases
-----

-  Plan: Requerimientos a cumplir, en este curso trabajaremos en un
   proyecto ya definido.
-  Code: Fase de desarrollo (features).
-  Build: Agrupación de features.
-  Test: Comprobación de calidad para las features.
-  Release: Paquete de código listo para mandar a producción.
-  Deploy: Software operando en un ambiente de producción.

Cuenta de Travis
================

Travis requiere **forzosamente** una cuenta de Github o BitBucket. Desde
el 2018 ya aceptan proyectos privados y open-source, sin necesidad de
pagar por el servicio. Anteriormente travis.org se encargaba de los
repositorios públicos y travis.com de los repositorios privados.

Archivo de configuraciones
==========================

Lenguaje y sistema operativo
----------------------------

La configuración de travis se hará a partir de un archivo con nombre
**travis.yml**, debe encontrarse como archivo oculto, **.travis.yml**.
Dentro del archivo es posible establecer un lenguaje, un sistema
operativo, una profundidad de commits. Dado que trabaja con git, podemos
bloquear o especificar ramas, con except y only, respectivamente.

.. code:: yaml

   language: node_js
   os: osx

Branches
--------

La configuración de branches nos permite declarar las ramas sobre las
que trabajará travis-ci

.. code:: yaml

   # blocklist
   branches:
     except:
     - legacy
     - experimental

   # safelist
   branches:
     only:
     - master
     - stable

Git
---

La directiva git y depth permiten declarar la profundidad de commits que
abarcará travis-ci. El tope de commits que puede clonar travis-ci es de
50.

.. code:: yaml

   git:
     depth: 3

Instalaciones
-------------

Install le dice a travis las instalaciones que necesitará

.. code:: yaml

   install:
     - yarn install

before_install
~~~~~~~~~~~~~~

before_install nos permite agregar dependencias antes de ejecutar el
archivo.

.. code:: yaml

   before_install:
     - python

scripts
-------

script nos da los comandos disponibles que se ejecutarán antes de un
despliegue

.. code:: yaml

   script:
     - yarn deploy
     - yarn test

before_script
~~~~~~~~~~~~~

before_script y after_script nos otorgan un hook que correrá antes de la
ejecución de scripts.

.. code:: yaml

   before_script:
     - clean

   after_script:
     - yarn clean

after_script
~~~~~~~~~~~~

after_script es un hook que se ejecuta después de la ejecución de script

.. code:: yaml

   after_script:
     - yarn clean

Cache
-----

Usamos la cache para especificar aquellos recursos que necesitamos
mantener entre integraciones. Es bastante común excluir node_modules y
.npm en los archivos de configuración.

.. code:: yaml

   cache:
     directories:
       - node_modules
       - .npm

Jobs
====

Los jobs establecen el flujo de trabajo.

.. code:: yaml

   jobs:
     include:
       - stage: test
         script: yarn test
         script: yarn eslint
       - stage: deploy
         script: yarn deploy

Ciclo de Jobs
=============

Cada trabajo es una secuencia. Las fases principales son:

-  install - Instalación de depdencias
-  script - Ejecuta el script de compilación

Travis CI puede ejecutar ciertos comandos en cada fase

   before_install - Antes de la fase install before_script - Antes de la
   fase script after_script - Después de la fase script after_success -
   Cuando el compilado es exitoso. El resultado se guarda en la variable
   de entorno TRAVIS_TEST_RESULT after_failure - Cuando el compilado
   falla resultado se guarda en la variable de entorno
   TRAVIS_TEST_RESULT

Existen tres fases opcionales de despliegue

La secuencia completa es la siguiente:

1.  OPTIONAL Install apt addons
2.  OPTIONAL Install cache components
3.  before_install
4.  install
5.  before_script
6.  script
7.  OPTIONAL before_cache (Sí y solo si caching está activo)
8.  after_success or after_failure
9.  OPTIONAL before_deploy (Sí y solo si despliegue está activo)
10. OPTIONAL deploy
11. OPTIONAL after_deploy (Sí y solo si despliegue está activo)
12. after_script

Deploy
======

Deploy nos permite pasarle una serie de configuraciones, tales como el
provider, el repositorio

.. code:: yaml

   deploy:
     provider: heroku
     on
       repo: user/repo

Deploy tiene varias opciones, como los directorios de salida, el
github-token, un mensaje de commit, la rama objetivo, etc.

.. code:: yaml

   deploy:
     provider: pages
     skip-cleanup: true
     keep-history: true
     github-token: $GITHUB_TOKEN
     local-dir: dist/
     target-branch: gh-pages
     commit_message: "deploy_proyecto"
     on:
       branch: master

La variable de entorno $GITHUB_TOKEN, puede ser aplicada en la
configuración de travis. Esta variable la conseguimos en la cuenta de
github en settings -> developer settings -> personal token. Los permisos
que elegiremos serán los de **admin:repo_hook, repo**

Plataforma de Travis
====================

La plataforma nos permite sincronizar nuestros repositorios, añadir
tareas periódicas y otras opciones.

Notificaciones
==============

Email
-----

Travis nos permite enviar notificaciones por correo. Con on_success
enviará un correo cuando la ejecución es exitosa, por otro lado, con
on_failure, el correo se enviará cuando la ejecución falle.

.. code:: yaml

notifications:
   email:
      recipients: - usuario@midominio.com -
      otro_usuario@miotrodominio.dev on_success: always on_failure:
      always

Slack
-----

Además de correo electrónico Travis permite enviar una notificación a un
canal de Slack. Es necesario contar con los permisos adecuados en
Slack.Para ver las configuraciones podemos hacerlas desde la sección
"App" de slack. La configuracion nos permite elegir un canal, multiples
canales, cifrado, token, el nombre del usuario que publica.

.. code:: yaml

   notifications:
     slack: workspace:token

Deploy en Heroku
================

Heroku permite activar hooks para hacer deploy de un proyecto
automáticamente cuando se hace push al repositorio. Para activarlo
necesitamos crear una nueva app, conectar la cuenta de github y activar
los deploys automáticos.

.. code:: yaml

   deploy:
     provider: heroku
     skip-cleanup: true
     keep-history: true
     api_key: la-api-key-de-heroku
     app: nuestra-app
     on:
       repo: usuario/repositorio

Si travis-ci nos retorna un 0 significará un deploy exitoso con las
pruebas aprobadas.

Travis CLI
==========

Instalación de Travis CLI
-------------------------

.. code:: bash

   sudo apt install ruby-full

Ahora con Ruby instalado usamos el comando gem

.. code:: bash

   gem install travis

Cifrado
-------

Travis permite encriptar inforamción con el comando travis encriptar. De
esta manera podemos poner nuestra llave en nuestros archivos de
configuración.

.. code:: yaml

   api_key:    
       secure: "..."
