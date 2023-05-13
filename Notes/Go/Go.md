# 1. Go

Go es un lenguaje compilado desarrollado por google. Es un lenguaje
bastante apreciado según los desarrolladores de acuerdo a las últimos
encuestas de Stackoverflow (2021).

Go está fuertemente orientado a las buenas prácticas de código. El
compilador de Go fuerza buenas prácticas en el código, impidiendo que el
código compile si hay variables que no se usan, o si falta documentación
en structs públicos.

La mascota oficial es una ardilla de tierra. La comunidad ama tanto su
mascota que creó una herramienta para crear avatares personalizados en
[Gopherizme](https://gopherize.me) y es apreciado por la comunidad. Sin
embargo el [logo oficial de go](https://blog.golang.org/go-brand) ya ha
sido definido.



[comment]:STARTING_GENERATED_TOC

* [1.1-Instalación](<./content/1.1-Instalación.md>)
* [1.2-Estructura-de-un-archivo-de-go](<./content/1.2-Estructura-de-un-archivo-de-go.md>)
* [1.3-El-paquete-principal](<./content/1.3-El-paquete-principal.md>)
* [1.4-Ejecutar-un-archivo-de-go](<./content/1.4-Ejecutar-un-archivo-de-go.md>)
* [1.5-Variables-constantes-y-zero-values](<./content/1.5-Variables-constantes-y-zero-values.md>)
* [1.6-comentarios](<./content/1.6-comentarios.md>)
* [1.7-Operadores-aritméticos-en-go](<./content/1.7-Operadores-aritméticos-en-go.md>)
* [1.8-Tipos-primitivos-de-datos](<./content/1.8-Tipos-primitivos-de-datos.md>)
* [1.9-Paquete-fmt](<./content/1.9-Paquete-fmt.md>)
* [1.10-Funciones-en-Go](<./content/1.10-Funciones-en-Go.md>)
* [1.11-Strings-runes-y-bytes](<./content/1.11-Strings-runes-y-bytes.md>)
* [1.12-Paquete-strings](<./content/1.12-Paquete-strings.md>)
* [1.13-Paquete-strconv](<./content/1.13-Paquete-strconv.md>)
* [1.14-Función-len](<./content/1.14-Función-len.md>)
* [1.15-Ignorando-variables](<./content/1.15-Ignorando-variables.md>)
* [1.16-godoc](<./content/1.16-godoc.md>)
* [1.17-Ciclos](<./content/1.17-Ciclos.md>)
* [1.18-Condicional-if](<./content/1.18-Condicional-if.md>)
* [1.19-Switch](<./content/1.19-Switch.md>)
* [1.20-defer-break-y-continue](<./content/1.20-defer-break-y-continue.md>)
* [1.21-make](<./content/1.21-make.md>)
* [1.22-Array-y-slices](<./content/1.22-Array-y-slices.md>)
* [1.23-Maps](<./content/1.23-Maps.md>)
* [1.24-Structs](<./content/1.24-Structs.md>)
* [1.25-Privacidad-en-structs-funciones-y-variables](<./content/1.25-Privacidad-en-structs-funciones-y-variables.md>)
* [1.26-Manejo-de-errores-con-go](<./content/1.26-Manejo-de-errores-con-go.md>)
* [1.27-Variables-de-entorno-de-go](<./content/1.27-Variables-de-entorno-de-go.md>)
* [1.28-Importacion-de-paquetes-con-go-mod](<./content/1.28-Importacion-de-paquetes-con-go-mod.md>)
* [1.29-Structs-y-punteros](<./content/1.29-Structs-y-punteros.md>)
* [1.30-Composición-en-Go](<./content/1.30-Composición-en-Go.md>)
* [1.31-Polimorfismo-usando-interfaces](<./content/1.31-Polimorfismo-usando-interfaces.md>)
* [1.32-String-en-structs](<./content/1.32-String-en-structs.md>)
* [1.33-Concurrencia](<./content/1.33-Concurrencia.md>)
* [1.34-Channels](<./content/1.34-Channels.md>)
* [1.35-Operaciones-bloqueantes](<./content/1.35-Operaciones-bloqueantes.md>)
* [1.36-Range-close-y-select-en-channels](<./content/1.36-Range-close-y-select-en-channels.md>)
* [1.37-Go-get-manejador-de-paquetes](<./content/1.37-Go-get-manejador-de-paquetes.md>)
* [1.38-Librerías](<./content/1.38-Librerías.md>)
* [1.39-Go-modules-Ir-más-allá-del-GoPath-con-Echo](<./content/1.39-Go-modules-Ir-más-allá-del-GoPath-con-Echo.md>)
* [1.40-Librerías-de-desarrollo-web](<./content/1.40-Librerías-de-desarrollo-web.md>)
* [1.41-Enlaces-útiles](<./content/1.41-Enlaces-útiles.md>)
* [2.2-Race-conditions](<./content/2.2-Race-conditions.md>)
* [2.3-Netcat](<./content/2.3-Netcat.md>)
* [2.4-Sync-Mutex-Lock-y-Unlock](<./content/2.4-Sync-Mutex-Lock-y-Unlock.md>)
* [3.1-Servidor-básico-de-Go](<./content/3.1-Servidor-básico-de-Go.md>)
* [3.2-Testing-en-go](<./content/3.2-Testing-en-go.md>)
* [3.3-Asincronía-en-go](<./content/3.3-Asincronía-en-go.md>)
* [3.4-Patrón-workers-jobs-y-dispatchers](<./content/3.4-Patrón-workers-jobs-y-dispatchers.md>)
* [3.5-Creando-un-servidor-web](<./content/3.5-Creando-un-servidor-web.md>)
* [3.6-Peticiones-http](<./content/3.6-Peticiones-http.md>)
* [3.7-Panic](<./content/3.7-Panic.md>)
* [3.8-JSON](<./content/3.8-JSON.md>)
* [3.9-Argumentos-en-Go](<./content/3.9-Argumentos-en-Go.md>)
* [4.1-GoProtobbuffersYgRPC](<./content/4.1-GoProtobbuffersYgRPC.md>)
* [5.1-GoRESTWebSockets](<./content/5.1-GoRESTWebSockets.md>)
* [6.1-Cronjobs](<./content/6.1-Cronjobs.md>)

[comment]:ENDING_GENERATED_TOC