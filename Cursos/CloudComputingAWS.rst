===================
Cloud computing AWS
===================

AWS cómputo se refiere a cualquier producto de AWS que nos permite
servir algún archivo, procesar o calcular algo. Hay varios disponibles:

-  EC2: Son máquinas virtuales que nos renta Amazon por segundo. Hay
   Linux o Windows. Podemos elegir número de CPUs, RAM, discos duros,
   tipo de conectividad, entre otras opciones. Se cobra por segundo
-  Lightsail: Es un producto particular porque es un VPS sobre Amazon
   similar a Dreamhost o Digital Ocean estando en la red de Amazon
   conservando los bajos costos de los VPS comerciales. El costo es fijo
   por mes
-  ECR/ECS/EKS: ECR es donde registramos contenedores, ECS es el
   producto de Amazon para Docker y EKS es el producto de Amazon para
   Kubernetes. Se cobra por capacidades
-  Lambda: Es la infraestructura de Amazon para poder correr diferentes
   funciones.
-  Elastic Beanstalk: Permite correr diversos software o cargas
   productivas, pudiendo autoescalar hacia arriba o hacia abajo de
   manera automática.

AMI
===

Máquinas virtuales llamadas instancias. Cuentan con imágenes
pre-configuradas, llamadas AMIs.

Ephemeral Storage
-----------------

Almacenamiento que existe a menos que apaguemos o destruyamos la
instancia..

Elastic Block Storage
---------------------

Este permanece a pesar que borremos la maquina virtual, podemos hacer
copias, restaurar o ir guardando en caso que este evolucionando algún
proyecto o alguna configuración de las maquinas.

Tipos de instancias EC2
-----------------------

Asegurate de tener la versión correcta de tus instancias o no se ver
ánada.

Las imágenes de Amazon vienen actualizadas con los últimos Drivers

La sección T2/T3 Unlimited en la configuración de la instancia nos sirve
si necesitamos mucha CPU o red, al habilitarla, Amazon nos lo dará sin
límite. El problema es que tiende a ser más costoso. Al parecer está
desactualizado, T2/T3 ya no aparece.

Es recomendable elegir un tagname adecuado para poder saber que hace la
instancia únicamente con verla.

El acceso a la máquina se hacáe por medio de una key. Es recomendable
guardarla en un lugar seguro o sera imposible conectarse por medio de
SSH

Proceso de creación de una instancia EC2
----------------------------------------

Elegimos la imagen principal

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen01.png
   :alt: image

   image

Hay diferentes capacidades entre las que podemos elegir

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen02.png
   :alt: image

   image

Podemos configurar número de instancias, ubicación y otras
características

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen03.png
   :alt: image

   image

Elegimos el tamaño

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen04.png
   :alt: image

   image

Es recomendable usar etiquetas para recordar fácilmente las instancias

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen05.png
   :alt: image

   image

Un grupo de seguridad nos indica los puertos que estarán abiertos, es
bastante similar a usar UFW. En este ejemplo dejamos los puertos básicos
para acceder por SSH y servir contenido por HTTP y HTTPS

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen06.png
   :alt: image

   image

Antes de lanzar la instancia AWS nos presentará un resumen de nuestra
configuración

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen07.png
   :alt: image

   image

Podemos elegir un par de llaves para conectarnos por SSH

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen08.png
   :alt: image

   image

La instancia demorará un poco en lanzarse pero AWS nos avisará cuando
esté disponible

.. figure:: img/cloudComputingAWS/CreacionDeUnaImagen09.png
   :alt: image

   image

Conectarse a la instancia por medio de SSH
------------------------------------------

Primero debemos quitarle permisos al archivo llave que se descargó

chmod 400 nuestra-llave.pem

Y ahora procedemos a conectarnos por medio de ssh

ssh -i <path_del_archivo.pem> ubuntu@<dirección_IP_de_la_instancia>

Imagenes de instancias
======================

Cosas a tener en cuenta al momento de crear imágenes de instancias:

No reboot le indica a Amazon que no apague nuestra instancia para hacer
la copia, se corre el riesgo de copias corruptas.

Esa copia puede usarse para crear imágenes de distintos tamaños al
momento de crear una nueva instancia.

Al reiniciar la instancia se cambia la IP pública, por lo que ya no será
posible acceder a ella usando la misma IP

Snapshots
=========

Una imagen es una una copia total de una instancia. Para copiar una sola
de sus características se usa un Snapshot al volumen, es decir, al disco
duro.

Es mejor crear una imagen nueva o AMI al hacer un cambio mayor en la
instancia, versionando a través de las imágenes en caso de que se
necesite un rollback

Configuración de red
====================

Es importante establecer una IP Elastic si quieres mantener tu IP
pública fija con cada reinicio.

Balanceadores de carga
======================

Usando un balanceador de carga podemos balancear peticiones HTTP, HTTPS
o TCP con los servicios de AWS.

Cuando creamos un load balancer, podemos ver en sus configuraciones
básicas un DNS el cual podemos usar en Route 53 como CNAME para ponerme
un nombre de dominio o subdominio.

Accedemos a la opción de balanceadores de carga en el menú principal

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga00.png
   :alt: image

   image

A continuación deberemos elegir un tipo de balanceador de carga.
Usaremos HTTP, HTTPS para el ejemplo

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga01.png
   :alt: image

   image

Especificamos sí será interno o expuesto a internet

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga02.png
   :alt: image

   image

Podemos configurar los grupos de seguridad o elegir uno ya existente.

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga03.png
   :alt: image

   image

Elegimos el grupo de destino

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga04.png
   :alt: image

   image

Si todo salió bien AWS nos mostrará un mensaje de confirmación

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga05.png
   :alt: image

   image

El balanceador de carga aparecerá en la opción de balanceadores de carga
y podremos ver su dirección DNS a la que podemos acceder

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga06.png
   :alt: image

   image

Si entramos en el enlace del balanceador podremos ver más detalles como
su IP pública y privada.

.. figure:: img/cloudComputingAWS/BalanceadorDeCarga07.png
   :alt: image

   image

Marketplace de AMI's
====================

Es un repositorio de imágenes con la mayoría de las necesidades ya
resueltas.

https://aws.amazon.com/marketplace

Lightsail
=========

Un VPS en Amazon

Cuenta con varios templates preconfigurados

-  LAMP
-  Magento
-  wordpress

Escala con unos clicks Tiene base de datos disponibles Multiregiones y
multizonas

Marketplace de Lightsail
------------------------

Existen múltiples imágenes de Lightstail ya preconfiguradas, incluso
imágenes de windows disponibles.

Creación de un VPS
------------------

Instalar un proyecto en Lightsail es muy similar al proceso que se
realiza en EC2.

Creación de una base de datos
-----------------------------

Ofrece dos configuraciones:

-  Estándar: Un servidor con una conexión desde afuera.
-  HA: Alta disponibilidad, donde tienes dos servidores o más con un
   load balancer.

ECR/ECS/EKS
===========

ECR es el servicio que te permite usar los contenedores a través de
Dockerfiles en Amazon.

Primero necesitamos entrar a ECS, solo ahí podremos acceder a ECR.

Es requisito instalar AWS CLI y Docker, así como otras dependencias como
pip, python-pip y otras.

Creación de una imagen en ECR
-----------------------------

Para crear la imagen necesitaremos un usuario con los siguientes
permisos

.. figure:: img/cloudComputingAWS/CreacionDeUsuarioAWS6.png
   :alt: image

   image

Procederemos a añadir al usuario

.. figure:: img/cloudComputingAWS/CreacionDeUsuarioAWS5.png
   :alt: image

   image

Elegimos un nombre de usuario

.. figure:: img/cloudComputingAWS/CreacionDeUsuarioAWS4.png
   :alt: image

   image

Podemos crear un grupo de permisos o asociar los permisos directamente

.. figure:: img/cloudComputingAWS/CreacionDeUsuarioAWS3.png
   :alt: image

   image

Nos permitirá revisar el usuario antes de agregarlo

.. figure:: img/cloudComputingAWS/CreacionDeUsuarioAWS2.png
   :alt: image

   image

Posteriormente nos creará una ID y una clave de acceso que serán
necesarios para configurar el awscli

.. figure:: img/cloudComputingAWS/CreacionDeUsuarioAWS1.png
   :alt: image

   image

Instalación de AWS
------------------

Înstalamos AWS por medio de pip

.. code:: bash

   pip install awscli

A continuación correremos el comando

.. code:: bash

   aws configure

El cual nos pedirá nuestra ID, clave de acceso y la región para
configurar las credenciales que usaremos para acceder

Instalación de Docker
---------------------

La instalación de Docker depende de cada distribución, por lo que es
mejor revisar la documentación oficial.

Creación del repositorio ECR
----------------------------

A continuación creamos un repositorio privado con el nombre que
querramos.

.. figure:: img/cloudComputingAWS/CreacionDeUnRepositorioPrivado.png
   :alt: image

   image

Una vez creado, podremos seleccionarlo y hacer click en el botón de
"view push commands" para obtener los pasos a ejecutar para mandar
nuestra imagen

.. figure:: img/cloudComputingAWS/PushCommands.png
   :alt: image

   image

ECS
---

ECS es toda la infraestructura que te permite correr contenedores de
Docker directo en AWS.

Amazon se encarga de todo, nosotros solo elegimos las capacidades.

Solo se paga por la capacidad que se solicita

Escalamiento basado en un contenedor de manera manual.

Configuración de Docker
~~~~~~~~~~~~~~~~~~~~~~~

Usaremos sla siguiente secuencia de comandos

.. code:: bash

   sudo su
   apt-get update
   snap install docker -y
   apt-get install git -y

Ahora podemos ejecutar un git clone a nuestro proyecto con Docker y
posteriormente correr

.. code:: bash

   docker build

Con esto, ya podrás hacer imágenes de contenedores y siguiendo las
instrucciones de la clase, podrás enviarlo a ECR (El registro de
contenedores de AWS).

EKS
---

EKS es una implementación de Kubernetes en Amazon que no requiere la
coordinación de nodos primarios y secundarios

Crea un ambiente de workers de k8s en AWS. Corre con el dashboard de
Kubernetes o cualquier otro orquestador

EKS va desde poner el nodo maestro de Kubernetes, poner los workers para
posteriormente conectarse a la API y ejecutar las tareas.

Kops/k8s en AWS
===============

Nos permite administrar Kubernetes en AWS.

Para instalarlo corremos

.. code:: bash

   sudo apt update
   sudo apt install -y awscli
   sudo snap install kubectl --clasic
   curl -LO https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64
   chmod +x kops-linux-amd64
   mv ./kops-linux-amd64 /usr/local/bin/kops

Posteriormente se crea un usuario llamado kops en IAM. Le asignamos el
rol de Administrador Access. Y conservamos su Access Key ID y la
contraseña

.. code:: bash

   aws iam create-group --group-name kops
   aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
   aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
   aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
   aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
   aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
   aws iam add-user-to-group --user-name kops --group-name kops
   aws s3api create-bucket --bucket s3kopstudominiocom --region us-west-2
   Antes de ejecutar el próximo comando, anexen lo siguiente a su archivo ~/.bashrc (al final):
   export AWS_ACCESS_KEY_ID=tuaccesskey
   export AWS_SECRET_ACCESS_KEY=tusecret
   export KOPS_STATE_STORE=s3://s3kopstudominiocom
   export KOPS_CLUSTER_NAME=kops-cluster-tudominio

cerramos sesión y posteriormente ejecutamos

.. code:: bash

   kops create cluster --name=kops-cluster-tudominio --cloud=aws --zones=us-west-2a --state=s3kopstudominiocom

Al terminar crearemos el dashboard con

.. code:: bash

   kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

Nos logeamos con user admin

.. code:: bash

   kops get secrets kube --type secret -oplaintext

Podemos obtener Tokens de la siguiente manera

.. code:: bash

   kops get secrets admin --type secret -oplaintext

Al terminar el deploy tendremos la url en la sección de services

Creación de un cluster y tareas
===============================

Primero debemos elegir el tipo de Cluster

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea01.png
   :alt: image

   image

Le asignamos un nombre y tags si las necesitamos

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea02.png
   :alt: image

   image

Una vez creado procederemos a definiar la tarea que queremos ejecutar

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea03.png
   :alt: image

   image

Creamos un task definition

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea04.png
   :alt: image

   image

Seleccionamos el tipo de task, en este caso Fargate

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea05.png
   :alt: image

   image

Colocamos el nombre y debemos asegurarnos de tener un rol con los
permisos **Elastic Container Service Task**, el cual podemos elegirlo si
le damos click al enlace a la consola IAM

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea06.png
   :alt: image

   image

A continuación daremos click en el botón para definir el contenedor.
Pegamos el enlace a la imagen en ECR que queremos usar. Y abrimos el
puerto 80 para que esté disponible en el navegador.

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea07.png
   :alt: image

   image

Elegimos las capacidades de nuestro contenedor

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea08.png
   :alt: image

   image

Y al terminar esperemos hasta que esté activo para crear nuestra nueva
tarea

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea09.png
   :alt: image

   image

Usaremos Fargate y el VPC, subnet y grupos de seguridad predeterminados

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea10.png
   :alt: image

   image

Si examinamos el task, podremos apreciar la IP pública, la cual podremos
usar para acceder desde cualquier navegador.

.. figure:: img/cloudComputingAWS/CreacionDeUnClusterYTarea11.png
   :alt: image

   image

Lambda
======

Lambda es un producto que implementa la filosofía de Serverless, lo cual
significa no tener un servidor sino tener funciones que hagan cosas muy
específicas. Es código que puede conectarse a una base de datos,
servicios web, etc.

AWS soporta Node.js, Python, Java, C#, Go

Lambda escala automáticamente

A la fecha te permite un millón de llamadas gratis por mes.

Configuración
-------------

Cada función requiere una serie de permisos. Es recomendable usar el
principio de responsabilidad mínima.

La entrada de un Lambda es un API Gateway.

Podemos crear una lambda function a partir de diferentes opciones.
elegimos el lenguaje que querramos y podemos usar un rol que hayamos
creado o dejar que AWS cree uno con los permisos mínimos

.. figure:: img/cloudComputingAWS/LambdaFunctions1.png
   :alt: image

   image

Especificamos el contenido de la lambda functión y podemos asignarle un
trigger para que se ejecute dada una acción. Esta acción puede ser el
acceso a un endpoint

.. figure:: img/cloudComputingAWS/LambdaFunctions2.png
   :alt: image

   image

También peude ser cualquier otra cosa

.. figure:: img/cloudComputingAWS/LambdaFunctions3.png
   :alt: image

   image

Al crearla podremos asignarle diferentes opciones, dejarla a público o
que requiera acceso.

.. figure:: img/cloudComputingAWS/LambdaFunctions4.png
   :alt: image

   image

Podemos examinar el evento para ver el endpoint en caso de que cuente
con uno.

.. figure:: img/cloudComputingAWS/LambdaFunctions5.png
   :alt: image

   image

Elastic Beanstalk
=================

Incluye todo lo que necesitas en un paquete

-  Endpoint para gestion de dominios a partir de Route 53
-  Load Balancer
-  Instancias de EC2 con Windows, Linux y soporte a muchos lenguajes.
-  Rollback en cuestión de minutos
-  Autoescalabilidad para arriba o para abajo
-  Base de datos interna

Creación de un ambiente
-----------------------

Requiere un archivo zip con todos los archivos.

.. code:: bash

   zip -r nombredelzipfile.zip archivos

Es recomendable colocar una versión para recordar la versión en caso de
rollback.

En la configuración avanzada podemos elegir entre bajo costo o alta
disponibilidad.

Configurando un ambiente para nuevas versiones
----------------------------------------------

Es necesario un nuevo archivo zip.

Hay varias opciones, ya sea subir los cambios a todos los servidores
(all at once) al mismo tiempo o hacerlo paulatinamente (rollback).

Es importante programar las actualizaciones para reducir el impacto a
los usuarios.
