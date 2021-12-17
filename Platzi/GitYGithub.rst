===
GIT
===

Es un sistema de control de versiones para llevar un seguimiento de los
cambios en el código y poder acceder a ellos en cualquier momento.

commit
======

Abreviación para agregar archivos y hacer un commit

.. code:: bash

   git commit -am "mensaje"

branches
========

Una rama es una bifurcación del código desde el punto en que se creo,
esto para que el código siga evolucionando sin afectar la rama
principal. Una vez que una nueva característica se ha desarrollado
podemos volver a unir la rama con la linea de código principal (rama
master) para integrar los nuevos cambios al código. La rama principal es
la rama master.

.. code:: bash

   git branch nombre_de_rama_nueva

También podemos hacerla a partir de un checkout

.. code:: bash

   git checkout -b nombre_de_rama_nueva

Podemos borrar ramas con

.. code:: bash

   git checkout -D nombre_de_rama

Estos comandos nos muestran las ramas locales y las remotas

.. code:: bash

   git branch -r # se muestran todas las ramas remotas
   git branch -a # se muestran todas las ramas tanto locales como remotas

Para mandar una rama al repositorio remoto hacemos un push con el nombre de la rama.

.. code:: bash

   git push origin rama

merge
=====

El comando git merge crea un nuevo commit con la combinación de dos ramas. Unirá la rama donde nos encontramos con la que especifiquemos
después de merge. Al hacer merge se *creará un nuevo commit*

.. code:: bash

   git checkout master
   git merge rama

rm
==

Elimina archivos de Git sin eliminar su historial del sistema de
versiones.

Debemos usar uno de los flags para indicarle a Git cómo eliminar los
archivos:

.. code:: bash

   git rm --cached: # Elimina los archivos del área de Staging y del próximo commit pero los mantiene en nuestro disco duro.
   git rm --force: # Elimina los archivos de Git y del disco duro. Git siempre guarda todo, por lo que podemos acceder al registro de la existencia de los archivos, de modo que podremos recuperarlos si es necesario (pero debemos usar comandos más avanzados).

reset
=====

Con git reset volvemos al pasado **sin la posibilidad de volver al
futuro. Es permanente**

Este comando es muy peligroso y debemos usarlo solo en caso de
emergencia. Recuerda que debemos usar alguna de estas dos opciones:

.. code:: bash

   git reset --soft: # Borra el historial y registros pero conserva el staging
   git reset --hard: # Borra el historial y el staging. Borra TODO

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

   git cherry-pick HASH_DE_LA_RAMA

rebase
======

Con rebase puedes recoger todos los cambios confirmados en una rama y
ponerlos sobre otra. *Usarlo se considera una mala práctica pues
modifica la historia*

.. code:: bash

   # Hacemos checkout a la rama de la que queremos traer los cambios
   git checkout experiment
   # Los integramos con master 
   git rebase master

shortlog
========

Shortlog muestra los commit que han hecho los miembros del equipo

.. code:: bash

   git shortlog -sn # Muestra cuantos commit han hecho cada miembros del equipo.
   git shortlog -sn --all # Muestra cuantos commit han hecho cada miembros del equipo hasta los que han sido eliminado y merges.
   git shortlog -sn --all # Muestra cuantos commit han hecho cada miembros quitando los eliminados y los merges

blame
=====

Para poder responsabilizar por los cambios, linea a linea del código,
alguien se usa el comando git blame, seguido del nombre del archivo

.. code:: bash

   git blame RUTA_AL_ARCHIVO 

   git blame RUTA_AL_ARCHIVO -Llinea_inicial,linea_final

help
====

Muestra a profundidad los detalles del comando de git que especifiquemos

.. code:: bash

   git COMANDO --help = muestra como funciona el comando.

clean
=====

git clean borra los archivos que no están siendo trackeados, hay que
recordar que los duplicados y los de gitignore no se tomarán en cuenta

.. code:: bash

   git clean --dry-run = este verifica y te indica que son los archivos que se van a borrar.
   git clean -f = Borra los archivos

stash
=====

Queremos hacer checkout a un punto en el pasado, pero no estamos listos
para hacer commit a los cambios y tampoco queremos perderlos, para eso
usamos git stash.

Esto sucede porque hace mucho que no hacemos un commit, o simplemente
queremos hacer pequeños cambios o experimentos que no vale la pena
guardar.

Git stash permite guardar los cambios que tenemos en memoria para
recuperarlos después.

.. code:: bash

   git stash

Podemos ver que los cambios se guardaron con

.. code:: bash

   git stash list

Ahora con los cambios guardados ya podemos ir al pasado

.. code:: bash

   git checkout pasado

Y ahora regresamos a master

.. code:: bash

   git checkout master

Y para recuperar los cambios

.. code:: bash

   git stash pop

También podemos guardar los cambios en una nueva rama

.. code:: bash

   git stash branch nombre_rama

Si queremos perder los cambios que tenemos en stash usamos *drop*

.. code:: bash

   git stash drop

grep y log
==========

Git tiene un comando derivado de grep para buscar información en los
repositorios

.. code:: bash

   git grep -n PALABRA_A_BUSCAR # Busca la palabra y muestra la linea en la que se encuentra.
   git grep -c PALABRA _A_BUSCAR # Busca cuantas veces se uso la palabra
   git grep -c “TAG_A_BUSCAR” # Busca cuantas veces se uso la ese tag pero entre comillas

git tambien permite buscar información en los mensajes de los commits
con el siguiente commando

.. code:: bash

   git log -S “PALABRA_A_BUSCAR_EN_EL_COMMIT”

Podemos ver estadisticas de los cambios hechos con

.. code:: bash

   git log --stat

Podemos ver los cambios de manera gráfica con el flag --graph

.. code-block:: bash

   git log --all --graph --decorate --oneline

Debido a que el comando es muy largo es recomendable crear un alias.

alias
=====

Para crear un alias de un comando lo hacemos a través de *git config*. pasándole el nombre del comando después de la sentencia "alias."

.. code-block:: bash

   git config --global alias.stats "shortlog -sn -all --no-merges"
   git stats

reflog
======

Este comando tiene todos los cambios hechos en el repositorio, incluso
aquellos que fueron desechos con *git reset --hard*

.. code:: bash

   git reflog

Excluir archivos del indice de git
==================================

Mantendrá el archivo pero borrará

.. code:: bash

   git rm --cached <file-name> or git rm -r --cached <folder-name>

Este método es para optimización. Para manejar una carpeta o una serie
de archivos que no cambiarán. Este comando le dice a git que deje de
revisar este folder cada vez que algo cambia. El contenido se
reescribira siá existe un pull al archivo o directorio.

.. code:: bash

   git update-index --assume-unchanged <path-name>

Esto le dice que quieres tu propia versión independiente de un archivo o
directorio.

.. code:: bash

   git update-index --skip-worktree <path-name>

Este comando no se propagará con git tiene que ejecutarse por cada
usuario de manera individual.

gitignore
=========

Gitignore permite que git deje fuera del seguimiento a los archivos que
le especifiquemos, funciona con expresiones regulares y basta con tener
un archivo llamado *.gitignore* en la misma carpeta del proyecto.

Un archivo .gitignore se vería así

.. code:: bash

   #.gitignore
   node_modules/
   *.pyc

gitignore.io
------------

A veces nos sentimos perdidos sobre que debe contener un *.gitignore*
sobre todo en entornos de desarrollo muy complejos con varios frameworks
y tecnologías. Para evitar esto podemos hacer uso de la página
*https://gitignore.io* donde vienen varias plantillas de archivos
*.gitignore* para diferentes desarrollos.

Versión gui de git
==================

Existen diferentes versiones de gui para git, entre las que se encuentran gitk, gitkraken entre otras.

Github
======

Tags y versiones
----------------

Los tags son útiles en github como referencia interna en github, generalmente fuera de github no son tan usados.

Para crear un tag necesitamos declarar el nombre y el mensaje

.. code-block:: bash

   git tag -a v0.1 -m "Mensaje del tag" hash_del_commit

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

   git tag -d nombre_del_tag

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

Para modificar un repositorio **no se deben realizar commits directos a master**. El flujo correcto es crear un branch** que contenga los cambios. 

Para colaboradores
------------------

Si la persona que hizo los cambios es un colaborador podremos obtener los cambios de su rama y realizar un merge.

.. code-block:: bash

   git checkout master
   git merge nombre_de_rama
   git push origin master


Para no colaboradores 
---------------------

Si la persona que realiza cambios no es un colaborador se necesitará realizar un *pull request* directo desde la plataforma de github en el botón que dice *Compare & pull request* que aparecerá tras haber subido los cambios o en el botón *new pull request*.

Review changes 
--------------

En el botón review changes podemos comentar, aceptar o pedir una modificación a los cambios. 

Pull Request
------------

Es el estado intermedio antes de enviar el merge, sirve para que los
demás colaboradores del proyecto observen y aprueben los cambios antes de la función, son la base de colaboracion de proyectos, es exclusivo de repositorios de código y pueden nombrarse de diferente manera entre los otros repositorios de código como gitlab, bitbucket, etc.

Traer datos del fork original
-----------------------------

Podemos especificar una fuente desde donde traer datos a master. Upstream es la convención pero puede nombrarse de forma libre.

.. code:: bash

   git remote add upstream https://github.com/usuario/proyecto

Para actualizar el proyecto de upstream usamos pull pasándole el nombre que definimos en el paso anterior.

.. code:: bash

   git pull upstream master

Una vez hecho esto podemos hacer un commit y push a origin master para actualizar el repositorio.