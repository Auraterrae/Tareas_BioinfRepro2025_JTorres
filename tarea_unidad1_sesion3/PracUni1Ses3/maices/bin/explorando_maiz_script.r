# ExplorandoMaiz.R

# Limpiar el ambiente de trabajo
rm(list = ls())
setwd("C:/Users/torre/Documents/Repositorios_Github/Tareas_BioinfRepro2025_JTorres/tarea_unidad1_sesion3/PracUni1Ses3/maices/meta")
# 1) Cargar el archivo de metadatos
# Cargar la base de datos desde el directorio meta
# Especificar encoding para manejar caracteres especiales
datos_maiz <- read.delim("../meta/maizteocintle_SNP50k_meta_extended.txt", 
                         header = TRUE, 
                         stringsAsFactors = FALSE,
                         encoding = "macintosh")

# ¿Qué tipo de objeto creamos al cargar la base?
cat("Tipo de objeto creado:/n")
class(datos_maiz)
cat("/n")

# ¿Cómo se ven las primeras 6 líneas del archivo?
cat("Primeras 6 líneas del archivo:/n")
head(datos_maiz)
cat("/n")

# ¿Cuántas muestras hay?
num_muestras <- nrow(datos_maiz)
cat("Número total de muestras:", num_muestras, "/n/n")

# ¿De cuántos estados se tienen muestras?
estados_unicos <- unique(datos_maiz$Estado)
num_estados <- length(estados_unicos)
cat("Número de estados con muestras:", num_estados, "/n")
cat("Estados:", paste(estados_unicos, collapse = ", "), "/n/n")

# ¿Cuántas muestras fueron colectadas antes de 1980?
# Primero verificar la columna de año de colecta
cat("Columnas que contienen 'año' o similar:/n")
colnames(datos_maiz)[grep("año|year|colecta", colnames(datos_maiz), ignore.case = TRUE)]

# Usar la columna AÌ±o._de_colecta
muestras_antes_1980 <- sum(datos_maiz$Año._de_colecta < 1980, na.rm = TRUE)
cat("Muestras colectadas antes de 1980:", muestras_antes_1980, "/n/n")

# ¿Cuántas muestras hay de cada raza?
cat("Número de muestras por raza:/n")
muestras_por_raza <- table(datos_maiz$Raza_Primaria)
print(muestras_por_raza)
cat("/n")

# En promedio ¿a qué altitud fueron colectadas las muestras?
altitud_promedio <- mean(datos_maiz$Altitud, na.rm = TRUE)
cat("Altitud promedio de colecta:", round(altitud_promedio, 2), "metros/n")

# ¿Y a qué altitud máxima y mínima fueron colectadas?
altitud_maxima <- max(datos_maiz$Altitud, na.rm = TRUE)
altitud_minima <- min(datos_maiz$Altitud, na.rm = TRUE)
cat("Altitud máxima:", altitud_maxima, "metros/n")
cat("Altitud mínima:", altitud_minima, "metros/n/n")

# Crear una nueva df de datos sólo con las muestras de la raza Olotillo
olotillo_df <- datos_maiz[datos_maiz$Raza_Primaria == "Olotillo", ]
cat("Número de muestras de la raza Olotillo:", nrow(olotillo_df), "/n/n")

# Crear una nueva df de datos sólo con las muestras de las razas Reventador, Jala y Ancho
razas_seleccionadas <- c("Reventador", "Jala", "Ancho")
submat <- datos_maiz[datos_maiz$Raza_Primaria %in% razas_seleccionadas, ]
cat("Número de muestras de las razas Reventador, Jala y Ancho:", nrow(submat), "/n")

# Mostrar distribución por raza en la submatriz
cat("Distribución por raza en la submatriz:/n")
print(table(submat$Raza_Primaria))
cat("/n")

# Escribir la matriz anterior a un archivo llamado "submat.csv" en /meta
write.csv(submat, file = "../meta/submat.csv", row.names = FALSE)
cat("Archivo 'submat.csv' guardado exitosamente en ../meta//n")

