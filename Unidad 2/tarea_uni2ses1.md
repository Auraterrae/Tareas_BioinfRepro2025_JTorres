# Tarea unidad 2 sesión 1

## Ejercicios

#### a) ¿Cuántos individuos y variantes (SNPs) tiene el archivo?

 `$ vcftools  --gzvcf /datos/compartido/ChileGenomico/GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf`

con este comando podemos acceder al archivo solicitado en el ejercicio

nos indica que tenemos 18 individuos y 4450360 sitios

#### b) ¿Cuántos sitios del archivo no tienen datos perdidos?

`$ vcftools --gzvcf /datos/compartido/ChileGenomico/GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf  --max-missing 1`

me reporta 383626 sitios observados a los que no les falta información, de un total de 4450360

#### c) Genera un archivo en tu carpeta de trabajo llamado que contenga solo SNPs en una ventana de 2Mb en cualquier cromosoma. Nombra el archivo`CLG_Chr<X>_<Start>-<End>Mb.vcf` donde es número del cromosoma, es el inicio de la ventana genómica y es el final en megabases.

`vcftools --gzvcf /datos/compartido/ChileGenomico/GATK_ChGdb_recalibrated.autosomes.12262013.snps.known.vcf --chr 7 --from-bp 1000000 --to-bp 3000000 --recode --recode-INFO-all --out CLG_Chr7_1-3Mb`

#### d) Reporta cuántas variantes tienen el archivo generado

` grep -v "^#" CLG_Chr7_1-3Mb.vcf | wc -l `

#### e) Reporta la cobertura promedio para todos los individuos del set de datos

` vcftools --vcf ../data/CLG_Chr7_1-3Mb.vcf --freq --out frecuencias_alelos`

este comando se debe ejecutar dentro del directorio de resultados para que el archivo se almacene de manera correcta en el directorio deseado

#### f) Calcula la frecuencia de cada alelo para todos los individuos dentro del archivo y guarda el resultado en un archivo

`vcftools --vcf ../data/CLG_Chr7_1-3Mb.vcf --freq --out frecuencias_alelos`

#### g) Filtra el archivo de frecuencias para solo incluir variantes bialélicas (tip: awk puede ser útil para realizar esta tarea, tip2: puedes usar bcftools para filtrar variantes con más de dos alelos antes de calcular las frecuencias)

`bcftools view -m2 -M2 ../data/CLG_Chr7_1-3Mb.vcf > CLG_Chr7_1-3Mb_biallelic.vcf`  primero filtramos el archivo para obtener las variantes bialélicas

`vcftools --vcf CLG_Chr7_1-3Mb_biallelic.vcf --freq --out frecuencias_bialelicas`  luego volvemos a calcular las frecuencias bialélicas del archivo generado

#### h) Llama a un script escrito en lenguaje R que lee el archivo de frecuencias de variantes bialélicas y guarda un histograma con el espectro de MAF para las variantes bialélicas

primero usamos awk para ectraer los datos de MAF

`awk 'NR>1 {
    # Extraer las frecuencias de las columnas 5 y 6
    split($5, freq1_parts, ":")
    split($6, freq2_parts, ":")
    freq1 = freq1_parts[2]
    freq2 = freq2_parts[2]
    maf = (freq1 < freq2) ? freq1 : freq2
    print maf
}' ../results/frecuencias_bialelicas.frq > ../results/maf_values.txt` 

luego creamos el script en el directorio code `nano plot_maf_simple.R`

dentro de este va lo siguiente `# Script simple usando archivo de MAF pre-procesado # Leer valores de MAF MAF <- scan("../results/maf_values.txt", quiet = TRUE) print(paste("Número de variantes procesadas:", length(MAF))) print("Primeros 10 valores de MAF:") print(head(MAF, 10)) # Verificar que tenemos datos if (length(MAF) == 0) { stop("No se pudieron leer los valores de MAF") } # Crear histograma png("../results/histograma_MAF.png", width = 800, height = 600) hist(MAF, breaks = 30, main = "Espectro de Frecuencias de Alelos Menores (MAF)", xlab = "Frecuencia del Alelo Menor", ylab = "Número de Variantes", col = "lightblue", border = "black") dev.off() # Estadísticas básicas cat("\nEstadísticas del MAF:\n") print(summary(MAF)) # Respuesta para pregunta i) - Contar MAF < 0.05 maf_005 <- sum(MAF < 0.05) cat(paste("\nRespuesta pregunta i):\n")) cat(paste("Número de sitios con MAF < 0.05:", maf_005, "\n")) cat(paste("Porcentaje de sitios con MAF < 0.05:", round(maf_005/length(MAF)*100, 2), "%\n")) cat("\nHistograma guardado en: ../results/histograma_MAF.png\n")`

finalmente ejecutamos el script creado con `Rscript ../code/plot_maf_simple.R`

#### i) ¿Cuántos sitios tienen una frecuencia del alelo menor <0.05?

al ejecutar el script de la letra h tambien tenemos la respuesta de este

#### j) Calcula la heterocigosidad de cada individuo.

`vcftools --vcf CLG_Chr7_1-3Mb.vcf --het --out ../results/heterocigosidad`

#### k) Calcula la diversidad nucleotídica por sitio.

`vcftools --vcf CLG_Chr7_1-3Mb.vcf --site-pi --out ../results/diversidad_nucleotidica`

#### l) Filtra los sitios que tengan una frecuencia del alelo menor <0.05

`vcftools --vcf CLG_Chr7_1-3Mb.vcf --maf 0.05 --recode --recode-INFO-all --out ../results/CLG_Chr7_1-3Mb_maf05`

#### m) Convierte el archivo `wolves_maf05.vcf` a formato plink (asumiendo que wolves es el archivo de CLG con el que estuvimos trabajando anteriormente).

primero renombramos el archivo 

```bash
mv results/CLG_Chr7_1-3Mb_maf05.recode.vcf results/wolves_maf05.vcf
```

luego lo convertimos a plink 

```bash
vcftools --vcf results/wolves_maf05.vcf --plink --out results/wolves_maf05
```

## Pasamos a plink

Copia esos archivos a tu respositorio en una carpeta para la sesión `Unidad2/Prac_Uni2/data` `cp /datos/compartido/ChileGenomico/chilean_all48_hg19.* ../data/`

1. Enlista los archivos plink que hay en `data`. ¿Qué tipos de archivos son cada uno?
   
   tenmos archivos bim, bed y fam de la base de datos copiada

2. Consulta el manual de [plink1.9](https://www.cog-genomics.org/plink/1.9/formats) y contesta utilizando comandos de plink lo siguiente. Deposita cualquier archivo que generes en la carpeta `Unididad2/Prac_Uni2/results`:
   
   a) Transforma de formato bed a formato ped (pista: sección Data Managment). El nombre del output debe ser igual, solo cambiando la extensión.

```bash
plink --bfile ../data/chilean_all48_hg19 --recode --out ../results/chilean_all48_hg19
```

        b) Crea otro archivo ped (ojo PPPPed) pero esta vez filtrando los SNPs cuya         frecuencia del alelo menor sea menor a 0.05 Y filtrando los individuos con más de         10% missing data. Tu output debe llamarse         maicesArtegaetal2015_maf05_missing10

¿Cuántos SNPs y cuántos individuos fueron removidos por los filtros?

```bash
plink --bfile ../data/chilean_all48_hg19 --recode --maf 0.05  --mind 0.1 --out ../results/chilean_all48_hg19_maf05_missing10
```

2 individuos fueron removidos y 347070 SNP´s

#### c) Realiza un reporte de equilibrio de Hardy-Weinberg sobre el archivo `chilean_all48_hg19_maf05_missing10` creado en el ejercicio anterior. El nombre del archivo de tu output debe contener chilean_all48_hg19_maf05_missing10.

```bash
plink --file ../results/chilean_all48_hg19_maf05_missing10 --hardy --out ../results/chilean_all48_hg19_maf05_missing10
```

Observa el output y discute que es cada columna.

```bash
head ../results/chilean_all48_hg19_maf05_missing10.hwe
10.hwe
 CHR                          SNP     TEST   A1   A2                 GENO   O(HET)   E(HET)            P
   1                    rs9701055      ALL    T    C              18/0/28        0   0.4764    5.994e-14
   1                    rs9701055      AFF    T    C                0/0/0      nan      nan            1
   1                    rs9701055    UNAFF    T    C              18/0/28        0   0.4764    5.994e-14
   1                    rs9701055      ALL    T    C              0/16/28   0.3636   0.2975       0.3137
   1                    rs9701055      AFF    T    C                0/0/0      nan      nan            1
   1                    rs9701055    UNAFF    T    C              0/16/28   0.3636   0.2975       0.3137
   1                    rs2073813      ALL    A    G              0/17/28   0.3778   0.3064       0.3197
   1                    rs2073813      AFF    A    G                0/0/0      nan      nan            1
   1                    rs2073813    UNAFF    A    G              0/17/28   0.3778   0.3064       0.3197
```

CHR: Cromosoma
SNP: Identificador del SNP
TEST: Tipo de test (ALL = todos los individuos, AFF = afectados, UNAFF = no afectados)
A1, A2: Los dos alelos del SNP
GENO: Conteos de genotipos en formato homocigoto_A1/heterocigoto/homocigoto_A2
O(HET): Heterocigosidad observada
E(HET): Heterocigosidad esperada bajo equilibrio de Hardy-Weinberg
P: P-valor del test de Hardy-Weinberg (valores bajos indican desviación del equilibrio)

#### d) Observa el archivo `maicesArtegaetal2015.fam`. Consulta la documentación de plink para determinar que es cada columna. ¿Qué información hay y no hay en este archivo?

```bash
head ../data/chilean_all48_hg19.fam
CDSJ177 CDSJ177 0 0 1 1
CDSJ021 CDSJ021 0 0 1 1
ARI006 ARI006 0 0 1 1
ARI021 ARI021 0 0 1 1
ARI022 ARI022 0 0 2 1
CDSJ174 CDSJ174 0 0 1 1
CDSJ175 CDSJ175 0 0 1 1
CDSJ046 CDSJ046 0 0 1 1
CDSJ176 CDSJ176 0 0 1 1
CDSJ469 CDSJ469 0 0 2 1
```

la columna 1 corresponde al identificador familiar o family ID, la 2 es individual ID, la 3 corresponde al ID del padre, si el calor es 0 es porque no se conoce, la 4 correpsonde al ID de la madre (0 = no se conoce), 5 es sexo (1 = masculino, 2 = femenino, 3 = desconnocido), 6 corresponde al fenotipo (1 = control/no afectado, 2 = caso/afectado, -9/0 = perdido)

3. Utiliza la info el archivo `data/chilean_all48_hg19_popinfo.csv` y el comando `update-ids` de plink para cambiar los nombres de las muestras de `data/chilean_all48_hg19.fam` de tal forma que el family ID corresponda a la info de la columna `Categ.Altitud` en `maizteocintle_SNP50k_meta_extended.txt`. Pista: este ejercicio requiere varias operaciones, puedes dividirlas en diferentes scripts de bash o de R y bash. Tu respuesta debe incluir todos los scripts (y deben estar en /code).

head ../data/chilean_all48_hg19_popinfo.csv

```r
# Leer el archivo popinfo
popinfo <- read.csv("../data/chilean_all48_hg19_popinfo.csv", stringsAsFactors = FALSE)

# Ver la estructura del archivo
print("Estructura del archivo popinfo:")
print(str(popinfo))
print(head(popinfo))

# Leer el archivo .fam actual
fam_data <- read.table("../data/chilean_all48_hg19.fam", stringsAsFactors = FALSE)
colnames(fam_data) <- c("FID", "IID", "PAT", "MAT", "SEX", "PHENO")

print("Primeros registros del archivo .fam:")
print(head(fam_data))

# Verificar qué columna tiene los IDs que coinciden
# Generalmente podría ser una columna como "Sample", "ID", "Individual", etc.
print("Nombres de columnas en popinfo:")
print(colnames(popinfo))

# Buscar la columna que contiene los IDs de las muestras
# (ajustar según la estructura real del archivo)
if ("Sample" %in% colnames(popinfo)) {
  sample_col <- "Sample"
} else if ("ID" %in% colnames(popinfo)) {
  sample_col <- "ID"
} else if ("Individual" %in% colnames(popinfo)) {
  sample_col <- "Individual"
} else {
  # Usar la primera columna como default
  sample_col <- colnames(popinfo)[1]
  cat("Usando la primera columna como Sample ID:", sample_col, "\n")
}

# Buscar la columna de categoría (usar Region, Population o Ancestry)
if ("Region" %in% colnames(popinfo)) {
  category_col <- "Region"
  cat("Usando columna Region como categoría\n")
} else if ("Population" %in% colnames(popinfo)) {
  category_col <- "Population"
  cat("Usando columna Population como categoría\n")
} else if ("Ancestry" %in% colnames(popinfo)) {
  category_col <- "Ancestry"
  cat("Usando columna Ancestry como categoría\n")
} else {
  cat("No se encontró columna de categoría apropiada. Columnas disponibles:\n")
  print(colnames(popinfo))
  stop("Especificar manualmente la columna de categoría")
}

# Crear el archivo de actualización de IDs para plink
# Formato: FID_old IID_old FID_new IID_new

# Primero necesitamos hacer match entre los IDs del .fam y popinfo
# Los IDs en .fam parecen tener formato diferente (ej: ARI006 vs ARI-006)

# Crear versiones modificadas de los IDs para hacer match
popinfo$IndID_modified <- gsub("-", "", popinfo$IndID)  # ARI-006 -> ARI006
fam_data$IID_clean <- toupper(fam_data$IID)

print("Ejemplos de IDs modificados:")
print(head(popinfo[, c("IndID", "IndID_modified")]))
print("IDs en .fam:")
print(head(fam_data$IID_clean))

# Hacer merge para encontrar matches
merged <- merge(fam_data, popinfo, by.x = "IID_clean", by.y = "IndID_modified", all.x = TRUE)

print("Resultados del merge:")
print(paste("Total individuos en .fam:", nrow(fam_data)))
print(paste("Matches encontrados:", sum(!is.na(merged[[category_col]]))))

# Crear archivo de actualización solo para los que tienen match
valid_matches <- !is.na(merged[[category_col]])
update_ids <- data.frame(
  FID_old = merged$IID_clean[valid_matches],
  IID_old = merged$IID_clean[valid_matches], 
  FID_new = merged[[category_col]][valid_matches],
  IID_new = merged$IID_clean[valid_matches]
)

# Guardar el archivo
write.table(update_ids, "../results/update_ids.txt", 
            row.names = FALSE, col.names = FALSE, quote = FALSE, sep = "\t")

cat("Archivo de actualización creado en: ../results/update_ids.txt\n")
cat(paste("Usando columna", category_col, "como nueva categoría de Family ID\n"))
print("Primeros registros:")
print(head(update_ids))
EOF

# Ejecutar el script de R
echo "Ejecutando script de preparación..."
Rscript prepare_update_ids.R

# Verificar que se creó el archivo
if [ -f "../results/update_ids.txt" ]; then
    echo "Archivo de actualización creado exitosamente"
    echo "Primeras líneas del archivo:"
    head ../results/update_ids.txt

    # Aplicar la actualización de IDs usando plink
    echo "Aplicando actualización de IDs con plink..."
    plink --bfile ../data/chilean_all48_hg19 \
          --update-ids ../results/update_ids.txt \
          --make-bed \
          --out ../results/chilean_all48_hg19_updated_ids

    echo "IDs actualizados. Verificando el nuevo archivo .fam:"
    head ../results/chilean_all48_hg19_updated_ids.fam
else
    echo "Error: No se pudo crear el archivo de actualización"
fi
```

4. Realiza una comparación entre el sexo y archivo `fam`y el `popinfo` y calcula la proporción de discordancias

```popinfo
   fam_data <- read.table("../data/chilean_all48_hg19.fam", stringsAsFactors = FALSE)
   colnames(fam_data) <- c("FID", "IID", "PAT", "MAT", "SEX", "PHENO")

print("Estructura de popinfo:")
print(str(popinfo))

print("Información de sexo en .fam:")
print("Códigos: 1=masculino, 2=femenino, 0=desconocido")
print(table(fam_data$SEX))

# Buscar columna de sexo en popinfo

sex_cols <- grep("sex|Sex|SEX|gender|Gender", colnames(popinfo), value = TRUE)
print(paste("Columnas relacionadas con sexo encontradas:", paste(sex_cols, collapse = ", ")))

if (length(sex_cols) > 0) {
  sex_col <- sex_cols[1]
  print(paste("Usando columna:", sex_col))

# Ver valores únicos en la columna de sexo

  print("Valores únicos en columna de sexo de popinfo:")
  print(table(popinfo[[sex_col]]))

# Intentar hacer merge por ID

# Buscar columna de ID en popinfo

  id_cols <- grep("sample|Sample|ID|id|Individual", colnames(popinfo), value = TRUE)
  if (length(id_cols) > 0) {
    id_col <- id_cols[1]
    print(paste("Usando columna de ID:", id_col))

    # Merge de los datos
    merged_data <- merge(fam_data, popinfo, by.x = "IID", by.y = id_col, all.x = TRUE)

    # Convertir códigos de sexo para comparación
    # Asumir que en popinfo: M/Male/1 = masculino, F/Female/2 = femenino
    merged_data$sex_popinfo_coded <- ifelse(
      grepl("^[Mm]", merged_data[[sex_col]]) | merged_data[[sex_col]] == "1", 1,
      ifelse(grepl("^[Ff]", merged_data[[sex_col]]) | merged_data[[sex_col]] == "2", 2, 0)
    )

    # Comparar
    discordances <- merged_data$SEX != merged_data$sex_popinfo_coded
    n_discordances <- sum(discordances, na.rm = TRUE)
    total_comparisons <- sum(!is.na(merged_data$sex_popinfo_coded))

    cat("\n=== RESULTADOS DE COMPARACIÓN DE SEXO ===\n")
    cat("Total de individuos comparados:", total_comparisons, "\n")
    cat("Discordancias encontradas:", n_discordances, "\n")
    cat("Proporción de discordancias:", round(n_discordances/total_comparisons, 4), "\n")

    # Mostrar casos discordantes
    if (n_discordances > 0) {
      discordant_cases <- merged_data[discordances & !is.na(merged_data$sex_popinfo_coded), 
                                      c("IID", "SEX", sex_col, "sex_popinfo_coded")]
      print("Casos discordantes:")
      print(discordant_cases)

      # Guardar casos discordantes
      write.csv(discordant_cases, "../results/sex_discordances.csv", row.names = FALSE)
    }

  } else {
    print("No se encontró columna de ID apropiada en popinfo")
  }

} else {
  print("No se encontró columna de sexo en popinfo")
  print("Columnas disponibles:")
  print(colnames(popinfo))
}
```

5. Realiza un test de estimación de sexo usando plink y reporta los resultados en formato de tabla para todos los individuos con discordancia entre el sexto reportado en `fam` y el calculado con plink.

```bash
# Realizar el test de sexo con plink

echo "Ejecutando test de sexo..."
plink --bfile ../data/chilean_all48_hg19 \
      --check-sex \
      --out ../results/chilean_sex_check

# Verificar que se generó el archivo

if [ -f "../results/chilean_sex_check.sexcheck" ]; then
    echo "Test de sexo completado exitosamente"
    echo ""
    echo "Primeras líneas del archivo de resultados:"
    head ../results/chilean_sex_check.sexcheck

    echo ""
    echo "=== ANÁLISIS DE RESULTADOS ==="

    # Crear script de R para analizar los resultados
    cat > analyze_sex_check.R << 'EOF'

# Analizar resultados del test de sexo

# Leer resultados del sex check

sexcheck <- read.table("../results/chilean_sex_check.sexcheck", header = TRUE, stringsAsFactors = FALSE)

print("Estructura de los resultados del sex check:")
print(str(sexcheck))
print(head(sexcheck))

# Explicar las columnas

cat("\n=== EXPLICACIÓN DE COLUMNAS ===\n")
cat("FID: Family ID\n")
cat("IID: Individual ID\n") 
cat("PEDSEX: Sexo reportado en archivo .fam (1=M, 2=F, 0=unknown)\n")
cat("SNPSEX: Sexo estimado por plink (1=M, 2=F, 0=unknown)\n")
cat("STATUS: Estado de concordancia (OK, PROBLEM)\n")
cat("F: Coeficiente de endogamia en cromosoma X\n")

# Análisis de concordancia

cat("\n=== ANÁLISIS DE CONCORDANCIA ===\n")
print("Tabla de concordancia:")
print(table(sexcheck$PEDSEX, sexcheck$SNPSEX, useNA = "always"))

cat("\nResumen de STATUS:\n")
print(table(sexcheck$STATUS))

# Identificar discordancias

discordant <- sexcheck[sexcheck$STATUS == "PROBLEM", ]

if (nrow(discordant) > 0) {
    cat("\n=== INDIVIDUOS CON DISCORDANCIAS ===\n")
    cat("Número de individuos con discordancias:", nrow(discordant), "\n")

    # Crear tabla formateada
    discordant_table <- discordant[, c("FID", "IID", "PEDSEX", "SNPSEX", "F")]
    discordant_table$PEDSEX_label <- ifelse(discordant_table$PEDSEX == 1, "Masculino",
                                           ifelse(discordant_table$PEDSEX == 2, "Femenino", "Desconocido"))
    discordant_table$SNPSEX_label <- ifelse(discordant_table$SNPSEX == 1, "Masculino", 
                                           ifelse(discordant_table$SNPSEX == 2, "Femenino", "Desconocido"))

    colnames(discordant_table) <- c("Family_ID", "Individual_ID", "Sexo_Reportado_Cod", 
                                   "Sexo_Estimado_Cod", "Coef_F", "Sexo_Reportado", "Sexo_Estimado")

    print("Tabla de individuos discordantes:")
    print(discordant_table)

    # Guardar tabla
    write.csv(discordant_table, "../results/sex_discordant_individuals.csv", row.names = FALSE)
    cat("\nTabla guardada en: ../results/sex_discordant_individuals.csv\n")

} else {
    cat("No se encontraron discordancias entre sexo reportado y estimado\n")
}

# Distribución del coeficiente F

cat("\n=== DISTRIBUCIÓN DEL COEFICIENTE F ===\n")
cat("Estadísticas del coeficiente F:\n")
print(summary(sexcheck$F))

cat("\nInterpretación del coeficiente F:\n")
cat("F < 0.2: Típicamente femenino\n")
cat("F > 0.8: Típicamente masculino\n")
cat("0.2 ≤ F ≤ 0.8: Ambiguo\n")
EOF

    # Ejecutar análisis
    Rscript analyze_sex_check.R

else
    echo "Error: No se pudo completar el test de sexo"
fi 

4. Genera una tabla de contingencia de individuos por sexo y ancestría (hint: ver columna Ancestry en el archivo `popinfo`)

```#
popinfo <- read.csv("../data/chilean_all48_hg19_popinfo.csv", stringsAsFactors = FALSE)
fam_data <- read.table("../data/chilean_all48_hg19.fam", stringsAsFactors = FALSE)
colnames(fam_data) <- c("FID", "IID", "PAT", "MAT", "SEX", "PHENO")

print("=== TABLA DE CONTINGENCIA: SEXO x ANCESTRÍA ===")

print("Columnas disponibles en popinfo:")
print(colnames(popinfo))

# Buscar columna de ancestría
ancestry_cols <- grep("anc|Anc|ANC|ancestry|Ancestry|ethnic|Ethnic|population|Population", 
                     colnames(popinfo), value = TRUE)

print(paste("Columnas de ancestría encontradas:", paste(ancestry_cols, collapse = ", ")))

if (length(ancestry_cols) > 0) {
  ancestry_col <- ancestry_cols[1]
  print(paste("Usando columna de ancestría:", ancestry_col))

  # Buscar columna de ID y sexo
  id_cols <- grep("sample|Sample|ID|id|Individual", colnames(popinfo), value = TRUE)
  sex_cols <- grep("sex|Sex|SEX|gender|Gender", colnames(popinfo), value = TRUE)

  if (length(id_cols) > 0) {
    id_col <- id_cols[1]
    print(paste("Usando columna de ID:", id_col))

    # Hacer merge
    merged_data <- merge(fam_data, popinfo, by.x = "IID", by.y = id_col, all.x = TRUE)

    # Convertir códigos de sexo
    merged_data$SEX_label <- factor(merged_data$SEX, 
                                   levels = c(1, 2, 0), 
                                   labels = c("Masculino", "Femenino", "Desconocido"))

    # Ver valores únicos de ancestría
    print("Valores únicos de ancestría:")
    print(table(merged_data[[ancestry_col]]))

    # Crear tabla de contingencia
    contingency_table <- table(merged_data$SEX_label, merged_data[[ancestry_col]], useNA = "always")

    print("=== TABLA DE CONTINGENCIA ===")
    print("Filas: Sexo, Columnas: Ancestría")
    print(contingency_table)

    # Calcular proporciones
    print("\n=== PROPORCIONES POR FILA (% dentro de cada sexo) ===")
    prop_by_sex <- prop.table(contingency_table, margin = 1) * 100
    print(round(prop_by_sex, 2))

    print("\n=== PROPORCIONES POR COLUMNA (% dentro de cada ancestría) ===")
    prop_by_ancestry <- prop.table(contingency_table, margin = 2) * 100
    print(round(prop_by_ancestry, 2))

    # Guardar resultados
    # Tabla de contingencia
    write.csv(as.data.frame.matrix(contingency_table), 
              "../results/contingency_sex_ancestry.csv")

    # Proporciones por sexo
    write.csv(as.data.frame.matrix(prop_by_sex), 
              "../results/proportions_by_sex.csv")

    # Proporciones por ancestría
    write.csv(as.data.frame.matrix(prop_by_ancestry), 
              "../results/proportions_by_ancestry.csv")

    # También usar información de sexo de popinfo si está disponible
    if (length(sex_cols) > 0) {
      sex_col <- sex_cols[1]
      print(paste("\n=== USANDO SEXO DE POPINFO (columna:", sex_col, ") ==="))

      contingency_table_popinfo <- table(merged_data[[sex_col]], merged_data[[ancestry_col]], useNA = "always")
      print(contingency_table_popinfo)

      write.csv(as.data.frame.matrix(contingency_table_popinfo), 
                "../results/contingency_sex_ancestry_popinfo.csv")
    }

    # Crear visualización si es posible
    tryCatch({
      png("../results/contingency_plot.png", width = 800, height = 600)
      barplot(contingency_table, 
              main = "Distribución de Individuos por Sexo y Ancestría",
              xlab = "Ancestría", 
              ylab = "Número de Individuos",
              col = c("lightblue", "pink", "gray"),
              legend = rownames(contingency_table),
              beside = TRUE)
      dev.off()
      print("Gráfico guardado en: ../results/contingency_plot.png")
    }, error = function(e) {
      print("No se pudo crear el gráfico")
    })

    cat("\n=== ARCHIVOS GUARDADOS ===\n")
    cat("- Tabla de contingencia: ../results/contingency_sex_ancestry.csv\n")
    cat("- Proporciones por sexo: ../results/proportions_by_sex.csv\n") 
    cat("- Proporciones por ancestría: ../results/proportions_by_ancestry.csv\n")

  } else {
    print("No se encontró columna de ID apropiada")
  }

} else {
  print("No se encontró columna de ancestría")
  print("Revisa manualmente las columnas disponibles y especifica cuál usar")
}
```
