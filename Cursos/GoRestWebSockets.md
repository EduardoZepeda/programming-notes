# Go Web sockets y REST con Gorilla

## Creación de un handler para manejo de URL

Es más sencillo modificar el comportamiento de nuestras vistas si
envolvemos a la función handler dentro de otra, de manera que retorne
una función *http.Handler* y reciba un argumento de tipo
*server.Server*.

``` go
func HomeHandler(s server.Server) http.HandlerFunc {
    // ...
}
```

La función http.Handler que retorna debe recibir un objeto
*http.ResponseWriter*, y como segundo argumento un *http.Request* pasado
por referencia, desde su interior podemos modificar los Headers o
escribir en el body la respuesta. Para escribir headers de estado
personalizados usamos *WriteHeader* y como argumento el estado
*http.\<CodigoDeEstado\>*.

Podemos escribir headers personalizados con la función *w.Header*

``` go
func HomeHandler(s server.Server) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        w.WriteHeader(http.StatusOK)
        json.NewEncoder(w).Encode(HomeResponse{
            Message: "Welcome to homepage",
            Status:  true,
        })
    }
}
```

### Método Encode

El método Encode recibe un struct que se transformará en un objeto JSON
para retornar en la respuesta.

``` go
json.NewEncoder(w).Encode(HomeResponse{
    Message: "Welcome to homepage",
    Status:  true,
})
```

Agregamos contenido con el objeto json, pasándole el objeto
*http.ResponseWriter*.

## Manejo de handlers en las URL

Estos handlers que creemos necesitamos asignarlos a una URL para que una
petición a esa URL active el handler y devuelva la respuesta. Para esto
crearemos un objeto intermediario lleno de rutas y su manejo con el
Router de mux.

``` go
func BindRoutes(s server.Server, r *mux.Router) {
    // Resto de handlers
    r.HandleFunc("/", handlers.HomeHandler(s)).Methods(http.MethodGet)
}
```

Tras ejecutar la función Handlefunc del Router de gorilla, podemos
declarar los tipos de petición que acepta nuestra ruta. En este caso
solo usará los métodos GET.

### Rutas con parámetros

Para manejar rutas con parámetros necesitamos envolver el nombre del
parámetro dentro de llaves en la ruta

``` go
func BindRoutes(s server.Server, r *mux.Router) {
    // Resto de handlers
    r.HandleFunc("/{id}", handlers.HandleRouteWithParameters(s)).Methods(http.MethodGet)
}
```

Para obtener los parámetros de las rutas los obtenemos con el método
Vars de mux.

``` go
params := mux.Vars(r)
fmt.Println(params["id"])
```

### Rutas con parámetros URL

Para manejar rutas con parámetros opcionales simplemente llamamos al
método Query de la URL del objeto request y accedemos al parámetro como
si se tratara de un diccionario.

``` go
func ListPostHandler(s server.Server) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        pageStr := r.URL.Query().Get("page")
        // Caputurará page=n
    }
}
```

### Recibir parámetros POST en JSON

Para obtener los parámetros de una petición POST necesitamos
decodificarlos usando el método NewDecoder en el cuerpo de la petición.
El método NewDecoder, recibirá el cuerpo de la petición y,
posteriormente el método Decode recibirá un struct, que se instanciará
con la información que recibimos desde el cuerpo.

Si la información en el body no coincide con la respuesta se nos
devolverá un error.

``` go
var RequestStruct = <RequestStruct>{}
err := json.NewDecoder(r.Body).Decode(&RequestStruct)
if err != nil {
    http.Error(w, err.Error(), http.StatusBadRequest)
    return
}
```

El struct puede especificar el nombre de los campos que está recibiendo,
seguido del string *json:* y el atributo del struct de go al que debe
asignarlos.

``` go
type <RequestStruct> struct {
    Field    string `json:"email"`
    Field2 string `json:"password"`
}
```

## Puesta en marcha del servidor

### Configurando ListenAndServe

Para crear un servidor necesitamos crear un nuevo router usando *mux* y
luego pasándole un número de puerto y un router, este router se unirá
con el recien creado. Al final le pasamos como argumentos el puerto y
las rutas.

``` go
func (b *Broker) Start(binder func(s Server, r *mux.Router)) {
    b.router = mux.NewRouter()
    binder(b, b.router)
    log.Println("Starting server on port", b.Config().Port)
    if err := http.ListenAndServe(b.config.Port, b.router); err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}
```

Los datos de configuración se obtienen de un broker, una abstracción que
contiene nuestra configuración y el router de mux.

``` go
type Broker struct {
    config *Config
    router *mux.Router
}
```

## Uso de middleware

El middleware nos permite someter a un handler a una serie de funciones,
a manera de capas a atravesar que deciden internamente si procesarla de
alguna manera o pasarla al siguiente middleware.

Para agregar un middleware a una vista necesitamos crear un *Subrouter*,
al que podemos especificarle un prefijo en la ruta. Y luego agregar un
middleware con la función *Use*. A continuación, en lugar de usar la
función *Handlefunc* del router normal, usamos la del *Subrouter*

``` go
func BindRoutes(s server.Server, r *mux.Router) {
    // Subrouter creation
    api := r.PathPrefix("/api/v1").Subrouter()
    api.Use(middleware.CheckAuthMiddleware(s))

    api.HandleFunc("/me", handlers.MeHandler(s)).Methods(http.MethodGet)
}
```

### Estructura del middleware

Un middleware es una función que retorna toma y retorna un
*http.Handler* como su argumento y valor de retorno. Este *http.Handler*
necesita recibir una función con un objeto response, http.ResponseWriter
y otro request, \*http.Request.

Si queremos interrumpir el middleware usamos un return, si queremos
procesar nuestra petición usando el siguiente middleware llamamos al
ServeHTTP, pasándole el writter y el objeto request.

Para este ejemplo, donde necesitamos manejar un objeto server, el
middleware está dentro de un wrapper.

``` go
func CheckAuthMiddleware(s server.Server) func(h http.Handler) http.Handler {
    // El middleware comienza aquí
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            if something(r.URL.Path) {
                next.ServeHTTP(w, r)
            } else {
                return
            }         
        })

    }
}
```

## Tokens JWT

Los Token JWT pueden leerse con el método *ParseWithClaims*.

``` go
```

jwt.ParseWithClaims(tokenString, &models.AppClaims{}, func(token \*jwt.Token) (interface{}, error) {  
return \[\]byte(s.Config().JWTSecret), nil })

### Devolver un Token

Para crear y devolver un token JWT firmado necesitamos usar el método
*NewWithClaims*, pasándole primero el método de firmado. Algunos métodos
de firmado requieren bytes y otros objetos más complejos, uno de los más
sencillos es SigningMethodHS256. Como segundo parámetro le pasamos el
objeto claims a cifrar.

``` go
//SigningMethodES256 is different than SigningMethodHS256, the later doesn't require a RSA Priv Key as a Signed String
token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
tokenString, err := token.SignedString([]byte(s.Config().JWTSecret))
if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
}
```

Donde claims es un struct con los campos personalizados que queremos, en
este caso solo el UserID, y además las aseveraciones estándar de JWT,
como el tiempo de expiración del Token.

``` go
claims := models.AppClaims{
    UserId: user.Id,
    StandardClaims: jwt.StandardClaims{
        ExpiresAt: time.Now().Add(2 * time.Hour * 24).Unix(),
    },
}
```

Derivado de un struct.

``` go
type AppClaims struct {
    UserId string `json:"userId"`
    jwt.StandardClaims
}
```

### Verificar un token

Un token puede ser verificado con el método *ParseWithClaims*, le
pasamos el tokenString, nuestro modelo de *AppClaims* y una función que
retorne el JWTSecret usado para firmar el token como un array de bytes.

``` go
tokenString := strings.TrimSpace(r.Header.Get("Authorization"))
_, err := jwt.ParseWithClaims(tokenString, &models.AppClaims{}, func(token *jwt.Token) (interface{}, error) {
    return []byte(s.Config().JWTSecret), nil
})
```

### Obtener los claims del token

Para obtener los tokens necesitamos realizar un Parse del token y
comprarlo con nuestra estructura de los claims, y pasarle como argumento
la clave secreta usada.

``` go
tokenString := strings.TrimSpace(r.Header.Get("Authorization"))
token, err := jwt.ParseWithClaims(tokenString, &models.AppClaims{}, func(token *jwt.Token) (interface{}, error) {
    return []byte(s.Config().JWTSecret), nil
})
```

Y ahora para obtener los claims a partir del token obtenemos su
propiedad Claims y revisamos que todo haya estado bien.

``` go
claims, ok := token.Claims.(*models.AppClaims)
```

## Bcrypt para hashes

### Obtener password hasheados

Para obtener un password hasheados usamos el paquete bcrypt. Debemos
recordar que GenerateFromPassword, requiere un array de bytes, no un
string, y el HASH_COST es un valor número para indicar el tiempo de
procesamiento.

``` go
hashedPassword, err := bcrypt.GenerateFromPassword([]byte(request.Password), HASH_COST)
if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
}
```

Tras obtener el password necesitamos volverlo un string para guardarlo

``` go
string(hashedPassword)
```

### Comparar passwords hasheados

si queremos comparar un password junto con un hash, le pasamos el hash
como primer argumento y nuestro password e ntexto plano como el segundo
argumento.

``` go
if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(request.Password)); err != nil {
    http.Error(w, "invalid credentials", http.StatusUnauthorized)
    return
}
```

## ksuid para identificadores

### Generador de id únicos

Para crear un identificador único usamos el método NewRandom del paquete
ksuid.

``` go
id, err := ksuid.NewRandom()
if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
    return
}
```

Igual que en el ejemplo anterior, necesitamos volverlo un string, pero
esta vez podemos usar el método string del valor de retorno del método
NewRandom

``` go
id.String()
```

## CORS

Para usar cors podemos usar el paquete de terceros cors, ya sea con la
configuración por defecto o una personalizada. Tras realizar el binding
de las rutas, se lo pasamos como segundo argumento a *ListenAndServe*.

``` go
func (b *Broker) Start(binder func(s Server, r *mux.Router)) {
    b.router = mux.NewRouter()
    binder(b, b.router)
    handler := cors.Default().Handler(b.router)
    // ...
    if err := http.ListenAndServe(b.config.Port, handler); err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}
```

## Websocket con gorilla

### Esquema general de manejo de websockets

Es conveniente crear un hub para el manejo de clientes

``` go
type Hub struct {
    clients    []*Client
    register   chan *Client
    unregister chan *Client
    mutex      *sync.Mutex
}
```

Cada cliente tendrá asignado un hub, una identificación y una conexión a
un websocket.

``` go
type Client struct {
    hub      *Hub
    id       string
    socket   *websocket.Conn
    outbound chan []byte
}
```

#### Manejo de conexiones

Y para arrancar el servicio escuchando conexiones y desconexiones
manejamos un bucle infinito

``` go
func (hub *Hub) Run() {
    for {
        select {
        case client := <-hub.register:
            hub.onConnect(client)
        case client := <-hub.unregister:
            hub.onDisconnect(client)
        }
    }

}
```

Y con la función del hub podemos manejar conexiones y desconexiones,
recuerda que los clientes conectados se manejan en el struct Hub, por lo
que, para evitar condiciones de carrera, debe bloquearse con un mutex
antes de realizar una modificación.

``` go
func (hub *Hub) onConnect(client *Client) {
    // proteje el hub con un mutex
    // modifica clients
}

func (hub *Hub) onDisconnect(client *Client) {
    client.socket.Close()
    // proteje el hub con un mutex
    // modifica clients 
}
```

#### Inicializar la escucha de conexiones

Ya con nuestra función Run definida, podemos correrla en la
inicialización de cualquier Server.

``` go
go b.hub.Run()
```

### Upgrade de la conexión

Una conexión puede realizar un upgrade a una conexión de websocket, para
realizar un upgrade de la conexión modificamos la función *CheckOrigin*
de la propiedad *Upgrader*, que recibe el objeto *http.Request*.

``` go
var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
        // logica interna
        return true
    },
}
```

### Creación de un hub

Para crear un hub necesitamos llamar al método *NewHub*

``` go
websocket.NewHub(),
```

### Manejar la petición al websocket

Para manejar la conexión con el websocket la incluimos en un handler,
este handler se encargará de manejar las conexiones.

``` go
func (hub *Hub) HandleWebsocket(w http.ResponseWriter, r *http.Request) {
    socket, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Println(err)
        http.Error(w, "Could not open web socket connection", http.StatusBadRequest)

    }
    // ...
}
```

En el conjunto de rutas basta con agregar la función encargada del
manejo de websockets, HandleWebsocket.

``` go
r.HandleFunc("/ws", s.Hub().HandleWebsocket)
```

### Escribir en una conexión de socket

El método WriteMessage de un socket se encarga de mandar un mensaje.

``` go
func (c *Client) Write() {
    for {
        select {
        case message, ok := <-c.outbound:
            if !ok {
                c.socket.WriteMessage(websocket.CloseMessage, []byte{})
                return
            }
            c.socket.WriteMessage(websocket.TextMessage, message)
        }
    }
}
```

## Paquetes de terceros útiles

-   godotenv, ideal para leer variables de entorno.
-   golang-jwt, para manejar JWT.
-   ksuid, para manejar identificadores únicos.
-   bcrypt, para obtención de hashes.

Fin
