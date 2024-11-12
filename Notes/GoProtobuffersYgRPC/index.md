# Protobuffers y gRPC en Go

Protocol Buffers (abreviado como Protobuf) es un formato binario de intercambio de datos disponible en múltiples lenguajes de programación.

Protobuf se utiliza en combinación con HTTP y RPC (Remote Procedure Call o llamada a procedimiento remoto) para llevar a cabo el proceso de comunicación cliente-servidor local y remota.

Al estar en formato binario, se requiere su deserialización y serialización para su manejo. Sin embargo este proceso es mucho más rápido que el que ocurre en JSON.

## gRPC

gRPC es un protocolo creado por Google basado en RPC.

### ¿Qué es RPC?


Es protocolo que oculta la implementación en el backend de la petición realizada por cliente, aunque el cliente sepa como hacer la petición y pueda llamarla como si fuera suya.

### Protocolo gRPC

Usando como base RPC, Google creó una versión de mejorada llamada gRPC donde resaltan dos aspectos HTTP2 y Protobuffers:

* El transporte de datos funciona con HTTP2.
    * Permite crear multiplexación a la hora de enviar mensajes: más mensajes en la conexión TCP de manera simultanea.
    * Permite serializar datos.
* Usa los protobuffers como estructura para intercambio de datos.
    * Permite serializar y deserializar datos más rápido.

## Métodos de gRPC

Existen dos métodos unary y streaming.

### Unary

Similar a como funciona una API con arquitectura REST; el cliente envía una petición al servidor y el servidor la responde.

Se define

``` go
rpc Name(Request) returns (Response)
```

### Streaming

Permite constante envío de data en un canal.

* Del lado del cliente: el cliente envía muchas peticiones, y el servidor responde una sola vez. rpc Nombre(stream Request) returns (Response)
* Del lado del servidor: el cliente realiza una sola petición, y el servidor responde enviando la data en partes. rpc Nombre(Request) returns (stream Response)
* Bidireccional: cliente y servidor deciden ambos comunicarse por streaming de data. rpc Nombre(stream Request) returns (stream Response)

La serialización y deserialización de ambos formatos siempre ocurre, con la ventaja de que los protobbufers tienen mucha menor latencia que los JSON al hacerlo.

## Comparación de protobuffers y JSON

JSON es un formato de mensajes eficiente para JavaScript con las siguientes características

* Pares de key-value o llave y valor.
* Es más fácil de leer y entender por humanos.
* Debido a que implica serialización y deserialización con otros lenguajes, es más costoso en rendimiento si se quiere trabajar con otro lenguaje.

Protobuffers es un formato de mensaje agnóstico a cualquier lenguaje de programación.

* Un compilador se encarga de convertir la sintaxis de protobuffer al lenguaje correspondiente.
* Esta compilación solo ocurre en tiempo de creación o modificación, no en tiempo de ejecución.
* Se puede llamar archivos .proto desde otros archivos .proto.

### ¿Cuando usar JSON y cuando Protobuffer?

Usa JSON cuando la aplicación requiere que la data sea más flexible, por ejemplo REST APIs directo al cliente
Usa Protobuffers cuando el rendimiento sea un factor crítico, ideal para microservicios.


## Instalación del compilador

```bash
apt install -y protobuf-compiler
protoc --version
```

También es recomendable instalar las dependencias en el proyecto

```bash
go get -u google.golang.org/protobuf/cmd/protoc-gen-go@latest
go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

## Estructura de un Protobuffer

Un protobuffer es un archivo con terminación .proto

Este requiere ciertas propiedades definidas, como la sintaxis, y el paquete de go que lo contendrá.

```javascript
syntax = "proto3";

package student;

option go_package = "github.com/EduardoZepeda/protobuffers-grpc;studentpb";
```

### Messages

Un message servirá como un struct con las propiedades de nuestros mensajes a intercambiar entre cliente y servidor.

```javascript
message Student {
    string id = 1;
    string name = 2;
    int32 age = 3;
}
```

Al compilar un protobuffer obtenemos un paquete en el lenguaje de programación que estemos usando.

### Servicios

Los servicios definen las funciones que utilizará el cliente para interaccionar con el servidor, debemos especificar los servicios con la palabra *service*, el nombre del servicio. Y dentro de este, anteponer la palabra rpc al nombre del servicio, su argumento y su valor de retorno entre paréntesis.

```javascript

message GetStudentRequest {
    string id = 1;
}

message SetStudentResponse {
    string id = 1;
}

service StudentService {
    rpc GetStudent(GetStudentRequest) returns (Student);
    rpc SetStudent(Student) returns (SetStudentResponse);
}
```

Nota como se usa *returns*, en plural, en lugar del más conocido return.

### Compilación

La compilación se lleva a cabo con el siguiente comando:

```bash
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/student.proto
```

Cuyo comportamiento podemos modificar con los siguientes flags:

* --go_out. Especifica que se use código de go
* --go_opt. Índica que la búsqueda debe hacerse de manera relativa
* --go-grpc_opt. Índica la ubicación del output
* source_relative. Para usar el directorio de trabajo actual como base

Tras correr el comando se crearán uno o varios archivos con extensión go, estos archivos son generados de manera automática y no necesitan modificarse.

## Creación de un servidor gRPC

Para crear un servidor necesitamos llamar al método NewServer y posteriormente registrar un servidor de servicio en el modelo gRPC creado anteriormente.

```go
s := grpc.NewServer()
studentpb.RegisterStudentServiceServer(s, server)
```

El objeto server que implementa debe heredar UnimplementedStudentServiceServer del protobuffer generado y puedes añadir los métodos que quieras añadiéndolos al objeto server.
Solo asegurate que los métodos aparezcan en el archivo *proto* y que respeten sus parámetros y sus tipos de respuesta.

```go
type Server struct {
    // ...
    studentpb.UnimplementedStudentServiceServer
}

func (s *Server) GetStudent(ctx context.Context, in *studentpb.Student) (*studentpb.SetStudentResponse, error) {
	// Just make sure the name and the signature of the function is followed
}
```

### Usando reflection para obtener los métodos

El paquete reflection puede ser de mucha utilidad para leer los métodos del servidor gRPC usando herramientas como Postman, lo que nos orientará sobre que espera el endpoint y el tipo de respuesta que nos retornará.

```go
s := grpc.NewServer()
testpb.RegisterTestServiceServer(s, server)
reflection.Register(s)
```

## Ejemplo de Server gRPC completo 

Podemos empezar el servidor con un listener, el cual le pasaremos al método Serve del servidor grpc.

```go
const addr = "0.0.0.0:9090"
// create a TCP listener on the specified port
listener, err := net.Listen("tcp", addr)
if err != nil {
	log.Fatalf("failed to listen: %v", err)
}
s := grpc.NewServer()
server := &Server{}
studentpb.RegisterStudentServiceServer(s, server)
reflection.Register(s)
if e := s.Serve(listener); e != nil {
	panic(e)
}
```

Si no hay ningún problema deberiamos tener un servidor funcionando.

## Manejo de Streaming en gRPC

Para manejar el streaming se usa la palabra stream en el argumento de nuestro método rpc. De esta manera le decimos al servidor que el cliente puede enviar un stream de data, del tipo del argumento.

```go
rpc SetQuestions(stream Question) returns (SetQuestionResponse);
```

### Cerrar el streaming gRPC

Escucharemos eternamente por un error de tipo EOF, que se dispara cuando el cliente cancela la conexión y lo manejaremos cerrando el stream.

```go
func (s *TestServer) SetQuestions(stream testpb.TestService_SetQuestionsServer) error {
    for {
    	msg, err := stream.Recv()
    	// Error cuando el cliente finaliza la conexión
    	if err == io.EOF {
    		return stream.SendAndClose(&testpb.SetQuestionResponse{
    			Ok: true,
    		})
    	}
    }
}
```

## Añadir SSL/TLS al server gRPC

### Generación de llaves

Lo primero es obtener una llave privada y una pública (certificado), para conseguir esto podemos usar openSSL.

```go
# Generate a private key and a certificate
openssl genrsa -out server.key 4096
openssl req -new -x509 -sha256 -key server.key -out server.crt -days 3650
```

Ahora contaremos con un archivo *server.crt*, que representa la llave pública y un archivo *server.key*, que representa la llave privada.

### Implementación de SSL/TLS del lado del servidor

El paquete nos provee un método para manejar credenciales del mismo nombre. 
Observa como le pasamos ambas llaves, tanto la pública como la privada.

```go
import (
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials"
)

func main() {
    credentials, err := credentials.NewServerTLSFromFile("server.crt", "server.key")
    if err != nil {
        log.Fatalf("Failed to use credentials for the server %v", err)
    }

    server := grpc.NewServer(grpc.Creds(credentials))

}
```

### Implementación de SSL/TLS del lado del cliente

De la misma forma, necesitamos implementar la funcionalidad del lado del server.
Observa que no estamos utilizando la llave privada; *server.key*, solo la pública, pues se trata del cliente.

```go
import (
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials"
)

func main() {
    credentials, err := credentials.NewClientTLSFromFile("server.crt", "")
    if err != nil {
        log.Fatalf("The client could not load the TLS certificate: %s", err)
    }
    conn, err := grpc.Dial("server.address:port", grpc.WithTransportCredentials(credentials))
    if err != nil {
        log.Fatalf("Could not connect: %v", err)
    }
    defer conn.Close()

   // Rest of the code for the client
}
```

## Usar gRPC en Web

El proyecto grpc-web o un proxy grpc/rest nos permiten usar directamente gRPC en el navegador web, como si se tratara de REST. 
