==========
Kubernetes
==========


¿Qué es kubernetes?
===================

Es una herramienta open source de orquestación de containers desarrollada por google.

¿Qué problema resuelve?
=======================

Cuando las aplicaciones crecen demasiado es muy complicado la administración de decenas o cientos de conetendores.


Contenedores
============

Los contenedores no son un first class citizen del kernel de Linux. Es un concepto abstracto conformado por diferentes tecnologías que se potencian las unas a las otras y trabajando en conjunto componen esta tecnología.

* Cgroups o Control Groups: Son los que permiten que un contenedor o proceso tenga aislado los recursos como memoria, I/O, Disco y más. Limitan los recursos del Sistema operativo. 
* Namespaces: Permiten aislar el proceso para que viva en un sandbox y no pueda haber otros recursos del sistema operativo o contenedores.
    - Mount Namespaces: Permite que nuestro proceso tenga una visibilidad reducida de los directorios donde trabaja.
    - Networking Namespaces: Permite que cada contenedor tenga su stack de red.
    - PID.
* Chroot: Cambia el root directory de un proceso.

¿Qué hace kubernetes?
=====================

* K8s permite correr varias réplicas y asegurarse de que todas se encuentren funcionando.
* Provee un balanceador de carga interno o externo automáticamente para nuestros servicios.
* Definir diferentes mecanismos para hacer roll-outs de código.
* Políticas de scaling automáticas.
* Jobs batch.
* Correr servicios con datos stateful.

Todos los contenedores que viven dentro de un mismo Pod comparten el mismo segmento de red.


Pod
===

Un pod es el más pequeño y más básico objeto que puede ser desplegado en kubernetes. Representa una instancia de un proceso que corre en el cluster. Un pod puede contener uno o más contenedores. Cuando un pod ejecuta múltiples contenedores, los contenedores se manejan como una entidad única y **comparten el mismo namespace de red (dirección IP)** y recursos del pod.

Cuando se escala un pod en kubernetes se crean nuevas copias del pod, estas copias son irrecuperables una vez se han eliminado.

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

EKS
---

EKS es el servicio de kubernetes de AWS. Con un cloud cluster nos brincamos la parte de la configuración desde cero y la actualización de los clusters de manera manual.

Es necesario crear roles para utilizar un cluster en AWS. Por lo que es buena idea revisar la documentación vigente que ofrece Amazon.



