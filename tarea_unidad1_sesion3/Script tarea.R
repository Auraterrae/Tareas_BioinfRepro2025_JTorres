# Ejercicio 1: crea una variable con el logaritmo base 10 de 50 y súmalo a otra variable cuyo valor sea igual a 5
# primero creamos las variables 

x <- log10(50)
y <- 5

#Luego sumamos ambas variables 

x + y

# Ejercicio 2: suma el número 2 a todos los números entre 1 y 150
# Primero creamos la variable con la secuencia de numeros

a <- c(1:150)

#Luego le sumamos el número deseado

a + 2

#Ejercicio 3: ¿Cuántos son n° son mayores a 20 en el vector -1343:234
#Primero creamos el vector

ejercicio3 <- c(-13432:234)

#Luego creamos el prompt para saber cuantos numeros son mayores a 20

sum(ejercicio3 > 20)
#El resultado es 214

#Ejercicio 4: cargar en R el archivo PracUni1Ses3/maices/meta/maizteocintle_SNP50k_meta_extended.txt y ponlo en un objeto de R llamado meta_maiz.
#Primero establecemos el directorio donde se escuentra el archivo solicitado

setwd("C:/Users/torre/Documents/Repositorios_Github/Tareas_BioinfRepro2025_JTorres/tarea_unidad1_sesion3/PracUni1Ses3/maices/meta")

#Luego creamos el objeto

meta_maiz <- "maizteocintle_SNP50k_meta_extended.txt"

#Ejercicio 5: Escribe un for loop para que divida 35 entre 1:10 e imprima el resultado en la consola.

for (i in 1:10) {
  print(35 / i)
}

#Luego modifica el loop anterior para que haga las divisiones solo para los números nones

for (i in 1:10) {
  if (i %% 2 == 0) next
  print(35 / i)
}

#Modifica el loop anterior para que los resultados de correr todo el loop se guarden en una df de dos columnas, la primera debe tener el texto "resultado para x" (donde x es cada uno de los elementos del loop) y la segunda el resultado correspondiente a cada elemento del loop. Pista: el primer paso es crear un vector fuera del loop.

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

#ejercicio 6: Abre en RStudio el script PracUni1Ses3/mantel/bin/1.IBR_testing.r. Este script realiza un análisis de aislamiento por resistencia con Fst calculadas con ddRAD en Berberis alpina.

#Lee el código del script y determina:
  
  #¿qué hacen los dos for loops del script?
  #¿qué paquetes necesitas para correr el script?
  #¿qué archivos necesitas para correr el script?

#Primero establecemos el directorio

setwd("C:/Users/torre/Documents/Repositorios_Github/Tareas_BioinfRepro2025_JTorres/tarea_unidad1_sesion3/PracUni1Ses3/mantel/bin")

#El primer loop contruye una matriz para determinar la distancia geográfica entre cada una de las especies de maiz, el segundo loop hace un test de mantel para cada una de las especies, crea un gráfico de los resultados y almacena los datos en un dataframe
#Se necesitan los paquete ade4, ggplot2 y sp
#Se necesitan los archivos "read.fst_summary_fix.R", "read.effdist.R", 

#Ejercicio 7: Escribe una función llamada calc.tetha que te permita calcular tetha dados Ne y u como argumentos.

calc.tetha <- function(Ne,u) {
  tetha <- 4 * Ne * u
  return(tetha)
}
calc.tetha(Ne= 1000, u = 0.001)

#Ejercicio 8 será desarrollado en el archivo "1.INR_testing_editado.r" (Al script del ejercicio de las pruebas de Mantel, agrega el código necesario para realizar un Partial Mantel test entre la matriz Fst, y las matrices del presente y el LGM, parcializando la matriz flat)

#Ejercicio 9: Este ejercico estará en el archivo ExplorandoMaiz.R (Escribe un script que debe estar guardado en PracUni1Ses3/maices/bin y llamarse ExplorandoMaiz.R, que 1) cargue en R el archivo PPracUni1Ses3maices/meta/maizteocintle_SNP50k_meta_extended.txt y 2) responda lo siguiente.

#(averigua cada punto con comandos de R. Recuerda comentar o tendrás 7 años de mala suerte en el lab)

#¿Qué tipo de objeto creamos al cargar la base?
  
 # ¿Cómo se ven las primeras 6 líneas del archivo?
  
  #¿Cuántas muestras hay?
  
  #¿De cuántos estados se tienen muestras?
  
  #¿Cuántas muestras fueron colectadas antes de 1980?
  
  #¿Cuántas muestras hay de cada raza?
  
  #En promedio ¿a qué altitud fueron colectadas las muestras?
  
  #¿Y a qué altitud máxima y mínima fueron colectadas?
  
  #Crea una nueva df de datos sólo con las muestras de la raza Olotillo

#Crea una nueva df de datos sólo con las muestras de la raza Reventador, Jala y Ancho

#Escribe la matriz anterior a un archivo llamado "submat.cvs" en /meta.)