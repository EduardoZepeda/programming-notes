=======
Jenkins
=======

Jenkins es una herramienta en Java open source de CI. Debido a que es bastante usado existen múltiples plugins, escritos en Java, desarrollados por la comunidad. 

Permite la escalabilidad horizontal y vertical, puede correr un sin número de trabajo concurrentemente en una sola máquina.

Jenkins nos permite escalar horizontalmente con "slaves" y controlar varios nodos para que trabajen por él.

Instalación y configuración
===========================

A la fecha de la última actualización de estas notas, Jenkins requiere Java 8, otras versiones presentarán dificultades para usarse. Además de Java, Jenkins requiere Git, por lo que es necesario tener ambos instalados.

Puedes revisar las instrucciones de instalación para todods los dispositivos en `su página de descargas <https://www.jenkins.io/download/>`_ 

Instalación para debian
-----------------------

Agregamos las keys de Jenkins al sistema.

.. code-block:: bash

    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null

A continuación agregamos Jenkins al repositorio

.. code-block:: bash

    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

Se instala como cualquier otro paquete

.. code-block:: bash

    sudo apt install jenkins

Accediendo a jenkins
--------------------

Una vez creado podemos acceder a la interfaz de jenkins en el puerto 8080. Sin embargo **necesitaremos una contraseña autogenerada que se encuentra en el directorio de jenkins /var/jenkins_home/secrets/initialAdminPassword**.

.. image:: img/Jenkins/PantallaPrincipalJenkins.png

Tras colocar el password, se nos presentarán dos opciones 

* Instalación con plugins por defecto
* Instalación de los plugins personalizados

Creando un admin
----------------

La siguiente pantalla es un formulario con datos del usuario admin de jenkins.

.. image:: img/Jenkins/CreandoUsuarioAdmin.png

Agregando un dominio
--------------------

Jenkins permite agregar un dominio personalizado en la siguiente pantalla. Es recomendable crear un subdominio en lugar de usar la dirección ip.

Creación de usuarios
====================

Es una cuestión de seguridad el contar con una cuenta por usuario, con fines de trazabilidad.

La ubicación para gestionar usuarios reside en la pestaña Manage Jenkins y después en manage users.

Además Es posible crear autenticación por medio de terceros, como github y Google.

Jobs
====

Los jobs son la piedra central de Jenkins. Se ejecutan de manera concurrente por el Build Executor. Pueden existir jobs de diferentes tipos:

* Freestyle project
* Pipeline
* Folder
* Multi-configuration project

La siguiente es la pantalla de creación de un Job

.. image:: img/Jenkins/CreacionDeUnJob.png

Donde podremos especificar descripciones, 

Freestyle project
-----------------

Es el estilo más viejo y más versátil de Jenkins.

.. image:: img/Jenkins/MenuCreacionDeUnJob.png

En la pestaña build environment podemos ejecutar comandos tal cual si estuvieramos en la terminal de GNU/Linux.

.. tip:: Al ejecutar cada shell es necesario realizar nuevamente los cambios de carpeta, pues se reinicia el working directory.

.. image:: img/Jenkins/TerminalJob.png

El job puede ejecutarse a mano dando un click en dando **build now**.

Si todo salió bien, podremos verificar el output

.. image:: img/Jenkins/VerificarOutputBuild.png

Configuración de Jobs
======================

Dentro de la pestaña General podemos especificar varias acciones entre ellas algunas importantes 

Descripción
-----------

La descripción de nuestro job.

Duración de los build
---------------------

Podemos especificar la duración en donde queremos guardar los builds, ya sea por cantidad de días o por número de builds. 

La configuración anterior se verá reflejada en *build history*.

Pasarle parámetros
------------------

Especificamos parámetros y su tipo a nuestros jobs. Que estarán disponibles como si fueran variables de entorno.

.. code-block:: bash

    echo "Hola $NAME"

Disable this project
--------------------

Para evitar que corra un job.

Source code management
----------------------

Aquí podemos guardar credenciales de github.

Build triggers
--------------

Para ejecutar un build ya sea por medio de una API, de manera periódica, como respuesta a un git pull en gitbub.

Build environment
-----------------

El entorno de pruebas, es **necesario marcar la casilla delete work before build starts** para evitar cualquier conflico con información que se queda en el folder de trabajo.

Entre otras opciones permite colocar variables secretas en archivos, abortar un job tras cierto tiempo transcurrido.

Post-build actions
------------------

La más importante es *archive the artifacts*, combinada con *watch other jobs*.

Interacción con máquina local
=============================

Para que Jenkins interaccione con la máquina local, jenkins usará los binarios que están disponibles en la máquina donde se está ejecutando, es **necesario corroborar que Jenkins tenga los permisos necesarios**.

Sin embargo es recomendable utilizar las herramientas o plugins integradas de Jenkins para evitar perder la portabilidad si migramos el proyecto a otra máquina.

Plugins de jenkins
==================

Los plugins son unidades que extienden las funcionalidades de Jenkins. Los plugins estarán disponibles dentro del plugin manager. 

Cada instalación puede instalarse sin reiniciar o hacerlo tras un reinicio. **Para no interrumpir los jobs podemos instalarlo y reiniciar después**, una vez que usemos esta opción, jenkins no aceptará nuevos jobs hasta que ocurra el reinicio.

.. image:: img/Jenkins/PluginsJenkins.png

Ahora los paquetes que instalemos estarán disponibles para usarse en las areas pertinentes de Jenkins.

Los cambios en los paquetes se pueden realizar dentro de la sección configureTools.

Cadena de jobs
==============

Jenkins nos permite llamar jobs desde otros jobs, esto por medio de la instalación de un plugin llamado "parameterized triggers", que habilita la opción,  dentro de job/<name>/configure, Trigger/call builds on other projects, desde la configuración de un job.

Esto nos permite ejecutar un job cuando otro se crea y tendremos muchas variables de entorno disponibles. 

Al crear una dependencia de jobs se modificará la sección Downstream projects

.. image:: img/Jenkins/ParameterizedJobJenkins.png

También podemos llamar el job con una variable de entorno.

.. image:: img/Jenkins/TriggerJenkinsPlugin.png

Hay múltiples variables de entorno disponibles en Jenkins, se pueden ver completas en `/env-vars.html <https://tuurl.com/env-vars.html/>`_ Hay un enlace en la sección de script de bash.

.. image:: img/Jenkins/EnvironmentalVariables.png

Estos jobs que se ejecutan al ejecutarse uno se añaden como jobs non-blocking en la sección de Subprojects.

.. image:: img/Jenkins/TriggersJenkins.png

Conexión con github
===================

Para conectarse con github necesitamos colocar la url del repositorio dentro de la pestaña source Code Management.

.. image:: img/Jenkins/CredencialesGithubJenkins.png

Para ejecutar los tests en cualquier rama dejamos la sección "branches to build" en blanco.

Y en los build triggers necesitamos usar Github hook trigger

.. image:: img/Jenkins/GithubHookTriggerJenkins.png

Recuerda especificar la versión de Node u otros plugins en Build Environment

.. image:: img/Jenkins/JenkinsBuildEnvironment.png

Conectando Github con Jenkins
-----------------------------

Dentro de la sección de configuración de nuestro repositorio de github, podemos crear un webhook, que creará un petición a la url que le indiquemos.

**Se necesita una slash al final de la url**

.. image:: img/Jenkins/GithubWebhook.jpg

Pipeline
========

Al momento de crear un job podemos hacerlo como un pipelina. 

.. image:: img/Jenkins/PipelineJobJenkins.png

Para crear un Pipeline vamos a la pestaña de Pipeline, después de crear el job.

.. image:: img/Jenkins/PipelineSyntax.png

Los Pipelines nos permiten configurar nuestros Jobs usando una CLI en lugar de interactuar con la GUI. En Jenkins existen dos maneras: 

* Scripting
* Declarative

Puedes pensar en un pipeline como el equivalente a un Dockerfile en Docker.

.. code-block:: bash

    pipeline {
    agent any
    tools {
        nodejs 'node-17.0.0'
    }

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    stages {
        stage('Install dependencies') {
        steps {
            sh 'cd tests && npm install'
        }
        }
        stage('Run tests') {
        steps {
            sh 'cd tests && npm test'
        }
        }
    }
    }

La separación en stages permite monitorear su tiempo, errores y poder optimizarlo.

Existe una herramienta que vuelve más visual el manejo de los pipelines llamado `Blue Ocean <https://www.jenkins.io/projects/blueocean/>`_ 