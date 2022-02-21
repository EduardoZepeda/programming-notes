==========
Kubernetes
==========


¿Qué es kubernetes?
===================

Es una herramienta open source de orquestación de containers desarrollada por google.

Docker se encarga del ciclo de vida de los contendores y Kuberentes de asignar el nodo en el que nodo deben correr.

También se le conoce como k8s.


¿Qué problema resuelve?
=======================

Cuando las aplicaciones crecen demasiado es muy complicado la administración de decenas o cientos de conetendores.

Kubernetes no realiza un provisionamiento de la infraestructura

¿Qué hace kubernetes en la práctica?
====================================

* K8s permite correr varias réplicas y asegurarse de que todas se encuentren funcionando.
* Provee un balanceador de carga interno o externo automáticamente para nuestros servicios.
* Establecer mecanismos para hacer roll-outs de código.
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

Arquitectura de kubernetes
==========================

Kubernetes consiste en un nodo master, que conecta con una cantidad de nodos o minions registrados en el cluster. Y un registro de imágenes.

El nodo master recibe instrucciones de una API a la que se accede con una UI o un CLI.

.. image:: img/Kubernetes/arquitectura-kubernetes.jpg


Estructura del nodo master
--------------------------

El nodo master consiste en los siguientes elementos:

* API Server: A lo que todo se conecta, los agentes, el CLI, el dashboard etc. Se usa el algoritmo de ruft para algoritmo de elección. Si el nodo master se cae perdemos el API server pero el resto de los nodos siguen funcionando.

Este primer elemento se comunicará con los otros tres:

* Scheduler: Cuando es necesario crear un job, un pod en máquinas específicas, el scheduler se encarga de asignar los pods a los nodos, revisando siempre las restricciones y los recursos disponibles.
* Controller Manager: Es un proceso que está en un ciclo de reconciliación constante buscando llegar al estado deseado con base al modelo declarativo con el que se le dan instrucciones a K8s.
* etcd, es un key-value store que guarda la configuración del cluster de kubernetes.

Tipos de controller manager
^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Replica manager
* Deployment manager
* Service manager
* Etcd: Key value store que permite que el cluster este altamente disponible.

Componentes muy importantes que viven en los nodos
--------------------------------------------------

* Kubelet: Agente de kubernetes, se conecta con el control play y le pregunta que recursos (pods, contenedores) debo correr al scheduler via API Server. **Monitorea los pods constantemente** para saber si están activos, los recursos disponibles, etc. y se comunica constantemente con scheduler por medio del API Server.
* Kube-proxy: Se encarga de balancear el tráfico que corre a través de nuestros contenedores/servicios. Una vez llega una request este se encarga de decidir a que pod y contenedor debe de ir.

Nodos
-----

Anteriormente **se les conocia como minions**. Todos los nodos y masters están conectados a una red física para poder comunicarse entre sí. 

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


    kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yml

Eventualmente los pods se inicializarán y veremos el cambio de estado. Este proceso puede tomar algo de tiempo y es secuencial; un pod a la vez.

En el ejemplo se levanta un kluster de nginx

.. code-block:: bash

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yml

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

El comando get all nos muestra la información de pods, deployments, servicios y replica set.

.. code-block:: bash

    kube get all

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

Podemos recuperar el formato en formato yml, que nos dará el label, la memoria, los cpu disponibles, si la red está disponible, las imágenes de docker que tiene y muchísimos datos extra.

.. code-block:: bash

    kubectl get nodes -o yml

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


Recursos de kubernetes
======================

Kubernetes cuenta con varios servicios que le permiten manejar aplicaciones: 

* Pod
* ReplicaSet
* Deployment
* Services
* Ingress

Pod
===

Un pod es el más pequeño y más básico objeto que puede ser desplegado en kubernetes. Representa una instancia de un proceso que corre en el cluster. Un pod puede contener uno o más contenedores y **se aloja en un nodo**. Cuando un pod ejecuta múltiples contenedores, los contenedores se manejan como una entidad única y **comparten el mismo namespace de red (dirección IP) y el almacenamiento.**. Generalmente no se gestionaran los pods de manera individual.

Cuando se escala un pod en kubernetes se crean nuevas copias del pod, estas copias son irrecuperables una vez se han eliminado. Si queremos desarrollar aplicaciones con data persistente necesitamos volúmenes.

La estructura de un pod se establece con un fichero yml.

.. code-block:: yml

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

Creación de un pod
------------------

Un pod se puede crear directo con el archivo yml que indica el kind pod y el comando create.

.. code-block:: bash

    kubectl create -f <archivo>.yml

Podremos corroborar su creación y ver el nodo en el que se creo con

.. code-block:: bash

    kubectl get pods -o wide

Gestión de un pod
-----------------

Para describir un pod usamos el comando describe

.. code-block:: bash

    kubectl describe pod <name>

Delete permite eliminar un pod

.. code-block:: bash

    kubectl delete pod <name>

Para editarlo. Tras ejecutar el comando un editor de texto nos permitirá modificar los valores, incluso aquellos que fueron definidos por defecto.

.. code-block:: bash

    kubectl edit pod <name>

Y si queremos acceder a su interior

.. code-block:: bash

    kubectl exec -it nginx -- /bin/bash

Replica set
===========

Un ReplicaSet es un recurso de Kubernetes que garantiza que siempre se ejecute un número de réplicas de un pod determinado. Sustitye al recurso más antiguo ReplicaController. Además asegira lo siguiente:

* Tolerancia a errores
* Escalabilidad dinámica
* Que no haya caída del servicio

Definición de un yml de ReplicaSet
-----------------------------------

.. code-block:: yml

    apiVersion: extensions/v1beta1
    kind: ReplicaSet
    metadata:
    name: nginx
    namespace: default
    spec:
    replicas: 2
    selector:
        matchLabels:
        app: nginx
    template:
        metadata:
        labels:
            app: nginx
        spec:
        containers:
            - image:  nginx
            name:  nginx

El número de pods se establece en la opción replicas.

El selector indica el pod a replicar y controlar. 

.. code-block:: bash

    kubectl create <archivo_replica>.yml

Esto creará los pods, podemos acceder a la cantidad de ReplicaSets y su nombre

.. code-block:: bash

    kubectl get rs

Y obtenemos los pods que la componen con

.. code-block:: bash

    kubectl get pods

Para editar ReplicaSets usamos edit

.. code-block:: bash

    kubectl edit rs <name>

Y, manteniendo la sintaxis podremos borrar ReplicaSets con

.. code-block:: bash

    kubectl delete rs <name>

Deployment
==========

Recurso del cluster Kubernetes que nos permite manejar los ReplicaSets, su objetivo es declarar las réplicas de un pod que se ejecutarán a la vez. Los deployments delegan toda la creación y scaling de los pods a los Replicaset. Es el elemento de más alto nivel que gestiona Kubernetes.
Nos proporciona las siguientes características:

* Control de réplicas
* Escabilidad de pods
* Actualizaciones continuas
* Despliegues automáticos
* Rollback a versiones anterior

Canary deployment
-----------------

Es un término que se utiliza cuando se quiere transicionar un deployment a nueva versión código, de manera controlada.

Consiste en hacer el deploy de esta nueva versión y enviar un porcentaje del tráfico general (early adopters) con el propósito de ir midiendo el comportamiento de esta nueva versión, adicionalmente Kubernetes permite ir analizando los health checks necesarios para decidir continuar o efectuar un rollback a una versión anterior

Para definir un deployment en un archivo 

.. code-block:: yml

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
    name: nginx
    namespace: default
    labels:
        app: nginx
    spec:
    revisionHistoryLimit: 2
    strategy:
        type: RollingUpdate
    replicas: 2
    template:
        metadata:
        labels:
            app: nginx
        spec:
        containers:
        - image: nginx
            name: nginx
            ports:
            - name: http
            containerPort: 80

El deployment es la entidad con la que se interactuará más frecuentemente. El despliegue de un Deployment conlleva la creación de un ReplicaSet y los Pods correspondientes. Por lo que es necesario definir también el replicaSet asociado. 

* revisionHistoryLimit establece la cantidad de replica set para hacer un rollback.
* Strategy indica el modo en que se actualizará el deploymet.

Creación de deployments
-----------------------

Para crearlo a partir de un fichero usamos 

.. code-block:: bash

    kubectl create -f <archivo>.yml 

Anteriormente, para crear un deployment se usaba el comando run, ahora se usa el comando create deployment.

.. code-block:: bash

    kubectl create deployment NAME --image=<image>

Replicas en deployment
----------------------

Para hacer replicas de nuestro deployment corremos el comando scale y le indicamos el número de replicas que necesitamos.

.. code-block:: bash

    kubectl scale deployments/<name> --replicas <numero>

Esto nos dará esa cantidad de pods que podremos ver con el comando *kubectl get pods*.

Kubectl va a intentar mantener los pods en el estado que le indicamos. Por lo que estarán monitoreados constantemente para mantener el estado declarado.

Si queremos ver el manifest file que establece las directivas del pod usamos 

.. code-block:: bash

    kubectl run --dry-run -o yml <nombre> --image <image> <comando>

Y para ver los logs de los pods usamos el comando *describe pods*

Actualizar deployment
---------------------

Para actualizar un deployment podemos editar la imagen con el comando edit

.. code-block:: bash

    kubectl edit deployment <name>

O cambiando la imagen directamente 

    kubectl set image deployment <name> <nginx>=<nginx>:version --all

El flag *--all* obliga a la actualización de los pods.

Logs deployment
---------------

Para ver los logs de un deployment usamos el comando logs. Este comando pueden añadirsele opciones como --tail, que tiene la misma función que en linux, mostrar el último número de n lineas.

.. code-block:: bash

    kubectl logs <deploy/container>
    kubectl logs <deploy/container> --tail 20

Para ver los logs de muchos pods ejecutándose.

.. code-block:: bash

    kubectl logs -l run=<palabra>

Borrar deployment
-----------------

Siguiendo la misma sintaxis

.. code-block:: bash

    kubectl delete deployment <name>

Servicios
=========

Los servicios son una abstracción para el acceso a un conjunto de pods que impementan un microservicio (backend, frontend, etc.). Ofrecen una dirección virtual y un nombre que identifica al conjunto de pods que representan.

La conexión a un servicio se puede realizar desde otros pods o desde el exterior. 

Se implementan con iptables y son monitoreados por el componente kube-proxy.

Cuando se crea un nuevo servicio, se le asigna una nueva ip interna virtual (IP-CLUSTER) que permite la conexión desde otros pods.

Tipos de servicios
------------------

* ClusterIP: Reserva una IP virtual para el servicio que elijamos. Solo permite el acceso interno entre distintos servicios. Es el tipo por defecto. Podemos acceder desde el exterior con la instrucción *kubectl proxy*
* NodePort: Un puerto para el servicio en cada uno los nodos, generalmente en el rango de 30000 a 40000. Que nos permitirá acceder interna o externamente a partir de la ip del servidor master del cluster. 
* LoadBalancer: Balanceador externo provisionado para cloud providers (GKE, AKS o AWS).
* ExternalName: Entrada de DNS que es gestionada por CoreDNS.


Creación de un servicio a partir de un yml
------------------------------------------

Para crear un servicio, podemos establecer la definición del recurso en un archivo yml:

.. code-block:: yml

    apiVersion: v1
    kind: Service
    metadata:
    name: nginx
    namespace: default
    spec:
    type: ClusterIP
    ports:
    - name: http
        port: 80
        targetPort: http
    selector:
        app: nginx

selector especifica los pods a los que se les otorgará acceso.

Una manera alternative sería:

.. code-block:: bash

    kubectl expose deployment/nginx --port=80 --type=ClusterIP

Acceso a un ClusterIP
---------------------

Para acceder desde el exterior podemos usar kubectl proxy.

.. code-block:: bash

    kubectl proxy [--port=<numero>]

Y nos dejará el acceso libre en la dirección:

.. code-block:: bash

    http://localhost:8001/api/v1/namespaces/<NAMESPACE>/services/<SERVICE NAME>:<PORT NAME>/proxy/
    # PORT_NAME = HTTP

Acceso con kubectl-post-forward
-------------------------------

Esto nos permite realizar lo mismo que kubectl-proxy, pero accediendo a cualquier puerto del servicio expuesto en nuestro cluster

.. code-block:: bash

    kubectl post-foward svc/<svc> <puerto_local>:<puerto_remoto> &

Acceso a NodePort
-----------------

Si modificamos el type del archivo anterior

.. code-block:: bash

    type: NodePort

Tendriamos acceso al servicio a partir de la dirección IP del cluster y el puerto asignado.

.. code-block:: bash

    kubectl get svc
    NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
    nginx        NodePort    <IP>             <none>        80:34325/TCP   3h

Ejemplo de deployment
---------------------

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

Se refiere a las direcciones ip a las que tendriamos que consultar si quisieramos acceder a ese servicio.

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

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yml


Este componente necesita acceder a los componentes del sistema, por lo que se crea en otro namespace.

Al final de estos apuntes hay recursos para implementar el dashboard y asegurarlo.

Daemon sets y balanceo de cargas
================================

Los daemon sets es una forma de asegurarse de que exista una copia de un pod en cada nodo. **Es imposible crear daemon sets desde kubectl**, su CLI, la única manera es a través de los manifest files.

.. code-block:: bash

    kubectl get deploy/<deployment> -o yml > <deployment>.yml

Al archivo exportado le cambiaremos el kind a DaemonSet

.. code-block:: yml

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

Kubelet usa pruebas tipo readiness para saber si un container está listo para aceptar tráfico. Un pod se considera listo cuando todos sus contenedores se encuentran listos. Si no es el caso, se considera un fallo y, tras superarse el failureThreshold, se marca como "not ready" y se remueve del servicio de balanceo de carga.

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

Es una herramienta que funge como gestor de paquetes de Kubernetes a través de sus manifest YML. Permite empaquetar una aplicación en un bundle. A estos paquetes se les conoce con el nombre de chart.

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

A continuación podemos exportar cada uno de nuestros servicios, en forma de archivos yml, en el interior de la carpeta templates.

.. code-block:: bash

    kubectl get -o yml deployment <service>

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

    kubectl get configmap <name> -o yml

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

Namespaces
==========

Un namespace es un medio que tiene kubernetes para correr aplicaciones en un entorno aislado. Permite tener recursos con el mismo nombre y tipo, pero en diferente namespace.

Los namespaces son bastante útiles para desplegar múltiples copias o versiones de una aplicación en un mismo cluster.

Sin embargo, un namespace no provee un entorno de recursos que se encuentra completamente aislado; diferentes pods en diferentes namespaces pueden comunicarse entre ellos.

.. code-block:: bash

    kubectl get namespace
    NAME                 STATUS   AGE
    default              Active   4d19h
    kube-node-lease      Active   4d19h
    kube-public          Active   4d19h
    kube-system          Active   4d19h
    local-path-storage   Active   4d19h
    
Donde cada uno significa

* default: Para objetos creados sin namespace específico
* kube-node-lease: 
* kube-public: configurar claves de configuración. Creado por kube admin.
* kube-system: donde viven los recursos administrativos del cluster

Creación de un namespace
------------------------

Para crear un namespace usamos el comando create namespace.

.. code-block:: bash

    kubectl create namespace <name>

Alternativamente pueden crearse con un archivo yml

.. code-block:: yml

    apiVersion: v1
    kind: Namespace
    metadata:
    name: proyecto

Para correr un comando para un namespace especificamos el namespace con el flag -n.

.. code-block:: bash

    kubectl -n <name> get svc

**Los atributos que definen unicidad de un recurso son los siguientes:**:

* Tipo de recurso
* Nombre de recursos
* Namespace

Cambio de namespace
-------------------

Para configurar un contexto y no tener que especificar el flag -n en cada servicio usamos set-context

.. code-block:: bash

    kubectl config set-context --current --namespace=<name>

Si ya colocamos el contexto, ahora cuando corramos comandos básicos se ejecutaran dentro del namespace que establecimos.

.. code-block:: bash

    kubectl get pods

Autorización y autenticación
============================

Cuando el API server recibe un request, intenta autorizarlo usando:

* Certificados TLS
* Bearer tokens
* Basic Auth
* Proxy de autenticación

Nota la ausencia de Oauth dentro de los mecanismos de autenticación.

Devolviendo un error 401 (unauthorized) en caso de que se rechace.

De manera predeterminada, un usuario anónimo es incapaz de realizar operaciones en el cluster.

.. code-block:: bash

    curl -k http://<direcion>
    {
        "status": "forbidden",
        "message": "forbidden",
    }

Para ver la configuración del kubectl del archivo kube config, que incluye los usuarios y sus certificados TLS (encodeado en base 64)

.. code-block:: bash

    kubectl config view --raw -o json
    {    
        "users": [
        {
            "name": "kind-kind",
            "user": {
                "client-certificate-data": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lJYnF5dENYZ..."
            }
        }
    }

Service account tokens
----------------------

Este es un método de autenticación en kubernetes. Un service account puede crearse, eliminarse y actualizarse, sirven para otorgar permisos a aplicaciones y servicios

.. code-block:: bash

    kubectl get serviceaccounts
    kubectl get sa

esto nos mostrará el total de service accounts 

.. code-block:: bash

    NAME                               SECRETS   AGE
    default                            1         4d20h

Por lo que ahora podemos obtener de uno en particular pasándoselo como un parámetro extra 

.. code-block:: bash

    kubectl get sa default -o yml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
    creationTimestamp: "2022-01-26T22:43:42Z"
    name: default
    namespace: default
    resourceVersion: "403"
    uid: a44307a3-d1ac-458f-9205-e1faea23e934
    secrets:
    - name: default-token-7djb7
  
Para 

.. code-block:: bash

    kubectl get secret default-token-00000 -o json

    apiVersion: v1
    data:
    ca.crt: ABC==
    namespace: ABC==
    token: ABC
    kind: Secret
    metadata:
    annotations:
        kubernetes.io/service-account.name: default
        kubernetes.io/service-account.uid: a44307f3-d1ac-458f-9205-e1faea23e933
    creationTimestamp: "2022-01-26T22:43:42Z"
    name: default-token-7djb7
    namespace: default
    resourceVersion: "399"
    uid: 340e87b5-456b-4f8a-8e8c-56cf1b75d372
    type: kubernetes.io/service-account-token

Y ahora podemos decodearlo en base 64

.. code-block:: bash

    kubectl get secret default-token-00000 -o json | jq -r '.data.token' | base64 -d

Otra manera de obtener el token del usuario es ejecutando el siguiente comando. 

.. code-block:: bash

    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

    Data
    ====
    ca.crt:     1066 bytes
    namespace:  11 bytes
    token: ABC

Ahora simplemente utilizamos el token en el Authorization header

.. code-block:: bash

    "Authorization: Bearer ABC.ED..."

RBAC (Role based access control)
================================

Un rol es un objeto con una lista de rules. **Un rolbinding asocia uno de estos roles a un usuario.**

Pueden existir usuarios, roles y rolebindings con el mismo nombre. Es recomendable tener un usuario por rol. Los clusters permiten definir permisos a nivel de cluster, no únicamente de namespace.

Un pod puede estar asociado a un service-account. Con el token en */var/run/secrets*

.. code-block:: bash

    kubectl create sa <rol>

Ahora necesitamos asociarlo 

.. code-block:: bash

    kubectl create rolebinding viewercanview --clusterrole=<rol> --serviceaccount=default:<rol>

Ahora podemos correr un pod para verificar

.. code-block:: bash

    kubectl run eyepod --rm -ti --restart=Never --serviceaccount=viewer --image alpine

Dentro del pod, posteriormente, instalar kubectl

.. code-block:: bash

    wget https://storage.googleapis.com/kubernetes-release/release/v0.0.0/bin/linux/amd64/kubectl

Darle permisos de ejecución al archivo y 

.. code-block:: bash

    chmod +x kubectl

E intentar crear un deployment para ver como falla, puesto que nuestro usuario no tiene los permisos adecuados.

.. code-block:: bash

    ./kubectl create deployment testrab --image nginx
    error: failed to create deployment: deployments.apps is forbidden: User "system:serviceaccount:default:viewer" cannot create resource "deployments" in API group "apps" in the namespace "default"

Consultar permisos
------------------

Para conocer los permisos podemos usar el comando auth, seguido de can-i con la instrucción a consultar

.. code-block:: bash

    kubectl auth can-i list nodes
    kubectl auth can-i create pods
    kubectl auth can-i get pods
    kubectl auth can-i list nodes --as kube-admin

Esto nos devolverá una respuesta en forma de yes or no

Fuera del pod, si queremos conocer los permisos del kube-admin

.. code-block:: bash

    kubectl get clusterrolebindings -o yml | grep -e kubernetes-admin -e system:masters

    name: system: masters

Y para describir un rolebinding 

.. code-block:: bash

    kubectl describe clusterrolebinding cluster-admin

Recomendaciones
===============

Establece una cultura de containers en la organización 
servicios

* Escribir Dockerfiles para aplicaciones
* Escribir compose files para describir servicios
* Configurar builds automáticos de imágenes
* Automatizar el CI/CD (staging) pipeline
* Developer Experience: Acompañar a las procesas usando k8s

Elige un cluster de producción 
 
Hay alternativas como Cloud, Managed o Self-managed, también puedes usar un cluster grande o múltiples pequeños.

Recordar el uso de namespaces. Puedes desplegar varias versiones de tu aplicación en diferentes namespaces.

Servicios con estados (stateful)

* **Intenta evitarlos al principio**. No se encuentran completamente listos para producción al momento de la última actualización de estas notas.
* Técnicas para exponerlos a los pods (ExternalName, ClusterIP, Ambassador)
* Storage provider, Persistent volumens, Stateful set

Gestión del tráfico Http

* Ingress controllers (virtual host routing)

Configuración de la aplicación

* Secretos y config maps

Stacks deployments

* GitOps (infraestructure as code)
* Heml, Spinnaker o Brigade

Git ops
=======

GitOps es una práctica que gestiona toda la configuración de nuestra infraestructura y las aplicaciones en producción a través de Git, es decir que Git se considerará la fuente de verdad. Por lo que que todo proceso de infraestructura conlleva code reviews, comentarios en los archivos de configuración y enlaces a issues y PR. **Gitops es diferente de CI.**

* Infraestructura como código
* Mecanismo de convergencia
* Uso de CI como fuente de verdad
* Pull vs Push
* Developers y operaciones(git)
* Actualizaciones atómicas

GitOps se volvió popular en el mundo de DevOps por el impacto que genera.

* Despliegue de features nuevos rápidos
* Menos tiempo en arreglar bugs
* Confidencialidad y control
* Muchos más deploys por día
* 80% menos tiempo en corregir errores en producción

En Gitops el se cambia el flujo de trabajo que incorpora un operador. El operador tomará la configuración del repositorio mediante un pull y la aplicará.

.. image:: path

.. image:: img/Kubernetes/gitops.png

Flux
----

`Flux <https://fluxcd.io/docs/>`_  es un sync operator que permite crear un flujo de trabajo. Obtenemos el código con *git clone* Y modificaremos el archivo *flux/deploy/flux-deployment.yml* para decirle que repositorio y rama de monitorear.

.. code-block:: bash

    args:
    # ...
    --git-url=git@github.com:usuario/proyecto
    --git-branch=prod
    --git-poll-interval=20s

Y luego aplicar los cambios con kubectl.

.. code-block:: bash

    kubectl apply -f deploy/

El recurso aparecerá en los pods

.. code-block:: bash

    kubectl get pods

Ahora hay que tomar la clave SSH que aparece tras correr

.. code-block:: bash

    kubectl get logs
    identity.pub="<clave>"

A continuación llevamos esa clave a las credenciales del repositorio de github en la sección deploy keys. Una vez fijada flux escuchará los cambios en el repositorio y hará deploy la aplicación en la plataforma.

Ahora con cada push que hagamos se detectará el cambio y se volverá a implementar las especificaciones del repositorio de github.

Recursos útiles
===============

* `Blog de José Domingo sobre pods, deployments, replicaSet y otros recursos <https://www.josedomingo.org/pledin/blog/>`_ 
* `Seguridad del dashboard de k8skubectl apply -f kubernetes-dashboard.yml <http://link>`_
* `Implementar kubernetes-dashboard <https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/>`_ 
* `Configurar tests healtcheckhttps://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ <http://link>`_ 
* `Repositorio de Flux https://github.com/weaveworks/flux`_ 
