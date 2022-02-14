===
GIT
===

Es un sistema de control de versiones para llevar un seguimiento de los cambios en el código y poder acceder a ellos en cualquier momento.

¿Cómo funciona internamente git?
================================

Internamente git se comporta como un grafo, donde existen tres tipos de objetos principales en git:

* blob
* tree
* commit

Estos objetos se guardan en la carpeta *.git/objects*, en la raiz donde fue inicializado git, dentro de esta carpeta encontraremos subcarpetas que empiezan con los primeros dos digitos de su identificador hexadecimal.

Objeto blob
-----------

Blob es un binary large object, que contiene el contenido de los commits comprimido. Cada blob tiene un identificador que es el resultado de aplicar la función SHA1 seguido de su compresión usando zlib.

Objeto tree
-----------

Un tree es un apuntador a un blob o a otro tree.

Objeto commit
-------------

Un commit son los metadatos de un snapshot que toma de la configuración del sistema. Un commit guarda una referencia a su commit padre o commit anterior.

Si quieres profundizar más, aquí hay un excelente video sobre el `funcionamiento interno de git <https://www.youtube.com/watch?v=LjwR--_ZUt8>`_ 

Comandos de alto nivel
======================

Generalmente no se trabaja con los objetos de manera directa, sino con comandos de alto nivel en los que el flujo de trabajo consiste en

1. Realizar cambios en los archivos
2. Pasar los cambios al staging area
3. Guardar los cambios en el sistema de archivos de git

add
===

El comando add nos permite agregar los cambios realizados en nuestro proyecto al staging area, desde donde podremos guardarlos en el control de versiones de git. Git add puede recibir un nombre de archivo, una ruta o múltiples archivos por medio wildcards y patrones.

.. code:: bash

   git add <patron>

commit
======

Un commit es una fotografía o snapshot que guarda el estado de un proyecto en un momento determinado.

Commit en un solo paso
----------------------

Abreviación para agregar archivos y hacer un commit

.. code:: bash

   git commit -a -m <mensaje>

branches o ramas
================

Una rama es una bifurcación del código desde el punto en que se creo,
esto para que el código siga evolucionando sin afectar la rama
principal. Una vez que una nueva característica se ha desarrollado
podemos volver a unir la rama con la linea de código principal (rama
main) para integrar los nuevos cambios al código. La rama principal es
la rama main.

.. code:: bash

   git branch <nombre_de_rama_nueva>

También podemos hacerla a partir de un checkout

.. code:: bash

   git checkout -b <nombre_de_rama_nueva>

Eliminar ramas
--------------

Podemos borrar ramas con

.. code:: bash

   git checkout -D <nombre_de_rama>

Estos comandos nos muestran las ramas locales y las remotas

.. code:: bash

   git branch -r # se muestran todas las ramas remotas
   git branch -a # se muestran todas las ramas tanto locales como remotas

Para mandar una rama al repositorio remoto hacemos un push con el nombre de la rama.

.. code:: bash

   git push origin <nombre_de_la_rama>

merge
=====

El comando git merge crea un nuevo commit con la combinación de dos ramas. Unirá la rama donde nos encontramos con la que especifiquemos
después de merge. Al hacer merge se *creará un nuevo commit*

.. code:: bash

   git checkout main
   git merge <nombre_de_la_rama>


borrar con rm
=============

El comando git rm elimina archivos de git **sin eliminar su historial del sistema de versiones**.

Debemos usar uno de los flags para indicarle a Git cómo eliminar los
archivos:

Mantener archivos en disco duro
-------------------------------

La opción --cached elimina los archivos del área de staging y del próximo commit pero los mantiene en nuestro disco duro. 

.. code:: bash

   git rm --cached <nombre_de_archivo>

Eliminar los archivos del disco duro
------------------------------------

La opción --force Elimina los archivos de Git y del disco duro. Git siempre guarda todo, por lo que podemos acceder al registro de la existencia de los archivos, de modo que podremos recuperarlos si es necesario (pero debemos usar comandos más avanzados).


.. code:: bash

   git rm --force <archivo_o_archivos>

Reset
=====

Con git reset volvemos al pasado **sin la posibilidad de volver al
futuro. Es permanente**

Este comando es muy peligroso y debemos usarlo solo en caso de
emergencia. Recuerda que debemos usar alguna de estas dos opciones:

Conservar el staging
--------------------

La opción --soft borra el historial y registros pero conserva el staging

.. code:: bash

   git reset --soft <archivo_o_archivos>

Borrar el staging 
-----------------

La opción --hard **borra los archivos tanto del staging como de los registros.** 

.. code:: bash

   git reset --hard: <archivo_o_archivos>


git amend
=========

Nos permitirá agregar cambios al commit anterior, esto es usado cuando
olvidamos agregar algún cambio al último commit.

.. code:: bash

   git commit --amend

cherry pick
===========

El siguiente comando trae un commit del pasado y lo agrega al HEAD de
una rama, modificando la historia. Se considera que usar este comando es
una mala práctica

.. code:: bash

   git cherry-pick <hash_de_la_rama>

rebase
======

Con rebase puedes recoger todos los cambios confirmados en una rama y
ponerlos sobre otra. Esto mejorar la legibilidad del código, pues mantiene la historia en una sola linea, sin ramificaciones. *Git rebase es considerado una mala práctica por algunos desarrolladores, debido a que modifica la historia*.

Para usarlo, nos posicionamos sobre la rama a la que queremos agregar los cambios y ejecutamos rebase sobre la rama cuyos cambios queremos agregar.

.. code:: bash

   git checkout <rama_a_aplicar_rebase>
   git rebase <rama_con_los_cambios>

shortlog
========

Shortlog muestra los commit que han hecho los miembros del equipo

Contar commits
--------------

Muestra cuantos commit han hecho cada miembros del equipo.

.. code:: bash

   git shortlog -sn

Mostrar commits eliminados
--------------------------

La opción *-all* muestra cuantos commit han hecho cada miembros del equipo hasta los que han sido eliminado y merges.

.. code:: bash

   git shortlog -sn --all #

Mostrar commits sin eliminados ni merges
----------------------------------------

Muestra cuantos commit han hecho cada miembros quitando los eliminados y los merges

.. code:: bash

   git shortlog -sn --all --no-merges # 

blame
=====

Para poder responsabilizar por los cambios, linea a linea del código, se usa el comando git blame, seguido del nombre del archivo

.. code:: bash

   git blame <ruta_al_archivo>

blame linea por linea
---------------------

También es posible monitorear los cambios linea por linea con la opción -L

.. code:: bash

   git blame <ruta_al_archivo> -L<linea_inicial>,<linea_final>

help
====

Muestra a profundidad los detalles del comando de git que especifiquemos

.. code:: bash

   git <comando> --help

clean
=====

git clean borra los archivos que no están siendo rastreados por git. Recuerda que todos aquellos archivos duplicados y que correspondan con algún patrón en el archivo *.gitignore* quedan excluidos del alcance de este comando.

Confirmación antes de borrar
----------------------------

La opción --dry-run verifica y te indica cuales son los archivos que se van a borrar.

.. code:: bash

   git clean --dry-run

Mientras que la opción -f borra los archivos de manera directa.

.. code:: bash

   git clean -f

stash
=====

Git stash guarda todos aquellos cambios en el staging area de manera temporal en memoria para su posterior recuperación.

Se usa cuando queremos hacer checkout a un punto en el pasado, pero no estamos listos
para hacer commit a los cambios, ya sea porque hace mucho que no hacemos un commit, o simplemente
deseamos realizar pequeños cambios o experimentos que no vale la pena
guardar, pero que tampoco queremos perder.

Para guardar los cambios en memoria usamos el comando git stash:

.. code:: bash

   git stash

Visualizamos los cambios se guardados con

.. code:: bash

   git stash list

Una vez los cambios se encuentren en memoria podemos movernos entre commits y ramas.

.. code:: bash

   git checkout <hash_de_commit_pasado>

Recuperar los cambios en stash
------------------------------

Cuando querramos recuperar los cambios volvemos a nuestra rama

.. code:: bash

   git checkout <rama>

Usamos git stash, seguido de pop.

.. code:: bash

   git stash pop

También podemos guardar los cambios en una nueva rama

.. code:: bash

   git stash branch <nombre_rama>

Por otro lado, si queremos perder los cambios que tenemos en stash usamos *drop*

.. code:: bash

   git stash drop

grep y log
==========

Git tiene un comando derivado de grep para buscar información en los
repositorios.

Encontrar un patrón
-------------------

El comando grep -n nos devuelve el patrón buscando y la linea donde se encuentra. Cuenta con múltiples opciones que es mejor revisar en la `documentación de git <https://git-scm.com/docs/git-grep>`_ 

.. code:: bash

   git grep -n <patron_a_buscar>

Contar patrones
---------------

La opción -c busca cuantas veces se uso el patrón. 

.. code:: bash

   git grep -c <patron_a_buscar>
   git grep -c “TAG_A_BUSCAR” # Busca cuantas veces se uso la ese tag pero entre comillas

Búsqueda en los mensajes de commits
-----------------------------------

Git tambien permite buscar información en los mensajes de los commits
con el siguiente commando

log
===

.. code:: bash

   git log -S <patron_a_buscar>

Podemos ver las estadísticas de lineas cambiadas y borradas, y archivos cambiadas y borrados por commit usamos la opción --stat.

.. code:: bash

   git log --stat

Podemos ver los cambios de manera gráfica con el flag --graph

.. code-block:: bash

   git log --all --graph --decorate --oneline

Debido a que el comando es muy largo es recomendable crear un alias.

Creación de alias
=================

Para crear un alias de un comando lo hacemos a través del comando *git config*, pasándole el nombre del comando después de la sentencia "alias."

.. code-block:: bash

   git config --global alias.stats <comando_entre_comillas>
   git stats

reflog
======

Este comando nos permite recuperar todos los cambios hechos en el repositorio, incluso
aquellos que fueron desechos con *git reset --hard*

.. code:: bash

   git reflog

Excluir archivos del indice de git
==================================

Mantendrá el archivo pero borrará

.. code:: bash

   git rm --cached <file_name> or git rm -r --cached <folder_name>

Este método es para optimización. Para manejar una carpeta o una serie
de archivos que no cambiarán. Este comando le dice a git que deje de
revisar este folder cada vez que algo cambia. El contenido se
reescribira si existe un pull al archivo o directorio.

.. code:: bash

   git update-index --assume-unchanged <path_name>

Esto le dice que quieres tu propia versión independiente de un archivo o
directorio.

.. code:: bash

   git update-index --skip-worktree <path_name>

Este comando no se propagará con git tiene que ejecutarse por cada
usuario de manera individual.

Archivo .gitignore
==================

La presencia de un archivo *.gitignore* en la misma carpeta .git, encontrada en la raiz del proyecto, le indica a git deje fuera del seguimiento a los archivos que le indiquemos. El archivo *.gitignore* funciona con expresiones regulares separadas por saltos de linea.

Un archivo *.gitignore* se vería así

.. code:: bash

   #.gitignore
   node_modules/
   *.pyc

gitignore.io
------------

A veces es buena idea partir de una plantilla *.gitignore*
sobre todo en entornos de desarrollo muy complejos con varios frameworks
y tecnologías. A la fecha de estas notas existe una página web localizada en 
*https://gitignore.io* donde es posible acceder varias plantillas de archivos
*.gitignore* para diferentes tecnologías de desarrollo.

Versión gui de git
==================

Existen diferentes versiones de GUI para git, entre las que se encuentran gitk, gitkraken entre otras. Sin embargo generalmente no son usadas por la comunidad de desarrolladores.

Github
======

Tags y versiones
----------------

Los tags son útiles en github como referencia interna en github, generalmente fuera de github no son tan usados.

Para crear un tag necesitamos declarar el nombre y el mensaje

.. code-block:: bash

   git tag -a v0.1 -m <mensaje_entre_comillas> <hash_del_commit>

Mostramos la lista de todos los tags con

.. code-block:: bash

   git tag

Para consultar que commit está conectado un tag usamos 

.. code-block:: bash

   git show-ref --tags

El push de los tags creados se crea con el comando:

.. code-block:: bash

   git push origin --tags

Si queremos borrar un tag. El tag se borrará del repositorio local, pero se mantendrá en github.

.. code-block:: bash

   git tag -d <nombre_del_tag>

Para borrar la referencia al tag en github usamos el siguiente comando.

.. code-block:: bash

   git push origin :refs/tags/nombre_del_tag

branches en github
------------------

Para mostrar todas las ramas 

.. code-block:: bash

   git show-branch -all

Flujo de trabajo en github
==========================

Para modificar un repositorio **jamás se deben realizar commits directos a main**. El flujo correcto es crear una nueva branch o rama que contenga los cambios.  

Para colaboradores
------------------

Si la persona que realizó los cambios es un colaborador podremos obtener los cambios de su rama y realizar un merge de manera directa.

.. code-block:: bash

   git checkout <rama_principal>
   git merge <nombre_de_rama>
   git push origin <rama_principal>


Para no colaboradores 
---------------------

Si la persona que realiza cambios no es un colaborador se necesitará realizar un *pull request* (puede tener otros nombres en gitlab, bitbucket u otras páginas de repositorios) directo desde la plataforma de github dando click en el botón que dice *Compare & pull request*, que aparecerá tras haber subido los cambios. O directamente en el botón *new pull request*.

Review changes 
--------------

Tras presionar el botón review changes podreemos comentar, aceptar o pedir una modificación a los cambios. 

Pull Request
------------

Es el estado intermedio antes de enviar el merge, sirve para que los demás colaboradores del proyecto observen y aprueben los cambios antes de la función, son la base de colaboracion de proyectos, es exclusivo de repositorios de código y pueden nombrarse de diferente manera entre los otros repositorios de código como gitlab, bitbucket, etc.

Traer datos del fork original
-----------------------------

Para agregar una fuente desde donde traer datos a main se usa el comando *remote add*. Nombrar a esta fuente de información con el nombre de *upstream* es la convención pero puede nombrarse de forma libre.

.. code:: bash

   git remote add <nombre_personalizado_o_upstream> <direccion_url>

Para actualizar el proyecto de upstream usamos pull pasándole el nombre que definimos en el paso anterior.

.. code:: bash

   git pull <nombre_personalizado_o_upstream> <main>

Una vez hecho esto podemos hacer un commit y push a origin main para actualizar el repositorio.