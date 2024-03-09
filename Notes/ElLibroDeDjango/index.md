# El libro de Django



## 1.1 Django sobre ruedas

### 1.1.1 Instalación

Al momento de iniciar un proyecto es una buena práctica usar entornos
virtuales para evitar problemas con las dependencias de tu sistema y las
del proyecto.

``` bash
virtualenv --python=python3 venv
```

Instala django. Para proyectos muy importantes puedes usar una LTS. Si
tienes más libertad puedes irte por la versión más nueva.

``` bash
pip install django
```

Para crear un proyecto usa el siguiente comando

``` bash
django-admin.py startproject misitio
```

Si quieres crear la carpeta principal dentro del directorio actual usa
la ubicación en el comando anterior.

``` bash
django-admin.py startproject misitio .
```

Esto creará la siguiente estructura de carpetas

``` bash
misitio/ (Carpeta Contenedora)
    manage.py (Utilidad linea de comandos. Usa manage.py help para ver uso)
    misitio/ (Contenedor usado para importar cualquier cosa dentro de el)
        __init__.py (Archivo para que trate el contenido como modulos)
        settings.py (Archivo de configuraciones)
        urls.py (Tabla de contenido del sitio, direcciones url)
        wsgi.py (Punto de entrada para el servidor web)
```

Posicionate dentro del directorio que contiene a manage.py y crea un
super usuario

``` bash
python3 manage.py createsuperuser
```

### 1.1.2 Configuración de base de datos

Para usar una base de datos edita el archivo settings.py para configurar
la base de datos, puedes usar mysql, postgres, etc.

Asegúrate de instalar los bindings de Python para la base de dato que
elijas.

``` bash
pip install mysqlclient
```

Modifica el archivo settings.py para modificar la variable DATABASES, de
acuerdo a tu base de datos

``` python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'Nombre_Base_Datos', #No olvides crearla primero
        'USER': 'Usuario',
        'PASSWORD': 'Contraseña',
        'HOST': 'host', #Localhost, 127.0.0.1, etc.
  'PORT': '3306', #Numero de puerto
    }
}
```

El siguiente comando busca en Installed_apps en settings.py y crea las
tablas correspondientes

``` bash
python3 manage.py migrate
```

El siguiente comando ejecuta la consola de python cargando el archivo de
configuraciones de Django

``` bash
python3 manage.py shell
```

### 1.1.3 Servidor de desarrollo

Puedes correr el servidor de desarrollo con los siguientes comandos
(Este servidor está totalmente desaconsejado en producción, es
únicamente para desarrollo)

``` bash
python3 manage.py runserver #Ver salida en consola
python3 manage.py runserver 8080 #Cambia el puerto
python3 manage.py runserver 192.148.1.103:8000 #Usa ifconfig para
ver tu verdadera dirección Ip local y que los demás puedan acceder
```

## 1.2 URLS

El servidor recibe una petición de página web. Django revisará el
archivo al que apunte la variable ROOT_URLCONF dentro de settings.py
para ver en que patrón de expresiones regulares encaja y ejecutar la
función correspondiente.

``` python
#urls.py
from django.urls import include, url
from django.contrib import admin
#NO OLVIDES importar la función a usar en URL

urlpatterns = [
    # Ejemplos. La funcion URL es una tupla (Expresion regular, funcion):
    url(r'^$', 'misitio.views.home', name='home'),
  # La función include importa patrones URL de otros modulos, apps, etc.
    url(r'^blog/', include('blog.urls')),
    url(r'^admin/', include(admin.site.urls)),
  # Las direcciones url usan expresiones regulares.
  # Puedes usar parentesis para pasarle variables a la función en url, 
  # en este caso se le pasará un digito (Codificado como cadena de caracteres) de 1 o 2 cifras 
  # a la función horas_adelante()
    url(r'^fecha/mas/(\d{1,2})/$', horas_adelante),
]
```

## 1.3 Sistema de plantillas

### 1.3.1 Plantillas HTML

Las plantillas son un conjunto de código HTML a rellenar con variables
de acuerdo a un contexto que especificaremos.

``` html
<html>
<head><title>Orden de pedido</title></head>
<body>

<h1>Orden de pedido</h1>

<p>Estimado: {{ nombre }},</p>

<p>Gracias por el pedido que ordeno de la {{ empresa }}.
El pedido junto con la mercancía se enviaran el
{{ fecha|date:"F j, Y" }}.</p>

<p>Esta es la lista de productos que usted ordeno:</p>

<ul>
{% for pedido in lista_pedido %}
    <li>{{ pedido }}</li>
{% endfor %}
</ul>

{% if garantía %}
    <p>La garantía será incluida en el paquete.</p>
    {% else %}
        <p>Lamentablemente no ordeno una garantía, por lo
        que los daños al producto corren por su cuenta.</p>
{% endif %}

<p>Sinceramente <br /> {{ empresa }}</p>
</body>
</html>
```

Como puede verse las variables se encierran dentro de dobles llaves {{
variable }} y pueden ser alterados mediante filtros, estos ultimos van
despues de la variable, seguidos del símbolo pipe \' filtro:
\"parametros,\"} Mientras que los condicionales, bucles, etc. dentro de
un juego de llave y el símbolo de porcentaje {% Realiza_esto %}

Las variables también pueden usar metodos para devolver False, True o
equivalentes {{ variable.isdigit }}, {{ variable.upper }}, {{
variable.lower}}, etc. La variable será reemplazada por un valor que
especificaremos de acuerdo al contexto.

### 1.3.2 Contexto

El contexto siempre se encontrará en forma de diccionario

``` python
variable_de_contexto = "Sandra"
contexto = {'variable_en_html': variable_de_contexto }
```

Esto reemplazará todas las {{ variable_en_html }} por \"Sandra\". Si no
existe una variable especificada en el contexto la variable se
reemplazará por una cadena vacia. La variable de contexto también puede
ser un diccionario con lo cual podemos especificar variables tipo
Key:value en la plantillas, incluido listas.

``` python
persona = {'nombre':'Sandra', 'apellido': ['Torrentera', 'Azanza']}
contexto = {'variable_en_html': persona}
```

Dentro de la plantilla se reemplazarán las {{variable_en_html.nombre}}
por \"Sandra\" y las {{variable_en_html.apellido.2}} por \"Azanza\". Los
siguientes objetos pueden usarse como contexto:

1.  Diccionario (por ej. foo\[\"bar\"\])
2.  Atributo (por ej. foo.bar)
3.  Llamada de método (por ej. foo.bar()). Si la excepción contiene la
    variable silent_variable_failure = True. Los fallos se renderizarán
    como una cadena vacia en lugar de lenvatar una excepción
4.  Índice de lista (por ej. foo\[bar\])

### 1.3.3 Etiquetas de plantilla

#### 1.3.3.1 Etiqueta {% if %}

La etiqueta If no permite el uso de diferentes operadores diferentes AND
u OR. Pero si pueden mezclarse solo AND o solo OR en una sola sentencia.
El uso de parentesis no está permitido

``` html
{% if lista_atletas or lista_entrenadores or lista_padres or lista_maestros %}
```

La etiqueta {% else %} es opcional.

``` html
{% if es_fin_de_semana %}
    <p>¡Bienvenido fin de semana!</p>
{% endif %}
```

La etiqueta {% else %} es opcional

``` html
{% if es_fin_de_semana %}
    <p>¡Bienvenido fin de semana!</p>
{% else %}
    <p>De vuelta al trabajo.</p>
{% endif %}
```

#### 1.3.3.2 Etiqueta {% for %}

La etiqueta {% for %} permite usar reversed para invertir el orden de
iteración. No se permite romper un bucle mediante \"break\" ni el uso de
la sentencia \"continue\".

``` html
{% for atleta in lista_atletas reversed %}
...
{% endfor %}}
```

La etiqueta {% empty %} permite especificar que se hará si la lista de
la etiqueta {% for %} está vacia

``` html
{% for atleta in lista_atletas %}
    <p>{{ athlete.nombre }}</p>
{% empty %}
    <p>No hay atletas. Únicamente programadores.</p>
{% endfor %}
```

Dentro de cada bucle, la etiqueta {% for %} permite acceder a una
variable llamada forloop, dentro de la plantilla. forloop.counter:
Numero de iteraciones sobre el bucle (Empieza a contar en 1).

``` html
{% for objeto in lista %}
         <p>{{ forloop.counter }}: {{ objeto }}</p>
{% endfor %}
```

-   forloop.counter0: Igual a la anterior pero comienza a contar en 0
-   forloop.revcounter: Numero de iteraciones faltantes
-   forloop.revcounter0: Igual que la anterior pero la última vuelta
    marcará 0 en lugar de 1
-   forloop.first: Devolverá True si es la primera iteración. Ideal para
    usar con {{ % if %}}
-   forloop.last: Devolverá True si es la última iteración. Ideal para
    usar con {{ % if %}}
-   forloop.parentloop: Usada para referirse al bucle padre en bucles
    anidados

``` html
{{ forloop.parentloop.counter }}
```

#### 1.3.3.3 Etiqueta {{ % ifequal % }}

Ideal para comparar valores bajo el siguiente formato. Pueden usarse
variables o cadenas de texto. La etiqueta {% else %} es opcional. Solo
permite comparar cadenas de texto, números y decimales

``` html
{% ifequal seccion 'noticias' %}
    <h1>Noticias</h1>
{% else %}
    <h1>No hay noticias nuevas</h1>
{% endifequal %}
```

#### 1.3.3.4 Comentarios

Los comentarios siguen el siguiente formato

``` html
{# Esto si es un comentario #}
{% comment %}
    Este es un comentario
    que abarca varias líneas
{% endcomment %}
```

#### 1.3.3.5 Filtros

Los filtros son usados para alterar las variables. Pueden ser sencillos
o concatenarse con otros filtros

``` html
{{ mi_lista|first|upper }}
```

Algunos filtros reciben parametros que deben ir entre dobles comillas

``` html
{{ bio|truncatewords:"30" }}
```

Los filtros más comunes son: \* Addslashes \* date {{ fecha\|date:\"F j,
Y\" }} \* escape \* length

### 1.3.4 Limitaciones

De acuerdo a las intenciones de los programadores de Django, el sistema
de plantillas tiene estas limitaciones: \* Una plantilla no puede
asignar una variable o cambiar el valor de esta. \* Una plantilla no
puede llamar código Python crudo.

### 1.3.5 Cargadores de plantillas

La llave DIRS dentro de la variable TEMPLATES especifica una lista donde
Django buscará directorios

``` python
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            # ... some options here ...
        },
    },
]
```

### 1.3.6 Render

El archivo *urls.py* recibe una dirección web, busca en que patrón de
expresiones regulares encaja y llama a la función correspondiente. Esta
función tiene la responsabilidad de devolver una respuesta, en este caso
código HTML renderizado bajo un contexto. Esto puede hacerse usando
multiples funciones, la más sencilla de usar **render()**. El archivo
views.py contendrá las funciones que retornaran el resultado de la
función **render()**.

``` python
import datetime
from django.shortcuts import render

# Función de vista que se usará desde urls.py
def fecha_actual(request): #El primer parametro siempre es request
    ahora = datetime.datetime.now()
    # Más código a utilizar
    # Contexto a crear
    # La función render() SIEMPRE requiere como primer parámetro el objeto request
    return render(request, 'fecha_actual.html', {'fecha_actual': ahora}) #Puedes usar subdirectorios bajo el formato '/subdirectorio/otra_plantilla.html'
```

### 1.3.7 Etiqueta {% Include %}

La etiqueta colocará el contenido del archivo html especificado en el
lugar de la etiqueta.

``` html
{% include 'includes/nav.html' %} {# Pueden usarse comillas sencillas o dobles #}
```

Si no se encuentra la plantilla esta fallará silenciosamente sin agregar
nada si DEBUG = False, si DEBUG = True Djago mostrará una excepción.

### 1.3.8 Herencia de plantillas

Las plantillas pueden heredarse, cambiando solo lo que es diferente y
definiendo bloques que serán diferentes de acuerdo a la sección de la
página. Primero se crea una plantilla base.

``` html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
<head>
    <title>{% block title %}{% endblock %}</title>
</head>
<body>
    <h1>Mi sitio Web</h1>
    {% block content %}{% endblock %}
    {% block footer %}
    <hr>
    <p>Gracias por visitar nuestro sitio web.</p>
{% endblock %}
</body>
</html>
```

Ya que se tiene la plantilla base se usa la etiqueta {% extends %} y se
especifican los bloques a reemplazar en esta ultima. Las etiquetas que
no se cambien utlizarán el valor por defecto definido en la plantilla
base.

``` html
{% extends "base.html" %}

{% block title %}Fecha Futura{% endblock %}

{% block content %}
    <p>En {{ horas }} horas(s), la fecha sera: {{ hora_siguiente }}.</p>
{% endblock %}
```

### 1.3.9 Reglas y recomendaciones

-   La primer etiqueta debe ser {% extends %} o la herencia no
    funcionará
-   A mayor numero de etiquetas {% block %} mejor
-   La variable {{ block.super }} obtendrá el contenido del bloque padre
-   No se recomienda definir etiquetas {% block %} con el mismo nombre
-   La etiqueta {% extends %} carga la plantilla de acuerdo a la opción
    dirs de la variable TEMPLATE en settings.py

## 1.4 Interactuando con una base de datos: Modelos

### 1.4.1 El patrón de diseño MTV

-   M significa '\'Model\'\' (Modelo): la capa de acceso a la base de
    datos.
-   T significa '\'Template\'\' (Plantilla): la capa de presentación que
    muestra los datos
-   V significa '\'View\'\' (Vista): la lógica que accede al modelo y la
    delega a la plantilla apropiada

### 1.4.2 Tu primera aplicación

Una aplicación es un conjunto portable de alguna funcionalidad de
Django, típicamente incluye modelos y vistas, que conviven en un solo
paquete de Python (Aunque el único requerimiento es que contenga una
archivo models.py). Si estás usando la capa de base de datos de Django
(modelos), debes crear una aplicación de Django. Los modelos deben vivir
dentro de aplicaciones. Crea una app con el siguiente codigo

``` bash
python3 manage.py startapp biblioteca # o el nombre de tu app
```

Esto creará la siguiente estructura

``` bash
biblioteca/
    __init__.py
    admin.py
    models.py
    tests.py
    views.py
    migrations/
        __init__.py
```

### 1.4.3 Definir modelos en Python

Django utilizará código python para crear las tablas en la base de
datos. De esa manera se evita el tener que manejar al mismo tiempo
lenguaje de base de datos y python.

### 1.4.4 Tu primer Modelo

Cada modelo es una clase que hereda de models.Model. Cada modelo es una
tabla en la base de datos. Django automaticamente coloca una llave
primaria autoincrementable a cada modelo. No olvides crear primero la
base de datos.

``` python
from django.db import models

class Editor(models.Model):
    nombre = models.CharField(max_length=30)
    domicilio = models.CharField(max_length=50)
    ciudad = models.CharField(max_length=60)
    estado = models.CharField(max_length=30)
    pais = models.CharField(max_length=50)
    website = models.URLField()

class Autor(models.Model):
    nombre = models.CharField(max_length=30)
    apellidos = models.CharField(max_length=40)
    email = models.EmailField()

class Libro(models.Model):
    titulo = models.CharField(max_length=100)
    autores = models.ManyToManyField(Autor) #Un libro puede tener multiples autores
    editor = models.ForeignKey(Editor) #Un libro tiene un editor
    fecha_publicacion = models.DateField()
    portada = models.ImageField(upload_to='portadas') #Recuerda installar pillow. Ve como más abajo
```

Recuerda agregar la app a tu archivo settings.py

``` python
INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'biblioteca',
)
```

Recuerda installar pillow para validar imagenes

``` bash
pip install pillow
```

Agregar el directorio donde se guardaran las imagenes a settings.py

``` python
MEDIA_ROOT = 'media/'
```

Así como la URL que servirá para servir esas imagenes

``` python
MEDIA_URL = 'http://localhost:8000/media/'  #En este caso al servidor de desarrollo
```

Revisa que los modelos estén correctamente escritos usando el comando

``` bash
python3 manage.py validate
```

Ejecuta el siguiente comando para que Django compruebe la sintaxis de
tus modelos

``` bash
python3 manage.py check biblioteca #Verifica que todo esté en orden, no toca la base de datos
```

Esto hace que Django guarde las migraciones en un archivo de control

``` bash
python3 manage.py makemigrations
python3 manage.py sqlmigrate biblioteca 0001 #Muestra el código SQL que se ejecutará
```

Ahora modifica las tablas usando el comando siguiente

``` bash
python3 manage.py migrate #Sincroniza los cambios hechos a los modelos
```

Los pasos para crear o actualizar cambios en el modelo son:

1.  Cambia tu modelo (en models.py).
2.  Ejecuta python manage.py makemigrations para crear las migraciones
    para esos cambios.
3.  Ejecuta python manage.py migrate para aplicar esos cambios a la base
    de datos.

### 1.4.5 Migraciones

Las migraciones son la forma en que Django se encarga de guardar los
cambios que realizamos a los modelos (Agregando un campo, una tabla o
borrando un modelo\... etc.)

### 1.4.6 Acceso básico a datos

Para crear un objeto, sólo importa la clase del modelo apropiado y crea
una instancia pasándole valores para cada campo. Para guardar el objeto
en la base de datos, llama el método **save()** del objeto (SQL INSERT).

Para recuperar objetos de la base de datos, usa el atributo
Editor.objects. Busca una lista de todos los objetos *Editor* en la base
de datos con la sentencia **Editor.objects.all()**. (SELECT)

``` python
>>> from biblioteca.models import Editor
>>> p1 = Editor(nombre='Addison-Wesley', domicilio='75 Arlington Street',
...     ciudad='Boston', estado='MA', pais='U.S.A.',
...     website='http://www.apress.com/')
>>> p1.save()
>>> Lista_Editores = Editor.objects.all()
>>> Lista_Editores
[<Editor: Editor object>, <Editor: Editor object>]
Si quieres crear un objeto en un solo paso usa el método objects.create()
>>> p1 = Editor.objects.create(nombre='Apress',
...     domicilio='2855 Telegraph Avenue',
...     ciudad='Berkeley', estado='CA', pais='U.S.A.',
...     website='http://www.apress.com/')
```

### 1.4.7 Agrega cadenas de representación a tus modelos

Para agregar una cadena de representación, agrega una funcion
\_\_str\_\_() a los modelos en models.py Debe ser una cadena de texto,
si devuelve un entero se devolverá un error.

``` python
from django.db import models

class Editor(models.Model):
    nombre = models.CharField(max_length=30)
    domicilio = models.CharField(max_length=50)
    ciudad = models.CharField(max_length=60)
    estado = models.CharField(max_length=30)
    pais = models.CharField(max_length=50)
    website = models.URLField()

    def __str__(self): # __unicode__ en Python 2
        return self.nombre #Devolverá el nombre de cada Editor

class Autor(models.Model):
    nombre = models.CharField(max_length=30)
    apellidos = models.CharField(max_length=40)
    email = models.EmailField()

    def __str__(self): # __unicode__ en Python 2
       return '%s %s' % (self.nombre, self.apellidos)#Devolverá el nombre y el apellido de cada Autor

class Libro(models.Model):
    titulo = models.CharField(max_length=100)
    autores = models.ManyToManyField(Autor)
    editor = models.ForeignKey(Editor)
    fecha_publicacion = models.DateField()
    portada = models.ImageField(upload_to='portadas')

    def __str__(self): # __unicode__ en Python 2
        return self.titulo
```

### 1.4.8 Seleccionar objetos

#### 1.4.8.1 Filtrar datos

Se usa el metodo **filter()**. Este puede recibir uno o varios
argumentos, traducidos a SQL AND. La parte *\_\_contains* puede ser
expresada como una sentencia SQL LIKE. Los resultados se tratan como una
lista.

``` bash
>>>Editor.objects.filter(ciudad="Berkeley", estado="CA")
>>>Editor.objects.filter(nombre__contains="press")
```

#### 1.4.8.2 Obtener objetos individuales

Para obtener un unico resultado se usa el metodo get() Si retorna más de
uno o no retorna nada levantará una excepción

``` bash
>>>Editor.objects.get(nombre="Apress Publishing")
```

#### 1.4.8.3 Ordenar datos

Se usa el método order_by() equivalente a SQL ORDER BY

``` python
>>> Editor.objects.order_by("nombre")
>>> Editor.objects.order_by("estado", "domicilio") #Para evitar ambigüedades
>>> Editor.objects.order_by("-nombre") #Orden inverso
```

Tambien se puede definir un orden predeterminado dentro de la clase.
Mediante la clase Meta

``` python
class Editor(models.Model):
   nombre = models.CharField(max_length=30)
   domicilio = models.CharField(max_length=50)
   ciudad = models.CharField(max_length=60)
   estado = models.CharField(max_length=30)
   pais = models.CharField(max_length=50)
   website = models.URLField()

   class Meta:
      ordering = ["nombre"]

   def __str__(self):
      return self.nombre
```

#### 1.4.8.4 Encadenar búsqueda

No existe un limite para el encadenamiento.

``` python
>>> Editor.objects.filter(pais="U.S.A.").order_by("-nombre")
```

#### 1.4.8.5 Rebanar datos

Se pueden rebanar datos como si se tratara de una lista en Python. No se
permiten los indices negativos.

``` python
>>> Editor.objects.all()[0]
>>> Editor.objects.order_by('nombre')[0:2]  #Equivalente a OFFSET 0 LIMIT 2;
```

#### 1.4.8.6 Actualizar multiples campos

El método update() puede actualizar uno o multiples campos y retorna el
numero de cambios hechos a la base datos

``` python
>>> Editor.objects.all().update(ciudad='USA')
2
```

### 1.4.9 Borrar objetos

Sirve para borrar tanto uno, como múltiples filas en la base de datos.
El borrado es permanente

``` python
>>> p = Editor.objects.get(nombre="Addison-Wesley")
>>> p.delete() #Se borra un objeto
>>> Editor.objects.filter(ciudad='USA').delete()  #Se borran todos los objetos que coincidan
>>> Editor.objects.all().delete()  #Se borran todos los objetos.
```

## 1.5 El sitio de administración

La interfaz de administración es solo parte de django.contrib. El cual
contiene muchas herramientas más. Esta esta activida por defecto si el
proyecto se inicio con \"startproject\". La interfaz puede activarse o
desactivarse de acuerdo a las necesidades del proyecto. Agrega
\'django.contrib.admin\' a la variable INSTALLED_APPS. Si quieres que
django cargue tus plantillas debes ponerlas antes de
django.contrib.admin Asegurate que estos 4 modulos se encuentren en
INSTALLED_APPS, pues son dependencias de django.contrib.admin

``` python
django.contrib.auth
django.contrib.contenttypes
django.contrib.messages
django.contrib.sessions
```

Agrega *django.contrib.messages.context_processors.messages* a la opción
de context_processors en la variable TEMPLATES de tu archivo
*settings.py* así como también agrega
*django.contrib.auth.middleware.AuthenticationMiddleware* y
*django.contrib.messages.middleware.MessageMiddleware* a la variable
MIDDLEWARE también de tu archivo *settings.py*.

Determina que modelos de tus aplicaciones serán editables en la interfaz
administrativa. No todos los modelos pueden (o deberían) ser editables
por los usuarios administradores. Por cada uno de los modelos, crea
opcionalmente una clase **ModelAdmin** en el archivo *admin.py* Apunta
la instancia AdminSite a tu URLconf Para cambiar el lenguaje en la
interfaz administrativa módifica la variable LANGUAGE_CODE al archivo
settings.py.

``` python
LANGUAGE_CODE = 'es-mx'
```

### 1.5.1 Agrega tus modelos al sitio administrativo

Agrega lo siguiente al archivo *admin.py* de tu aplicación. Django busca
en cada elemento de la variable INSTALLED_APPS un archivo *admin.py* y
agrega cada modelo en admin.site.register(modelo) a la interfaz.

``` python
from django.contrib import admin
from biblioteca.models import Editor, Autor, Libro

admin.site.register(Editor)
admin.site.register(Autor)
admin.site.register(Libro)
```

Para modificar el plural que aparece en el sitio agrega la variable
verbose_name_plural a la clase Meta en los modelos

``` python
verbose_name_plural = 'Autores'
```

### 1.5.2 Como crear campos opcionales

Para especificar un campo opcional agrega la variable blank = True al
campo que desees volver opcional.

``` {.python
class Autor(models.Model):
nombre = models.CharField(max_length=30)
apellidos = models.CharField(max_length=40)
email = models.EmailField(blank = True)}
```

Si quieres permitir agregar valores en blanco a un campo (DateField,
TimeField, DateTimeField o númerico (IntegerField, DecimalField),
FloatField) necesitas agregar null = True y blank = True. Recuerda usar
los comandos makemigrate y migrate para aplicar los cambios.

### 1.5.3 Personalizar las etiquetas de los campos

Para modificar las etiquetas de cada campo en la interfaz agrega la
variable verbose_name al campo del modelo a modificar.

``` python
class Autor(models.Model):
  nombre = models.CharField(max_length=30)
  apellidos = models.CharField(max_length=40)
  email = models.EmailField(blank=True, verbose_name='e-mail')# Verbose_name es un argumento posicional, por lo que puedes pasarlo al principio solo como 'e-mail' Sin embargo no trabaja con campos ManyToManyField o ForeignKey
```

### 1.5.4 Clases personalizadas de la interfaz administrativa

#### 1.5.4.1 Personalizar la lista de cambios

Por omisión la interfaz administrativa solo muestra los valores en la
función. \_\_[str]()\_ se cambiará de la sig. manera: Creamos la clase
AutorAdmin. Esta clase, la cual es una subclase de
django.contrib.admin.ModelAdmin, se encarga de llevar a cabo la
configuración para un modelo especifico de la interfaz administrativa.
Alteramos la llamada a admin.site.register(), para agregar AutorAdmin
después de Autor. La función admin.site.register() toma un subclase
ModelAdmin como un segundo argumento opcional para de ahí tomar sus
opciones

``` python
from django.contrib import admin
from biblioteca.models import Editor, Autor, Libro
class AutorAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'apellidos', 'email') #Ahora la interfaz mostrará nombre, apellido y email de cada autor.
    search_fields = ('nombre', 'apellidos') #Muestra un campo de busqueda
class LibroAdmin(admin.ModelAdmin):
    list_display = ('titulo', 'editor', 'fecha_publicacion')
    list_filter = ('fecha_publicacion',)
    date_hierarchy = 'fecha_publicacion' #Agregará una barra de navegación por fechas
    ordering = ('-fecha_publicacion',)# Cambia el ordenamiento por omisión
admin.site.register(Editor)
admin.site.register(Autor, AutorAdmin)
admin.site.register(Libro)
```

#### 1.5.4.2 Personalizar formularios de edición

La variable Fields cambia el orden en el que aparecen los campos en la
sección modificar, incluso puede desaparecer la opción de modificar si
se omite un valor

``` python
class LibroAdmin(admin.ModelAdmin):
  list_display = ('titulo', 'editor', 'fecha_publicacion')
  list_filter = ('fecha_publicacion',)
  date_hierarchy = 'fecha_publicacion'
  ordering = ('-fecha_publicacion',)
  fields = ('titulo', 'autores', 'editor', 'fecha_publicacion')
```

Para campos many-to-many de más de 10 objetos se recomienda usar la
variable filter_horizontal (o filter_vertical), vuelve el manejo mucho
más sencillo

``` python
class LibroAdmin(admin.ModelAdmin):
  list_display = ('titulo', 'editor', 'fecha_publicacion')
  list_filter = ('fecha_publicacion',)
  date_hierarchy = 'fecha_publicacion'
  ordering = ('-fecha_publicacion',)
  filter_horizontal = ('autores',)
```

Para campos ForeignKey, con multiples objetos, esto debido al alto
tiempo de carga de la página se recomienda usar la variable
raw_id_fields

``` python
class LibroAdmin(admin.ModelAdmin):
  list_display = ('titulo', 'editor', 'fecha_publicacion')
  list_filter = ('fecha_publicacion',)
  date_hierarchy = 'fecha_publicacion'
  ordering = ('-fecha_publicacion',)
  filter_horizontal = ('autores',)
  raw_id_fields = ('editor',)
```

### 1.5.5 Personalizar la apariencia de la interfaz de administración

Puedes colocar el titulo del sitio de administración agregando la
variable admin.site.site_header a *urls.py*

``` python
admin.site.site_header = 'Nombre de mi sitio'
admin.site.index_title = 'Panel de control de mi sitio'
admin.site.site_title = 'Titulo en la pestaña del navegador'
```

Copia la plantilla que se encuentra en django/contrib/admin/templates
dentro de un directorio llamado admin que se encuentre dentro de la ruta
a la que apunta la variable TEMPLATE en *settings.py*

### 1.5.6 Usuarios, Grupos y Permisos

En los usuarios hay 3 opciones: \* Activo: Si está desactivada el
usuario no tendrá acceso a ninguna URL que requiera identificación. \*
Es staff: Si está activada permite el ingreso al sitio administrativo
para ese usuario \* Es superusuario: da al usuario completo e
irrestricto acceso a todos los elementos de la interfaz de
administración, y sus permisos regulares son ignorados.

La lista de permisos detallada se encuentra más abajo de cada usuario Si
le das a alguien el permiso de editar usuarios, estará en condiciones de
editar sus propios permisos. También puedes asignar usuarios a grupos.
Un grupo es simplemente un conjunto de permisos a aplicar a todos los
usuarios de ese grupo.

## 1.6 Procesamiento de formularios

### 1.6.1 Obteniendo datos de los objetos Request

#### 1.6.1.1 Información acerca de las URL

Los objetos HttpRequest contienen algunas piezas de información acerca
de la URL requerida.

-   Atributos o Métodos
-   Descripción

##### 1.6.1.1.1 request.path

La ruta completa, no incluye el dominio pero incluye, la barra
inclinada.

##### 1.6.1.1.2 request.get_host()

El host (ejemplo: tu '\'dominio,\'\' en lenguaje común).
\"127.0.0.1:8000\" o \"www.example.com\" \"/hola/?print=true\"

##### 1.6.1.1.3 request.get_full_path()

La ruta (path), mas una cadena de consulta (si está disponible).

##### 1.6.1.1.4 request.is_secure()

True si la petición fue hecha vía HTTPS. Si no, False.

#### 1.6.1.2 Más información acerca de las peticiones o request

request.META es un diccionario Python, que contiene todas las cabeceras
HTTP disponibles para la petición dada **Incluyendo la dirección IP y el
agente** Generalmente el nombre y la versión del navegador Web.
Obtendrás una excepción KeyError si intentas acceder a una clave que no
existe por lo que intenta acceder a ellos en cápsulas try, except. Los
datos los manda el cliente, por lo que **nunca deberias confiar en
ellos.**

### 1.6.2 Tu primer formulario usando clases

Django posee una librería llamada django.forms, que maneja Formularios
para validar y mostrar HTML. Lo primero es definir una clase Form para
cada formulario HTML que quieras crear preferentemente en un archivo
separado *forms.py* en el mismo directorio que *views.py*

``` python
from django import forms

class FormularioContactos(forms.Form):
   asunto = forms.CharField(max_length=100) #Longitud máxima
   email = forms.EmailField(required=False) #Campo opcional
   mensaje = forms.CharField()
```

La primera cosa que puede hacer es mostrarse a sí misma como HTML. Las
etiquetas \<table\>, \<ul\> y \<form\> no se incluyen.

``` python
>>> from contactos.forms import FormularioContactos
>>> f = FormularioContactos()
>>> print(f)   # Lo imprime como tabla
>>> print(f.as_ul()) # Lo imprime como lista
>>> print(f.as_p()) #Lo imprime como párrafo
>>> print  (f['asunto']) #Imprime el input asunto
    >>> f = FormularioContactos({'asunto': 'Hola', 'email': 'adrian@example.com', 'mensaje': '¡Buen sitio!'}) # Vincula datos con el formulario
    >>> f.is_bound # Verifica si hay datos vinculados True or False
>>> f.is_valid() #Comprueba si el formulario vinculado es válido True or False
>>> f.errors #Si el formulario no es válido imprime los errores
>>> f['mensaje'].errors  # Imprime los errores asociados al campo mensaje del formulario
>>> f.cleaned_data #Si el formulario es válido es un diccionario de datos enviados 'limpiamente'
```

### 1.6.3 Enviar emails usando django

#### 1.6.3.1 CONFIGURAR UN SERVIDOR DE CORREO EN DJANGO

Django puede enviar correos fácilmente mediante la función send_mail()

``` bash
>>>from django.core.mail import send_mail
>>>send_mail('Este es el argumento', 'Aquí va el mensaje.', 'administrador@example.com',    ['para@example.com'], fail_silently=False)
```

El correo se envía usando el servidor SMPT, con el puerto y el host
especificado en el archivo de configuración *settings.py*, mediante
EMAIL_HOST y EMAIL_PORT, mientras que las variables EMAIL_HOST_USER y
EMAIL_HOST_PASSWORD se usan para autentificarte con el servidor SMPT si
así se requiere, por otra parte EMAIL_USE_TLS y EMAIL_USE_SSL se
utilizan para controlar las conexiones seguras y por último
EMAIL_BACKEND se utiliza para configurar el servidor de correo a
utilizar. Por omisión Django utiliza SMTP, como la configuración por
defecto. Si quieres especificarla explícitamente usa lo siguiente en el
archivo de configuraciones

``` python
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
```

#### 1.6.3.2 Un servidor de correo usando la terminal

Modifica la variable EMAIL_BACKEND en settings.py

``` python
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
```

Los correos serán enviados a la salida estandar.

Cambiando la forma en que los campos son renderizados

``` python
from django import forms

class FormularioContactos (forms.Form):
    asunto = forms.CharField()
    email = forms.EmailField(required=False)
    mensaje = forms.CharField(widget=forms.Textarea)
```

Las clases Field son las encargadas de la lógica de validación ,
mientras que los widgets se encargan de la lógica de presentación.

#### 1.6.3.3 Especificar valores iníciales

Podemos especificar valores iniciales pasándole el argumento initial al
formulario con un diccionario que relacione campos y valores iniciales

``` python
# contactos/views.py
def contactos(request):
    if request.method == 'POST':
        form = FormularioContactos(request.POST)
        if form.is_valid():
            cd = form.cleaned_data
            send_mail(
                cd['asunto'],
                cd['mensaje'],
                cd.get('email', 'noreply@example.com'),
                     ['siteowner@example.com'],
             )
            return HttpResponseRedirect('/contactos/gracias/')
    else:
        form = FormularioContactos(initial={'asunto': '¡Adoro tu sitio!'})
    return render(request, 'formulario-contactos.html', {'form': form})
```

Podemos especificar nuestras propias reglas de validación. El sistema de
formularios de Django, automáticamente busca cualquier método que
empiece con *clean\_* y termine con el nombre del campo. Si cualquiera
de estos métodos existe, este será llamado durante la validación.

``` python
# contactos/forms.py
from django import forms

class FormularioContactos(forms.Form):
    asunto = forms.CharField(max_length=100)
    email = forms.EmailField(required=False)
    mensaje = forms.CharField(widget=forms.Textarea)

    def clean_mensaje(self):
        mensaje = self.cleaned_data['mensaje']
        num_palabras = len(mensaje.split())
        if num_palabras < 4:
           raise forms.ValidationError("¡Se requieren mínimo 4 palabras!")
        return mensaje
```

#### 1.6.3.4 Como especificar etiquetas

Podemos especificar nuestras propias etiquetas usando el argumento label
en cada campo

``` python
# contactos/forms.py
from django import forms

class FormularioContactos(forms.Form):
  asunto = forms.CharField(max_length=100)
  email = forms.EmailField(required=False, label='Tu correo electronico')
  mensaje = forms.CharField(widget=forms.Textarea)

  def clean_mensaje(self):
      mensaje = self.cleaned_data['mensaje']
      num_palabras = len(mensaje.split())
      if num_palabras < 4:
         raise forms.ValidationError("¡Se requieren mínimo 4 palabras!")
      return mensaje
```

### 1.6.4 Diseño de formularios personalizados

La forma más rápida de personalizar la presentación de un formulario es
usando CSS (hojas de estilos).

``` html
<ul class="errorlist"> tiene asignada una clase para ese propósito.
<style type="text/css">
    ul.errorlist {
        margin: 0;
        padding: 0;
}
.errorlist li {
    background-color: red;
    color: white;
    display: block;
    font-size: 10px;
    margin: 0 0 3px;
    padding: 4px 5px;
}
</style>
```

## 1.7 Vistas avanzadas y URLconfs

### 1.7.1 Trucos de URLconf

#### 1.7.1.1 Importación de funciones de forma efectiva

Puedes importar directamente usando una cadena de texto

``` python
from misitio.views import hola, fecha_actual, horas_adelante #Usar función hola
from misitio import views # Usar views.hola
#Nada #Usar directamente 'misitio.views.hola' CON LAS COMILLAS
```

#### 1.7.1.2 Casos especiales de URLs en modo Debug

En urls.py

``` python
if settings.DEBUG:
   urlpatterns += [
      url (r'^debuginfo/$', views.debug),
   ]
```

Django se encarga de servir los archivos estáticos de forma automática,
para servir los archivos media de forma local, es necesario habilitar
una vista opcional y enlazarla a una URLconf en modo DEBUG.

``` python
if settings.DEBUG:
   urlpatterns += [
      url(r'^media/(?P<path>.*)$', serve,
         {'document_root': settings.MEDIA_ROOT,
   }),
   ]
```

De esta forma la URL /media/ sólo estará disponible si la configuración
DEBUG tiene asignado el valor True. El ejemplo anterior jamás debe
usarse en producción.

#### 1.7.1.3 Usar grupos con nombre

La sintaxis para los grupos de expresiones regulares con nombre es
(?P\<nombre\>patrón)

``` python
url(r'^libros/(?P<año>\d{4})/(?P<mes>\w{3})/(?P<dia>\d{2})/$', views.libros_dia),
```

De esta manera los datos capturados se pasan como argumentos clave, en
lugar de posicionales. Pasarle opciones extra a las funciones vista

``` python
url(r'^libros/favoritos/$', views.libros_dia, {'mes': 'enero', 'dia': '06'})

def libros_dia(request, mes, dia):
     # Código
     pass
```

De esta manera puedes hacer modificable las funciones vista, incluso
usando nombres de plantilla para que el usuario coloque las suyas

#### 1.7.1.4 Entendiendo la precedencia entre valores capturados vs. opciones extra

Tiene precedencia el valor fijado en el diccionario al final de la
función. Cuidado al crear vistas con patrones regulares pues se
ignoraran.

#### 1.7.1.5 Usando argumentos de vista por omisión

Los especificamos en la función que usemos

``` python
def una_vista(request, plantilla='biblioteca/mi_vista.html'):
   pass
```

#### 1.7.1.6 Capturando texto en URLs

Cada argumento capturado es enviado a la vista como una cadena Python,
sin importar qué tipo de coincidencia se haya producido con la expresión
regular. Recuerda usar int() o str()

#### 1.7.1.7 Entendiendo dónde busca una URLconf

El método de la petición (por ejemplo POST, GET, HEAD) no se tiene en
cuenta cuando se recorre la URLconf.

#### 1.7.1.8 Incluyendo otras URLconfs

La petición url credito/cargos/ primero encontrará concordancia con
credito/ y luego pasará a las url en include, pasando a cargos/ y
ejecutará la vista correspondiente

``` python
from django.urls import include, url
from apps.main import views as vista_principal

from credito import views as vista_credito

patrones_extra = [
    url(r'^reportes/(?P<id>[0-9]+)/$', vista_credito.reportes),
    url(r'^cargos/$', vista_credito.cargos),
]

urlpatterns = [
    url(r'^$', vista_principal.indice),
    url(r'^ayuda/', include('apps.ayuda.urls')),
    url(r'^credito/', include(patrones_extra)),
]
```

También puede usarse para remover código repetitivo. En el ejemplo
anterior se remueve código de expresiones regulares

``` python
from django.urls import include, url
from . import views

urlpatterns = [
    url(r'^(?P<pagina_slug>\w+)-(?P<pagina_id>\w+)/', include([
        url(r'^historia/$', views.historia),
        url(r'^editar/$', views.editar),
        url(r'^discusiones/$', views.discusiones),
        url(r'^permisos/$', views.permisos),
    ])),
]
```

#### 1.7.1.9 Cómo trabajan los parámetros capturados con include()

La url padre pasará toda valor capturado a TODAS las funciones hijas en
include. Asegurate de que las funciones en include puedan manejar la
variable.

``` python
url(r'^(?P<username>\w+)/blog/', include('misitio.urls.blog')),
```

#### 1.7.1.10 Cómo funcionan las opciones extra de URLconf con include()

La url padre pasará todas las opciones extra a las funciones hijas en
include. Asegurate de que las funciones en include puedan manejar la
variable.

``` python
url(r'^blog/', include('url-interna'), {'blogid': 3}),
```

#### 1.7.1.11 Resolución inversa de URLs

Al producir sitios web es necesario colocar links (href) en las
plantillas que apunten a otros sitios para facilitar la navegación,
redireccionamiento, etc. Lo anterior no deberia hacerse en duro pues
reemplazar cada link si algo cambia sería un problema. Django
proporciona herramientas para optimizar las coincidencias de URL
inversas en las distintas capas donde sean necesarios.

-   En las plantillas: Usando la etiqueta de plantillas url apuntando al
    nombre de las urls en urls.py
-   En el código Python: Usando la función django.urls.reverse
-   En código de alto nivel, para relacionar el manejo de URLs de
    instancias de modelos: por ejemplo el método get_absolute_url en los
    modelos.

A la hora de usarlo quedaría de la siguiente manera

``` python
url(r'^libros/([0-9]{4})/$', views.libros_anuales, name='libros-anuales')
```

En plantilla

``` html
<a href="{% url 'libros-anuales' 2014 %}">Libros del 2014</a>
   {# o sin el año en el contexto de la variable de la plantilla: #}
<ul>
    {% for año in lista_anual %}
       <li><a href="{% url 'libros-anuales' año %}">{{ año }} Libros</a></li>
    {% endfor %}
</ul>
```

En el código:

``` python
from django.urls import reverse
from django.http import HttpResponseRedirect

def redireccionar_libros_anuales(request):
    # ...
    year = 2014
    # ...
    return HttpResponseRedirect(reverse('libros-anuales', args=(year,)))
```

## 1.8 Plantillas avanzadas

### 1.8.1 Request context y procesadores

La función RequestContext recibe un primer parametro request y uno
opcional llamado processors el cual es una lista o una tupla de
funciones procesadoras de contexto. from django.template import loader,
RequestContext

``` python
def custom_proc(request):
   """Un procesador de contexto que provee 'aplicacion', 'usuario' y'direcccion_ip'."""
   return {
      'aplicacion': 'Biblioteca',
      'usuario': request.user,
      'direccion_ip': request.META['REMOTE_ADDR'],
   }

def vista_1(request):
  # ...
  t = loader.get_template('plantilla1.html')
  c = RequestContext(request, {'mensaje': 'Soy la vista 1.'}, #Aun puede agregarse variables de contexto si se desea
      processors=[custom_proc])
  return t.render(c)
```

Django admite el uso de procesadores de contexto globales . El parámetro
de configuración TEMPLATE_CONTEXT_PROCESSORS designa cuales serán los
procesadores de contexto que deberán ser aplicados siempre a
RequestContext. Todos toman un objeto request y retornan un diccionario
como contexto de plantilla

``` python
TEMPLATE_CONTEXT_PROCESSORS = (
    'django.core.context_processors.auth',
    'django.core.context_processors.debug',
    'django.core.context_processors.i18n',
    'django.core.context_processors.media',
)
```

#### 1.8.1.1 django.core.context_processors.auth

Contiene lo siguiente:

-   user: Instancia de django.contrib.auth.models que representa el
    usuario activo
-   messages: Una lista de mensajes (como string ) para el usuario
    actualmente autenticado.
-   Perm: Instancia de django.core.context_processors.PermWrapper, la
    cual representa los permisos del usuario actual

#### 1.8.1.2 django.core.context_processors.debug

Al ser información sensible solo se mostrará si DEBUG = True y la
solicitud ( request ) viene de una dirección IP listada en el parámetro
de INTERNAL_IPS. Contiene lo siguiente:

-   debug: El valor del parámetro de configuración DEBUG (True o False)
-   sql_queries : Una lista de diccionarios {\'sql\': \..., \'time\':
    \...} representando todas las consultas SQL que se generaron durante
    la petición ( request ) y cuánto duraron.

#### 1.8.1.3 django.core.context_processors.i18n

Si este procesador está habilitado, cada RequestContext contendrá las
siguientes variables: \* LANGUAGES : El valor del parámetro de
configuración LANGUAGES. \* LANGUAGE_CODE : request.LANGUAGE_CODE si
existe; de lo contrario, el valor del parámetro de configuración
LANGUAGE_CODE.

#### 1.8.1.4 django.core.context_processors.request

Deshabilitado por default. Cada RequestContext contendrá una variable
request, la cual es el actual objeto HttpRequest. Activalo si quieres
usar el objeto request en plantilla.

``` python
{{ request.REMOTE_ADDR }}
```

#### 1.8.1.5 Consideraciones para escribir tus propios procesadores de contexto

Cada procesador de contexto debe ser responsable por la mínima cantidad
de funcionalidad posible. Ten presente que cualquier procesador de
contexto en TEMPLATE_CONTEXT_PROCESSORS estará disponible en cada
plantilla (Evita conflictos de nombre) No importa dónde residan en el
sistema de archivos, mientras se hallen en tu ruta de Python (La
convención es en context_processors.py en la ruta de la app o proyecto)

#### 1.8.1.6 Escape automático de HTML

Por defecto en Django, cada plantilla se encarga automáticamente de
escapar la salida de cada etiqueta de variable. Como desactivar el
escape automático Para renderizar HTML en crudo o usar el sistema de
plantillas para crear correos, etc. Para Variables individuales

``` python
{{ variable }}
{{ variable | safe}} #Esto no será escapado
```

#### 1.8.1.7 Para bloques de plantillas

Puedes escapar bloques de plantillas, esto incluye a include y extends

``` html
{% autoescape off %}
    Texto {{ variable }}
{% endautoescape %}
```

#### 1.8.1.8 Escape automático de cadenas literales en argumentos de filtros

Todas las cadenas literales son insertadas sin escape automático en la
plantilla. Pero al decidir los autores que se muestra Escribirías

``` html
{{ datos default:"0 &lt; 1" }}
```

En lugar de

``` html
{{ datos default:"0 < 1" }}
```

#### 1.8.1.9 Detalles internos de la carga de plantillas

Django tiene dos maneras de cargar plantillas usando los valores de
loaders de la variable TEMPLATES:

-   django.template.loader.get_template(template): get_template retorna
    la plantilla compilada (un objeto Template) para la plantilla con el
    nombre provisto. Si la plantilla no existe, se generará una
    excepción TemplateDoesNotExist.
-   django.template.loader.select_template(template_nombre_list): Recibe
    una lista de nombres de plantillas. Retorna la primera plantilla de
    dicha lista que existe. Si ninguna plantilla existe, se generará una
    excepción TemplateDoesNotExist.

Los cargadores de plantillas especificados en loaders incluidos con
Django: \* django.template.loaders.filesystem.load_template_source:
Carga las plantillas desde el sistema de archivos \*
django.template.loaders.app_directories.load_template_source: Busca cada
app de INSTALLED_APPS un subdirectorio llamado templates \*
django.template.loaders.eggs.load_template_source: Este cargador es
básicamente idéntico a app_directories, excepto que carga las plantillas
desde eggs Python. Este cargador de plantillas se encuentra desactivado
por default.

Django usa los cargadores de plantilla en el orden de loaders y se
detendrán cuando encuentren una plantilla básica.

### 1.8.2 Extender el sistema de plantillas

#### 1.8.2.1 Crear una biblioteca para etiquetas

La creación de una biblioteca para etiquetas es un proceso de dos
pasos: 1. Decidir qué aplicación Django alojará el directorio. No
olvides agregarla a INSTALLED_APPS 2. Crea un directorio templatestags
en el paquete de aplicación Django apropiado. Debe encontrarse en el
mismo nivel que models.py, views.py, etc. Agrega un archivo
\_\_init\_\_.py para que python lo trate como modulo.

``` bash
biblioteca/
    __init__.py
    admin.py
    forms.py
    models.py
    templates/
        indice.html
    templatestags/
        __init__.py
        etiquetas.py #El archivo que tendrá las etiquetas personalizadas.
    views.py
```

Las cargaras con {% load etiquetas%} o el nombre que hayas elegido para
el archivo. Para hacer una biblioteca válida el módulo debe contener una
variable a nivel del módulo llamada register, que sea una instancia de
template.Library

``` python
from django import template
register = template.Library()
```

#### 1.8.2.2 Escribir filtros de plantilla personalizados

Los filtros son funciones python con uno o dos argumentos, la variable y
el valor del argumento, que puede tener un valor por omisión. Las
funciones filtro deben siempre retornar algo. No deben arrojar
excepciones, y deben fallar silenciosamente. {{ var\|foo:\"bar\" }} #Var
es la variable, \"bar\" el argumento y foo la función

``` python
def cortar(value, arg):
   """Remueva todos los valores que concuerdan con los Argumentos de la cadena dada"""
   return value.replace(arg, '')
```

Una vez creada la función debe registrarse en una instancia de Library.
El primer argumento es el nombre del filtro y el segundo la función a
utilizar.

``` python
register.filter('cortar', cortar)
```

#### 1.8.2.3 Escribir etiquetas de plantilla personalizadas

Cuando Django compila una plantilla, divide el texto crudo de la
plantilla en nodos. Cada nodo es una instancia de django.template.Node y
tiene un método render(). Cuando llamas a render() en una plantilla
compilada, la plantilla llama a render() en cada Node() de su lista de
nodos, con el contexto proporcionado y luego concatena el resultado

#### 1.8.2.4 Escribir la función de compilación

La función recibe el token, que son los contenidos de la etiqueta y los
divide para pasarselos a la clase NodeFechaActual, la cual posee el
método render necesario.

``` python
from django import template

register = template.Library()

def fecha_actual(parser, token): #parser es la instancia del parser #token son los contenidos en crudo de la etiqueta
    try:
        # El metodo split_contents() sabe como dividir cadenas entre comillas.
        tag_nombre, formato_cadena = token.split_contents()
    except ValueError:
        msg = '%r la etiqueta requiere un simple argumento' % token.split_contents()[0] #Siempre tendrá el nombre de la etiqueta
        raise template.TemplateSyntaxError(msg)
    return NodoFechaActual(formato_cadena[1:-1]) #Siempre deben devolver una subclase de Node
```

#### 1.8.2.5 Escribir el nodo de plantilla

El siguiente paso es escribir una sublcase Node con el metodo render()

``` python
import datetime

class NodoFechaActual(template.Node):
    def __init__(self, formato_cadena):
        self.formato_cadena = str(formato_cadena)

    def render(self, context):
        ahora = datetime.datetime.now()
        return ahora.strftime(self.formato_cadena)
```

#### 1.8.2.6 Registrar la etiqueta

El método tag() toma dos argumentos: 1. El nombre de la etiqueta 2. La
función (Si se omite se usará el nombre de la etiqueta)

``` {.python
register.tag('fecha_actual', fecha_actual)}
```

#### 1.8.2.7 Definir una variable en el contexto

Para definir una variable en el contexto, asignaremos a nuestro objeto
contexto disponible en el método render() nuestras variables, como si de
un diccionario se tratase

``` python
class NodoFechaActual2(template.Node):
    def __init__(self, formato_cadena):
        self.formato_cadena = str(formato_cadena)

    def render(self, context):
        ahora = datetime.datetime.now()
        context['fecha_actual'] = ahora.strftime(self.formato_cadena)
        return "" # Siempre debe devolver una cadena, en este caso una cadena vacia
```

Una solución más limpia sería usarla así, para hacerlo es necesario
modificar el código. El código es algo complejo y utiliza expresiones
regulares para identificar el modelo {{% funcion as variable %}}

``` html
{% traer_fecha_actual "%Y-%M-%d %I:%M %p" as mi_fecha_actual %}
<p>Fecha: {{ mi_fecha_actual }}.</p>
```

en el código

``` python
import datetime
import re
from django import template

register = template.Library()

class NodoFechaActual3(template.Node):
    def __init__(self, formato_cadena, var_nombre):
        self.formato_cadena = str(formato_cadena)
        self.var_nombre = var_nombre

    def render(self, context):
        ahora = datetime.datetime.now()
        context[self.var_nombre] = ahora.strftime(self.formato_cadena)
        return ''

@register.tag(name="traer_fecha_actual")
def traer_hora_actual(parser, token):
    # Esta versión usa expresiones regulares para analizar el contenido de la etiqueta.
    try:
        # Dividir por None == dividir por espacios.
        tag_nombre, arg = token.contents.split(None, 1)
    except ValueError:
       msg = '%r La etiqueta requiere un simple argumento' % token.contents[0]
       raise template.TemplateSyntaxError(msg)

    m = re.search(r'(.*?) as (\w+)', arg)
    if m:
        fmt, var_nombre = m.groups()
    else:
       msg = '%r Argumentos no validos para la etiqueta' % tag_nombre
       raise template.TemplateSyntaxError(msg)
    if not (fmt[0] == fmt[-1] and fmt[0] in ('"', "'")):
       msg = "%r Los argumentos deben de ir entre comillas" % tag_nombre
       raise template.TemplateSyntaxError(msg)

    return NodoFechaActual3(fmt[1:-1], var_nombre)
```

#### 1.8.2.8 Evaluar hasta otra etiqueta de bloque

Parser.parse toma una tupla de nombres de etiqueta de bloque
django.template.NodeList (nodelist es una lista con todos los nodos
antes del endcomment, no se pasa al comando return por que no se hará
nada con ese contenido). La etiqueta no se consume por lo que para
evitar su reprocesamiento se llama a delete_first_token() y despues
devuelve un string vacio. Resultado: Todo lo que está entre comments se
ignora.

``` python
def do_comment(parser, token):
    nodelist = parser.parse(('endcomment',))
    parser.delete_first_token()
    return CommentNode()

class CommentNode(template.Node):
    def render(self, context):
        return ''
```

#### 1.8.2.9 Evaluar hasta otra etiqueta de bloque y guardar el contenido

Igual que el ejemplo anterior, nodelist es la lista de todos los nodos
antes de encontrar endupper, se borra el token para evitar
reprocesamiento y la lista se pasa a la clase con el metodo render que
devolverá el metodo upper para cada nodo.

``` python
def do_upper(parser, token):
    nodelist = parser.parse(('endupper',))
    parser.delete_first_token()
    return UpperNode(nodelist)

class UpperNode(template.Node):

    def __init__(self, nodelist):
        self.nodelist = nodelist

    def render(self, context):
        output = self.nodelist.render(context)
        return output.upper()
```

#### 1.8.2.10 Un atajo para etiquetas simples

Esta función, que es un método de django.template.Library, recibe una
función que acepta un argumento, lo encapsula en una función render y lo
registra con el sistema de plantillas.

``` python
def fecha_actual(format_string):
    return datetime.datetime.now().strftime(format_string)

register.simple_tag(fecha_actual)
```

#### 1.8.2.11 Etiquetas de inclusión

Visualiza ciertos datos renderizando otra plantilla

``` python
def libros_por_autor(autor):
    libros = Libro.objects.filter(autores__id=autor.id)
    return {'libros': libros}
```

Luego creamos la plantilla usada para renderizar la salida de la
etiqueta

``` html
<ul>
   {% for libro in libros %}
      <li>{{ libro.titulo }}</li>
   {% endfor %}
</ul>
```

Y finalmente suponiendo que la plantilla se llama libros_por_autor.html
la registramos

``` python
register.inclusion_tag('libros_por_autor.html')(libros_por_autor)
```

El resultado será lo siguiente

``` html
{% libros_por_autor autor %}
```

Será remplazado por

``` html
<ul>
    <li>Libro uno</li>
    <li>Libro dos</li>
    <li>Otro libro</li>
</ul>
```

### 1.8.3 Escribir cargadores de plantillas personalizados

Aquí se muestra como implementar un cargador de plantillas
personalizado. Debe heredar de django.template.backends.base.BaseEngine.
Debe implementar un método get_template() y opcionalmente un método
llamado from_string()

``` python
from django.template import TemplateDoesNotExist, TemplateSyntaxError
from django.template.backends.base import BaseEngine
from django.template.backends.utils import csrf_input_lazy, csrf_token_lazy

import foobar


class FooBar(BaseEngine):

    # Name of the subdirectory containing the templates for this engine
    # inside an installed application.
    app_dirname = 'foobar'

    def __init__(self, params):
        params = params.copy()
        options = params.pop('OPTIONS').copy()
        super().__init__(params)

        self.engine = foobar.Engine(**options)

    def from_string(self, template_code):
        try:
            return Template(self.engine.from_string(template_code))
        except foobar.TemplateCompilationFailed as exc:
            raise TemplateSyntaxError(exc.args)

    def get_template(self, template_name):
        try:
            return Template(self.engine.get_template(template_name))
        except foobar.TemplateNotFound as exc:
            raise TemplateDoesNotExist(exc.args, backend=self)
        except foobar.TemplateCompilationFailed as exc:
            raise TemplateSyntaxError(exc.args)


class Template:

    def __init__(self, template):
        self.template = template

    def render(self, context=None, request=None):
        if context is None:
            context = {}
        if request is not None:
            context['request'] = request
            context['csrf_input'] = csrf_input_lazy(request)
            context['csrf_token'] = csrf_token_lazy(request)
        return self.template.render(context)
```

### 1.8.4 Usar la referencia de plantillas incorporadas

La interfaz de administración de Django incluye una referencia completa
de todas las etiquetas y filtros de plantillas disponibles para un sitio
determinado entrando a /admin/doc. Los pasos para hacerlo son:

1.  Agrega \'django.contrib.admindocs\' a INSTALLED_APPS a settings.py
2.  Agrega , url(r\'\^admin/doc/\',
    include(\'django.contrib.admindocs.urls\')) a urls.py (Antes
    (r\'\^admin/\')

## 1.9 Modelos avanzados

### 1.9.1 Accediendo a valores en claves foráneas

Se accede al objeto libros y editor se trata como otro objeto con sus
propios atributos.

``` python
>>> from biblioteca.models import Editor, Libro
>>> b = Libro.objects.get(id=5)
>>> b.editor
<Publisher: Apress Publishing>
>>> b.editor.website
u'http://www.apress.com/'
```

El nombre de los atributos se usa agregando el nombre del modelo en
minúsculas a \_set.

``` python
>>> p = Editor.objects.get(nombre='Apress Publishing')
>>> p.libro_set.all()
[<Libro: The Django Libro>, <Libro: Dive Into Python>, ...]
```

### 1.9.2 Accediendo a valores en claves muchos a muchos

El modelo autores se usa como si fuera un objeto de Libro, con sus
atributos y métodos

``` python
>>> b = Libro.objects.get(id=5)
>>> b.autores.all()
[<Author: Adrian Holovaty>, <Author: Jacob Kaplan-Moss>]
>>> b.autores.filter(nombre='Adrian')
[<Author: Adrian Holovaty>]
>>> b.autores.filter(nombre='Adam')
```

El nombre de los atributos se usa agregando el nombre del modelo en
minúsculas a \_set.

``` python
>>> from biblioteca.models import Autor
>>> a = Autor.objects.get(nombre='Adrian', apellidos='Holovaty')
>>> a.libro_set.all()
[<Libro: The Django Libro>, <Libro: Adrian's Other Libro>]
```

### 1.9.3 Como realizar cambios al esquema de la base de datos

Las nuevas versiones de Django borran, modifican datos solo cambiando
los modelos y ejecutando makemigrations y migrate.

#### 1.9.3.1 Agregar campos

1.  Agrega el campo a tu modelo.
2.  Asegúrate que el campo incluya las opciones blank=True o null=True
    (si es un campo basado en fechas o numérico).
3.  Ejecuta el comando manage.py makemigrations, para grabar los
    cambios.
4.  Sincroniza los modelos con manage.py migrate.

#### 1.9.3.2 Eliminar campos

1.  Remueve el campo de tu modelo.
2.  Ejecuta el comando python3 manage.py makemigrations, para grabar los
    cambios.
3.  Haz los cambios en la base de datos con el comando python3 manage.py
    migrate
4.  Y reinicia el servidor Web.

#### 1.9.3.3 Eliminar relaciones muchos a muchos

1.  Remueve el campo muchos a muchos de tu modelo.
2.  Ejecuta el comando python3 manage.py makemigrations, para grabar los
    cambios.
3.  Haz los cambios en la base de datos con el comando python3 manage.py
    migrate
4.  Y reinicia el servidor Web.

#### 1.9.3.4 Eliminar modelos

1.  Remueve el modelo.
2.  Ejecuta el comando python3 manage.py makemigrations, para grabar los
    cambios.
3.  Haz los cambios en la base de datos con el comando python3 manage.py
    migrate
4.  Y reinicia el servidor Web.

### 1.9.4 Manejadores o Managers

Un Manager es la interfaz a través de la cual se proveen las operaciones
de consulta de la base de datos a los modelos de Django

#### 1.9.4.1 Nombres de manager

Django agrega un Manager llamado objects a cada clase modelo de Django
para cambiar el nombre se modifica el modelo así

``` python
from django.db import models

class Persona(models.Model):
   gente = models.Manager() #Esto te permitira llamar Persona.gente.all() en lugar de Persona.objects.all()
```

#### 1.9.4.2 Managers Personalizados

Las razones de usar managers personalizados pueden ser para agregar
métodos extra al Manager, y/o para modificar el QuerySet inicial que
devuelve el Manager.

``` python
from django.db import models

class ManejadorLibros(models.Manager):
    def contar_titulos(self, keyword):
        return self.filter(titulo__icontains=keyword).count()
        #self se refiere al manager en sí mismo

class Libro(models.Model):
    objects = ManejadorLibros() #Renombra al manager por defecto aquí se usa objects para ser consistente
```

Lo que te permitirá hacer esto

``` bash
>>> Libro.objects.contar_titulos('django')
4
```

#### 1.9.4.3 Modificando los QuerySets iniciales del Manager

Un QuerySet base de un Manager devuelve todos los objetos en el sistema.
Puedes sobrescribir el QuerySet base, sobrescribiendo el método
Manager.get_query_set(). Se pueden definir varios manager, el primer
manager es el manager por omisión, usado para otras caracteristicas
especiales

``` python
from django.db import models

# Primero, definimos una subclase para el Manager.
class DahlLibroManager(models.Manager):
    def get_query_set(self):
        return super(DahlLibroManager, self).get_query_set().filter(autor='Roald Dahl')

# Despues lo anclamos al modelo Libro explícitamente.
class Libro(models.Model):
    # ...
    objects = models.Manager() # El manager predeterminado.
    dahl_objects = DahlLibroManager()
```

Al ejecutar el manejador devolverá solo los libros escritos por Roald
Dahl y puede usar todos los métodos de QuerySet sobre el

``` python
>>> Libro.dahl_objects.all()
>>> Libro.dahl_objects.filter(titulo='Matilda')
```

#### 1.9.4.4 Métodos de un Modelo

Se usan para obtener datos que de preferencia no estén a nivel de tabla,
pero esten basados en los datos de tabla

``` python
from django.db import models

class Persona(models.Model):
    #...
    def es_del_medio_oeste(self):
      "Retorna True si la persona nacio en el medio-oeste."
      return self.estado in ('IL', 'WI', 'MI', 'IN', 'OH', 'IA', 'MO')
```

#### 1.9.4.5 get_absolute_url

Define un método get_absolute_url() para decirle a Django cómo calcular
la URL de un objeto, por ejemplo. Si un objeto define
get_absolute_url(), la página de edición del objeto tendrá un enlace
'\'View on site\'\', que te llevará directamente a la vista pública del
objeto

``` python
def get_absolute_url(self):
    from django.urls import reverse
    return reverse('gente.views.detalles', args=[str(self.id)])
```

Y asi poder usar

``` html
<a href="{{ object.get_absolute_url }}">{{ object.nombre }}</a>
```

#### 1.9.4.6 Sobrescribir métodos predefinidos de un modelo

Para obtener otros comportamientos de los métodos tradicionales.

``` python
from django.db import models

class Autor(models.Model):
    #...

     def save(self, *args, **kwargs):
        haz_algo()
        super(Autor, self).save(*args, **kwargs)#Llama al verdadero método save()
```

#### 1.9.4.7 Ejecutando consultas personalizadas en SQL

Se crea un método para la clase. Connection y cursor implementan en su
mayor parte la API de bases de datos estándar de Python que ejecute el
código SQL personalizado

``` python
from django.db import connection
cursor = connection.cursor()
class PersonaManager(models.Manager):
     def nombres(self, apellido):
        cursor = connection.cursor()
        cursor.execute("""
            SELECT DISTINCT apellido
            FROM persona
            WHERE apellido = %s""", [apellido])
        return [row[0] for row in cursor.fetchone()]

class Persona(models.Model):
     #...
     objects = PersonaManager()
```

## 1.10 Vistas genericas

### 1.10.1 Vista Base

Todas las vistas heredan de la clase-base View. Hay 3 principales: View,
TemplateView y RedirectView Organizan el código relacionado en métodos
específicos HTTP (GET, POST, etc) Usan la técnica de orientación a
objetos para crear '\'mixins\'\' (herencia múltiple) para factorizar el
código en componentes comunes y reutilizables.

### 1.10.2 View

View es la clase base maestra, las demás vistas heredan de esta clase
base Flujo de los métodos: 1. dispatch(): El método que valida el
argumento de la petición, más los argumentos recibidos y devuelve la
respuesta correcta HTTP. (GET a get() POST a post()) Llamada por
as_view() 2. http_method_not_allowed(): Si la vista es llamada con un
método HTTP no soportado, este método es llamado en su lugar. 3.
options(): Manejadores que responden a las peticiones OPTIONS HTTP.
Retorna una lista de nombres permitidos al método HTTP para la vista En
este ejemplo si la petición es GET se llamará al método del mismo nombre
de la clase MiVista. Al ser una clase, la vistas basadas en clases
provén un método interno llamado as_view(), que sirve como punto de
entrada para enlazar la clase a la URL

``` python
# views.py
from django.http import HttpResponse
from django.views.generic import View

class MiVista(View):

    def get(self, request, *args, **kwargs):
        return HttpResponse('Hola, Mundo')

# urls.py
from django.urls import url
from myapp.views import MiVista

urlpatterns = [
    url(r'^hola/$', MiVista.as_view(), name='mi-vista'),
]
```

### 1.10.3 TemplateView

La clase TemplateView renderiza una plantilla dada, con el contexto que
contiene los parámetros capturados en la URL. Esta vista hereda
atributos y métodos de las siguientes vistas:

-   django.views.generic.base.TemplateResponseMixin
-   django.views.generic.base.ContextMixin
-   django.views.generic.base.View

Flujo de los métodos: 1. dispatch(): Valida la petición 2.
http_method_not_allowed(): Verifica los métodos soportados. 3.
get_context_data(): Se encarga de pasarle el contexto (context) a la
vista. En el ejemplo obtiene los datos de contexto de la clase padre y
agrega uno nuevo. Despues de eso usa la variable template_name para
cargar la plantilla del mismo nombre.

``` python
# views.py:
from django.views.generic.base import TemplateView
from biblioteca.models import Libro

class PaginaInicio(TemplateView):
    template_name = "bienvenidos.html" #Nombre la plantilla a usar. La variable es fija.
    def get_context_data(self, **kwargs):
      context = super(PaginaInicio,self).get_context_data(**kwargs)#Obtiene los datos de contexto de la clase padre
      context['ultimos_libros'] = Libro.objects.all()[:5] #Agrega un dato de contexto extra
      return context #Retorna el contexto a la plantilla a usar

# urls.py:

from django.urls import url
from biblioteca.views import PaginaInicio

urlpatterns = [
    url(r'^$', PaginaInicio.as_view(), name='bienvenidos'),
]
```

### 1.10.4 RedirectView

La clase RedirectView simplemente redirecciona una vista con la URL
dada. Si la URL dada es None, Django retornara una respuesta
HttpResponseGone (410)

Flujo de los métodos: 1. dispatch() 2. http_method_not_allowed() 3.
get_redirect_url(): Construye el URL del objetivo para el
redireccionamiento.

Los atributos de esta clase son: \* url: La URL para redireccionar la
vista, en formato de cadena o un valor None para lanzar un error HTTP
410 \* pattern_name: El nombre de el patrón URL para redirecionar la
vista. \* Permanent: Se usa solo si el redireccionamiento debe ser
permanente. True = 301, False = 302 \* query_string: Cualquier cosa que
se le pase a la consulta usando el método GET a la nueva localización.
Si es True se añadé al final de la url

``` python
# views.py
from django.shortcuts import get_object_or_404
from django.views.generic.base import RedirectView
from biblioteca.models import Libro

class ContadorLibrosRedirectView(RedirectView):
    permanent = False
    query_string = True
    pattern_name = 'detalle-libro'

    def get_redirect_url(self, *args, **kwargs):
        libro = get_object_or_404(Libro, pk=kwargs['pk'])
        libro.update_counter()
        return super(ContadorLibrosRedirectView,
            self).get_redirect_url(*args, **kwargs)
# urls.py:
from django.urls import url
from django.views.generic.base import RedirectView

from biblioteca.views import ContadorLibrosRedirectView, DetalleLibro

urlpatterns = [
    url(r'^contador/(?P<pk>[0-9]+)/$', ContadorLibrosRedirectView.as_view(), name='contador-libros'),
    url(r'^detalles/(?P<pk>[0-9]+)/$', DetalleLibro.as_view(),   name='detalles-libro'), #Pk se refiere a Primary Key
    url(r'^ir-a-django/$', RedirectView.as_view(url='http://djangoproject.com'), name='ir-a-django'),
]
```

### 1.10.5 Vistas genéricas basadas en clases usando URLconfs

La manera más simple de utilizar las vistas genéricas es creándolas
directamente en la URLconf. O, si usarás las clases blase; cualquier
argumento pasado al método as_view() sobrescribirá los atributos fijados
en la clase.

``` python
from django.urls import url
from django.views.generic import TemplateView

urlpatterns = [
    url(r'^acerca/', TemplateView.as_view(template_name="acerca_de.html")),
]
```

### 1.10.6 Vistas genéricas basadas en clases usando subclases

Los atributos y métodos de las clases anteriores se pueden heredar o
sobreescribir en clases hijas. Los ejemplos anteriores expresan muy bien
esto.

#### 1.10.6.1 Vistas genéricas de objetos

-   ListView: Muestra listas de objetos.
-   DetailView: Muestra objetos en individual.

##### 1.10.6.1.1 ListView

Se encarga de presentar un listado de todos los objetos de un modelo.
(Object.objects.all()) Se crea una clase que herede de ListView y se
especifica la variable model usando una clase previamente definida en
models.py y se llama a su método as_view(). Django por defecto buscara
una plantilla con el siguiente formato dentro del directorio de
plantillas \'/myapp/nombredelmodelo_list.html\' (En este caso
\'biblioteca/editor_list.html\') para renderizar el modelo. Esta
plantilla será renderizada con un contexto que contiene una variable
llamada object_list que contiene la lista de todos los objetos Editores.

``` python
# views.py
from django.views.generic import ListView
from biblioteca.models import Editor

class ListaEditores(ListView):
    model = Editor

# urls.py
from django.urls import url
from biblioteca.views import ListaEditores

urlpatterns = [
    url(r'^editores/$', ListaEditores.as_view(), name='lista-editores' ),
]
```

##### 1.10.6.1.2 DetailView

Se encarga de presentar los detalles de un objeto, ejecutando
self.object. Primero se creara una clase que herede de DetailView.
Posteriormente se llama a su método as_view() Django por defecto buscara
una plantilla con el siguiente formato dentro del directorio de
plantillas \'/myapp/nombredelmodelo_detail.html\' (En este caso
\'biblioteca/editor_detail.html\') para renderizar el modelo. Podremos
acceder al objeto usando Editor.atributo en la plantilla. Editor.pk se
refiere a la Primary Key del objeto.

``` python
# views.py
from django.views.generic.detail import DetailView
from biblioteca.models import Editor

class DetallesEditor(DetailView):
    model = Editor

# urls.py
from django.urls import url
from biblioteca.views import DetallesEditor

urlpatterns = [
    url(r'^detalles/editor/(?P<pk>[0-9]+)/$', DetallesEditor.as_view(), name='detalles-editor' ),
]
```

### 1.10.7 Extender las vistas genéricas

#### 1.10.7.1 Crear contextos de plantilla \"amistosos\"

Para cambiar el nombre del objeto que se usará en plantilla solo se
asigna la vaiable context_object_name. Esto facilita la vida de los
desarrolladores de plantillas.

``` python
from django.views.generic import ListView
from biblioteca.models import Editor

class ListaEditores(ListView):
    model = Editor
    context_object_name = 'lista_editores'
```

#### 1.10.7.2 Agregar un contexto extra

A menudo es necesario agregar más información a parte de la vista
genérica.

``` python
from django.views.generic import DetailView
from biblioteca.models import Editor, Libro

class DetallesEditor(DetailView):
    model = Editor
    context_object_name = 'editor'

    def get_context_data(self, **kwargs):
        # Llama primero a la implementación para traer un contexto
        context = super(DetallesEditor,self).get_context_data(**kwargs)
        # Agrega un QuerySet para obtener todos los libros
        context['lista_libros'] = Libro.objects.all()
        return context
```

#### 1.10.7.3 Vista para un subconjunto de objetos

El argumento model de las vistas genéricas DetailView y ListView es un
atajo para un atajo para decir: queryset = Editor.objects.all(). Esto
significa que puede reemplazarse queryset por cualquier sentencia de
filtrado.

``` python
from django.views.generic import ListView
from biblioteca.models import Libro

class LibroAcme(ListView):
    context_object_name = 'lista_libros_acme'
    queryset = Libro.objects.filter(editor__nombre='Editores Acme')
    template_name = 'biblioteca/lista_libros_acme.html'
```

#### 1.10.7.4 Filtrado Dinámico

La clase ListaLibrosEditores obtiene el objeto Editor y toma como
variable name el argumento capturado entre parentesis de la url (Ver
urls.py) y posteriormente filtra los libros usando el nombre del edtitor
obtenido

``` python
# urls.py
from django.urls import url
from biblioteca.views import ListaLibrosEditores

urlpatterns = [
     url(r'^libros/([\w-]+)/$', ListaLibrosEditores.as_view(), name='lista-libros-editor' ),
]

# views.py

from django.shortcuts import get_object_or_404
from django.views.generic import ListView

from biblioteca.models import Libro, Editor

class ListaLibrosEditores(ListView):
    template_name = 'biblioteca/lista_libros_por_editores.html'

    def get_queryset(self):
        self.editor = get_object_or_404(Editor, nombre=self.args[0])
        return Libro.objects.filter(editor=self.editor)
```

#### 1.10.7.5 Realizar trabajo extra

En este caso buscamos que se haga algo al obtener un objeto. El método
get_object obtendrá el objeto y lo retornará como si fuera un DetailView
normal, pero con la diferencia de que se guardará en la base de datos el
ultimo_acceso al editor.

``` python
# urls.py
from django.urls import url
from biblioteca.views import VistaDetallesAutor

urlpatterns = [
     #...
    url(r'^autores/(?P<pk>[0-9]+)/$', VistaDetallesAutor.as_view(),
        name='detalles-autor'),
]
# views.py
from django.views.generic import DetailView
from django.utils import timezone

from biblioteca.models import Autor

class VistaDetallesAutor(DetailView):
    queryset = Autor.objects.all()

    def get_object(self):
         # LLama a la superclase
        objeto = super(VistaDetallesAutor, self).get_object()
        # Graba la fecha de el último acceso
        objeto.ultimo_acceso = timezone.now()
        objeto.save()
        # Retorna el objeto
        return objeto
```

### 1.10.8 Introducción a los mixins

Se refiere al uso de herencia múltiple. Puede volverse dificil de seguir
al usarlo en subclases de mucha profundidad Usando un mixin en vistas
genéricas Primero el método get obtiene el objeto Editor y agrega el
objeto al contexto y despues une ese Editor con
self.object.libro_set.all() . El atributo paginate_by nos dice cuantos
objetos se mostrarán por página

``` python
from django.views.generic import ListView
from django.views.generic.detail import SingleObjectMixin

from biblioteca.models import Editor

class DetalleEditores(SingleObjectMixin, ListView):
    paginate_by = 3
    template_name = "biblioteca/detalles_editores.html"

    def get(self, request, *args, **kwargs):
        self.object =  self.get_object(queryset=Editor.objects.all())
        return super(DetalleEditores, self).get(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super(DetalleEditores, self).get_context_data(**kwargs)
        context['editor'] = self.object
        return context

    def get_queryset(self):
        return self.object.libro_set.all()
```

En la siguiente plantilla, llamada detalles_editores.html, page_obj se
crea si la clase tiene el atributo paginator

``` html
{% extends "base.html" %}

{% block content %}
    <h2>Editor {{ editor.nombre }}</h2>

    <ol>
        {% for libro in page_obj %}
            <li>{{ libro.titulo }}</li>
        {% endfor %}
    </ol>

    <div class="pagination">
        <span class="step-links">
            {% if page_obj.has_previous %} #El objeto page_obj tiene un método para indicar si hay una página anterior
                <a href="?page={{ page_obj.previous_page_number }}">anterior</a> #El numero de la página previa
            {% endif %}
            <span class="current">
                Pagina {{ page_obj.number }} de  {{ paginator.num_pages }}.
            </span>
            {% if page_obj.has_next %}
                <a href="?page={{ page_obj.next_page_number }}">siguiente</a> #Número de la página siguiente
            {% endif %}
        </span>
    </div>
{% endblock %}
```

#### 1.10.8.1 Envolviendo el método as_view() con mixins

Una forma de aplicar un comportamiento común a muchas clases es escribir
un mixin que envuelva el método as_view ()

``` python
from django.contrib.auth.decorators import login_required

class RequiereLogin(object):

    @classmethod
    def as_view(cls, **initkwargs):
        vista = super(RequiereLogin, cls).as_view(**initkwargs)
        return login_required(vista)

class MiVista(RequiereLogin,  ...):
    # Esta es la vista genérica
    pass
```

#### 1.10.8.2 Manejando formularios con vistas basadas en clases genéricas

Lo interesante de esta vista es que al ser una clase puedes usarla para
heredar métodos y atributos en otra clase hija. Tales como nombre de
plantilla o valores iniciales, etc.

``` python
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.views.generic import View

from .forms import MyForm

class MiFormulario(View):
    form_class = MyForm
    initial = {'key': 'value'}
    template_name = 'formulario.html'

    def get(self, request, *args, **kwargs):
        form = self.form_class(initial=self.initial)
        return render(request, self.template_name, {'form': form})

    def post(self, request, *args, **kwargs):
        form = self.form_class(request.POST)
        if form.is_valid():
            # <proceso el formulario con cleaned data>
            return HttpResponseRedirect('/success/')

        return render(request, self.template_name, {'form': form})
```

#### 1.10.8.3 Ejemplo de un formulario usando una clase genérica

Se coloca un método get_absolute_url() en el modelo, con la url inversa
detalles-autor que es a donde redireccionará la página al llenar el
formulario y la primary key del Autor

``` python
# models.py
from django.db import models
from django.urls import reverse

class Autor(models.Model):
    nombre = models.CharField(max_length=30)
    # Omitimos los demas campos y métodos.

    def get_absolute_url(self):
        return reverse('detalles-autor', kwargs={'pk': self.pk})
```

Despues se crean las clases que crean, actualizan y borran una vista,
heredando de CreateView, UpdateView y DeleteView, respectivamente. Los
campos a crear en la plantilla bajo ella forma de form.atributo se
especifican aquí como una lista.

``` python
# forms.py
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from biblioteca.models import Autor

class CrearAutor(CreateView):
    model = Autor
    fields = ['nombre', 'apellidos', 'email',]

class ActualizarAutor(UpdateView):
    model = Autor
    fields = ['nombre', 'apellidos', 'email',]

class BorrarAutor(DeleteView):
    model = Autor
    success_url = reverse_lazy('lista-autor')
```

Se enlazan las vistas llamando al método as_view().

``` python
# urls.py
from django.urls import url
from biblioteca.forms import CrearAutor, ActualizarAutor, BorrarAutor

urlpatterns = [
    # ...
    url(r'autor/agregar/$', CrearAutor.as_view(), name='agregar-autor'),
    url(r'autor/(?P<pk>[0-9]+)/$', ActualizarAutor.as_view(), name='actualizar-autor'),
    url(r'autor/(?P<pk>[0-9]+)/borrar/$', BorrarAutor.as_view(), name='borrar-autor'),
]
```

CreateView y UpdateView usan la plantilla */myapp/autor_form.html*
dentro del directorio de plantillas. En este caso
*/biblioteca/autor_form.html*. DeleteView usa
*/biblioteca/autor_confirm_delete.html* Estos nombres pueden
sobreescribirse modificando el atributo *template_name* en la clase.

``` html
<html>
<head>
    <title>Agregar autor</title>
</head>
<body>
    <h1>Agregar autor</h1>

    {% if form.errors %}
        <p style="color: red;">
            Por favor corrige lo siguiente:
        </p>
    {% endif %}

    <form action="" method="post">{% csrf_token %}
        <div class="field">
            {{ form.nombre.errors }}
            <label for="id_nombre">Nombre:</label>
            {{ form.nombre }}
        </div>
        <div class="field">
            {{ form.apellidos.errors }}
            <label for="id_apellidos">Apellidos:</label>
            {{ form.apellidos }}
        </div>
        <div class="field">
            {{ form.email.errors }}
            <label for="id_email">E-mail:</label>
            {{ form.email }}
        </div>
        <input type="submit" value="Enviar">
    </form>

</body>
</html>
```

### 1.10.9 Decorando vistas de una clase-base

La extensión de vistas basadas en clases no se limita a usar solamente
mixins. También puedes utilizar decoradores

La forma más simple de decorar una vista basada en una clase, es decorar
el resultado de el método as_view()

``` python
from django.contrib.auth.decorators import login_required
from django.views.generic import TemplateView

from biblioteca.forms import CrearAutor

urlpatterns = [
    #
    url(r'agregar/autor/$', permission_required(CrearAutor.as_view()), name='agregar-autor'),
   ]
```

#### 1.10.9.1 Decorando una clase

Si quieres que cada instancia de una vista se vea decorada usa el
siguiente método. El decorador \@method_decorator transforma un
decorador de una función en un decorador de un método. En el ejemplo
cada instancia de Vista Protegida, tendrá protección de login.

``` python
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator

from django.views.generic import TemplateView

class VistaProtegida(TemplateView):
   template_name = "pagina-secreta.html"

   @method_decorator(login_required)
   def dispatch(self, *args, **kwargs):
      return super(VistaProtegida, self).dispatch(*args, **kwargs)
```

## 1.11 Comandos útiles

A veces cuando iniciamos un desarrollo desde cero, hay muchos cambios en
la base de datos y no es problema empezar desde cero la base de
decorators.

Si queremos borrar toda la información de la base de datos pero dejar
las tablas intactas usamos.

``` bash
manage.py flush
```

Para una aproximación más manual podemos obtener las sentencias SQL que
se ejecutarían del comando anterior con:

``` bash
manage.py sqlflush
```

En cambio, si queremos desaparecer todas las tablas y empezar desde
cero, y estamos usando postgres ejecutamos.

``` bash
manage.py reset_schema
```
