# Machine learning con Python

## Datos

### Terminología de datos

- Data/Datos: unidades de informacion o “hechos” de observaciones.
- Features: tipos de informacion acerca de tus observaciones.
- Filas: observaciones individuales o muestras.
- Columnas: features que describen tus observaciones.
- Pre-processing: preparar datos para su uso en un modelo de machine learning.
- ETL pipeline: framework de data science para extraer, transformar y cargar. un dataset comúnmente viene en forma de tabla y tienen 2 componentes:
  - fila: es un registro, un datapoint. ejemplo: datos de un paciente en un hopital, datos de una cuenta de banco de un cliente. comúnmente tienen un ID asignado.
  - columna: es una característica de la información, cada columna tiene un nombre. En ML supervisado siempre tendremos una columna target (output), que muestra la variable a predecir. y las demás columnas nos servirán como input para poder predecir. Por ejemplo: input= nivel de azúcar en sangre, presión arterial. output = paciente con o sin diabetes.


Podríamos asignar un id a cada categoria y listo pero los modelos no manejan bien las relaciones de los datos en esta forma de código, la forma mas optima de hacer esta conversión es mediante un hot encoding el cual asigna a cada categoría un vector que se diferencia de los demás por la posición de un 1 en el vector, ejemplo:
“SI” > (1,0,0)
“NO” > (0,1,0)
“talvez” > (0,0,1)


### Pandas

esta librería es la ideal para cargar y entender tus datos. los comandos mas basicos son:
* pd.read_csv(): Leer un archivo CSV
* df.head(): Muestra las primeras 5 filas
* df.dtypes: Muestra el tipo de representación de los datos (float, int, object)

### Visualizando tus datos

Los gráficos más famosos para analizar tus datos son:
* Histogramas: Te dice qué tan “frecuentes” y distribuidos son ciertos valores en tus datos.
* Gráficas de dispersión: Muestra la relación entre 2 features graficándolos como pares ordenados. Te puede ayudar a detectar anomalías.

### Tipos de datos

- Numéricos: su feature es un número de tipo entero o flotante.
- Categórica: sus features representan una clase o tipo; usualmente se representan como un mapeo de números o un “one-hot” vector.
- Image: su feature representa una imagen.
- Texto: su feature es en la forma de texto, sea corto (como Twitter) o largo (como en noticias).
- NaN: su feature es desconocido o perdido.

## Preprocesar datasets

Los modelos de ML no pueden manejar strings(palabras) solo entienden números, así que si queremos suministrar una variable categórica a un modelo, primero debemos transformarla a número.

### to_categorical

En el caso de procesamiento de lenguaje natural a veces necesitamos transformar una entrada categórica en una representación similar a un array.

Ejemplo:

| Categoria | Valor   |
| --------- | ------- |
| Yes       | [1,0,0] |
| No        | [0,1,0] |
| Maybe     | [0,0,1] |


En código se vería de la siguiente manera

``` python
from keras.utils import to_categorical

dataset_processed = to_categorical(<dataset>)

dataset_processed[0]
# array([0,0,0...,1,0,0...])
```

Donde el array guarda una relación con las categorias y la presencia de un 1 índica que dicha data pertenece a esa categoria.

### Vectorización

Otra manera de prerocesar información es pasando una lista de palabras a una representación de vectores, donde cada palabra es correspondida con un número, a manera de diccionario.

``` python
def vectorizar(sequences, dim=<dimensiones>):
    restults = np.zeros((len(sequences),dim))
    for i, sequences in enumerate(sequences):
        restults[i,sequences]=1
    return restults     
```

### Normalización

A veces tenemos un conjunto de datos que númericamente presentan muchísima variación. 

Por ejemplo:

``` python
[0.1, 350, 0.2, 0.2, 25]
```

Para normalizar estas vamos a restarle la media aritmética a todos los datos y dividirlos por la desviación estándar.

``` python
mean = train_data.mean(axis=0)
train_data = train_data  - mean
std = train_data.std(axis=0)
train_data = train_data / std
```

Si se normalizan los datos, hay que recordar que la **data de prueba va a usar la media y la desviación estándar de la data de entrenamiento**. Porque se supone que no tenemos acceso a la data de entrenamiento.

``` python
test_data = test_data - mean
test_data = test_data / std
```

## Pandas

Pandas puede leer información en csv con su método *read_csv*

### Head

Head muestra las primeras 5 lineas, para obtener un resumen de los datos.

### dtypes

Intenta inferir el tipo de los datos.


### Visualización

- Histogramas: nos ayudan a ver la distribución de un feature
- Gráficos de dispersión: útil para detectar anomalias. 

## Paradigmas de machine learning

### Aprendizaje supervisado

Obtiene features de entrada y salida y hay un target a predecir.

- Regresión: para valores números. Por ejemplo: pronósticos de temperatura, mercado, esperanza de vida.
- Clasificación: el output es una etiqueta. Por ejemplo, clasificación de email en spam or no spam, fraude, retención de clientes.

### Aprendizaje no supervisado

Objetivo desconocido, queremos encontrar estructura y grupos dentro de los datos

- Clustering: queremos encontrar grupos en los datos.
- Reducción dimensional: queremos encontrar que features en los datos de entrada influencian el modelo.

## Receta del funcionamiento de ML

Receta de algoritmos ML

- Proceso de decisión: cdmo los modelos hacen una prediccion, o retornan una respuesta, usando los parametros.
- Funcion de error/coste: como evaluar si los parametros en el modelo generan buenas predicciones.
- Regla de actualizacién: c6mo mejorar los parametros para hacer mejores predicciones (usando optimizacion numérica).


### Normalizar los datos

Para cada columna de tu dataset con valores numéricos:
1. Calcular el promedio de tus datos (μ).
2. Calcular la desviacién estandar (σ) de tus datos.
3. Para cada punto de datos, realizar el siguiente cálculo:

$x_i=\frac{x_i-μ}{σ}$

### Preparar tus datos para modelos

Particionar los datos:

- Training: Datos para que el modelo aprenda patrones (60-80%)
- Validación: Datos para verificar el aprendizaje (0-20%)
- Testing: Datos para revisar si el aprendizaje fue exitoso

Las proporciones del modelo pueden cambiar y se necesita experimentar con ellos.

## Regresión lineal

Un modelo que mide la relación entre cambios de una variable independiente e independientes para ver que tan correlacionados están.

Este valor se mide usando una relación llamada $R$, mientras más cercana a uno sea, más correlación guardan las variables.

### Ecuación de la recta

LA ecuación para calcular un valor de la variable dependiente será la siguiente

$y_pred=w_1x+w_0$

### Función de coste o Mean-square Error Loss

El costo () es la diferencia entre el valor del target y el valor predecido

$J(w, w_0)=\frac{1}{N}\sum_{i=1}^{n}(y_{i}-y_{1predic})²$

### Regla de actualización

Queremos minimizar la distancia $y_{i,pred}$ sobre cada punto de datos en entrenamiento. Cambiamos $w_0$ y $w_1$ hasta encontrar una suma de distancia menor

$Update rule=minJ(w_0,w_1)$

### Rendimiento

El MSE y $R²$ ayudan a identificar la fortaleza de la relación entre los datos de entrada y de salida.

## Regresión logística

### Proceso de decisión

La probabilidad de que se apruebe un evento

$p(Pass)=\frac{exp(w_0+w_1x_1...+w_Nx_n)}{1+exp(w_0+w_1x_1...+w_Nx_n)}$

### Cost function o función de coste

Es el promedio de que tan bien se predice el resultado de un dato

$J(w,w_0)=-\frac{1}{N}\sum_{i=0}^nlog(p_{pass})+(1-y_i)log(1-p_{pass})$

Si se aprueba, el primer miembro de la sumatoria no es 0. Si se rechaza, el segundo término de la sumatoria no es 0

### Minimizando la función de coste con la regla de actualización

Encuentra valores que predicen mejor esta probabilidad

$Update rule = min(w,w_0)$

|                        | Actually positive(1) | Actually Negative(0) |
| ---------------------- | -------------------- | -------------------- |
| Predicted Positive (1) | True Positive (TP)   | False Positive (FP)  |
| Predicted Negative(0)  | False Negative (FN)  | True Negative (TN)   |

#### Rendimiento o accuracy de la regresión logística

Para medir el rendimiento de una regresión logística usamos una matriz de confusión. Nos dice cuantas veces predijimos de manera correcta

$Accuracy=\frac{(TP+TN)}{(TP+TN+FP+FN)}$

### Resumen de regresión logística

* Proceso de decisión: probabilidad de que ocurra un evento
* Función de error/coste: El promedio que de que tan bien predice el modelo que un evento ocurra
* Regla de actualización: encuentra valroes $w$ y $w_0$ que mejor predicen esta probabilidad## Árboles de decisión

La predicción se lleva a cabo evaluando alguna característica del dato y separando los resultados con base en la respuesta.

Se evaluan diferentes árboles y la respuesta final depende de cuantos árboles aprueben o rechacen un dato, como una votación democrática por mayoría.

### Parámetros

- Número de árboles: más árboles, menos variación, pero más recursos de computo
- Max features: Número de features para separar los datos
- Max depth: Número de niveles del árbol de decisión

También existen los parámetros

N split: Número de data points que un nodo debe tener antes de dividirse

N min: Mínimo número de muestras requeridas para estar en una hoja

### Función de coste

Para un feature seleccionado encuentra el mejor punto de separación y separa los datos en dos nodos más pequeños. Para encontrar la mejor manera de separar la data

### Regla de actualización

Si el nodo hoja tiene más de $n_min$ puntos de datos, repite la función de coste (hacer más preguntas para dividir los datos), si no, para.

### Rendimiento

Se puedan usar métricas de clasificación para evaluar el modelo

Tales como la matriz de confusión de la sección anterior para valores categóricos.

También podemos usar $R$ para valores númericos.

## Algoritmos de aprendizaje no supervisado

### K-means clustering

Implica la agrupación de una serie de datos, que busca encontrar la estructura mediante la asignación de puntos de datos a grupos específicos.

![](Notes/MachineLearningPython/img/k-means.png)

Estos grupos se llaman clusters.

Para hacer esto k-means usa centroides, que representan cada cluster y que, inicialmente, se colocan de manera aleatoria. El objetivo es actualizar la posición de los centroides encontrando la media de los puntos de datos que pertenecen a cada cluster.

![](Notes/MachineLearningPython/img/k-means-avg.png)

El parámetro más importante es el número de clusters, conocido como "k", de ahí el nombre "K-means". Este valor cambia por completo el significado de todo, pues varios puntos de datos pueden moverse de un cluster a otro.

![](Notes/MachineLearningPython/img/k-means-k.png)


### Pasos de la regla de actualización

1. Colocar aleatoriamente los centroides
2. Calcular la distancia de cada punto de datos a cada centroide
3. Asignar cada punto de datos a un cluster basándonos en la distancia más corta
4. Computar nuevos centroides como promedios del os miembros del cluster.

![](Notes/MachineLearningPython/img/k-means-update.png)

### Calcular el rendimiento

Para evaluar un modelo usaremos una gráfica de elbow (codo), debido a su similaridad con un brazo flexionado. Y se evaluarán dos factores:

- Inercia: Que tan cerca están los puntos al centroide, se busca un número pequeño
- Silhouette score: Que tan lejanos son los clusters [-1,1]. De preferencia cercanos a 1

Lo ideal es encontrar la velocidad de cambio más lenta, el punto de inercia más pequeño antes de que se dispare el número de clusters, es decir, el punto de inflexión

![](Notes/MachineLearningPython/img/k-means-performance.png)

### Función de coste

La función de coste se calcula:

$J(c¹, ..., c^k)=\sum^k_{j=1}\sum_{x∈Sj} ||x_1^j-c^j$||²

## Redes neuronales

Una red neuronal es un modelo que usa neuronas y conexiones entre ellos para hacer predicciones.

Son usadas usualmente para aprendizaje supervisado.

### Capa de entrada

Los pesos gobiernan la fuerza de una conexión. La unidad escondida (nodo) acepta una combinación lineal de nodos adjuntos previamente a él.

``` mermaid
Edad->h1
Salario->h1
Dinero->h1
```

$g_1(x)=w_{0,1}+w_{1,1}x_1+w_{2,1}x_2...$

### Capa de entrada conecta múltiples unidades

La unidad oculta ejecuta una funcion en la combinacion linea $(g,(x))$

Esta funcion es una funci6n de activacion.

#### Tipos

- Linear
- Softmax
- ReLU
- Sigmoide

Expresadas visualmente así

![](Notes/MachineLearningPython/img/funciones-activacion.jpg)

### Capa de salida

Nos da la predicción del valor## Entrenar redes neuronales

El proceso se resume en 3 partes

1. Escoger arquitectura
2. La receta de entrenamiento
3. Ajustar la tasa de entrenamiento

### Tipos de redes neuronales

Las redes neuronales se dividen en estos 3 tipos:

- DNNS Deep Feed-Forward
- Convolucionales
- Recurrentes

![](Notes/MachineLearningPython/img/tipos-redes-neuronales.jpg)

#### DNNS

Usa funciones de activicación. Es usada en muchos problemas complejos

#### Convolucionales

Operador convolucional/pool y kernels

Usada en imágenes y genómicos

#### Recurrentes

Celdas de memoria/puerta

Representa secuencias

Ideal para su uso en lenguaje

### Receta de redes neuronales

El proceso se resume en la siguiente imagen

![](Notes/MachineLearningPython/img/entramiento.jpg)

### Backpropagation

Es la regla de actualización para ajustar los pesos

Se actualizan tomando la derivada parcial, empezando desde la salida hacia atrás, hasta las entradas de datos.

- Si la tasa de aprendizaje es muy pequeña toma mucho tiempo encontrar buenos pesos
- Si es muy grande, el modelo podría "atorarse" en una meseta local.

## Overfitting

El término se refiere a cuando el método ha memorizado la información de entrenamiento de los datos, pero no ha encontrado el patrón que los predice. El modelo funcionará perfectamente con los datos de entrada, pero fallará con datos nuevos.

![](Notes/MachineLearningPython/img/overfitting.jpg)

### Prevenir overfitting

Una estrategia para prevenir el overfitting es detener el entrenamiento en su mejor punto de predicción.

![](Notes/MachineLearningPython/img/prevenir-overfitting.jpg)

## Neuronas

La neurona, también llamado perceptrón está inspirado en las redes neuronales biológicas.

El funcionamiento del perceptrón se describe de la siguiente manera:
1. Se realiza una suma ponderada de las entradas con los pesos (weights w). Esto da como resultado una salida lineal.
2. Esta salida se pasa por una función de activación que introduce no linealidades al perceptrón.
3. Si el modelo no satisface de forma adecuada el problema entonces se itera. Se itera actualizando los pesos hasta resolver el problema.

## Redes neuronales

La arquitectura de la red neuronal se dividide en tres partes:

1. La capa de entrada, en donde los datos son introducidos.
2. La cada de salida, que hace la predicción
3. Las capas ocultas, que se encuentran entre la capa de salida y la capa de entrada. Las capas ocultas son quienes hacen las operaciones matemáticas.

### Operaciones matemáticas en las redes neuronales

Dentro de la arquitectura de la red neuronal ocurren muchas operaciones de producto punto entre las entradas de cada perceptron con sus respectivos pesos. Estas operaciones son lineales.

Las funciones de activación son la solución al colapso de las linealidades de las capas de la red neuronal.

## Funciones de activación

En redes computacionales, la Función de Activación de un nodo define la salida de un nodo dada una entrada o un conjunto de entradas.

### Tipos de funciones de activación

- Escalonada (De 0 a 1)
- Signum (De -1 a 1)
- Sigmoide Función de 0 a 1 con valores continuos, ideal para probabilidad.
- Tangente (De -1 a 1) con valores negativos para "x"
- Relu, la más usada. (Valores menores a 0 son 0, si es mayor, deja el valor)
- Softmax, nos da la probabilidad de ciertos outputs

![](Notes/MachineLearningPython/img/funciones-activacion_2.png)

La página [wolframalpha](https://www.wolframalpha.com/) nos permite obtener las fórmulas de las funciones y su comportamiento.

## Descenso del gradiente

El objetivo es disminuir la función de coste respecto a los pesos (weights) de cada neurona. Un punto bajo indica mayor precisión en las predicciones.

* Optimizador: me dice como debo actualizar los pesos, para disminuir el error. Hay varios tipos: gradient descent, AdaGrand, AdaDelta, Momentum, Nesterov, ADAM, RMS prop
* Learning rate: magnitud en la actualizacion de los pesos. Muy altos no encuentran un punto mínimo local o global, muy pequeños consumen demasiados recursos.
* Momentum: para evitar caer en mínimos globales hay optimizadores que aplican momentum (como el concepto de física, es el impulso extra que acumulo en la bajada de bajada) como el RMS prop, el cual es una variación del descenso del gradiente más el momentum.

## Funciones de pérdida

La función de pérdida evalúa los valores reales contra la predicción. Un valor alto en la función de pérdida indica que nuestras predicciones son malas. En cambio, un valor bajo de la función de pérdida indica una buena predicción.

Para el caso de una regresión tenemos la función de pérdida del error cuadrático medio (MSE, por sus siglas en inglés)

$MSE = \frac{1}{n}\sum(y-y)$

Mientras que para las categoricas tenemos la cross Entrupy function.

$-\sum_xp(x)log q(x)$

## Backpropagation

Backpropagation (propagación hacia atrás) es un algoritmo de entrenamiento utilizado en redes neuronales artificiales para ajustar los pesos de las conexiones entre las neuronas. Es una técnica de optimización que utiliza el descenso del gradiente para minimizar la función de error entre las salidas de la red y los valores objetivo.

La propagación hacia atrás se llama así porque el error se propaga a través de la red desde la capa de salida hasta la capa de entrada, de manera inversa al flujo de la información durante la fase de entrenamiento hacia adelante (feedforward). Durante el proceso de entrenamiento, se calcula el error de la salida de la red en función de los valores objetivo, y luego se propagan estos errores hacia atrás a través de la red para actualizar los pesos de las conexiones.

![](Notes/MachineLearningPython/img/backpropagation.jpg)

### Fundamentos matemáticos del backpropagation

La derivada del coste se calcula con la regla de la cadena.

$C(a(Z^L))$

## Dimensiones, tensores y reshape

Los datos pueden tener diferentes dimensiones dependiendo de su estructura y complejidad:

- Scalar: Un valor escalar representa una única cantidad o valor numérico sin ninguna dirección o magnitud asociada. Por ejemplo: Una medición de temperatura.
- Vector: Un vector es una entidad matemática que tiene magnitud y dirección. Está compuesto por una secuencia de valores numéricos dispuestos en una sola dimensión. Ejemplo: Lista de coordenadas.
- Matrix: Una matriz es un conjunto de valores numéricos dispuestos en filas y columnas que forman una estructura bidimensional. Las matrices se utilizan para realizar cálculos lineales, como transformaciones lineales, rotaciones y escalamientos. Por ejemplo: Una imagen.
- Tensor: Un tensor es un objeto matemático de múltiples dimensiones que se utiliza en el análisis y procesamiento de datos en áreas como la física, la ingeniería y el aprendizaje automático. Un tensor puede ser un vector o una matriz de cualquier dimensión. Un ejemplo de tensor puede ser una imagen en color, que se puede representar como un tensor de tres dimensiones, con una dimensión para el ancho, otra para la altura y otra para los canales de color (rojo, verde y azul).

## Ejemplo de entrenamiento usando la imdb

### Importamos librerías

Primero importamos las librerías necesarias, y el dataset de imdb.

``` python
from keras.datasets import imdb
from keras import models, layers, optimizers
import numpy as np
```

### Descargamos los datos de imdb - Keras

Descargamos los datos y el número de palabras a usar. 

``` python
(train_data, train_labels), (test_data, test_labels) = imdb.load_data(num_words=10000)
train_data[0]
train_labels[1]
```

#### Diccionario de palabras

``` python
word_index = imdb.get_word_index()
word_index = dict([(value,key) for (key,value) in word_index.items()])
for _ in train_data[0]:
    print(word_index.get( _ - 3))
```

### Función de one-hot encoding

Las palabras irán vectorizadas puesto que las redes neuronales solo procesan números, no palabras.

``` python
def vectorizar(sequences, dim=10000):
    restults = np.zeros((len(sequences),dim))
    for i, sequences in enumerate(sequences):
        restults[i,sequences]=1
    return restults    
```

### Transformamos datos

Los datos se vectorizan y se convierten en flotantes.

``` python
x_train = vectorizar(train_data)
x_test = vectorizar(test_data)
y_train = np.asarray(train_labels).astype('float32')
y_test = np.asarray(test_labels).astype('float32')
```

### Creamos el modelo

Creamos el modelo, con modo secuencial, y agregamos capas densas, por que son las que corresponden al set de datos, existen otros tipos de layers. 

El input shape será de 10,000 debido a los ejemplos de entrada.

La última capa será sigmoide y con una sola neurona puesto que solo índica dos posibilidades, la probabilidad de ser 0 o 1.

El optimizador es rmsprop, una versión mejorada del descenso del gradiente y el optimizador por defecto.

La función de pérdida es *binary cross entropy*.

La métrica de éxito es accuracy.

``` python
model = models.Sequential()
model.add(layers.Dense(16, activation='relu', input_shape=(10000,)))
model.add(layers.Dense(16, activation='relu'))
model.add(layers.Dense(1, activation='sigmoid'))
model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
             metrics=['acc'])

# Se tiene un total de 25,000 registros
x_val = x_train[:10000]
partial_x_train = x_train[10000:]

y_val = y_train[:10000]
partial_y_train =  y_train[10000:]
```

### Entrenando la red neuronal

Se guarda el resultado del modelo y se entrena con los resultados del 10,000 al 25,000 del set de datos.

``` python
history = model.fit(partial_x_train,
                   partial_y_train,
                   epochs=4,
                   batch_size=512,
                   validation_data=(x_val,y_val))
```

#### Usando validation split

En lugar de dividir los datos, podemos hacer que la función fit lo haga automáticamente con el parámetro *validation_split*

``` python
historia=model.fit(x_train,y train, epochs=4,batch_size=512, validation_split=0.3)
```

### Analizamos resultados

La propiedad history del modelo muestra el rendimiento de cada iteración, es decir, la historia del entrenamiento en cada época.

``` python
import matplotlib.pyplot as plt 

history_dict = history.history
loss_values = history_dict['loss']
val_loss_values = history_dict['val_loss']

fig = plt.figure(figsize=(10,10))
epoch = range(1,len(loss_values)+1)
plt.plot(epoch,loss_values, 'o',label='training')
plt.plot(epoch,val_loss_values, '--',label='val')
plt.legend()
plt.show()
model.evaluate(x_test, y_test)
```

El overfitting se manifiesta como la diferencia entre la gráfica de dos datos.

### Predicciones

``` python
predictions = model.predict(x_test)
predictions[1]
```

## Overfitting

El overfitting es el sobre ajuste de los datos o dicho de otro modo la memorización de los datos por parte de la red neuronal

Para solucionarlo, se debe reducir la complejidad del modelo.

### Reducir overfitting con regularización

Con la regularización se penaliza a la función de coste, usando el valor de los pesos.

``` python
from keras import regularizer

model = models.Sequential()
model.add(
    layers.Dense(
        <int>,
        activation='<activation>',
        input_shape=(<shape_int>,),
        kernel_regularizer=regularizers.l1(0.0001)
    )
)

```

### Regularización L1 y L2:

#### Regularización L1 (Lasso)

Aplica una penalización proporcional al valor absoluto de los coeficientes de los pesos del modelo. Esto puede llevar a que algunos coeficientes se vuelvan exactamente cero, lo que implica una selección automática de características. La regularización L1 promueve la esparcidad en los pesos y puede ser útil cuando se desea realizar selección de características y reducir la complejidad del modelo.

``` python
    layers.Dense(
        <int>,
        activation='<activation>',
        input_shape=(<shape_int>,),
        kernel_regularizer=regularizers.l1(0.0001)
    )
```

#### Regularización L2 (Ridge)

Aplica una penalización proporcional al cuadrado de los coeficientes de los pesos del modelo. La regularización L2 penaliza los valores grandes de los pesos y empuja hacia valores más pequeños, lo que ayuda a evitar el sobreajuste. También se conoce como "regularización de peso al cuadrado" y es la más comúnmente utilizada en redes neuronales.

``` python
    layers.Dense(
        <int>,
        activation='<activation>',
        input_shape=(<shape_int>,),
        kernel_regularizer=regularizers.l2(0.0001)
    )
```

### Reducir el overfitting con dropout

El regularizador de Dropout es una técnica eficaz para reducir el sobreajuste en las redes neuronales. Durante el entrenamiento, se aplica de manera aleatoria y temporal a una fracción de las unidades (neuronas) de una capa, lo que implica que estas unidades no contribuyan a la propagación hacia adelante ni a la propagación hacia atrás durante ese paso. Al aplicar el abandono de forma estocástica, el modelo se ve obligado a aprender características redundantes y, en consecuencia, se vuelve más generalizable.

A nivel código, el dropout se agrega como si fuera una capa.

``` python
model.add(layers.Dropout(<flotante entre 0 y 1>))
```

### Regularización de elastic net

La regularización de elastic net es una combinación de la regularización L1 y L2. Aplica una penalización que incluye tanto términos de regularización L1 como L2, lo que combina las propiedades de ambas. La regularización de elastic net permite seleccionar características y al mismo tiempo manejar la multicolinealidad en los datos.

## K-fold validation

K-fold validation, también conocida como validación cruzada en k grupos, es una técnica utilizada en el aprendizaje automático (machine learning) para evaluar y validar modelos de manera más robusta y precisa.

### División de datos en k-fold validation

Cuando se entrena un modelo de aprendizaje automático, es común dividir los datos disponibles en dos conjuntos: uno para entrenamiento y otro para evaluar el rendimiento del modelo. Sin embargo, esta división puede ser problemática si los datos de prueba no son representativos de la distribución de los datos reales o si la partición es aleatoria y los resultados varían con cada partición.

![](Notes/MachineLearningPython/img/k-fold.jpg)

La validación cruzada en k-fold aborda este problema dividiendo los datos en k grupos o pliegues (folds) de tamaño similar. El valor de k se selecciona de antemano y generalmente se elige un número entre 5 y 10. Luego, el modelo se entrena y evalúa k veces, cada vez utilizando un grupo diferente como conjunto de prueba y los restantes como conjunto de entrenamiento.

### Entrenamiento en k-fold validation

En cada iteración, el modelo se entrena en k-1 pliegues y se evalúa en el pliegue restante. Luego, se promedian los resultados de evaluación obtenidos en cada iteración para obtener una estimación general del rendimiento del modelo. Esto proporciona una evaluación más estable y confiable del modelo, ya que se utiliza todo el conjunto de datos para entrenamiento y evaluación en diferentes combinaciones.

### Usos de k-fold validation

La validación cruzada en k-fold es especialmente útil cuando el conjunto de datos es limitado, ya que aprovecha al máximo los datos disponibles sin requerir una partición adicional en conjuntos de entrenamiento y prueba. También ayuda a identificar problemas como el sobreajuste (overfitting) y el subajuste (underfitting) de manera más efectiva.


### Ejemplo de imeplentación de K-Fold

``` python
k = 4
num_val_samples = len(train_data) // 4
num_epoch = 80
all_history = []
```


``` python
for i in range(k):
    print("Fold " , i)
    val_data = train_data[i*num_val_samples: (i+1) * num_val_samples]
    val_targets = train_targets[i*num_val_samples: (i+1) * num_val_samples]
    
    partial_train_data = np.concatenate(
    [train_data[:i * num_val_samples],
     train_data[(i+1) * num_val_samples:]],
     axis= 0   
    )
    
    partial_train_targets = np.concatenate(
    [train_targets[:i * num_val_samples],
     train_targets[(i+1) * num_val_samples:]],
     axis= 0   
    )    
    model = build_model_regression(13)
    history = model.fit(partial_train_data, partial_train_targets, epochs=num_epoch, batch_size =16, 
                        validation_data = (val_data, val_targets),
                        verbose=0)
    all_history.append(history.history['val_mae'])
```

## Tipos de capas en Keras

### Capa Dense (totalmente conectada):

En una capa densa, cada neurona está conectada a todas las neuronas de la capa anterior. Cada conexión tiene un peso asociado que se aprende durante el entrenamiento. Las capas densas son capaces de aprender representaciones complejas y capturar patrones no lineales en los datos.

### Capa Conv2D (convolucional en 2D):

Las capas convolucionales aplican operaciones de convolución a los datos de entrada. Estas capas son especialmente útiles en tareas de visión por computadora, ya que pueden aprender patrones locales y características espaciales en imágenes o datos en formato de matriz.

### Capa LSTM (memoria a largo plazo):

Las capas LSTM son una variante de las capas recurrentes y están diseñadas para capturar relaciones secuenciales en los datos. A diferencia de las capas recurrentes estándar, las capas LSTM tienen una estructura más compleja que les permite aprender dependencias a largo plazo en las secuencias de datos.

Las capas LSTM se utilizan en problemas de procesamiento de lenguaje natural (NLP) y otras tareas que involucran secuencias de datos, como reconocimiento de voz y traducción automática.

### Capa recurrente (SimpleRNN, LSTM, GRU):

Las capas recurrentes son capaces de procesar secuencias y datos con dependencias temporales. Cada unidad en estas capas tiene una conexión recurrente consigo misma, lo que les permite tener memoria de estados anteriores.

Las capas recurrentes se utilizan en problemas de procesamiento del lenguaje natural (NLP) como la generación de texto, traducción automática y reconocimiento de voz, donde se necesita modelar la estructura temporal de los datos.

## Métricas de éxito

En la biblioteca Keras, hay varias métricas de éxito disponibles que se utilizan para evaluar el rendimiento de los modelos de machine learning. A continuación, se presentan algunos ejemplos de métricas comunes y cuándo se usan:

### Precisión (Accuracy):

Uso: La precisión es una métrica comúnmente utilizada en problemas de clasificación. Mide la proporción de muestras correctamente clasificadas en relación con el total de muestras. Es útil cuando las clases están balanceadas.

### Pérdida (Loss):
        
Uso: La pérdida es una métrica utilizada durante el entrenamiento del modelo para evaluar qué tan bien se están ajustando los datos. El objetivo es minimizar la pérdida. Existen diferentes tipos de pérdidas según el tipo de problema, como la pérdida de entropía cruzada binaria (Binary Cross-Entropy) o la pérdida de entropía cruzada categórica (Categorical Cross-Entropy).

### Precisión por clase (Class Accuracy):

Uso: En problemas de clasificación con múltiples clases, a veces es útil analizar el rendimiento de cada clase por separado. La precisión por clase mide la precisión de cada clase individualmente y proporciona información más detallada sobre el rendimiento del modelo para cada clase.

### AUC (Area Under the Curve):

Uso: El área bajo la curva (AUC) se utiliza comúnmente en problemas de clasificación binaria y mide la capacidad de un modelo para distinguir entre las clases positiva y negativa. Es especialmente útil cuando las clases están desequilibradas.

### Recall (Recall) y Precisión (Precision):

Uso: Estas métricas también se utilizan en problemas de clasificación binaria. El recall (también conocido como sensibilidad o tasa de verdaderos positivos) mide la proporción de positivos reales que se identifican correctamente. La precisión mide la proporción de resultados positivos que son realmente positivos. Estas métricas son útiles cuando el equilibrio entre falsos positivos y falsos negativos es importante.

### Coeficiente de correlación de Matthews (Matthews Correlation Coefficient):

Uso: El coeficiente de correlación de Matthews es una métrica utilizada en problemas de clasificación binaria y tiene en cuenta los verdaderos positivos, verdaderos negativos, falsos positivos y falsos negativos. Proporciona una medida de la calidad general de la clasificación.
