==========
Kubernetes
==========


¿Qué es kubernetes?
===================

Es una herramienta open source de orquestación de containers desarrollada por google.

¿Qué problema resuelve?
=======================

Cuando las aplicaciones crecen demasiado es muy complicado la administración de decenas o cientos de conetendores.


¿Qué hace kubernetes?
=====================

* K8s permite correr varias réplicas y asegurarse de que todas se encuentren funcionando.
* Provee un balanceador de carga interno o externo automáticamente para nuestros servicios.
* Definir diferentes mecanismos para hacer roll-outs de código.
* Políticas de scaling automáticas.
* Jobs batch.
* Correr servicios con datos stateful.

Todos los contenedores que viven dentro de un mismo Pod comparten el mismo segmento de red.

Contenedores
============

Los contenedores no son un first class citizen del kernel de Linux. Es un concepto abstracto conformado por diferentes tecnologías que se potencian las unas a las otras y trabajando en conjunto componen esta tecnología.

* Cgroups o Control Groups: Son los que permiten que un contenedor o proceso tenga aislado los recursos como memoria, I/O, Disco y más. Limitan los recursos del Sistema operativo. 
* Namespaces: Permiten aislar el proceso para que viva en un sandbox y no pueda haber otros recursos del sistema operativo o contenedores.
    - Mount Namespaces: Permite que nuestro proceso tenga una visibilidad reducida de los directorios donde trabaja.
    - Networking Namespaces: Permite que cada contenedor tenga su stack de red.
    - PID.
* Chroot: Cambia el root directory de un proceso.

 Aunque Kubernetes es un orquestador de contenedores, la unidad mínima de ejecución son los pods:

Pod
===

Un pod es el más pequeño y más básico objeto que puede ser desplegado en kubernetes. Representa una instancia de un proceso que corre en el cluster. Un pod puede contener uno o más contenedores y **vive en un nodo**. Cuando un pod ejecuta múltiples contenedores, los contenedores se manejan como una entidad única y **comparten el mismo namespace de red (dirección IP) y el almacenamiento.**

Cuando se escala un pod en kubernetes se crean nuevas copias del pod, estas copias son irrecuperables una vez se han eliminado. Si queremos desarrollar aplicaciones con data persistente necesitamos volúmenes.

La estructura de un pod se establece con un fichero yaml.

.. code-block:: yaml

    apiVersion: v1
    kind: Pod
    metadata:
        name: nginx
        namespace: default
        labels:
            app: nginx
    spec:
        containers:
            - image:  nginx
            name:  nginx

Estableciendo la versión de la API, el tipo de recurso, la metada para identificación del pod y las características del recurso.

Arquitectura de kubernetes
==========================

.. image:: img/Kubernetes/arquitectura-kubernetes.png


Nodo Master
-----------

* API Server: A lo que todo se conecta, los agentes, el CLI, el dashboard etc. Se usa el algoritmo de ruft para algoritmo de elección. Si el nodo master se cae perdemos el API server pero el resto de los nodos siguen funcionando.
* Scheduler: Cuando es necesario crear un job, un pod en máquinas específicas, el scheduler se encarga de asignar los pods a los nodos, revisando siempre las restricciones y los recursos disponibles.
* Controller Manager: Es un proceso que está en un ciclo de reconciliación constante buscando llegar al estado deseado con base al modelo declarativo con el que se le dan instrucciones a K8s.

Tipos de controller manager
^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Replica manager
* Deployment manager
* Service manager
* Etcd: Key value store que permite que el cluster este altamente disponible.

Componentes muy importantes que viven en los nodos
--------------------------------------------------

* Kubelet: Agente de kubernetes, se conecta con el control play y le pregunta que recursos (pods, contenedores) debo correr al scheduler via API Server. **Monitorea los pods constantemente** para saber si están activos, los recursos disponibles, etc. y se comunica constantemente con scheduler por medio del API Server.
* Kube-proxy: Se encarga de balancear el tráfico que corre a través de nuestros contenedores/servicios. Una vez llega una request se encarga de decidir a que pod y contenedor debe de ir.

Nodos
-----

Todos los nodos y masters están conectados a una red física para poder comunicarse entre sí.


Declarativo vs imperativo
=========================

Kubernetes hace enfasis en ser un sistema declarativo.

Diferencias entre sistemas imperativos y declarativos
-----------------------------------------------------

Un sistema es imperativo cuando ejecuta una serie de pasos a seguir. Si algún paso se interrumpe, la secuencia inicia desde el primer paso.
    
Un sistema es declarativo cuando trata de converger a un estado meta, a partir de un estado actual.


¿Como desplegar un cluster de kubernetes?
=========================================

Minikube
--------

Minikube usa opciones de hypervisor como virtualbox, hyperkit o KVM2 para despleguar un cluster mínimo. 

Para instalarlo puedes hacerlo desde la url oficial de `minikube <https://minikube.sigs.k8s.io/docs/start/>`_ 

Minikube utiliza kubeadm internamente.

Kubeadm
-------

.. code-block:: bash

    kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr <ip>

Al finalizar la inicialización del admin tendremos una dirección para unir nodos a nuestro cluster.

Y ahora en cada nodo que querramos unir corremos el comando que aparece al final de la salida del comando anterior. Obviamente el token será diferente.

.. code-block:: bash

    kubeadm join <ip:port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>

Y ahora vemos los nodos

.. code-block:: bash

    kubectl get nodes
    NAME    STATUS     ROLES                  AGE     VERSION
    node1   NotReady   control-plane,master   12m     v1.20.1
    node2   NotReady   <none>                 4m21s   v1.20.1

Si apreciamos el estado estarán como NotReady porque necesitamos un plugin de network.

.. code-block:: bash

    kubectl describe node node1

Por lo que es necesario correr un comando que se instale un plugin de network en el cluster. Existen muchas empresas que se dedican a hacer estos plugins, por lo que es mejor leer las especificaciones de cada uno.

.. code-block:: bash


    kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

Eventualmente los pods se inicializarán y veremos el cambio de estado. Este proceso puede tomar algo de tiempo y es secuencial; un pod a la vez.

En el ejemplo se levanta un kluster de nginx

.. code-block:: bash

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yaml

Y ejecutando get service podremos ver el puerto en el que estará disponible el servidor

.. code-block:: bash

    kubctl get service
    NAME           TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
    kubernetes     ClusterIP      10.96.0.1        <none>        443/TCP        33m
    my-nginx-svc   LoadBalancer   10.105.142.114   <pending>     80:30070/TCP   43s

En este caso el puerto 30070.

.. code-block:: bash

    kubectl get nodes -o wide
    NAME    STATUS   ROLES                  AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION      CONTAINER-RUNTIME
    node1   Ready    control-plane,master   15m     v1.20.1   192.168.0.13   <none>        CentOS Linux 7 (Core)   4.4.0-101-generic   docker://20.10.1
    node2   Ready    <none>                 7m45s   v1.20.1   192.168.0.12   <none>        CentOS Linux 7 (Core)   4.4.0-101-generic   docker://20.10.1


EKS
---

EKS es el servicio de kubernetes de AWS. Con un cloud cluster nos brincamos la parte de la configuración desde cero y la actualización de los clusters de manera manual.

Es necesario crear roles para utilizar un cluster en AWS. Por lo que es buena idea revisar la documentación vigente que ofrece Amazon.


Localmente con kind
-------------------

Kind nos permite desplegar un cluster de manera local. Para ver las instrucciones accede a esta `guia para usar kind <https://jamesdefabia.github.io/docs/getting-started-guides/docker/>`_ 

Una vez instalado kind es muy sencillo crear un cluster

Kubectl
=======

Es la herramienta para interaccionar con el cluster de kubernetes.

Kubectl guarda la configuración en una carpeta llamada *.kube* en el directorio *home* del sistema, con un archivo config dentro.

Si queremos usar otro archivo usamos

.. code-block:: bash

    kubectl --config <config_file>

Para obtener los nodos usamos el comando get nodes

.. code-block:: bash

    kubectl get nodes


Si queremos ver más detalles como versión de kernel, direcciones IP y datos extras usamos.

.. code-block:: bash

    kubectl get nodes -o wide

Si queremos ver todos los pods de todos los namespaces usamos la opción --all-namespaces.

.. code-block:: bash

    kubctl get pods --all-namespaces

Podemos ver los nodes de un namespace en particular con

.. code-block:: bash

    kubectl get nodes -n <namespace>

Para mirar los certificados secretos.

.. code-block:: bash

    kubectl get secrets -n <namespace>

Podemos recuperar el formato en formato yaml, que nos dará el label, la memoria, los cpu disponibles, si la red está disponible, las imágenes de docker que tiene y muchísimos datos extra.

.. code-block:: bash

    kubectl get nodes -o yaml

Podemos obtener información detallada de un nodo en específico

.. code-block:: bash

    kubectl describe nodes <nombre_nodo>

Y para ver la explicación de los kinds o tipos de kubectl usamos el comando *explain*. 

.. code-block:: bash

    kubectl explain node

Para ver la definición técnica de un tipo anidado (nodo.spec).

.. code-block:: bash

    kubectl explain node.spec

Mientras que para ver la definición técnica de de manera recursiva.

.. code-block:: bash

    kubectl explain node --recursive

Creación y manejo de pods
-------------------------

Para corre run pod usamos create. Antes se usaba run pero está obsoleto.

.. code-block:: bash

    kubectl create deployment NAME --image=<image>

El comando get all nos muestra la información de pods, deployments, servicios y replica set.

.. code-block:: bash

    kube get all

Para ver los logs de un deploy usamos el comando logs. Este comando pueden añadirsele opciones como --tail, que tiene la misma función que en linux, mostrar el último número de n lineas.

.. code-block:: bash

    kubectl logs <deploy/container>
    kubectl logs <deploy/container> --tail 20

Para ver los logs de muchos pods ejecutándose.

.. code-block:: bash

    kubectl logs -l run=<palabra>

Para borrar un pod usamos el comando delete pod

.. code-block:: bash

    kubectl delete pod <nombre_pod>

Y si queremos editar las características de un pod, una vez creado, podemos modificarlo con 

.. code-block:: bash

    kubectl edit pod nginx

Y un editor de texto nos permitirá modificar los valores, incluso aquellos que fueron definidos por defecto.

Revisar errores en un pod
-------------------------

Una aproximación para hacerlo sería obtener el nombre con

.. code-block:: bash

    kubectl get pods

Para posteriormente  usar describe 

.. code-block:: bash

    kubectl describe pod <nombre>


Deployment y replica set
========================

Para hacer replicas de nuestro pod corremos el comando scale y le indicamos el número de replicas que necesitamos.

.. code-block:: bash

    kubectl scale deployments/<name> --replicas <numero>

Esto nos dará esa cantidad de pods que podremos ver con el comando *kubectl get pods*.

Kubectl va a intentar mantener los pods en el estado que le indicamos. Por lo que estarán monitoreados constantemente para mantener el estado declarado.

Si queremos ver el manifest file que establece las directivas del pod usamos 

.. code-block:: bash

    kubectl run --dry-run -o yaml <nombre> --image <image> <comando>

Y para ver los logs de los pods usamos el comando *describe pods*

.. code-block:: bash

    kubectl describe pods

Accediendo a pods
=================

* ClusterIP: Una IP virtual por servicio
* NodePort: Un puerto para el servicio en todos los nodos
* LoadBalancer 
* ExternalName: Entrada de DNS por CoreDNS

Para este ejemplo creamos primero un deployment de una imagen

.. code-block:: bash

    kubectl create deployment httpenv --image jpetazzo/httpenv

A continuación escalamos una aplicación para crear múltiples pods con scale, esto nos dejará con 10 pods.

.. code-block:: bash

    kubectl scale deployment httpenv --replicas=10

Ahora exponemos nuestro deployment y sus pods como un servicio

.. code-block:: bash

    kubectl expose deployment <httpenv> --port=8888

Estará disponible como servicio y podremos verlo con el comando get svc (servicios)

.. code-block:: bash

    kubectl get svc
    NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
    httpenv      ClusterIP   10.96.204.73   <none>        8888/TCP   100s
    kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP    44m

Ahora si hacemos un curl, múltiples veces a esta dirección, podremos recuperar las variables de entorno y apreciaremos un HOSTNAME diferente cada vez, lo que indica que el balanceador de carga está funcionando. 

.. code-block:: bash

    curl http://10.96.204.73:8888 | jq ""
    {
        "HOME": "/root",
        "HOSTNAME": "httpenv-57b8868f99-dqx52",
    }

Podemos obtener las reglas de enrutado para el OUTPUT

.. code-block:: bash

    sudo iptables -t nat -L OUTPUT
    sudo iptables -t nat -nL KUBE-SERVICES


El administrador de todas las reglas es *kube-proxy*. Podemos buscar la IP de nuestro servicio

Y eso nos dará la lista de servicios. Si, ahora obtenemos las reglas de ese servicio 

.. code-block:: bash

    sudo iptables -t nat -nL KUBE-SVC-<ID>

Por defecto maneja una probabilidad azaroza (random probability), de 0 a 1, con una diferente ponderación para cada pod.

Del output anterior buscamos el que querramos conocer y lo usamos para ver a donde se dirige el tráfico, es decir a la **ip interna privada** de nuestro nodo.

.. code-block:: bash

    sudo iptables -t nat -nL KUBE-SEP-<ID>

endpoints en kubernetes
=======================

Se refiere a las direcciones ip a las que tendriamos que acceder si quisieramos acceder a ese servicio.

Los endpoints lo podemos ver con

.. code-block:: bash

    kubectl describe endpoints httpenv

    Name:         httpenv
    Namespace:    default
    Labels:       app=httpenv
    Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2022-01-26T21:10:56Z
    Subsets:
    Addresses:          10.5.1.12,10.5.1.13,10.5.1.14,10.5.1.15,10.5.1.16,10.5.1.17,10.5.1.18,10.5.1.19,10.5.1.20,10.5.1.21
    NotReadyAddresses:  <none>
    Ports:
        Name     Port  Protocol
        ----     ----  --------
        <unset>  8888  TCP

    Events:  <none>

Es el único recurso que se nombra en plural, puesto que pertenecen a uno o más pods.


Despliegue de una app en k8s
============================

Recuerda que para que nuestra app funcione correctamente necesitamos exponer los puertos correctos de nuestros deployments.

.. code-block:: bash

    kubectl expose deployment <name> --port <port>

Para exponer un puerto público en nuestra ip, usamos el comando expose con el tipo --type=NodePort

.. code-block:: bash

    kubectl expose deploy/<name> --type=NodePort --port=80

Para conocer el puerto público examinamos los servicios.

.. code-block:: bash

    kubectl get svc
    webui  NodePort 10.96.240.45  <none>  80:30986/TCP  12m


Si estamos trabajando de manera local, es necesario saber que el puerto no mapea desde el localhost o 127.0.0.1, kind hace un bind con una direccion local. Para acceder a la dirección local, podemos hacerlo con docker, examinando las configuraciones de red del contenedor.

.. code-block:: bash

    docker inspect -f "{{ .NetworkSettings.Networks.kind.IPAddress }}" $(docker ps --filter="name=kind-control-plane" -q)

Ahora, ya con el puerto y la dirección podemos acceder a nuestra aplicación.

Durante el manejo de kubernetes los servicios tienen direcciones locales que son innaccesibles para nuestra máquina, necesitamos acceder a aellas desde el cluster. Una manera es 

.. code-block:: bash

    docker exec <nombre-cluster> comando <ip-interna>
    docker exec kind-control-plane curl 10.244.0.30

Kubernetes dashboard
====================

El dashboard es una interfaz web que permite manejar el cluster y obtener información de este de una manera visual. El dashboard no está activo por defecto. Para deployarlo corre el siguiente comando.

.. code-block:: bash

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml


Este componente necesita acceder a los componentes del sistema, por lo que se crea en otro namespace.

Al final de estos apuntes hay recursos para implementar el dashboard y asegurarlo.

Daemon sets y balanceo de cargas
================================

Los daemon sets es una forma de asegurarse de que exista una copia de un pod en cada nodo. Es imposible crear daemon sets desde kubectl, su CLI, la única manera es a través de los manifest files.

.. code-block:: bash

    kubectl get deploy/<deployment> -o yaml > <deployment>.yml

Al archivo exportado le cambiaremos el kind a DaemonSet

.. code-block:: yaml

    kind: DaemonSet

Esto nos permitirá obtener el archivo yml. Sin embargo si intentamos aplicarlo directamente, hay algunos atributos que estarán de más, por lo que necesitaremos anular la validación con el flag --validate y establecerlo en falso.

.. code-block:: bash

    kubectl apply -f <deployment>.yml --validate=False

Para ver los pods de nuestro daemonset podemos filtrar los pods con el flag --selector

.. code-block:: bash

    kubectl get pods --selector=app=<service>
    NAME                   READY   STATUS    RESTARTS   AGE
    rng-5d8b6c4cff-cw955   1/1     Running   1          21h
    rng-bn5jj              1/1     Running   0          5m23s

Podremos comprobar los endpoints con

.. code-block:: bash

    kubectl describe service <service>
    Endpoints:         10.244.0.2:80,10.244.0.20:80

Cada service tiene los endpoints de los pods que se están ejecutando, de manera que otros
servicios puedan acceder.

Despliegues de nuevas versiones controlados
===========================================

Al momento de realizar una actualización a una nueva versión, kubernetes se encarga de crear los pods nuevos, manteniendo un mínimo para que nuestra app siga funcionando.

Podemos obtener metadata de de nuestros deployments

.. code-block:: bash

    kubectl get deploy -o json | jq ".items[] | {name:.metadata.name} + .spec.strategy.rollingUpdate"
    {
    "name": "hasher",
    "maxSurge": "25%",
    "maxUnavailable": "25%"
    }

maxSurge
--------

Es un campo opcional que indica el número máximo de Pods que pueden existir al momento de que ocurra una aplicación. En el momento en el que se están eliminando pods y creando nuevos puede haber un número mayor al número establecido. Su número por default es 25%.

maxUnavailable
--------------

Es un campo opcional que indica el número máximo de Pods que pueden no estar disponibles durante el proceso de actualización. Su número por default es 25%.

Para actualizar simplemente colocamos la imagen que querramos usar en nuestro deploy.

.. code-block:: bash

    kubectl set image deploy <deployment> <deployment> =<image>

.. tip:: Antes de cualquier cambio, verifica que todos los Pods estén en su estado deseado, running, de lo contrario, es mejor hacer un RollOut y corregir el problema.

Para ver los deploys

.. code-block:: bash

    kubectl get replicasets -w

Si queremos editar un deploy en tiempo de ejecución

.. code-block:: bash

    kubectl edit deploy <name>

Y si algo salió mal podemos hacer un rollout con

.. code-block:: bash

    kubectl rollout undo deploy <name>

Podemos verificar el status de un deployment con 

.. code-block:: bash

    kubectl rollout status deployment <name>

Healtchecks
===========

Healthchecks es un organismo que tiene kubernetes para evaluar el correcto funcionamiento de nuestra aplicación. 

Hay tres tipos de healtchecks:

* readiness
* liveness
* startup

liveness
--------

Kubelet usa pruebas tipo liveness para saber cuando reiniciar un contenedor. 

readiness
---------

Kubelet usa pruebas tipo readiness para saber si un container está listo para aceptar tráfico. Un pod se considera listo cuando todos sus contenedores se encuentran listos. Si no es el caso, se remueve del servicio de balanceo de carga.

Pruebas comunes
^^^^^^^^^^^^^^^

Command: Si el comando retorna 0, se considera exitoso, de otra manera se elimina el contenedor y se reinicia.

Http request: Kubelet manda una petición HTTP, al servidor, si retorna una respuesta se considera exitoso, de otra forma se elimina el contenedor y se reinicia.

TCP: Kubelet intentará abrir un puerto y conectarse si no lo consigue se elimina el contenedor y se reinicia.

startup
-------

Kubelet usa pruebas de tipo startup para saber cuando una aplicación ha iniciado. Puede ser usado para adaptar test de lveness en containers que empiezan lento, evitando eliminarlos antes de que estén listos.

Agregar un healtcheck
---------------------

Para agregar un deployment necesitamos editarlo.

.. code-block:: bash

    kubectl edit deploy/<deployment>

Los healtchecks se pueden agregar a nivel de especificación de container.

.. code-block:: bash

    spec:
        containers:
            livenessProbe:
                exec:
                    command: ["redis-cli", "ping"]


Dentro de la sección liveness de la descripción de un pod podremos ver nuestras pruebas. Así como parámetros opcionales de nuestras pruebas.

    kubectl describe pod <name>
    Liveness:       exec [redis-cli ping] delay=0s timeout=1s period=10s #success=1 #failure=3

Para ingresar a un contenedor 

.. code-block:: bash

    kubectl exec <name> -ti bash

Helm
====

Es una herramienta que funge como gestor de paquetes de Kubernetes. Permite empaquetar una aplicación en un bundle. A estos paquetes se les conoce con el nombre de chart.

Las versiones previas de Helm requerían correr el comando init. A partir de la versión 3 ya no es necesario. También aparecía el Server Side Component de Helm llamado tillir, esto ya no sucede.


Instalación de Helm
-------------------

Lo mejor para instalar helm es ir a las `instrucciones en la página oficial <https://helm.sh/docs/intro/quickstart/>`_


Prometheus
----------

Es una herramienta de monitoreo bastante popular que está empaquetada en el chart.

Primero necesitamos añadir la repo.

.. code-block:: bash

    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts


Si queremos buscar los charts relacionados

.. code-block:: bash

    helm search repo prometheus

Si inspeccionamos el 

.. code-block:: bash

    helm inspect all prometheus-community/prometheus | less

Para instalar el chart 

.. code-block:: bash

    helm install my-prometheus prometheus-community/prometheus --set server.service.type=NodePort --set server.persistentVolume.enabled=false --version 15.0.1

    helm install <target_name> <chart_name> 

Creación de un helm chart
-------------------------

Para crear un chart con helm corremos

.. code-block:: bash

    helm create <chart>

Esto creará una serie de carpetas y archivos. Con una carpeta llamada templates. Para personalizar el contenido de esta carpeta eliminamos o movemos su contenido.

A continuación podemos exportar cada uno de nuestros servicios, en forma de archivos yaml, en el interior de la carpeta templates.

.. code-block:: bash

    kubectl get -o yaml deployment <service>

Gestionando configuraciones con Config Maps
===========================================

La mayoría de las aplicaciones requieren configuraciones.

Existen formas de configuraciones diferentes:

* Argumentos de linea de comandos
* Variables de entorno
* Archivos de configuración

Config Maps
-----------

Podemos crear un config map con el comando create y la opción configmap.

.. code-block:: bash

    kubectl create configmap <name> --from-file=<archivo>

El comando anterior nos producirá un configmap con una configuración que podemos consultar con get configmap

.. code-block:: bash

    kubectl get configmap <name> -o yaml

    data: 
        haproxy.cfg: |+
            global
                daemon

Ahora solo basta con aplicarlo creando un pod que utilice ese configmap

.. code-block:: bash

    apiVersion: v1
    kind: Pod
    metadata:
    name: haproxy
    spec:
    volumes:
    - name: config
        configMap:
        name: haproxy
    containers:
    - name: haproxy
        image: haproxy
        volumeMounts:
        - name: config
        mountPath: /usr/local/etc/haproxy/ 

Resalta el uso del columen con un configMap del mismo nombre, y el container con nombre e imagen del mismo nombre.

Ahora podemos crear el pod

.. code-block:: bash

    kubectl apply -f <archivo>

Para modificar el configmap que estamos usando corremos edit.

.. code-block:: bash

    kubectl edit configmap <name>

Volúmenes
=========

Un volumen nos permite compartir archivos entre diferentes pods o archivos en nuestro host que persisten incluso tras reinicios.

Ciclo de vida
-------------

* Está vinculado al ciclo de vida de los pods
* El volumen se crea cuando el pod se crea. 
* Un volumen se mantiene aún cuando se reinicie el contenedor
* El volumen se destruye cuando el pod se elimina.

Diferencia entre docker y k8s
-----------------------------

En docker comparten información en el mismo host, k8s permite compartir información **entre contenedores del mismo pod**.




Recursos útiles
===============

*  `Kubernetes y pods <https://www.josedomingo.org/pledin/2018/06/recursos-de-kubernetes-pods/>`_ 
* `Seguridad del dashboard de k8skubectl apply -f kubernetes-dashboard.yaml <http://link>`_
* `Implementar kubernetes-dashboard <https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/>`_ 
* `Configurar tests healtcheckhttps://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ <http://link>`_ 
