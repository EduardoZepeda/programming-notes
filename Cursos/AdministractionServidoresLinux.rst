==================================
Administración de servidores Linux
==================================

Es recomendable siempre usar versiones Long Term Support(LTS), pues cuenta con 10 años de soporte, tanto para CentOS, como para Ubuntu Server. 

Ubuntu Server es la versión más popular de distribución de GNU/Linux, de acuerdo a las estadísticas de w3tech.

Terminales de GNU/Linux
=======================

Las consolas físicas tienen una terminación de tty1 hasta tty6. Cada usuario activo en nuestro sistema operativo crea una nueva conexión. Podemos ver todas estas. Para verlas usamos el comando w o who. Es recomendable matar aquellas que no estamos usando.

chvt
----

Se encarga de cambiar la terminal

Para matar las consolar usamos 

.. code-block:: bash

    ps -ft tty0

sort
----

El comando sort nos permite ordenar un output por una llave específica.

El flag n compara según el número, el flag, r los invierte y el flag -k sirve para indicar la llave.

Siendo las keys la columna respectiva

.. code-block:: bash

    # ps auxf
    # USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
    sort -n -k 2 # Ordena según la columna 2

Conocer el número de procesadores
---------------------------------

Para mirar el número de procesadores usamos

.. code-block:: bash

    cat /proc/cpuinfo | grep "processor"

Muestra los 5 procesos que más consumen CPU

.. code-block:: bash

    sudo ps auxf | sort -nr -k 3 | head -5

Muestra los 5 procesos que usan más RAM

.. code-block:: bash

    sudo ps auxf | sort -nr -k 4 | head -5

Manejo de redes
===============

Las IPs privadas se usan para identificar los dispositivos en una red local, mientras que las públicas son para identificar cualquier dispositivo conectado a internet.

Para mirar las direcciones usamos

.. code-block:: bash

    ip a

Podemos filtrar las direcciones ipv4 con

.. code-block:: bash

    ip -4 a

Mientras que para las direcciones ipv6

.. code-block:: bash

    ip -6 a

Para ver la identificación del equipo usamos

.. code-block:: bash

    hostname

Y para ver las direcciones IP asignadas

.. code-block:: bash

    hostname -I

nslookup
--------

Para ver las direcciones IP usamos nslookup, y sirve para internet o para las redes locales

.. code-block:: bash

    nslookup google.com


Y esto nos arrojará la información pertinente

curl
----

Para realizar peticiones http

.. code-block:: bash

    curl localhost:8000

wget
----

Para descargar archivos de internet

.. code-block:: bash

    wget https://example.org

Administración de paquetes
==========================

RedHat/CentOS/Fedora
--------------------

Su gestor de paquetes es rpm. Su base de datos está en /var/lib/rpm

Para listar todos los paquetes

.. code-block:: bash

    rpm -qa

Instalación de paquetes rpm
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para instalar y remover paquetes utilizamos 

.. code-block:: bash

    rpm -i <nombre-del-paquete.rpm>
    rpm -e <nombre-del-paquete.rpm>

Para ver todos los paquetes instalados

.. code-block:: bash

    rpm -qa

Para ver la información de un paquete

.. code-block:: bash

    rpm -qi <paquete>

Para ver la configuración de un paquete

.. code-block:: bash

    rpm -qc <paquete>

yum
^^^

Yum nos permite instalar o buscar el nombre del paquete. Es el equivalente de apt en Debian.

.. code-block:: bash

    yum install nombre-del-paquete
    yum search nombre-del-paquete

Debian
------

Su administración de paquetes es con .deb

dpkg
^^^^

para instalar un paquete usamos el comando dpkg

.. code-block:: bash

    dpkg -i nombre-del-paquete-deb

Su base de datos está disponible en /var/lin/dpkg

Para listar sus paquetes instalados usamos 

.. code-block:: bash

    dpkg -l

Para eliminar un paquete

.. code-block:: bash

    dpkg -r nombre-del-paquete-deb

apt
---

Es el equivalente de yum en red hat.

apt install
^^^^^^^^^^^

Además, podemos usar apt para manejar los paquetes 

.. code-block:: bash

    apt install nombre-del-paquete

apt update
^^^^^^^^^^

Actualiza la información local sobre los repositorios.

apt upgrade
^^^^^^^^^^^

Actualiza todos los programas que tenemos lados en la máquina.

snap install <nombre-del-paquete>
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instala un paquete con el nuevo gestor de paquetes de Canonical.

Descomprimir archivos
=====================

El comando tar se usa para descomprimir, generalmente se usa con las opcionex xvfz.

.. code-block:: bash

    tar -xvfz <nombre-de-archivo.tar.gz>

Donde las opciones son:

* x para extraer
* v para verbosidad
* f para indicar el archivo
* z para indicar la desempaquetación

Trabajando con usuarios
=======================

Identificación de usuarios
--------------------------

El comando id nos muestra el identificador del usuario. En Debian empiezan a contar desde el número 1000, en Red Hat desde el 500.

.. code-block:: bash

    id
    # uid=1000(eduardo) gid=1000(eduardo) grupos=1000(eduardo),7(lp),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),107(render),109(netdev),115(bluetooth),122(scanner),127(docker),134(lpadmin)

El comando whoami recupera la informacion de /etc/passwd

.. code-block:: bash

    whoami
    # eduardo

Contraseñas de usuarios
-----------------------

Las contraseñas, cifradas, de los usuarios se guardan en la ruta /etc/shadow. Este archivo no debe manipularse de manera directa.

Para cambiar el password de un usuario usamos el comando passwd, si no le pasamos ningún usuario, cambiará el password del usuario actual.

.. code-block:: bash

    passwd <nombre-del-usuario>

En versiones más nuevas de Ubuntu el usuario root viene desactivado, para activarlo se usa el comando passwd sobre el usuario root.

.. code-block:: bash

    sudo passwd root

Creación de usuarios
--------------------

Los usuarios se crean con useradd, es necesario tener los privilegios necesarios, generalmente se usan

.. code-block:: bash

    sudo useradd <nombre-de-usuario>

Eliminación de usuarios
-----------------------

Para eliminar un usuario se usa:

.. code-block:: bash

    sudo userdel <nombre-de-usuario>

Cambio de usuario
-----------------

Para cambiar de usuario usamos

.. code-block:: bash

    su - <nombre-de-usuario>

Si tenemos los permisos con sudo (o wheel para CentOS), podemos cambiar directamente sin conocer la contraseña

.. code-block:: bash

    sudo su - <nombre-de-usuario>

grupos
======

Los grupos son útiles para asignar los mismos permisos a una serie de usuarios al mismo tiempo.

Para ver los grupos a los que pertenece un ususario

.. code-block:: bash

    groups <nombre-de-usuario>

Para agregar usuarios a un nuevo grupo

.. code-block:: bash

    sudo gpasswd -a <nombre-de-usuario> <nombre-de-grupo>

Para eliminarlos se usa el mismo comando con el parámetro -d

.. code-block:: bash

    sudo gpasswd -d <nombre-de-usuario> <nombre-de-grupo>

Otra opción para modificar grupos es con el comando usermod

.. code-block:: bash

    sudo usermod -aG <nombre-de-grupo> <nombre-de-usuario>

Sudo y wheel
------------

El grupo sudo permite realizar acciones como superusuario en sistemas basados en debian, mientras que wheel es para sistemas basados en RedHat, como CentOS.

PAM
===

PAM es un mecanismo para la administración de usuarios. Permite autenticar usuarios, controlar la cantidad de procesos que ejecutan cada uno, validar contraseñas, ver la actividad de los usuarios y otras.

Pam se encuentra en la ruta /etc/pam.d

pwscore
-------

Solo disponible en CentOS. Sirve para evaluar un password, verifica que tenga más de 8 caracteres, la presencia de caracteres especiales y la presencia en diccionarios.

.. code-block:: bash
    
    pwscore

Para instalarla en sistemas debian es necesario instalar la librería

.. code-block:: bash
    
    sudo apt install libpwquality-tools

ulimit
------

ulimit nos indica las limitaciones que tiene el usuario en cuanto a infraestructura, memoria, número de procesadores, etc.

.. code-block:: bash
    
    ulimit -a
    # Maximum size of core files created                           (kB, -c) 0
    # Maximum size of a process’s data segment                     (kB, -d) unlimited
    # Maximum size of files created by the shell                   (kB, -f) unlimited
    # Maximum size that may be locked into memory                  (kB, -l) 1009945
    # Maximum resident set size                                    (kB, -m) unlimited
    # Maximum number of open file descriptors                          (-n) 1024
    # Maximum stack size                                           (kB, -s) 8192
    # Maximum amount of cpu time in seconds                   (seconds, -t) unlimited
    # Maximum number of processes available to a single user           (-u) 31264
    # Maximum amount of virtual memory available to the shell      (kB, -v) unlimited

Para modificar los parámetros usamos el flag correspondiente

.. code-block:: bash

    ulimit -u <número-máximo-de-procesos>

Para limitar el acceso a los usuarios por tiempo modificamos el archivo /etc/security/time.conf. Dentro de este archivo existen instrucciones para el manejo de la sintaxis.

La sintaxis es:

.. code-block:: bash

    services;ttys;users;times

Por ejemplo:

.. code-block:: bash

    *;*;usuario|otro_usuario;Wk0800-1900

Donde ponemos Wk para indicar entre semana y luego el horario en formato miliar.

SSH
===

Secure Shell, es un protocolo que permite conectar dos computadoras de forma remota sin necesidad de un password, por medio de una conexión segura basada en cifrado RSA.

Para revisar la configuración de ssh podemos modificar el archivo de configuración:

.. code-block:: bash

    sudo vim /etc/ssh/sshd_config

En este archivo podemos bloquear la autenticación por password y otras medidas.

Generación de llaves
--------------------

Para la generación de llaves se usa 

.. code-block:: bash

    ssh-keygen

El número de bits por defecto es 2048, en caso de que no se especifique ninguno. El comando nos indicará la dirección donde se guardarán las llaves generadas.

Uso de SSH 
----------

Para usar un servidor remoto

.. code-block:: bash

    ssh <nombre-de-usuario>@<ip-del-servidor>

Para copiar la llave pública al servidor

.. code-block:: bash

    ssh-copy-id -i <directorio>/<llave_publica.pub> <nombre-de-usuario>@<ip-del-servidor>

Aplicar cambios en SSH
----------------------

Para aplicar los cambios reiniciamos el servicio

.. code-block:: bash

    sudo systemctl restart ssh

Problemas de conexión en ssh
----------------------------

Para obtener más información del proceso podemos especificar el nivel de verbosidad, de acuerdo al número de "v"

.. code-block:: bash

    ssh -v <nombre-de-usuario>@<ip-del-servidor>
    # ...
    ssh -vvvv <nombre-de-usuario>@<ip-del-servidor>

Configurando DNS con bind
=========================

En 1983 se conectaron cerca de 70 sitios a la red de CS. En 1983 se publicó el RFC 882 que define el servicio de nombre de dominios. Posteriormente, en octubre de 1984 se crearon 7 TLDs (Dominios de nivel superior), conocidos como dominios de propósito general .arpa, .com, .org, .edu, .gov, .mil y la letra de los países respetando su código ISO.

Instalación de bind
-------------------

.. code-block:: bash

    sudo apt install -y bind9

Si la instalación funcionó, el puerto 53 estará abierto

.. code-block:: bash

    netstat -ltn
    # tcp 0 0 127...:53 ESCUCHAR

Y podremos verificar los manuales usando

.. code-block:: bash

    dpkg -L bind9

También podremos ver la versión usando el flag -v.

.. code-block:: bash

    named -v

Dig
---

dig nos permite realizar consultas al dns. Para esto se usará un dominio y una ubicación 

.. code-block:: bash

    dig www.<dominio>.<extension> @<direccion-ip>

Configuración de bind
---------------------

El archivo de configuración de bind estará en /etc/bind/named.conf

Arranque, detención y recarga de servicios
==========================================

Systemd se encarga de la gestión de todos los servicios, los comandos más comunes son:

Verificar el estado de un servicio usamos 

.. code-block:: bash

    sudo systemctl status <servicio>

Para que un servicio cargue al iniciar el sistema

.. code-block:: bash

    sudo systemctl enable <servicio>

Para remover un servicio del arranque del sistema

.. code-block:: bash

    sudo systemctl disable <servicio>

Iniciar un servicio

.. code-block:: bash

    sudo systemctl start <servicio>

Detener un servicio

.. code-block:: bash

    sudo systemctl stop <servicio>

Reiniciar un servicio

.. code-block:: bash

    sudo systemctl restart <servicio>

Para listar los servicios del sistema 

.. code-block:: bash
    
    sudo systemctl list-units -t <servicio> --all

si queremos ver los logs de un servicio. La -f es para realizar un follow, escuchará cambios en los logs.

.. code-block:: bash

    sudo journalctl -fu <servicio>

Muestra cuanto pesan los logs en el sistema operativo.

.. code-block:: bash
    
    sudo journalctl --disk-usage

Muestra los reinicios del ordenador

.. code-block:: bash

    sudo journalctl --list-boots

Muestra los mensajes que corresponden con determinada categoría

.. code-block:: bash

    sudo journalctl -p critic|notice|info|warning|error

Es posible obtener los logs en formato JSON con

.. code-block:: bash

    sudo journalctl -o json

Para recargar los archivos de configuración de un servicio sin reiniciarlo

.. code-block:: bash

    sudo systemctl reload <servicio>

Para reducir el tamaño de los logs cierta cantidad

.. code-block:: bash

    sudo journalctl --vacuum-size=100M

Para reducir el tamaño de los logs a cierta cantidad de días

.. code-block:: bash

    sudo journalctl --vacuum-time=2days

Configuración de Nginx
======================

Para instalar nginx con sus extras usamos

.. code-block:: bash

    sudo apt install nginx nginx-extras

Nginx amplify
-------------

NGINX Amplify es una herramienta que sirve para monitorear el servidor, parámetros del sistema operativo, bases de datos, etc

Para activarlo vamos a modificar el directorio conf.d de nginx que suele estar en /etc/nginx, para agregar un archivo nuevo.

.. code-block:: bash

    sudo cat > conf.d/stub_status.conf
    server{
        listen 127.0.0.1:80;
        server_name 127.0.0.1;
        location /nginx_status {
            stub_status on;
            allow 127.0.0.1;
            deny all;
        }
    }

Seguir las `instrucciones de instalación <https://amplify.nginx.com/>`_ y posteriormente

A continuación reiniciamos el servicio de nginx y lo habilitamos.

.. code-block:: bash

    sudo systemctl restart nginx && systemctl enable nginx

Tras reiniciar nginx activamos el servicio de nginx amplify eligiendo la opción start.

.. code-block:: bash

    service amplify-agent <start | stop>

Una vez hecho lo anterior amplify-agent estará ejecutándose.

MySQL con Nagios
================

Nagios es un sistema de monitorización de redes, de código abierto, que revisa el rendimiento de los equipos y servicios. 

Primero instalamos MySQL

.. code-block:: bash

    sudo apt install mysql-server

Obtenemos el password de MySQL

.. code-block:: bash

    sudo vim /etc/mysql/debian.conf
    # ...
    # user = <user>
    # password = <password>

Para inciar sesión usamos los datos del comando anterior. Usamos la opción -p para que el password no quede guardado en el historial de comandos.

.. code-block:: bash

    mysql -y <user> -p

Reforzamos la seguridad del server de la base de datos con el comando interactivo.

.. code-block:: bash

    sudo mysql_secure_installation


Nagios
------

Instalamos los paquetes

.. code-block:: bash

    sudo apt install -y libmcrypt-dev make libssl-dev bc gawk dc build-essential snmp libnet-snmp-perl gettext
    wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz -0 plugins.tar.gz -O plugins.tar.gz

Configuramos

.. code-block:: bash

    sudo ./configure

Verificamos la ausencia de errores

.. code-block:: bash

    sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

Y una vez que nos aseguremos reiniciamos nagios.

.. code-block:: bash

    sudo systemctl restart nagios

Neceistamos descargar el plugin de MySQL en el Home.

.. code-block:: bash

    wget https://labs.consol.de/assets/downloads/nagios/check_mysql_health-2.2.2.tar.gz -O mysqlplugin.tar.gz

Y posteriormente desempaquetarlo

.. code-block:: bash

    tar -xzvf mysqlplugin.tar.gz

Creamos un usuario para ingresar en nagios

.. code-block:: bash

    sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin 

Nagios estará disponible en nuestro navegador web

.. code-block:: bash

    <direccion-ip>:8080/nagios

Configuración en base de datos
------------------------------

.. code-block:: bash

    grant select on *.* to '<user>'@'<ip>' identified by '<password>'

Ahora agregamos la siguiente linea dentro de /usr/local/nagios o /etc/nagios.cfg

.. code-block:: bash

    cfg_file=/usr/local/nagios/etc/objects/mysqlmonitoring.cfg

Creación de comandos para nagios
--------------------------------

Dentro de la ruta /usr/local/nagios/etc/objects/commands.cfg, agregamos

.. code-block:: bash

    define command {
        command_name check_mysql_health
        command_line $USER1$/check_mysql_health -H $ARG4$ --username $ARG1$ --password $ARG2$ --port $ARG5$  --mode $ARG3$
    }

Por último, creamos el archivo cfg_file que declaramos en el archivo nagios.cfg de la configuración. Su ubicación será la ruta /usr/local/nagios/etc/objects/mysqlmonitoring.cfg

.. code-block:: bash

    define service {
        use local-service
        host_name localhost
        service_description MySQL connection-time
        check_command check_mysql_health!nagios!<password>*!connection-time!127.0.0.1!3306!
    }

Manejo de logs
==============

Hay varios comandos útiles para manejar logs

El comando siguiente encontrará todos los archivos que terminen en ".log", insensible a mayúsculas y minúsculas.

.. code-block:: bash

    find /var/log/ -iname "*.log" -type f

Para encontrar los logs que tuvieron salidas de error en los últimos minutos. El 2 en el comando indica el output para STDERR

.. code-block:: bash

    sudo find /etc/ -mtime <minutos> 2

awk
===

awk es un comando que recibe patrones, muy usado para visualizar los de una manera atractiva. Nos permite imprimir por número de columna.

.. code-block:: bash

    awk '{print $num_columna}'

También podemos usar otro delimitador en lugar de los espacios

.. code-block:: bash

    awk -F "<delimitador>" '{print $num_columna}'

O imprimir múltiples columnas

.. code-block:: bash

    awk -F "<delimitador>" '{print $num_columna $num_columna $num_columna}'

También recibe expresiones regulares

.. code-block:: bash

    awk '/^\/dev\/sda5/ {print}'

O aquellas que son más largas de cierta longitud

.. code-block:: bash

    awk ' length($0) > <longitud> {print length} ' <directorio>

Para ver las IP conectadas a nuestro servidor usamos 

O solo determinadas lineas

.. code-block:: bash

    awk 'NR==2, NR==4 {print $0}'

Mirando los logs de ngnix con awk
---------------------------------

Sabiendo que los logs de nginx se localizan en la ruta /var/log/nginx/, podemos visualizarlos de manera más amigable usando el comando awk.

.. code-block:: bash

    sudo awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr
    # 534 159.65.103.143
    # 103 187.158.4.52

Para ver los códigos en nuestro servidor.

.. code-block:: bash

    sudo awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -nr
    # 4427 200
    # 211 301

Otros servicios
===============

Collectd
--------

Genera reportes en web del rendimiento. 

Nmon
----

Obtiene visualizaciones rápidas del sistema. Guardar archivos en formato nmon que se pueden convertir a html

Munin
-----

Analiza el rendimiento del servidor con gráficos históricos

Grafana
-------

Visualiza alerta y entiende las métricas del negocio sin portar su ubicación.

Pandora
-------

Recomendado por la comunidad con una versión community.

Bash
====

Es una shell de UNIX y el intérprete de comandos por defecto en la mayoría de distribuciónes GNU/Linux. Se pueden crear scripts que, por convención, terminan con .sh

Cabecera
--------

Para indicarle a GNU/Linux que un script se use con bash usamos

.. code-block:: bash

    #!/bin/bash

Para definir una variable usamos el operador =

.. code-block:: bash

    VARIABLE = "variable"

Para imprimirlas usamos echo

.. code-block:: bash

    echo $VARIABLE

Mientras que los comentarios usan el caracter hashtag o numeral

.. code-block:: bash

    # Este es un comentario

Variables de entorno
====================

Para mirar todas las variables que están disponibles usamos el comando *env*

.. code-block:: bash

    env

Variable $PATH
--------------

La variable PATH le indica que a GNU/Linux donde debe buscar los binarios para ejecutar.

Para extender el PATH usamos

.. code-block:: bash

    export PATH=$PATH:~/otra/ruta

Vulnerabilidades en el servidor
===============================

Buenas prácticas
----------------

Hay buenas prácticas a realizar

* desactivar el usuario root
* Evitar login con usuario y password
* Validar la versión de software usada
* User telnet
* Identificar los servicios y puertos abiertos
* Asignarle los permisos mínimos a los usuarios

Mantener actualizado el servidor
--------------------------------

En sistemas basados en RedHat

.. code-block:: bash

    yum check-update --security
    yum update security

En sistemas basados en debian

.. code-block:: bash

    sudo apt update
    sudo apt upgrade

Principio del menor privilegio
------------------------------

La superficie de ataque es el conjunto de datos conocidos o vulnerabilidades.

Existen algunas soluciones para manejar las vulnerabilidades

* Lynis

Frameworks de seguridad
-----------------------

Existen organizaciones encargadas de la seguridad.

* SCAP, conjunto de reglas para la información relacionada con configuraciones y fallos
* OWASP, proyecto destinado a pelear contra la inseguridad informática.

Implementación de firewall
--------------------------

ufw es un software que ya viene instalado por defecto en sistemas ubuntu.

Generalmente para web se dejan abiertos únicamente los puertos 80, 443 y 22, que corresponden a HTTP, HTTPS y SSH, respectivamente.

Uso de ufw
^^^^^^^^^^

Muestra el estado (activo/inactivo) y las reglas del firewall. 

.. code-block:: bash

    sudo ufw status

Con el modificador numbered me muestra las reglas numeradas.

.. code-block:: bash

    sudo ufw status numbered

Para habilitar un puerto usamos allow

.. code-block:: bash

    sudo ufw allow <puerto>

Si queremos encender el firewall usamos enable

.. code-block:: bash

    sudo ufw enable

Para ver borrar un número de regla

.. code-block:: bash

    sudo ufw delete <numero-de-regla>

Para permitir la conexión de ciertas direcciones ip 

.. code-block:: bash

    sudo ufw allow from <direccion-ip> proto <tcp|udp> to any port <numero-de-puerto> comment <commentario>
    
.. tip:: Recuerda que ssh usa el protocolo tcp

Si queremos eliminar todas las reglas

.. code-block:: bash

    sudo ufw reset

Escaneo de puertos con nmap
---------------------------

Nmap es una herramienta que se encuentra de manera nativa en Kali Linux, usada para auditorias web.

.. code-block:: bash

    nmap -sV -sC -O -oA <dirección-ip>

Donde:

* -sV Muestra información de los puertos abiertos
* -sC Habilita el uso de Scripts
* -O Detección de OS
* -p Escanea todos los puertos
* -oA Detecta la salida a un archivo
* -Pn Para 

Lynis
=====

Es una herramienta de auditoria y seguridad, para endurecer servidores GNU/Linux.

se instala con

.. code-block:: bash

    sudo apt install lynis

Y para usarlo basta con correr el comando

.. code-block:: bash

    sudo lynis audit system
    # [+] Users, Groups and Authentication
    #- Administrator accounts [ OK ]
    #- Unique UIDs [ OK ]
    #- ...

El cual nos hará recomendaciones respecto a nuestro sistema.

Emite un reporte muy completo con una checklist de las medidas y recomendaciones a tomar en cuenta.

