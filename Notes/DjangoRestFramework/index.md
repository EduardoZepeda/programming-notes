# Django Rest Framework

## ¿Qué es Django rest framework?

Django REST framework es un framework de django que nos permite crear REST API de manera sencilla, echando de mano los modelos, vistas y otros elementos que ya provee Django


### Flujo de información en Django REST Framework

1. El método create de un ViewSet se llama
2. Esto crea un serializador y lo valida, una vez válido se llama al método perform_create
3. Lo anterior llamada al método save del serializador
4. Que a su vez llama al método create o update de la instancia que le fue pasada al serializador.
5. El ViewSet retorna una respuesta con la información que viene de serializer.data
6. Esta información se representa con el método to_representation
7. Y la respuesta en forma de diccionario de Python se procesa por un renderizador, ya sea JSON, XML, etc.


la página donde podemos ver la estructura de drf es https://www.cdrf.co/## CSRF

CSRF (Cross-Site Request Forgery) es un ataque en el que un sitio web malicioso engaña al usuario para que realice una acción no deseada en un sitio web en el que ya está autenticado. Por ejemplo, un atacante podría crear un enlace que parezca inofensivo, pero en realidad, cuando el usuario hace clic en él, envía una solicitud HTTP al sitio web objetivo, como una transferencia de fondos o el cambio de una contraseña, sin el conocimiento del usuario. Para prevenir CSRF, los desarrolladores pueden incluir tokens aleatorios en las solicitudes HTTP para verificar que la solicitud proviene del usuario autorizado.

Para poder usar la protección la CSRF con CSRF necesitamos 

* Obtener cookie con el valor *csrftoken* accediendo por primera vez al sitio
* Añadir un header X-CSRFToken a cada una de nuestras peticiones.


````markdown
# Django REST Framework — Notas Básicas

Guía directa para entender y usar los componentes más comunes en producción.

---

## Serializers

Transforman modelos ↔ JSON.

### Ejemplo básico
```python
from rest_framework import serializers
from .models import Product

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'name', 'price']
````

### Nested Serializers

Relaciones entre modelos.

```python
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']

class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer()

    class Meta:
        model = Product
        fields = ['id', 'name', 'category']
```

### Uso común en producción

* Representar relaciones (`ForeignKey`, `ManyToMany`)
* Validación de datos de entrada
* Serialización parcial (`partial=True` en updates)

### Errores comunes

* Olvidar `many=True` en relaciones múltiples
* No sobrescribir `create()` o `update()` en nested writes
* Exponer campos sensibles

---

## Permissions

Controlan acceso a endpoints o datos.

### Permiso básico

```python
from rest_framework.permissions import BasePermission

class IsOwner(BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.user == request.user
```

### Aplicación

```python
class ProductViewSet(ModelViewSet):
    permission_classes = [IsOwner]
```

### Diferencia clave

* `has_permission`: nivel endpoint
* `has_object_permission`: nivel objeto

### Uso común en producción

* Acceso por dueño del recurso
* Roles (admin vs usuario)
* Filtrado de datos por usuario

### Error común

* Usar solo `has_permission` cuando se requiere control por objeto

---

## API Views

Control total sobre lógica.

```python
from rest_framework.views import APIView
from rest_framework.response import Response

class HelloView(APIView):
    def get(self, request):
        return Response({"message": "Hello"})
```

### Uso común

* Lógica custom compleja
* Integraciones externas

### Error común

* Reescribir CRUD manualmente innecesariamente

---

## Generic Views

CRUD simplificado.

```python
from rest_framework.generics import ListCreateAPIView

class ProductListCreateView(ListCreateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
```

### Uso común

* Endpoints estándar CRUD

### Error común

* No sobrescribir `get_queryset()` cuando se necesita filtrar por usuario

---

## Routers

Generan rutas automáticamente para ViewSets.

```python
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'products', ProductViewSet)

urlpatterns = router.urls
```

### Uso común

* APIs REST estándar

### Error común

* No usar routers y definir rutas manuales innecesariamente

---

## Actions

Endpoints personalizados dentro de un ViewSet.

```python
from rest_framework.decorators import action
from rest_framework.response import Response

class ProductViewSet(ModelViewSet):

    @action(detail=True, methods=['post'])
    def publish(self, request, pk=None):
        return Response({"status": "published"})
```

### Uso común

* Operaciones no CRUD (`publish`, `cancel`, etc.)

### Error común

* Meter lógica compleja en actions en lugar de servicios separados

---

## Parsers

Definen cómo se interpreta el request body.

```python
from rest_framework.parsers import JSONParser, MultiPartParser

class UploadView(APIView):
    parser_classes = [MultiPartParser]
```

### Uso común

* Subida de archivos (`multipart/form-data`)
* APIs JSON

### Error común

* No configurar parser para uploads

---

## Validators

Validación extra en serializers.

```python
from rest_framework import serializers

def validate_price(value):
    if value < 0:
        raise serializers.ValidationError("Debe ser positivo")
    return value

class ProductSerializer(serializers.ModelSerializer):
    price = serializers.FloatField(validators=[validate_price])
```

### Uso común

* Reglas de negocio
* Validaciones cross-field (`validate()`)

### Error común

* Duplicar validaciones ya existentes en el modelo

---

## Pagination

Divide resultados en páginas.

```python
from rest_framework.pagination import PageNumberPagination

class CustomPagination(PageNumberPagination):
    page_size = 10
```

```python
class ProductListView(ListAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    pagination_class = CustomPagination
```

### Uso común

* Listados grandes

### Error común

* No paginar endpoints → problemas de rendimiento

---

## Authentication

Identifica al usuario.

### Ejemplo básico

```python
from rest_framework.authentication import TokenAuthentication

class ProductViewSet(ModelViewSet):
    authentication_classes = [TokenAuthentication]
```

### Tipos comunes

* Token
* Session
* JWT (con librerías externas)

### Uso común

* APIs protegidas
* Microservicios

### Error común

* No proteger endpoints sensibles

---

## Testing

Pruebas de endpoints.

```python
from rest_framework.test import APITestCase
from django.urls import reverse

class ProductTest(APITestCase):
    def test_list_products(self):
        url = reverse('product-list')
        response = self.client.get(url)
        assert response.status_code == 200
```

### Uso común

* Validar endpoints críticos
* Testing de permisos y autenticación

### Error común

* No probar casos de error (403, 400, etc.)

---

## Diferencia entre perform_create y create

La diferencia entre estas dos es que *perform_create* se llama dentro del método *create* una vez que se sabe que la serialización es válida, especificamente *serializer.save*.

El código original es este

``` python
class CreateModelMixin(object):
    """
    Create a model instance.
    """
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def perform_create(self, serializer):
        serializer.save()

    def get_success_headers(self, data):
        try:
            return {'Location': str(data[api_settings.URL_FIELD_NAME])}
        except (TypeError, KeyError):
            return {}
```


## JSON parser

DRF cuenta con un parser que se encarga de leer y poner a disposición el cuerpo JSON de una petición HTTP.

Para esto tenemos que añadir el *JSONParser* el atributo *parser_classes* en nuestras vistas.


``` python
from rest_framework.parsers import JSONParser

class FollowingViewSet(viewsets.ModelViewSet):
    parser_classes = [JSONParser]

```

Una vez hecho esto los datos en JSON estarán disponibles como un diccionario de python dentro del objeto *request*, en su atributo *data*.

``` python
request.data
```

## Obtener request y el objeto usuario en un serializer

Si queremos usar el objeto usuario o el objeto request como parte de una validación podemos hacerlo a través del contexto de nuestro serializador

``` python
def validate_user_to(self, user_to):
    user = None
    request = self.context.get("request")
    if request and hasattr(request, "user"):
        user = request.user
```

## Representar un objeto con to_representation o meta

### to_representation

El método to_representation le dice al serializador como debe pintar el objeto JSON, es decir, cual será su representación, esto nos permite modificar los campos por defecto a nuestro antojo.

``` python
def to_representation(self, instance):
    return {
        'id': instance['id'],
        'correo': instance['email']
    }
    
```

### Meta

Considera que el campo fields de la clase *Meta* también realiza lo mismo, pero además se encarga de participar en la maquinaría interna del serializador.

``` python

class Serializer(serializers.ModelSerializer):

    class Meta:
        fields = ['id', 'email']
    
```

## ViewSets

Los métodos tradicionales recibian las peticiones HTTP de acuerdo al método que coincidiera: *get*, *post*, *delete*, *patch* y *update*.

``` python

def view(generiv)

```


Los ViewSet son una abstracción que se encarga de redirigen las peticiones a los métodos *create*, *retrieve*, *list*, *update*, *patch* y *destroy*.

Además los ViewSets nos permiten crear automáticamente


si reempalzamos el queryset de un viewset por medio de get_queryset necesitamos pasarle un base_name al router como tercer argumento.

la página donde podemos ver la estructura de drf es https://www.cdrf.co/## Reemplazar un queryset

Si queremos reemplazar el atributo queryset de una vista, necesitamos sustituir el método *get_queryset*:

``` python
def get_queryset(self):
    return Modelo.objects.filter(...)
```

Considera que si reemplazas el queryset, necesitaras agregar un tercer argumento a 

``` python
def get_queryset(self):
    return Modelo.objects.filter(...)
```

## Acciones

Un "action" es una característica que permite definir funciones personalizadas para una vista basada en clases (class-based view). Esto permite agregar funcionalidades adicionales a una vista específica sin tener que crear una vista completamente nueva.

Para definir un "action" en DRF, se utiliza el decorador @action en una clase de vista. El decorador @action toma algunos argumentos, incluyendo el método HTTP que se utilizará para la función personalizada, el detalle de si la acción es para un solo objeto o una lista de objetos y una cadena que define el nombre de la acción.

``` python
# ...
from rest_framework.decorators import action

class MiVista(APIView):
    @action(methods=['post'], detail=True)
    def change_password(self, request, username=None):
        pass
```

La estructura anterior añadirá la ruta change_password en el router que le indiquemos y de esa manera

``` bash
<ruta_original>/<ruta_de_la_accion>/
```

## HyperlinkedModelSerializer

En Django Rest Framework (DRF), HyperlinkedModelSerializer es una clase de serializador que se utiliza para serializar modelos con enlaces de hipertexto (hipermedia). Proporciona una representación de los modelos que incluye enlaces a otros recursos relacionados, lo que facilita la navegación a través de la API.

``` python
class UserSerializer(serializers.HyperlinkedModelSerializer):
    fields = ['url', 'id']
```

Añade un campo nuevo llamado *url* que genera automáticamente una url del objeto.

También es posible decirle como debe generar esa url por medio de los atributos opcionales.

``` python
class UserSerializer(serializers.HyperlinkedModelSerializer):
    fields = ['url', 'id']
        lookup_field = "<field>"
        extra_kwargs = {"url": {"lookup_field": "<field>"}}
```

## Incluir contexto

Para incluir contexto, lo agregamos como un argumento opcional al serializador.

``` python
Serializer(data, context={'request': request})
```

## ¿Cómo hacer un annotate que devuelva si un objecto está en una relación many to many?

Este patrón es bastante útil para situaciones donde queremos ver si un objeto (generalmente request.user) forma parte de la relación ManytoMany de un objeto o un queryset. Como por ejemplo para saber si un usuario le ha dado like a una entidad.

``` python
from django.db.models import Count, Exists, OuterRef

Modelo.objects.all()
.annotate(
    exists=Exists(
        Modelo.likes.through.objects.filter(
            Modelo_id=OuterRef("pk"), objeto_id=objecto.pk
        )
    ),
)
```

Además de esto, considera que es necesario aplicar un nuevo campo al serializador y agregarlo a fields.

``` python
exists = serializers.BooleanField()

# ...

fields =[..., "exists"]
```

## Anotar objetos anidados

Para anotar objetos anidados echamos mano del método Prefetch, el cual colocaremos dentro de *prefetch_related* para asignar la propiedad. de esta forma se les añadará a cada objeto de nuestra relación ManyToMany, la propiedad que especifiquemos.

En este caso anota la propiedad followed, que nos dice si un usuario está siguiendo a otro.


``` python
from django.db.models import Exists, OuterRef, Prefetch


User.objects
# Annotate nested following entities with the followed attribute
# that tell us if the request user is following that user
.prefetch_related(
    Prefetch(
        "following",
        User.objects.annotate(
            followed=Exists(
                User.following.through.objects.filter(
                    user_to_id=OuterRef("pk"),
                    user_from_id=self.request.user.id,
                )
            )
        ),
    )
)
```

## Enviar imágenes y archivos

Si vamos a enviar un archivo de manera multipart/form-data tenemos que activar los parsers para ese serializador.

``` python
class UserSerializer(serializers.HyperlinkedModelSerializer):
    parser_classes = (MultiPartParser, FormParser)
```

## ¿Cómo autenticar un usuario en django channels?

Podemos echar mano de los middleware para autenticar un usuario en django channels. Para esto buscaremos obtener el token desde un parámetro query en la url, los cuales son accesibles desde django channels por medio del diccionario *scope["query_string"]*

``` python
from django.contrib.auth.models import AnonymousUser
from rest_framework.authtoken.models import Token
from channels.db import database_sync_to_async
from channels.middleware import BaseMiddleware


@database_sync_to_async
def get_user(token_key):
    try:
        token = Token.objects.get(key=token_key)
        return token.user
    except Token.DoesNotExist:
        return AnonymousUser()


class TokenAuthMiddleware(BaseMiddleware):
    """Auth middleware for tokens in django rest framework. It requires a connection with a query string token=<token>"""

    def __init__(self, inner):
        super().__init__(inner)

    async def __call__(self, scope, receive, send):
        try:
            token_key = (
                dict((x.split("=") for x in scope["query_string"].decode().split("&")))
            ).get("token", None)
        except ValueError:
            token_key = None
        scope["user"] = (
            AnonymousUser() if token_key is None else await get_user(token_key)
        )
        return await super().__call__(scope, receive, send)

```

Una vez creado el middleware, importamos nuestro middleware y envolvemos nuestro router en el archivo *asgi.py*

``` python
application = ProtocolTypeRouter(
    {
        "http": get_asgi_application(),
        "websocket": TokenAuthMiddleware(URLRouter(chat.routing.websocket_urlpatterns)),
    }
)

```

## Manejar datos en JSON

Si le pasamos un dato no serializable a json.dumps, el intérprete devolverá un error, para solucionar esto es muy útil usar el default de string.

``` python
text_data=json.dumps(message, indent=4, sort_keys=True, default=str)
```
