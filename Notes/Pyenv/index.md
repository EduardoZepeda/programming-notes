# Pyenv

Pyenv es un programa que nos permite  utilizar múltiples versiones de Python en un mismo entorno. Pyenv sobreescribe la prioridad

## Instalación

``` bash
curl https://pyenv.run | bash
```

## Instalar versiones de Python

Para instalar una versión en específico usamos

``` bash
pyenv install -v <numero.numero.numero>
```

## Listar versiones instaladas

Para ver las versiones instaladas usamos

``` bash
pyenv versions
```

## Establecer una versión para el directorio actual

Para establecer la versión a usar dentro de un proyecto usamos local

``` bash
pyenv local <numero.numero.numero>
```

## Prioridad de binarios de Python

Pyenv establecerá la prioridad del binario a usar de acuerdo al siguiente diagrama, priorizando el elemento superior y luego al subsecuente.

``` bash
Pyenv shell ($PYENV_VERSION)
Pyenv local (.python-version file)
Pyenv global (~./pyenv/version)
System Python
```

# Gestión de entornos virtuales

Para crear un entorno virtual usamos

``` bash
pyenv virtualenv <python_version> <project_name>
```

## Activar un entorno virtual

Para activar un entorno usamos local

``` bash
pyenv local <project_name>
```

## Activar múltiples versiones simultaneamente

Para usar múltiples versiones simultaneamente, ideal para probar varias versiones con software como Tox.

``` bash
pyenv local <projecto-o-version> <projecto-o-version> <projecto-o-version> ...
```