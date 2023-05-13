# Numpy

## ¿Para qué sirven Numpy y Pandas?

* Numpy sirve para el calculo numérico y manejo de arrays. Es muy veloz, optimiza el almacenamiento en memoria. 
* Pandas sirve para la manipulación y análisis de datos. Es veloz, requiere poco código, soporta múltiples formatos de archivos y ordena los datos de forma inteligente.

## Arrays

El array es el principal objeto de la librería. Representa datos de manera estructurada y se puede acceder a ellos a traves del indexado, a un dato específico o un grupo de muchos datos específicos. Puede ser un array plano o una matriz.

Para inicializar un array basta con pasarlo como argumento al método array

``` python
np.array([<valores>...])
```

### Tipos de datos

Los arrays de NumPy solo pueden contener un tipo de dato, ya que esto es lo que le confiere las ventajas de la optimización de memoria.

Podemos conocer el tipo de datos del array consultando la propiedad


``` python
arr = np.array([<valores>...])
arr.dtype
```

### Cambiar tipo de array con stype

Esto se puede hacer con el método astype

``` python
arr = np.array([<valores>...])
arr = arr.stype(np.bool_)
arr = arr.stype(np.int8)
```

Obtendremos un error si el tipo de dato no es convertible.

### Creación de arrays numerados con arange

``` python
np.arange(<inicio>,<final>)
```

## Dimensiones y ndim

    * scalar: Adimensional. Un solo dato o valor, sin estar en una estructura.
    * vector: Una dimension. Listas de Python
    * matriz: Dos dimensiones. Hoja de cálculo
    * tensor: Tres dimensiones. Series de tiempo o Imágenes

Para obtener las dimensiones usamos el atributo ndim


``` python
arr = np.array(<valor>)
arr.ndim
```

También es posible establecer el número de dimensiones, modificando la entrada de datos si es necesario con el parámetro ndim

``` python
arr = np.array(<valor>, ndmin=<numero>)
arr.ndim
```

O expandirla directamente cambiando el axis, en donde 0 son filas y 1 som columnas

``` python
arr = np.expand_dims(np.array(<valores>), axis=<0|1>)
arr.ndim
```

Para eliminar dimensiones usamos la utilizad squeeze. Esto lo llevará a la dimensionalidad correcta, tomando como base todas aquellas que no se están usando.

``` python
np.squeeze(<vector>)
```

## Creando arrays desde cero

Creando Arrays

    1 np.arange (<inicio>,<final>,[<pasos>]) → es como el list( ran (0,10)) pero como arrange
    2 np.zeros(<numero>): acepta tuplas para la dimensionalidad.
    3 np.ones(<numero>): acepta tuplas para la dimensionalidad.
    4 np.linspace(<inicio>,<final>,[<pasos>]). Distribución de gradiente usando los datos.
    5 np.eye(<numero>): Matriz de identidad con diagonal en unos.

Arrays con numeros randoms

    1. np.random.rand(<columnas>, <filas>, <dimensiones>) Ambos con numeros randoms. con números entre 0 y 1
    2. np.random.randint(<inicio>, <final>, <dimensiones de una estructura>). Genera un número aleatorio entre cierto rango de valores

### Shape

Shape nos da las dimensiones y estructura del array.

``` python
arr.shape
(<number>, <number>)
```

### reshape

Nos permite modificar el array para que se adapte a otra forma.

Las dos formas siguientes son equivalentes.

``` python
arr.reshape(<number>, <number>)
np.reshape(arr, (<number>, <number>))
```

reshape recibe un tercer argumento, que es el string que representa el idioma que se usará de base para ordenar.

* C (Lenguaje C). Apilado mediante filas.
* F (Fortran). Apilado mediante columnas.
* A (Aleatoriamente, de acuerdo al almacenamiento del sistema).

Si las dimensiones del nuevo array son incompatibles, se devolverá un error.

## Funciones principales

### Max

Devuelve el elemento más grande del array

``` 
arr.max()
```

Podemos pasarle la dimension como argumento opcional.

### Min

Devuelve el elemento más pequeño del array

``` 
arr.min()
```

Podemos pasarle la dimension como argumento opcional.

### argmax

Arxmax retorna la ubicación del valor más grande.

### argmin

La contraparte de argmax; retorna la ubicación del valor más pequeño.

### ptp (peak to peak)

Devuelve el rango del array, valor máximo menos el valor mínimo

``` python
arr.ptp()
```

### percentile

Especifica directamente el percentil en el que se trabaja. Si el número de datos es par, calculará el promedio entre los dos valores.

``` 
np.percentile(<array>, <numero>)
```

### sort

Ordena ascendentemente los valores del array.

### median

Calcula la mediana de un array.

``` python
np.media(<array>)
```

### std

Calcula la desviación estándar de un array.

``` python
np.std(<array>)
```

### var

Calcula la varianza de un array.

``` python
np.var(<array>)
```

### mean

Calcula la media aritmética de un array.

``` python
np.mean(<array>)
```

### concat

Sirve para unir un array A con un array B.

Es necesari especificar el axis

``` python
np.concatenate((<number>, <number>), axis=<0|1>)
```

Es necesario llevar ambos arrays a la misma dimension, lo cual puede hacerse con el método *expand_dims*

### Transpuesta (T)

La transpuesta es la transpuesta de una matriz. Transformando una matriz de forma (n,m) en (m,n)

``` python
m.T
```

## Copy

Nos permite copiar un array de NumPy en otra variable de tal forma que al modificar el nuevo array los cambios no se vean reflejados en array original.

``` python
arr.copy()
```

## Condiciones

Nos permiten hacer consultas más específicas.

Para esto basta usar una condicional y numpy va a devolver los elementos que coincidan, como si se tratara un map, pero de manera directa

``` python
<arr> <condicion>
```

O de otra manera

``` python
condicion = <condicion>
<arr>[condicion]
```

### Concatenando condiciones

Para concatenar condiciones usamos el operador ampersand (&).

``` python
<arr>[<condicion> & <condicion>]
```

### Con lambdas

También se pueden usar lambdas

``` python
func = <lambda>

func(<arr>)
```

## Operadores en python

A diferencia de Python, los operadores de multiplicación, suma no concatenan o añaden, sino que se efectuan sobre los elementos del array.

``` python
arr = [a, b, c]
arr * 2
[a*2, b*2, c*2]
```

En la suma de arrays, en lugar de concatenar se lleva a cabo la operación por índices

``` python
[a,b,c] + [x,y,z]
[a+x, b+y, c+z]
```

### matmul

Podemos usar este método para llevar a cabo la multiplicación de matrices.

``` python
np.matmul(<matriz>, <matriz>)
```

#### Sintaxis alternativa con @

La arroba lleva a cabo la multiplicación de matrices

``` python
<matriz> @ <matriz>
```

## Pandas

Pandas es una librería de Python especializada en el manejo y análisis de estructuras de datos. El nombre viene de “Panel data”, nos ayuda a hacer una mejor exploración y análisis de los datos.


• Velocidad
• Poco código
• Múltiples formatos de archivos
• Alineación inteligente

### Pandas Series

Es muy parecido a un array de una dimensión (o vector) de NumPy.

• Arreglo unidimensional indexado
• Búsqueda por índice
• Slicing
• Operaciones aritméticas
• Distintos tipos de datos


``` python
import pandas as pd
pd.Series([<array>])
```

Es posible usar índices personalizados pasándole el parámetro opcional *index*

``` python
pd.Series([<array>], index=[<n1>, <n2>, <n3>...])
```

### Índices con diccionarios

Es posible emular el comportamiento anterior al crear una serie usando un diccionario en lugar de un array, donde las llaves serán los índices.

``` python
pd.Series({<dict>})
```

#### Extender una series

Podemos tener una estructura matricial, pasándole un diccionario complejo

``` python
dict = {'Player':['Chrono','Lucca','Kid','Robo'],
 'Height':[173.0, 160.0, 160.0, 183.0],
  'Attack':[192, 101, 75, 200]}
```

Y posteriormente establecer los índices

``` python
pd.Series(dict, index=[<array>])
```

Esto dará como resultado una tabla

### Pandas DataFrame

Muy parecido a las estructuras matriciales trabajadas con NumPy.

• Estructura principal
• Arreglo de dos dimensiones
• Búsqueda por índice (columnas o filas)
• Slicing
• Operaciones aritméticas
• Distintos tipos de datos
• Tamaño variable
Series

Es un arreglo unidimensional indexado

### Cargar archivos CSV y JSON

Pandas permite cargar los archivos de manera sencilla siguiendo la sintaxis:

``` python
pd.read_<format>(<file_location>, [separator=<sep>, header=<position>, names=[<heading names>]])
```

#### Flags
* Separator: El tipo de separador de cada columna de información
* Header: la columna que contiene las cabeceras
* Names: Cabeceras personalizadas que podemos establecer

Entre los que destacan:
* CSV
* JSON (Poco frecuentes de encontrar)

## ¿Dónde encontrar datasets?

Ciertas páginas ofrecen múltiples datasets disponibles para descargar

- [Kaggle](https://www.kaggle.com/)

## loc e iloc

Podemos filtrar por columna pasándola como si fuera un índice

``` python
data['<columna>', ['<columna>'...]]
```

### loc y particionado

Loc muestra un rango de filas desde la posición start hasta stop

``` python
data.loc[<start>: <stop>, ['<columna>', ...]]
```

No establecer límites devuelve todos los datos

``` python
data.loc[:, ['<columna>', ...]]
```

#### Condicionales con loc

De la misma manera que con numpy, podemos filtrar los datos usando una condición después del particionado.

``` python
data.loc[:['columna']] == '<valor>'
```

### iloc

El método iloc filtra mediante índices **i**loc. En este caso especificamos el índice en lugar del label.

``` python
data.iloc[<n>,<start>:<end>]
```

#### Filtrado por columna

Podemos filtrar por fila, especificando un inicio y un final y establecer las columnas que queremos obtener.

``` python
data.iloc[<start>:<end>,[<col_1>, ...]]
```

#### Filtrado por número de columna.

De la misma manera que el ejemplo anterior, podemos filtrar usando el número de columna, en lugar de su nombre.

``` python
data.iloc[<start>:<end>,<col_start>:<col_end>]
```

### Eliminar datos en pandas

Pandas nos permite eliminar columnas usando el método drop, el cual recibe el nombre de la columna.

El método drop borra de la salida estándar, no del data frame.

``` python
data.drop(<columna o fila>, axis=<0|1>)
```

Recuerda que en axis el axis 0 (cero) se refiere a filas y el axis 1 (uno) a las columnas.

Si queremos borrarlo del data tenemos que pasar el parámetro inplace.

``` python
data.drop(<columna o fila>, axis=<0|1>, inplace=True)
```

También es posible usar la sintaxis de Python, aunque no es aconsejado.

``` python
del data['<columna>']
```

#### drop con range

drop acepta un rango para establecer un rango de datos a borrar

``` python
data.drop(range(<inicio>, <final>), axis=<0|1>, [inplace=True])
```

### Agregar datos con pandas

Para esto basta con usar una asignación por índice, como si fuera un diccionario de Python.

``` python
data['<new column>'] = np.<dataType>
```

Si le asignamos una lista a la nueva columna, pandas la asignará ascendentemente. Es necesario que la lista tenga el mismo número de datos que las filas.

``` python
data['<new column>'] = [<d_1>..., <d_n>]
```

#### concatenar data frames

Para concatenar se usaba *append* pero se deprecó y ahora se usa concat

``` python
data.concat(<data>)
```

### Manejo de datos nulos

Es muy usual que los datos que recibamos no estén completos por alguna razón y será necerario manejar estas excepciones antes de procesar los datos. Para ello Pandas nos ofrece una serie de métodos:

#### isnull

Isnull nos devuelve una tabla de booleanos donde índica si el valor es nulo.

Es conveniente reemplazar los booleanos con números para su fácil filtrado con:

``` python
data.isnull() * 1
```

#### fillna
    
Reemplaza los valores nulos por un valor que puede ser la media, la moda u otro valor que veamos por conveniente

``` python
data.fillna('<valor>')
```

Este valor puede ser dinámico, tal como el resultado de otra función o del mismo dataset, como la media, la moda, la mediana u otro valor que elijamos.

``` python
data.fillna(data.mean())
```

#### interpolate

Funciona solo con datos numéricos, interpola los valores del data frame como si fuera una serie consecutiva.

``` python
data.interpolate()
```

Esto rellenará los espacios faltantes con los datos que panda infiera como los faltantes.

|      | Col   | Col  |
| ---- | ----- | ---- |
| Fila | 3.0   | True |
| Fila | 4.0   | True |
| Fila | <5.0> | True |

#### dropna

Borra los datos nulos, esta es la opción recomendable siempre y cuando no haya muchos valores nulos

``` python
data.dropna()
```

### Filtrado por condiciones

Funciona por lógica booleana y retorna los valores que están en "True". Es muy útil porque en ocasiones queremos filtrar o separar datos.

``` python
data['<col>'] <condicion>
```

Esto nos devolverá una tabla con booleanos como resultado de nuestra condición

Si la asignamos a una variable, nos devolverá la tabla completa que cumpla la condición

``` python
condition = data['<col>'] <condition>
data[condition]
```

Las condiciones igual se pueden concatenar usando operadores booleanos.

``` python
condition = data['<col>'] <condition_1> & <condition_2>
data[condition]
```

Para negar condiciones se usa el caracter "~".

### Funciones principales de objetos de Pandas

#### head

trae los "n" primeros registros.

``` python
data.head(<numero>)
```

#### tail

Igual que head, pero devuelve los últimos "n" registros

``` python
data.tail(<numero>)
```

#### info

Devuelve: Columnas, indices, cuantos no son nulos, tipo de dato que maneja cada columna, el uso de memoria y el número de columnas en total.

#### describe

Describe los datos estadísticos de las columnas numericas me arroja datos estadisticos.


#### memory_usage

Devuelve la memoria usada por el data frame, desglosadas por columnas.

``` python
data.memory_usage(deep=True)
# Index ...
# Name ...
# ...
```

#### value_counts

Devuelve un conteo de valores por columna

``` python
data.value_counts('<columna>')
# data_1 22
# data_2 32
# ...
```

#### drop_duplicates

Elimina los valores duplicados, revisa todas las columnas

``` python
data.drop_duplicates()
```

El parámetro keep nos permitirá conservar el último.

``` python
data.drop_duplicates(keep='last')
```

### sort_values

Ordena los datos de acuerdo a la columna que se le pasa como argumento. El orden ascendente o descendente se puede establecer con la variable *ascending*.

``` python
data.sort_values('<columna>', ascending=<False|True>)
```

### Group by o funciones de agregación

Permite agrupar datos en función de los demás. Es decir, hacer el análisis del Data Frame en función de una de las columnas.

``` python
data.groupby('<column>').count()
```

#### Funciones de agregación por columna

Podemos establecer funciones de agregación personalizadas para cada columna usando un diccionario

``` python
data.groupby('<column>').agg({'<col_name_1>':['function_1', 'function_2'], '<col_name_2>': 'function_3'})
```

### Combinar data frames

Existen diferentes formas de fusionar dos Data frames. Esto se hace a través de la lógica de combinación, justo como se hace en SQL, como se muestra a continuación:

- Left join: Da prioridad al DataFrame de la izquierda. Trae siempre los datos de la izquierda y las filas en común con el DataFrame de la derecha.
- Right join: Da prioridad al DataFrame de la derecha. Trae siempre los datos de la derecha y las filas en común con el DataFrame de la izquierda.
- Inner join: Trae solamente aquellos datos que son común en ambos DataFrame
- Outer join: Trae los datos tanto del DataFrame de la izquierda como el de la derecha, incluyendo los datos que comparten ambos.

## Merge y concat

### Concat

Pandas requiere que los valores a concatenar estén dentro de un array. Los índices se heredan a menos que usemos el parámetro *ignore_index* y lo establezcamos en True

``` python
pd.concat([<dataframe1>, <dataframe2>], ignore_index=<True|False>)
```

### Merge

El merge en pandas toma como elemento izquierdo el datas frame del cual se llama el método y el derecho como el argumento del método

``` python
<data1>.merge(<data2>)
```

Podemos especificar la columna sobre la cual se hará el merge usando el parámetro on. La columna tiene que ser común entre ambos dataframes.

``` python
<data1>.merge(<data2>, on='<key>')
```

Para usar columnas diferentes como punto de unión usamos la siguiente sintaxis.

``` python
<data1>.merge(<data2>, left_on='<key_1>', right_on='<key_2>')
```

#### how

El parámetro how establece que data frame tendrá prioridad antes datos faltantes.

``` python
<data1>.merge(<data2>, left_on='<key_1>', right_on='<key_2>', how='right|left|inner')
```

### Join

Join va directo a los índices, no a columnas específicas de un data frame. Es decir, hace un index match.

Por lo que podemos especificar índices personalizados para cada dataset

``` python
izq = pd.DataFrame({'A': ['A0','A1','A2'],
  'B':['B0','B1','B2']},
  index=['k0','k1','k2'])

der =pd.DataFrame({'C': ['C0','C1','C2'],
  'D':['D0','D1','D2']},
  index=['k0','k2','k3']) 
```

Observa como los índices son diferentes para cada dataset.

### Pivot

Pivot, básicamente, transforma los valores de determinadas columnas o filas en los índices de un nuevo DataFrame, y la intersección de estos es el valor resultante.

``` python
df_books.pivot_table(index='<columna>',columns='<columna>',values='<columna>')
```

Podemos establecer una función de agregación como parámetro

``` python
df_books.pivot_table(index='<columna>',columns='<columna>',values='<columna>', aggfunc='<nombre de la funcion>')
```

### Melt

El método melt toma las columnas del DataFrame y las pasa a filas, con dos nuevas columnas para especificar la antigua columna y el valor que traía.

``` python
data[['<col_1>','<col_2>']].melt()
```

melt puede recibir un parámetro id_vars para especificar la columna a usar como el índice y el valor a usar para desarrollar esos índices

``` python
df_books.melt(id_vars='<col_1>',value_vars='col_2')
```

|     | Col       | Variable | Value |
| --- | --------- | -------- | ----- |
| 0   | Col Value | Variable | Value |
| 1   | Col Value | Variable | Value |
| 2   | Col Value | Variable | Value |

## apply

Apply es un comando muy poderoso que nos deja aplicar funciones a nuestro Data Frame

``` python
data['<columna>'].apply('<nombre de la funcion>')
```

Esta función tiene que recibir un valor y retornar un dato

``` python
def function(value):
    return value
```

Apply también puede recibir lambdas.

Para agregar más argumentos a la función usamos el parámetro opcional args

``` python
data['<columna>'].apply('<nombre de la funcion>', args=[...])
```