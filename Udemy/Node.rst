====
Node
====

Mongoose
========

Antes de utilizarlo debemos crear una conexión con mongoDB. Esta
conexion debemos importarla al archivo que servirá como el enrutador.

.. code:: javascript

   const mongoose = require('mongoose')

   mongoose.connect('mongodb://127.0.0.1:27017/task-manager-api', {
       useNewUrlParser: true,
       useCreateIndex: true,
       useFindAndModify: false
   })

En Mongoose un schema es únicamente la estructura que tendran los datos,
la estructura así como el tipo de los datos. Mientras que un modelo es
una estructura que toma un schema y que permite interactuar con los
datos por medio de funciones que permiten un CRUD de los objetos.

.. code:: javascript

   const mongoose = require('mongoose')

   const Task = mongoose.model('Task', {
       description: {
           type: String,
           required: true,
           trim: true
       },
       completed: {
           type: Boolean,
           default: false
       }
   })

   module.exports = Task

Podemos obtener las colecciones con el método getCollection()

.. code:: javascript

   db.getCollection(name)     

Luego podemos encadenar métodos de búsqueda como find()

.. code:: javascript

   db.getCollection(name).find({owner: user._id})

Podemos crear relaciones tipo Foreign Key especificando un Id

.. code:: javascript

   const mongoose = require('mongoose')

   const Task = mongoose.model('Task', {
       description: {
           type: String,
           required: true,
           trim: true
       },
       completed: {
           type: Boolean,
           default: false
       }
       owner: {
           type: mongoose.Schema.Types.ObjectId,
           required: true,
           ref: 'User'
       }
   })

   module.exports = Task

Los modelos en MongoDB tienen id en formato de hash. Normalmente
buscamos un objeto usando el método findById de su modelo.

.. code:: javascript

   const task = await Task.findById('hash')

Para crear una relación inverse podemos usar la relación usando la
función virtual, esta es solo una relación virtual, no está en la base
de datos. La referencia es el modelo, el localField es el campo con el
que está asociado, mientras que foreignField es el nombre del campo en
el modelo del cual queremos obtenerlo, Task en este caso.

.. code:: javascript

   userSchema.virtual('tasks', {
       ref: 'Task',
       localField: '_id',
       foreignField: 'owner'
   })

También podemos especificar métodos de validación para cada campo.

.. code:: javascript

   const userSchema = new mongoose.Schema({
       name: {
           type: String,
           required: true,
           trim: true
       },
       email: {
           type: String,
           unique: true,
           required: true,
           trim: true,
           lowercase: true,
           validate(value) {
               if (!validator.isEmail(value)) {
                   throw new Error('Email is invalid')
               }
           }
       },

Podemos especificar una longitud mínima o eliminar los espacios con
minlength y trim, respectivamente.

.. code:: javascript

   password: {
       type: String,
       required: true,
       minlength: 7,
       trim: true,
       validate(value) {
           if (value.toLowerCase().includes('password')) {
               throw new Error('Password cannot contain "password"')
           }
       }
   },
   age: {
       type: Number,
       default: 0,
       validate(value) {
           if (value < 0) {
               throw new Error('Age must be a postive number')
           }
       }
   },

También nos es posible tener array de valores, para casos donde tenemos
varias instancias de un mismo tipo de datos.

.. code:: javascript

   tokens: [{
       token: {
           type: String,
           required: true
       }
   }]
   })

Podemos especificar métodos para nuestros modelos. En este ejemplo
creamos un método para generar tokens de autenticación

.. code:: javascript

   userSchema.methods.generateAuthToken = async function () {
       const user = this
       const token = jwt.sign({ _id: user._id.toString() }, 'thisismynewcourse')

       user.tokens = user.tokens.concat({ token })
       await user.save()

       return token
   }

En este ejemplo creamos un método para encontrar credenciales. El método
findOne nos lo provee mongoose para manipular nuestros modelos, le
pasamos un objeto con propiedades y nos encontrará un usuario que
contenga ese objeto

.. code:: javascript

   userSchema.statics.findByCredentials = async (email, password) => {
       const user = await User.findOne({ email })

       if (!user) {
           throw new Error('Unable to login')
       }

       const isMatch = await bcrypt.compare(password, user.password)

       if (!isMatch) {
           throw new Error('Unable to login')
       }

       return user
   }

Podemos especificar acciones previas a ejecutar cuando un método se
ejecuta.

.. code:: javascript

   userSchema.pre('remove', async function(next){
   const user = this
   await Task.deleteMany({owner: user._id })
   next()
   })

El método pre ejecutará, antes de cualquier remove, la función que borra
cualquier Task cuyo usuario tenga el \_id del useEl método pre
ejecutará, antes de cualquier remove, la función que borra cualquier
Task cuyo usuario tenga el \_id del user

Middleware
==========

Node permite el uso de middleware. El middleware puede regresar una
respuesta http o una llamada a next(), este último le indicará que debe
la petición debe continuar con su flujo normal. Esta pieza de middleware
se encargará de validar un JWT Token, y asignará el usuario recibido al
objeto requests.

.. code:: javascript

   const jwt = require('jsonwebtoken')
   const User = require('../models/user')

   const auth = async (req, res, next) => {
       try {
           const token = req.header('Authorization').replace('Bearer ', '')
           const decoded = jwt.verify(token, 'thisismynewcourse')
           const user = await User.findOne({ _id: decoded._id, 'tokens.token': token })

           if (!user) {
               throw new Error()
           }

           req.user = user
           next()
       } catch (e) {
           res.status(401).send({ error: 'Please authenticate.' })
       }
   }

   module.exports = auth

Para hacer uso de este middleware lo agregamos como un segundo parámetro
al objeto router, para que se ejecute cuando la dirección 'users/me' sea
solicitada.

.. code:: javascript

   const express = require('express')
   const User = require('../models/user')
   const auth = require('../middleware/auth')
   const router = new express.Router()

   router.get('/users/me', auth, async (req, res) => {
       res.send(req.user)
   })

Logging out
===========

Para hacer un cambio en el estado de loggeo debemos seleccionar el token
que usaremos para cerrar sesión. Recuerda que al tener varios tokens que
representan diferentes sesiones, no queremos cerrar todas las sesiones.

.. code:: javascript

   router.post('/users/logout', auth, async (req, res) => {
       try {
           res.user.tokens = req.user.tokens.filter((token)=>{
   return token.token !== req.token 

   })
   await req.user.save()
   res.send()

   } catch (e) {
    res.status(500).send()
   }

})

Hide private data
=================

Solo debemos mostrarle información necesaria para el usuario. Esto
excluye el password hash, los tokens innecesarios.

.. code:: javascript

   router.post('/users/login', async (req, res) => {
       try {
           const user = await User.findByCredentials(req.body.email, req.body.password)
           const token = await user.generateAuthToken()
           res.send({user, token})
       } catch (e) {
           res.status(400).send()
       }
   })

En el esquema de MongoDB podemos reemplazar el método toJSON() para que
elimine el atributo password y tokens. El método toJSON() se llama de
manera automática al hacer el send del objeto respuesta.

.. code:: javascript

   # Desde el schema de MongoDB
   userSchema.methods.toJSON = function () {
       const user = this
       const userObject = user.toObject()

       delete userObject.password
       delete userObject.tokens

       return userObject
   }

Podemos filtrar los datos usando el

.. code:: javascript

   router.get('/tasks', auth, async (req, res)=> {

     if(req.query.completed) {
       match.completed = req.query.completed=== 'true'
     }
     try{
        await req.user.populate({
          path: 'tasks',
          match
        }).execPopulate()
        res.send(req.user.tasks)
     } catch (e) {
        res.status(500).send()
   })

Pagination
==========

Para fijar una paginación especificamos la propiedad limit dentro de
options. parseInt se encarga de transformar un string de número en un
valor de tipo int.

.. code:: javascript

   router.get('/tasks', auth, async (req, res)=> {

     if(req.query.completed) {
       match.completed = req.query.completed=== 'true'
     }
     try{
        await req.user.populate({
          path: 'tasks',
          match,
          options: {
            limit: parseInt(req.query.limit)
          }
        }).execPopulate()
        res.send(req.user.tasks)
     } catch (e) {
        res.status(500).send()
   })

Mientras que para especificar un punto de partida y brincar todos los
valores anteriores usamos skip.

.. code:: javascript

   router.get('/tasks', auth, async (req, res)=> {

     if(req.query.completed) {
       match.completed = req.query.completed=== 'true'
     }
     try{
        await req.user.populate({
          path: 'tasks',
          match,
          options: {
            limit: parseInt(req.query.limit),
            skip: parseInt(req.query.skip)
          }
        }).execPopulate()
        res.send(req.user.tasks)
     } catch (e) {
        res.status(500).send()
   })

Ordenando
=========

Para ordenarr valores vamos a usar la propiedad sort, que aceptará como
valor un campo. Como parámetro GET usaremos sortBy.

Para especificar el orden podemos colocar un caracter especial para más
tarde hacerles split y obtener el valor asc o desc.

.. code:: javascript

   router.get('/tasks', auth, async (req, res)=> {
     const match = {}
     const sort = {}

     if(req.query.sortBy) {
       const parts = req.query.sortBy.split(':')
       sort[parts[0]] = parts[1] === 'desc' ? -1 : 1
     }

     if(req.query.completed) {
       match.completed = req.query.completed=== 'true'
     }
     try{
        await req.user.populate({
          path: 'tasks',
          match,
          options: {
            limit: parseInt(req.query.limit),
            skip: parseInt(req.query.skip),
            sort: {
                createdAt: 
            }
          }
        }).execPopulate()
        res.send(req.user.tasks)
     } catch (e) {
        res.status(500).send()
   })

File Upload
===========

Para llevar a cabo un upload de un archivo usamos la libreria multer.
Esta libreria es un middleware para manejar multipart/form-data.

Para usarlo debemos configurarlo pasándole un objeto con el valor de la
carpeta de destino

.. code:: javascript

   const multer = require('multer')

   const upload = multer({
     dest: 'images'
   })

En la ruta usaremos en middleware de multer, upload.single() buscará el
archivo que se encuentre asociado al key llamado upload en el form-data
del request.

   app.post('/upload', upload.single('upload'), (req, res)=>{
      res.send()

   })

Validación
----------

Al recibir archivos debemos validarlos, podemos reestringir el tamaño y
el tipo de archivo. Estos valores podemos especificarlos en el objeto de
configuración al momento de instanciar multer.

Limits fijará el valor en bytes.

.. code:: javascript

   const upload = multer({
     dest: 'images',
     limits: {
       fileSize: 1000000
     }
   })

Para validar el tipo de archivo usaremos la propiedad fileFilter, que
recibe los parámetros req, file y cb, que son request, file y callback,
respectivamente.

.. code:: javascript

   const upload = multer({
     dest: 'images',
     limits: {
       fileSize: 1000000
     },
     fileFilter(req, file, cb) {

     }
   })

Podemos especificar el error pasándoselo al callback.

.. code:: javascript

   const upload = multer({
     dest: 'images',
     limits: {
       fileSize: 1000000
     },
     fileFilter(req, file, cb) {
       cb(new Error('El archivo debe ser un -inserta aqui- '))
       cb(undefined, true)
       cb(undefined, false)
     }
   })

Todos las propiedades del objeto file están disponibles en la
[documentación](https://www.npmjs.com/package/multer#api)

.. code:: javascript

   const upload = multer({
     dest: 'images',
     limits: {
       fileSize: 1000000
     },
     fileFilter(req, file, cb) {
       if(!file.originalname.endsWith('.pdf')){
         return cb(new Error('Please upload a PDF'))
       }
       cb(undefined, true)
     }
   })

Para múltiples tipos de archivo podemos usar expresiones regulares.

.. code:: javascript

   const upload = multer({
     dest: 'images',
     limits: {
       fileSize: 1000000
     },
     fileFilter(req, file, cb) {
       if(!file.originalname.(/\.(doc|docx)$/)){
         return cb(new Error('Please upload a PDF'))
       }
       cb(undefined, true)
       cb(undefined, false)
     }
   })
