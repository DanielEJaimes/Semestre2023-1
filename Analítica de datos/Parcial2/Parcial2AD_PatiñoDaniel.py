# -*- coding: utf-8 -*-
"""Parcial2AD_PatiñoDaniel.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1-zYR5ZdXJXVxEbgmbqcO6s7t9_pLry1z

# Daniel Enrique Patiño Jaimes 000421816

## Utilizar la base de datos de diabetes proporcionada para este examen realizar

Librerías
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import KFold
from sklearn.model_selection import train_test_split

"""Cargar el dataset"""

data = pd.read_csv('diabetes_012_health_indicators_BRFSS2015.csv')
columnas = ['resultado']
for i in range(1,22,1):
  columnas.append("c"+str(i))
data.columns=columnas
data = data.dropna()
data

"""## 1. Realizar gráficas de dispersión entre variables para entender un poco la relación entre ellas"""

for i in columnas[1:]:
  data.plot(kind='scatter',x =columnas[0],y=i,figsize=(6,6))

"""## 2. Calcular la matriz de correlación del conjunto de datos original"""

corr = data.corr()

fig = plt.figure(figsize=(8,8))
plt.matshow(corr,cmap = 'RdBu' ,fignum=fig.number)
plt.xticks(range(len(corr.columns)),corr.columns,rotation='vertical');
plt.yticks(range(len(corr.columns)),corr.columns);

corr_matrix = data.corr()
corr_values = corr_matrix['resultado'].sort_values(ascending=False)
print(corr_values)

"""## 3. Estadísticos de cada columna como lo son la media, mediana, moda, kurtosis y asimetría. Mencionar en base de estos datos si dicha variable o columna tiene tendencia de ser una distribución normal o no"""

# Calcular la media de cada columna
media = data.mean()

# Calcular la mediana de cada columna
mediana = data.median()

# Calcular la moda de cada columna
moda = data.mode().iloc[0]

# Calcular la kurtosis de cada columna
kurtosis = data.kurtosis()

# Calcular la asimetría de cada columna
asimetria = data.skew()

# Imprimir los resultados
print("Media:")
print(media)
print("\nMediana:")
print(mediana)
print("\nModa:")
print(moda)
print("\nKurtosis:")
print(kurtosis)
print("\nAsimetría:")
print(asimetria)

# Determinar si una columna tiene tendencia de ser una distribución normal
for columna in data.columns:
    if abs(asimetria[columna]) < 0.5 and abs(kurtosis[columna]) < 0.5:
        print(f"La columna {columna} tiene tendencia a seguir una distribución normal.")
    else:
        print(f"La columna {columna} no tiene tendencia a seguir una distribución normal.")

"""## 4. Generar dos datasets, uno con valores atípicos y otro sin ellos. Los dos se utilizarán para entrenar modelos

### Dataset con atípicos
"""

data_con = pd.DataFrame()
for i in columnas[2:]:
  Q1 = data[i].quantile(0.25)
  Q3 = data[i].quantile(0.75)
  IQR = Q3 - Q1
  u_limit_h = Q3 + 1.55 * IQR
  l_limit_h = Q1 - 1.55 * IQR
  atp = (data[i] < l_limit_h) | (data[i] > u_limit_h) # Registro con dato atípico
  data_con = pd.concat([data_con,data[atp]],ignore_index=True) # Se guarda el registro
  
data_con=data_con.drop_duplicates() # Se eliminan registros repetidos
print('Existen',data_con.shape[0],'registros con datos atípicos')

"""### Dataset sin atípicos"""

data_sin = data
for i in columnas[1:]:
  Q1 = data[i].quantile(0.25)
  Q3 = data[i].quantile(0.75)
  IQR = Q3 - Q1
  u_limit = Q3 + 1.5 * IQR
  l_limit = Q1 - 1.5 * IQR
  atp = data_sin[(data_sin[i] < l_limit) | (data_sin[i] > u_limit)].index
  data_sin = data_sin.drop(atp) # Nuevo data set sin los datos atípicos

print('Existen',data_sin.shape[0],'registros sin datos atípicos')

"""## 5. Calcular la matriz de correlación del conjunto sin atípicos"""

corr = data_sin.corr()

fig = plt.figure(figsize=(8,8))
plt.matshow(corr,cmap = 'RdBu' ,fignum=fig.number)
plt.xticks(range(len(corr.columns)),corr.columns,rotation='vertical');
plt.yticks(range(len(corr.columns)),corr.columns);

corr_matrix = data_sin.corr()
corr_values = corr_matrix['resultado'].sort_values(ascending=False)
print(corr_values)

"""## 6. Los modelos por entrenar tienen que ser validados por medio de una validación cruzada con K igual a 7,9 y 11. SE DEBE GARANTIZAR LA HOMOGENEIDAD DE LOS DATOS AL MOMENTO DE REALIZAR LA VALIDACIÓN CRUZADA"""

def homogeneidad(resultados, k):
    # DataFrame para almacenar los datos
    data_cruzada = pd.DataFrame()
    
    # Separación en grupos según la categoría
    grupos = resultados.groupby('resultado')
    diabetes_0 = grupos.get_group(0)
    diabetes_1 = grupos.get_group(1)
    diabetes_2 = grupos.get_group(2)

    # Cantidad de registros por grupo
    diab0 = math.floor(diabetes_0.shape[0] / k)
    diab1 = math.floor(diabetes_1.shape[0] / k)
    diab2 = math.floor(diabetes_2.shape[0] / k)

    # Se agregan los datos al dataframe
    for i in range(0, k):
        data_combinada = pd.DataFrame()
        data_combinada = pd.concat([data_combinada, diabetes_0[i * diab0:i * diab0 + diab0]], ignore_index=True)
        data_combinada = pd.concat([data_combinada, diabetes_1[i * diab1:i * diab1 + diab1]], ignore_index=True)
        data_combinada = pd.concat([data_combinada, diabetes_2[i * diab2:i * diab2 + diab2]], ignore_index=True)
        # Mezclar las filas del DataFrame
        data_combinada = data_combinada.sample(frac=1).reset_index(drop=True)
        # Agregar datos combinados al DataFrame final
        data_cruzada = pd.concat([data_cruzada, data_combinada])
    
    # Se agregan posibles datos faltantes
    data_combinada = pd.DataFrame()
    data_combinada = pd.concat([data_combinada, diabetes_0[k * diab0:]], ignore_index=True)
    data_combinada = pd.concat([data_combinada, diabetes_1[k * diab1:]], ignore_index=True)
    data_combinada = pd.concat([data_combinada, diabetes_2[k * diab2:]], ignore_index=True)
    data_combinada = data_combinada.sample(frac=1).reset_index(drop=True)
    data_cruzada = pd.concat([data_cruzada, data_combinada])
    data_cruzada = data_cruzada.dropna()
    return data_cruzada

"""## 7. Se debe imprimir la matriz de confusión por cada validación del numeral anterior

"""

def confusion_matrix(y_true, y_pred):
    classes = ['No diabetes','Pre diabetes','Diabetes']
    num_classes = len(classes)
    matrix = np.zeros((num_classes, num_classes), dtype=int)
    
    for i in range(len(y_true)):
        true_class = int(y_true[i])
        pred_class = int(y_pred[i])
        matrix[true_class][pred_class] += 1
    
    confusion = pd.DataFrame(matrix, index=classes, columns=classes)

    return confusion

"""## 8. Calcular el desempeño de cada modelo usando sensibilidad, precisión y especificidad"""

def desempeno(confusion):
    classes = ['No diabetes','Pre diabetes','Diabetes']
    num_classes = len(classes)
    desempeno_matrix = np.zeros((3, num_classes))
    index_desempeno = ['Sensibilidad', 'Precisión', 'Especificidad']

    for i in range(num_classes):
        tp = confusion.iloc[i, i]  # Verdaderos positivos
        fn = np.sum(confusion.iloc[i, :]) - tp  # Falsos negativos
        fp = np.sum(confusion.iloc[:, i]) - tp  # Falsos positivos
        tn = np.sum(confusion.values) - tp - fn - fp  # Verdaderos negativos

        desempeno_matrix[0][i] = tp / (tp + fn) if (tp + fn) != 0 else 0 # Sensibilidad
        desempeno_matrix[1][i] = tp / (tp + fp) if (tp + fp) != 0 else 0 # Precisión
        desempeno_matrix[2][i] = tn / (tn + fp) if (tn + fp) != 0 else 0 # Especificidad

    desempeno = pd.DataFrame(desempeno_matrix, index=index_desempeno, columns=confusion.index)

    # Cálculo del promedio del desempeño
    promedio_desempeno = pd.DataFrame(desempeno.mean(axis=1), columns=['Promedio'])
    desempeno = pd.concat([desempeno, promedio_desempeno], axis=1)

    return desempeno

"""## 9. Deben realizar al menos 4 modelos por algoritmo utilizado y decidir en base de la curva ROC cual es el mejor

### Algoritmo KNN
"""

def KNN(data_cruzada,caracteristicas,kvecinos,kparticiones):
  sensibilidad = 0
  precision = 0
  especificidad = 0
  # Obtener los valores de entrada (X) y las etiquetas (y) del dataset
  X = data_cruzada.iloc[:, caracteristicas].values
  y = data_cruzada.iloc[:, 0].values

  # Inicializar el objeto KFold con el número de folds (k)
  kf = KFold(n_splits=kparticiones)

  # Listas para almacenar los conjuntos de entrenamiento y prueba
  train_indices = []
  test_indices = []

  # Generar los conjuntos de entrenamiento y prueba usando KFold
  for train_index, test_index in kf.split(X):
      train_indices.append(train_index)
      test_indices.append(test_index)

  # Iterar sobre los k folds
  for fold in range(k):
      print('\nFold ',fold)
      # Obtener los índices de entrenamiento y prueba para el fold actual
      train_index = train_indices[fold]
      test_index = test_indices[fold]

      # Obtener los conjuntos de entrenamiento y prueba para el fold actual
      X_train, y_train = X[train_index], y[train_index]
      X_test, y_test = X[test_index], y[test_index]

      modelo = KNeighborsClassifier(n_neighbors=kvecinos)
      modelo.fit(X_train,y_train)
      y_pred = modelo.predict(X_test)
      matriz = confusion_matrix(y_test,y_pred)
      metricas = desempeno(matriz)
      promedio = metricas['Promedio']
      sensibilidad += promedio[0]
      precision += promedio[1]
      especificidad += promedio[2]
      print(matriz)
      print(metricas)
  return sensibilidad/k, precision/k, especificidad/k

"""Modelo 1"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas_1=[14,1,4]
sens0,prec0,espe0 = KNN(data_cruzada,caracteristicas_1,5,k)
print('Promedio sensibilidad: ',sens0)
print('Promedio precisión: ',prec0)
print('Promedio especificidad: ',espe0)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas_1,5,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas_1,5,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 2"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[14,1,4,19,2,18,5]
sens1,prec1,espe1 = KNN(data_cruzada,caracteristicas,5,k)
print('Promedio sensibilidad: ',sens1)
print('Promedio precisión: ',prec1)
print('Promedio especificidad: ',espe1)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas,5,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas,5,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 3"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[14]
sens2,prec2,espe2 = KNN(data_cruzada,caracteristicas,7,k)
print('Promedio sensibilidad: ',sens2)
print('Promedio precisión: ',prec2)
print('Promedio especificidad: ',espe2)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas,7,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas,7,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 4"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[21,20,9,15]
sens3,prec3,espe3 = KNN(data_cruzada,caracteristicas,7,k)
print('Promedio sensibilidad: ',sens3)
print('Promedio precisión: ',prec3)
print('Promedio especificidad: ',espe3)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas,7,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = KNN(data_cruzada,caracteristicas,7,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

roc_x = [espe0,espe1,espe2,espe3]
roc_y = [sens0,sens1,sens2,sens3]
nombres = ['M0','M1','M2','M3']
colores = ['blue','red', 'green','yellow']

plt.scatter(roc_x, roc_y,c=colores)

for i, nombre in enumerate(nombres):
    plt.annotate(nombre, (roc_x[i], roc_y[i]))

plt.title('Gráfica de las 3 validaciones')
plt.xlabel('1 - Especificidad')
plt.ylabel('Sensibilidad')

plt.show()

# calcular la distancia de cada punto a la esquina superior izquierda donde tendrá la mejor especificidad y sensibilidad
distancias = []
for p in range(0,len(nombres)):
    distancia = math.sqrt((0 - roc_x[p])**2 + (1 - roc_y[p])**2)
    distancias.append(distancia)

# obtener el índice del punto más cercano
indice = distancias.index(min(distancias))

# obtener el punto más cercano
punto_mas_cercano = nombres[indice]

print("El mejor modelo es:", punto_mas_cercano)
print(distancias)

"""### Algoritmo Árboles de decisión"""

def ArbolesDecision(data_cruzada,caracteristicas,kparticiones):
  sensibilidad = 0
  precision = 0
  especificidad = 0
  # Obtener los valores de entrada (X) y las etiquetas (y) del dataset
  X = data_cruzada.iloc[:, caracteristicas].values
  y = data_cruzada.iloc[:, 0].values

  # Inicializar el objeto KFold con el número de folds (k)
  kf = KFold(n_splits=kparticiones)

  # Listas para almacenar los conjuntos de entrenamiento y prueba
  train_indices = []
  test_indices = []

  # Generar los conjuntos de entrenamiento y prueba usando KFold
  for train_index, test_index in kf.split(X):
      train_indices.append(train_index)
      test_indices.append(test_index)

  # Iterar sobre los k folds
  for fold in range(k):
      print('\nFold ',fold)
      # Obtener los índices de entrenamiento y prueba para el fold actual
      train_index = train_indices[fold]
      test_index = test_indices[fold]

      # Obtener los conjuntos de entrenamiento y prueba para el fold actual
      X_train, y_train = X[train_index], y[train_index]
      X_test, y_test = X[test_index], y[test_index]

      modelo = DecisionTreeClassifier()
      modelo.fit(X_train,y_train)
      y_pred = modelo.predict(X_test)
      matriz = confusion_matrix(y_test,y_pred)
      metricas = desempeno(matriz)
      promedio = metricas['Promedio']
      sensibilidad += promedio[0]
      precision += promedio[1]
      especificidad += promedio[2]
      print(matriz)
      print(metricas)
  return sensibilidad/k, precision/k, especificidad/k

"""Modelo 1"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas_2=[14,1,4]
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas_2,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas_2,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas_2,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 2"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[14,1,4,19,2,18,5]
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 3"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[14]
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 4"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[21,20,9,15]
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = ArbolesDecision(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

roc_x = [espe0,espe1,espe2,espe3]
roc_y = [sens0,sens1,sens2,sens3]
nombres = ['M0','M1','M2','M3']
colores = ['blue','red', 'green','yellow']

plt.scatter(roc_x, roc_y,c=colores)

for i, nombre in enumerate(nombres):
    plt.annotate(nombre, (roc_x[i], roc_y[i]))

plt.title('Gráfica de las 3 validaciones')
plt.xlabel('1 - Especificidad')
plt.ylabel('Sensibilidad')

plt.show()

# calcular la distancia de cada punto a la esquina superior izquierda donde tendrá la mejor especificidad y sensibilidad
distancias = []
for p in range(0,len(nombres)):
    distancia = math.sqrt((0 - roc_x[p])**2 + (1 - roc_y[p])**2)
    distancias.append(distancia)

# obtener el índice del punto más cercano
indice = distancias.index(min(distancias))

# obtener el punto más cercano
punto_mas_cercano = nombres[indice]

print("El mejor modelo es:", punto_mas_cercano)
print(distancias)

"""### Algoritmo Regresión logística"""

def RegresionLogistica(data_cruzada,caracteristicas,kparticiones):
  sensibilidad = 0
  precision = 0
  especificidad = 0
  # Obtener los valores de entrada (X) y las etiquetas (y) del dataset
  X = data_cruzada.iloc[:, caracteristicas].values
  y = data_cruzada.iloc[:, 0].values

  # Inicializar el objeto KFold con el número de folds (k)
  kf = KFold(n_splits=kparticiones)

  # Listas para almacenar los conjuntos de entrenamiento y prueba
  train_indices = []
  test_indices = []

  # Generar los conjuntos de entrenamiento y prueba usando KFold
  for train_index, test_index in kf.split(X):
      train_indices.append(train_index)
      test_indices.append(test_index)

  # Iterar sobre los k folds
  for fold in range(k):
      print('\nFold ',fold)
      # Obtener los índices de entrenamiento y prueba para el fold actual
      train_index = train_indices[fold]
      test_index = test_indices[fold]

      # Obtener los conjuntos de entrenamiento y prueba para el fold actual
      X_train, y_train = X[train_index], y[train_index]
      X_test, y_test = X[test_index], y[test_index]

      modelo = LogisticRegression(max_iter = 1000)
      modelo.fit(X_train,y_train)
      y_pred = modelo.predict(X_test)
      matriz = confusion_matrix(y_test,y_pred)
      metricas = desempeno(matriz)
      promedio = metricas['Promedio']
      sensibilidad += promedio[0]
      precision += promedio[1]
      especificidad += promedio[2]
      print(matriz)
      print(metricas)
  return sensibilidad/k, precision/k, especificidad/k

"""Modelo 1"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[14,1,4]
sens0,prec0,espe0 = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens0)
print('Promedio precisión: ',prec0)
print('Promedio especificidad: ',espe0)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 2"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas_3=[14,1,4,19,2,18,5]
sens1,prec1,espe1 = RegresionLogistica(data_cruzada,caracteristicas_3,k)
print('Promedio sensibilidad: ',sens1)
print('Promedio precisión: ',prec1)
print('Promedio especificidad: ',espe1)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas_3,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas_3,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 3"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[14]
sens2,prec2,espe2 = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens2)
print('Promedio precisión: ',prec2)
print('Promedio especificidad: ',espe2)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

"""Modelo 4"""

k = 7
data_cruzada = homogeneidad(data_sin,k)
caracteristicas=[21,20,9,15]
sens3,prec3,espe3 = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens3)
print('Promedio precisión: ',prec3)
print('Promedio especificidad: ',espe3)

k = 9
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

k = 11
data_cruzada = homogeneidad(data_sin,k)
sens,prec,espe = RegresionLogistica(data_cruzada,caracteristicas,k)
print('Promedio sensibilidad: ',sens)
print('Promedio precisión: ',prec)
print('Promedio especificidad: ',espe)

roc_x = [espe0,espe1,espe2,espe3]
roc_y = [sens0,sens1,sens2,sens3]
nombres = ['M0','M1','M2','M3']
colores = ['blue','red', 'green','yellow']

plt.scatter(roc_x, roc_y,c=colores)

for i, nombre in enumerate(nombres):
    plt.annotate(nombre, (roc_x[i], roc_y[i]))

plt.title('Gráfica de las 3 validaciones')
plt.xlabel('1 - Especificidad')
plt.ylabel('Sensibilidad')

plt.show()

# calcular la distancia de cada punto a la esquina superior izquierda donde tendrá la mejor especificidad y sensibilidad
distancias = []
for p in range(0,len(nombres)):
    distancia = math.sqrt((0 - roc_x[p])**2 + (1 - roc_y[p])**2)
    distancias.append(distancia)

# obtener el índice del punto más cercano
indice = distancias.index(min(distancias))

# obtener el punto más cercano
punto_mas_cercano = nombres[indice]

print("El mejor modelo es:", punto_mas_cercano)
print(distancias)

"""## 10. Fusionar por esquema de votación la salida de algoritmos clasificadores, los cuales pueden ser: SVM, Regresión logísitca, Árboles de decisión, KNN y Redes neuronales."""

def Fusion(car1, car2, car3, kparticiones):
    caracteristicas = data_sin[columnas[1:]]
    x_train, x_test, y_train, y_test = train_test_split(caracteristicas, data_sin['resultado'], train_size=0.8)

    modelo_knn = KNeighborsClassifier(n_neighbors=kparticiones)
    modelo_knn.fit(x_train.iloc[:, car1], y_train)
    y_pred_knn = modelo_knn.predict(x_test.iloc[:, car1])

    modelo_btree = DecisionTreeClassifier()
    modelo_btree.fit(x_train.iloc[:, car2], y_train)
    y_pred_btree = modelo_btree.predict(x_test.iloc[:, car2])

    modelo_log = LogisticRegression(max_iter = 1000)
    modelo_log.fit(x_train.iloc[:, car3], y_train)
    y_pred_log = modelo_log.predict(x_test.iloc[:, car3])

    # Crear la matriz de votos
    votos = np.vstack((y_pred_knn, y_pred_btree, y_pred_log))
    votos = votos.astype(int)

    # Obtener las predicciones fusionadas mediante votación
    predicciones_fusionadas = np.apply_along_axis(lambda x: np.argmax(np.bincount(x)), axis=0, arr=votos)

    # Crear DataFrame con las predicciones de cada modelo
    y_pred_modelos_df = pd.DataFrame(
        np.vstack((y_pred_knn, y_pred_btree, y_pred_log, predicciones_fusionadas)).T,
        columns=['KNN', 'Decision Tree', 'Logistic Regression', 'Fusión']
    )

    return y_pred_modelos_df

Fusion(caracteristicas_1,caracteristicas_2,caracteristicas_3,5)