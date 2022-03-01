=======
Jenkins
=======

Jenkins es una herramienta en Java open source de CI. Debido a que es bastante usado existen múltiples plugins, escritos en Java, desarrollados por la comunidad. 

Permite la escalabilidad horizontal y vertical, puede correr un sin número de trabajo concurrentemente en una sola máquina.

Jenkins nos permite escalar horizontalmente con "slaves" y controlar varios nodos para que trabajen por él.

Instalación y configuración
===========================

Jenkins requiere Java y Git, por lo que es necesario tenerlos instalados.

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

Una vez creado podemos acceder a la interfaz de jenkins en el puerto 8080. Sin embargo **necesitaremos una contraseña autogenerada que se encuentra en el directorio de jenkins /var/jenkins_home/secrets/initialAdminPassword**

Tras colocar el password, se nos presentarán dos opciones 

* Instalación con plugins por defecto
* Instalación de los plugins personalizados

Creando un admin
----------------

La siguiente pantalla es un formulario con datos del usuario admin de jenkins.

Agregando un dominio
--------------------

Jenkins permite agregar un dominio personalizado en la siguiente pantalla. Es recomendable crear un subdominio en lugar de usar la dirección ip.

Creación de usuarios
====================

Es una cuestión de seguridad el contar con una cuenta por usuario, con fines de trazabilidad.

La ubicación para gestionar usuarios reside en la pestaña Manage Jenkins y después en manage users.

Además Es posible crear autenticación por medio de terceros, como github y Google.

