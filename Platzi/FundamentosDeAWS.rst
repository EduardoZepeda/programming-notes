========================
Fundamentos de AWS Cloud
========================

¿Qué es el cómputo en la nube?
==============================

En AWS el cómputo en la nube trata de los siguiente:

-  Sitios Web, una sola computadora corriendo un solo stack de
   programación cómo LAMP, XAMPP, entre otros.
-  Respaldos y recuperación, incluso de sistemas operativos completos.
-  Archivos Permanentes, también puedes guardar archivos estáticos como
   fotografías o documentos.
-  DevOps, no solo tenemos automatización en el release de los
   proyectos, también cuentas con alta disponibilidad o respaldos
   automatizados en diversos lugares del mundo.
-  Análisis Masivos
-  Cómputo Serverless, en lugar de preocuparte por la cantidad de
   computadoras o cómo y cuándo va a escalar tu servicio puedes
   programar tu aplicación con microservicios mientras que AWS se
   encarga de darte los elementos necesarios.
-  Cómputo de Alto Rendimiento, levanta tus servidores sólo cuando tu
   aplicación lo necesita.
-  Internet of Things.
-  Aplicaciones Empresariales.
-  Distribución de media.
-  Servicios móviles.
-  Cómputo científico.
-  E-commerce.
-  Ambientes Híbridos.
-  Blockchain.

Ventajas de AWS:

-  Cero inversión inicial, muchos servicios son gratis el primer año
-  Usa lo que necesites, apaga lo que no
-  Crece tanto como sueñes
-  Velocidad cuando la necesitas
-  Si no lo usas, no lo pagas
-  Cobertura mundial

Servicios de AWS:
=================

-  Computo
-  Storage
-  Bases de Datos
-  Migración de servicios [Si ya tienes data en un data center, te ayuda
   a poder migrar]
-  Networking & Content Delivery [Registrar dominios, administrar
   certificados SSL]
-  Herramientas de desarrollador
-  Herramientas de administración
-  CloudWatch:Permite ver que esta sucediendo en tu infraestructura o en
   tus servidores
-  CloudTrail: Permite llevar una auditoria de que hace que o de quien
   hace que]
-  Media Services: [Elastic Transcoder: Ejm: Si estas haciendo streaming
   de un partido podrías subir el dato que estas generando (vídeo) y
   ellos generaran todas las versiones que necesitas para diferentes
   tipos de dispositivos (Celulares, computadora, etc)]
-  Machine Learning: [Rekognition: Le puedes ir enviando imágenes y te
   puede reconocer que estas viendo ]
-  Analytics: [Cuanta RAM esta usando cada visitante, cuanto CPU, que
   actividad esta teniendo ese visitante en tu sitio ]
-  Seguridad [IAM: Manejar a que tienen acceso la cuenta de los
   colaboradores GuardDuty: Te permite hacer un recuento de los
   diferentes accesos de red que ha habido, entonces si es hubiese un
   ataque a un servidor te va ha permitir saber de donde viene el ataque
   y te va dar opciones ]
-  Servicios moviles: [Te permite generar tus propios servicios moviles
   de forma más sencilla] AR & VR (Realidad virtual) [Ya viene con el
   software, puedes empezar a hacer identificación de algún patrón para
   empezar a enseñar alguna cosa en tu aplicación]
-  Integración de aplicaciones: [Simple Notification Service: Se puede
   hacer llamado a diferentes servicios, Ejm: Enviar notificaciones a
   través de correo electrónico, SMS]
-  Customer Engagement
-  Bussines Productivity
-  Desktop & App Streaming [
-  WorkSpaces: Ejm: Tal vez si necesitas compartirle a alguien alguna
   maquina virtual,de,cierta,manera, que tenga un escritorio como
   Windows y que esa maquina tenga un navegador y que solo se pueda
   conectar al sitio de la empresa,escuela,etc]
-  Internet of Things: Puede proveeer de hardware y te permite crear
   servicios para que fácilmente puedas administrarlos, como conectarlos
   con datos o aplicaciones web.
-  Game Development: [Motor de juegos] Puedes generar un juego con el
   software que te proporcionan. Crear escenas, interacción.

EC2
===

EC2 son un conjunto de maquinas virtuales en línea que puedes utilizar
para desarrollo, calidad o producción. Estas son algunas de sus
características:

-  Instancias: Máquinas virtuales con diversas opciones de Sistema
   Operativo, vCPU, RAM, Disco Duro, etc.
-  Seguridad: Generación de llaves únicas para poder conectarse a tu
   máquina Linux o Windows de forma segura.
-  Espacio: Diversas opciones de espacio en disco duro, virtualmente
   infinito.
-  Redundancia: Puedes tener diversas copas de la misma máquina en
   diversas regiones geográficas.
-  Firewall:Puedes controlar de manera muy fina desde donde te puedes
   conectar a la máquina y por qué puertos.
-  Direcciones IP estáticas: Puedes optar por comprar una IP pública
   estática para que siempre puedas poner la última versión o la última
   máquina en esa IP.
-  Respaldos: Puedes respaldar toda la máquina (Ambiente, Sistema
   operativo, todo) cada que quieras.
-  Escalable: En caso necesario, puedes incrementar o decrementar los
   recursos de la máquina: más vCPUs, más RAM, etc.
-  Migración de snapshot: Puedes copiar un snapshot a otras regiones, en
   caso de que cualquier cosa suceda en la que estas.

Recuerda que puedes ver la documentación oficial de EC2 en:
https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/concepts.html

¿Qué es Lambda y Serverless?
----------------------------

Lambda es un proyecto de AWS muy relacionado con el concepto de
Serverless, dejar la administración de tus servidores en manos de Amazon
para **solo encargarte de las funciones de código que ejecutara tu
aplicación.**

¿Qué son? Imagina lambda como un lugar donde puedes ejecutar funciones
de tu código.

Serverless No existe un servidor como vimos en EC2, es decir, solo está
el código en lamba y AWS se encarga de ejecutarlo cuando necesites.

Lenguajes soportados Puedes programar funciones lamba en Nodejs
(JavaScript), Python, Java (8), C# (.Net Core) y Go.

Recuerda tener en cuenta los siguientes puntos:

Memoria: Mínima de 128MB, máxima 3000MB con incrementos de 64MB. Límites
de ejecución y espacio: Puedes correr tu aplicación hasta 300 segundos y
tienes un /tmp limitado a 512MB. Ejecución paralela: Esta limitada a
1000 ejecuciones concurrentes (a un mismo tiempo), no tiene límite en
ejecuciones secuenciales (una detrás de otra).

Ventajas de Lambda:

Seguridad: Al ser una infraestructura compartida, no tienes que
preocuparte de seguridad: AWS maneja todo. Performance: AWS está
monitoreando constantemente la ejecución de tus funciones y se encarga
de que siempre tenga el mejor performance. Código aislado: Tu código,
aún estando en una infraestructura compartida, corre en un ambiente
virtual exclusivo, aislado de las demás ejecuciones lamba.

Recuerda que AWS te regala 1 millón de peticiones lamba gratis el primer
año.

Funcion Lambda
~~~~~~~~~~~~~~

Para ejecutar una función lambda debemo tener una función llamada
*lambda_handler* con un evento y un contexto como parámetros:

::

   import os

   def lamda_handler(event, context):
       os.environ.get('variable_de_entorno')
       return 0

AWS nos permitirá establecer variables de entorno a las que podemos
acceder

Conociendo Elastic Beanstalk
============================

Elastic Beanstalk es una plataforma donde en pocos pasos, obtienes un
balanceador de cargas y tantas instancias EC2 como tu quieras.

Esta arquitectura tiene como ventaja la alta disponibilidad y la
eficiencia para atender una gran cantidad de usuarios.

Este ambiente puede escalar de manera dinámica de acuerdo al tiempo de
respuesta a los usuarios, uso de CPU, uso de RAM, etc.

Esta herramienta soporta los siguientes ambientes:

-  Docker Image
-  Go
-  Java SE
-  Java con Tomcat
-  .NET + Windows Server + IIS
-  Nodejs
-  PHP
-  Python
-  Ruby

Almacenamiento S3
=================

Existen dos grandes opciones para almacenamiento en AWS:

-  S3: Es un repositorio de archivos rápido y perfecto para uso de una
   aplicación a la hora de crear, manipular y almacenar datos.
-  Glacier: Es un servicio de almacenamiento en la nube para archivar
   datos y realizar copias de seguridad a largo plazo. Más barato y
   lento que S3.

Con S3, AWS te permite guardar archivos en su plataforma, de tal forma,
tus instancias EC2, Lamba u otras son efímeras y puedes borrarlas sin
preocupación alguna. Tambien te permite hacer respaldos en tiempo
prácticamente real en otras regiones de AWS.

Bases de Datos - RDS Aurora PG
------------------------------

AWS creó un producto llamado RDS que optimiza el funcionamiento de un
motor de bases de datos. Este servicio incluye mantenimiento a tu base
de datos, respaldos diarios, optimización para tu tipo de uso, etc.

RDS tiene varias opciones de motores de bases de datos, como: Aurora PG,
Aurora MySQL, MySQL, MariaDB, PostgreSQL, Oracle y Microsoft SQL Server.

AWS implementa el motor de PostgreSQL (RDS PG) en una instancia
optimizada para correr con la máxima eficacia.

¿Qué incluye?
~~~~~~~~~~~~~

RDS PG incluye, por omisión, tareas de optimización como vacuum,
recuperación de espacio en el disco duro y planificación de queries.
Tambien te permite hacer respaldos diarios (o incluso más seguido) de tu
base de datos.

Otras ventajas de RDS PG son:

-  Cifrado a tu elección, tu base de datos puede estar cifrada en disco
   duro
-  Migración asistida: RDS PG tiene mecanismos que te ayudan a migrar tu
   información en caso de que tu ya cuentes con una base de datos con
   otro proveedor.
-  Alta disponibilidad: RDS PG te permite fácilmente configurar un
   ambiente de alta disponibilidad al ofrecerte diversas zonas para tu
   base de datos.

Recuerda que Amazon RDS provee de seguridad por omisión tan alta que
**no podrás conectarte a tu DB hasta que explícitamente lo permitas.**

Conociendo Aurora PG (Postgress)
--------------------------------

Aurora PG es una nueva propuesta en bases de datos, AWS toma el motor de
Postgres, instancias de nueva generación, optimizaciones varias en el
kernel/código y obtiene un Postgres 3x más rápido.

**Aurora PG es compatible con Postgres 9.6.x.**

Antes de migrar a Aurora PG debes considerar los siguientes puntos:

-  Usar Aurora RDS PG no es gratis en ningún momento.

-  

   AWS RDS PG es eficiente por varias razones:
      -  Modificaciones al código mismo del motos de bases de datos.
      -  Instancias de última generación.
      -  Aurora PG estará por omisión en una configuración de alta
         disponibilidad con distintas zonas, es decir, en 3 centros de
         datos a un mismo tiempo.

Mejores prácticas
-----------------

-  Respaldos diarios
-  Replicar base de datos

Redes - Route53
===============

Existen muchos servicios de redes en AWS, uno de los más interesantes es
Route 53.

AWS te permite tener un DNS muy avanzado a tu disposición, con el podrás
hacer subdominios asignados a instancias y verlos reflejados en
segundos.

Route 53 está disponible en todas las regiones de AWS, por lo que
funcionará excelente aún en caso de que alguna de las regiones se
pierda.

Herramientas de administración
==============================

Existen muchas herramientas de administración en AWS muy útiles, las
siguientes tres son las más importantes:

-  IAM te permite administrar todos los permisos de acceso de usuarios y
   máquinas sobre máquinas.
-  CloudWatch te mostrará diversos eventos relacionados con tu
   infraestructura o servidores, para tener un lugar centralizado de
   logs e información. Incluso tiene un sistema de gráficas para una
   mejor visualización.
-  Cloudtrail es una herramienta de auditoria que permite ver quién o
   qué hizo que actividad en tu cuenta de AWS.

Cada uno de los productos de AWS tienen diversas alternativas para
acceder a más logs, estas opciones cuentan con almacenamiento histórico
y hacen un gran trabajo al tratar la información para auditar
actividades y deshabilitar usuario.

Certificate manager
===================

Existen varias herramientas de seguridad en AWS. Vamos a ver las más
importantes:

-  Certificate Manager: AWS te permite crear nuevos certificados cuando
   necesites (o importar alguno que ya tengas) y te sera fácil usarlos
   en balanceadores de cargas.
-  GuardDuty: AWS permite que hagas una auditoria constante de todos los
   intentos de conexiones que tienen tus equipos de computo.
