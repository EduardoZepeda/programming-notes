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

Un pod es el más pequeño y más básico objeto que puede ser desplegado en kubernetes. Representa una instancia de un proceso que corre en el cluster. Un pod puede contener uno o más contenedores. Cuando un pod ejecuta múltiples contenedores, los contenedores se manejan como una entidad única y **comparten el mismo namespace de red (dirección IP) y el almacenamiento.**

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

    kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

Al finalizar la inicialización del admin tendremos una dirección para unir nodos a nuestro cluster.

Y ahora en cada nodo que querramos unir corremos el comando que aparece al final de la salida del comando anterior. Obviamente el token será diferente.

.. code-block:: bash

    kubeadm join 192.168.0.13:6443 --token 5voz75.m4j2flv4n1n4nk4g --discovery-token-ca-cert-hash sha256:1637235428de2ac9fc624d8175ededde5f572b41cdb28d4f3ced56b9bf9cf4e0

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

    kubectl scale deployments/pingpong --replicas <numero>

Esto nos dará esa cantidad de pods que podremos ver con el comando *kubectl get pods*.

Kubectl va a intentar mantener los pods en el estado que le indicamos. Por lo que estarán monitoreados constantemente para mantener el estado declarado.

Si queremos ver el manifest file que establece las directivas del pod usamos 

.. code-block:: bash

    kubectl run --dry-run -o yaml <nombre> --image <image> <comando>


Recursos útiles
===============

*  `Kubernetes y pods <https://www.josedomingo.org/pledin/2018/06/recursos-de-kubernetes-pods/>`_ 
