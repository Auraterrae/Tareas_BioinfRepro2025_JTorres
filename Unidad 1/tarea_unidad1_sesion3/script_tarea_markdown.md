# Tarea Bioinformática Reproductiva - Ejercicios en R

**Cabe destacar que el ejercicio 9 está desarrollado en codificación *"macintosh"*, aunque no fuese la más optima para leer el archivo, se puede correr el codigo sin inconvenientes**

## Ejercicio 1: Logaritmo base 10 y suma

Crear una variable con el logaritmo base 10 de 50 y sumarlo a otra variable cuyo valor sea igual a 5.

```r
# Primero creamos las variables 
x <- log10(50)
y <- 5

# Luego sumamos ambas variables 
x + y
```

## Ejercicio 2: Suma vectorial

Sumar el número 2 a todos los números entre 1 y 150.

```r
# Primero creamos la variable con la secuencia de números
a <- c(1:150)

# Luego le sumamos el número deseado
a + 2
```

## Ejercicio 3: Conteo condicional

¿Cuántos números son mayores a 20 en el vector -1343:234?

```r
# Primero creamos el vector
ejercicio3 <- c(-13432:234)

# Luego creamos el prompt para saber cuántos números son mayores a 20
sum(ejercicio3 > 20)
# El resultado es 214
```

## Ejercicio 4: Cargar archivo de datos

Cargar en R el archivo `PracUni1Ses3/maices/meta/maizteocintle_SNP50k_meta_extended.txt` y ponerlo en un objeto de R llamado `meta_maiz`.

```r
# Primero establecemos el directorio donde se encuentra el archivo solicitado
setwd("C:/Users/torre/Documents/Repositorios_Github/Tareas_BioinfRepro2025_JTorres/tarea_unidad1_sesion3/PracUni1Ses3/maices/meta")

# Luego creamos el objeto
meta_maiz <- "maizteocintle_SNP50k_meta_extended.txt"
```

**Nota**: El código anterior solo asigna el nombre del archivo como string. Para cargar correctamente los datos sería:

```r
meta_maiz <- read.delim("maizteocintle_SNP50k_meta_extended.txt", 
                       fileEncoding = "macintosh")
```

## Ejercicio 5: Bucles for

### 5a. Bucle básico

Escribir un for loop para que divida 35 entre 1:10 e imprima el resultado en la consola.

```r
for (i in 1:10) {
  print(35 / i)
}
```

### 5b. Bucle con condición

Modificar el loop anterior para que haga las divisiones solo para los números nones.

```r
for (i in 1:10) {
  if (i %% 2 == 0) next
  print(35 / i)
}
```

### 5c. Bucle con almacenamiento en data.frame

Modificar el loop anterior para que los resultados se guarden en un data.frame de dos columnas.

```r
# Creamos un df vacío con dos columnas
resultados <- data.frame(Operacion = character(0), Resultado = numeric(0))

# Loop
for (i in 1:10) {
  if (i %% 2 == 0) next  # saltar pares

  # Texto de la operación
  texto <- paste("resultado para", i)
  valor <- 35 / i

  # Agregar al df
  resultados <- rbind(resultados, data.frame(Operacion = texto, Resultado = valor))
}

# Ver resultados
print(resultados)
```

## Ejercicio 6: Análisis del script IBR

Abrir y analizar el script `PracUni1Ses3/mantel/bin/1.IBR_testing.r`.

```r
# Establecer el directorio
setwd("C:/Users/torre/Documents/Repositorios_Github/Tareas_BioinfRepro2025_JTorres/tarea_unidad1_sesion3/PracUni1Ses3/mantel/bin")
```

### Preguntas de análisis:

**¿Qué hacen los dos for loops del script?**

- El primer loop construye una matriz para determinar la distancia geográfica entre cada una de las especies de maíz
- El segundo loop hace un test de Mantel para cada una de las especies, crea un gráfico de los resultados y almacena los datos en un dataframe

**¿Qué paquetes necesitas para correr el script?**

- `ade4`
- `ggplot2` 
- `sp`

**¿Qué archivos necesitas para correr el script?**

- `"read.fst_summary_fix.R"`
- `"read.effdist.R"`

## Ejercicio 7: Función calc.tetha

Escribir una función llamada `calc.tetha` que permita calcular tetha dados Ne y u como argumentos.

```r
calc.tetha <- function(Ne, u) {
  tetha <- 4 * Ne * u
  return(tetha)
}

# Ejemplo de uso
calc.tetha(Ne = 1000, u = 0.001)
```

## Ejercicio 8: Partial Mantel Test

Este ejercicio se desarrollará en el archivo `"1.IBR_testing_editado.r"`. 

**Objetivo**: Agregar al script del ejercicio de las pruebas de Mantel el código necesario para realizar un Partial Mantel test entre la matriz Fst y las matrices del presente y el LGM, parcializando la matriz flat.

## Ejercicio 9: Script ExplorandoMaiz.R

Este ejercicio está en el archivo `ExplorandoMaiz.R` ubicado en `PracUni1Ses3/maices/bin`.

**Objetivo**: Crear un script que:

1. Cargue el archivo `PracUni1Ses3/maices/meta/maizteocintle_SNP50k_meta_extended.txt`
2. Responda las siguientes preguntas mediante comandos de R:

### Preguntas a responder:

- ¿Qué tipo de objeto creamos al cargar la base?
- ¿Cómo se ven las primeras 6 líneas del archivo?
- ¿Cuántas muestras hay?
- ¿De cuántos estados se tienen muestras?
- ¿Cuántas muestras fueron colectadas antes de 1980?
- ¿Cuántas muestras hay de cada raza?
- En promedio ¿a qué altitud fueron colectadas las muestras?
- ¿Y a qué altitud máxima y mínima fueron colectadas?
- Crear una nueva df de datos sólo con las muestras de la raza Olotillo
- Crear una nueva df de datos sólo con las muestras de la raza Reventador, Jala y Ancho
- Escribir la matriz anterior a un archivo llamado `"submat.csv"` en `/meta`

---
