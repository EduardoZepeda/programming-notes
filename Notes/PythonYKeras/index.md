# Python y Keras

Las herramientas más conocidas para manejar redes neuronalnes son TensorFlow y PyTorch.

Keras es una API, quese utiliza para facilitar el consumo del backend.

## Deep learning

La inteligencia artificial son los intentos de imitar a la inteligencia humana en sistemas artificiales.

Mientras que machine learning, el cual existe dentro de la inteligencia artificial, son las técnicas de aprendizaje automático, en donde mismo sistema aprende como encontrar una respuesta sin que alguien lo este programando.

Y, como parte de Machine, Learning, Deep learning es todo lo relacionado a las redes neuronales. Se llama aprendizaje profundo porque a mayor capas conectadas ente sí se obtiene un aprendizaje más fino.

En el Deep learning existen dos grandes problemas:

- Overfitting: Es cuando el algoritmo “memoriza” los datos y la red neuronal no sabe generalizar.
- Caja negra: Nosotros conocemos las entradas a las redes neuronales. Sin embargo, no conocemos que es lo que pasa dentro de las capas intermedias de la red.
## ¿Qué es una neurona en AI?

La neurona, también llamado perceptrón (nacido en los años 50’s) está inspirado en las redes neuronales biológicas.

### Funcionamiento de una neurona

El funcionamiento del perceptrón se describe de la siguiente manera:

1. Se realiza una suma ponderada de las entradas con los pesos (weights w). Esto da como resultado una salida lineal.
2. Esta salida se pasa por una función de activación que introduce no linealidades al perceptrón.
3. Si el modelo no satisface de forma adecuada el problema entonces se itera. Se itera actualizando los pesos hasta resolver el problema.
