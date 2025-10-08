# Respuestas a las Tareas - Tutorial de Análisis Genético de Poblaciones

## Parte 1: Análisis de Control de Calidad

### Paso 1 - Tarea: Datos Perdidos

**1. ¿Cómo se llaman los archivos que contienen las tasas de datos perdidos por SNP y por muestra?**

- **Por SNP**: `plink.lmiss` (locus missing)
- **Por muestra/individuo**: `plink.imiss` (individual missing)

**2. ¿Cuántas variantes se eliminaron por tener una tasa de datos perdidos mayor a 0.2?**

Para responder esto, necesitamos revisar el output de PLINK. En el comando:

```bash
plink --bfile $C/chilean_all48_hg19 --geno 0.2 --make-bed --out chilean_all48_hg19_2
```

4680 variants removed due to missing genotype data (--geno).



**3. ¿Cuántos individuos tenían una tasa de datos perdidos mayor a 0.02?**

Del comando:

```bash
plink --bfile chilean_all48_hg19_4 --mind 0.02 --make-bed --out chilean_all48_hg19_5
```

0 people removed due to missing genotype data (--mind).

**4. Basados en los histogramas y en sus cálculos, ¿qué valores umbrales de datos perdidos para muestras y SNPs sugeriría?**

**Respuesta**: 

- **Para SNPs**: El umbral de 0.02 (2%) es apropiado para estudios de alta calidad. Los histogramas deberían mostrar que la mayoría de SNPs tienen tasas de missingness muy bajas (<1%), por lo que un umbral de 2% elimina principalmente SNPs problemáticos sin perder demasiada información.

- **Para muestras**: El umbral de 0.02 (2%) también es razonable. Muestras con más de 2% de datos perdidos pueden indicar problemas en la extracción de ADN o en el proceso de genotipificación. Sin embargo, en estudios con muestras limitadas, podría considerarse un umbral de hasta 0.05 (5%) como compromiso entre calidad y tamaño muestral.

---

### Paso 2 - Tarea: Discrepancia de Sexo

**1. ¿Cuántos individuos fueron eliminados por discrepancia de sexo?**

Según el tutorial, se identificaron individuos con la etiqueta "PROBLEM" en el archivo `plink.sexcheck`. Del ejemplo mostrado:

- ARI022: PEDSEX=2 (femenino), SNPSEX=1 (masculino), F=0.9051
- CDSJ176: STATUS=PROBLEM, F=0.7645

El comando `grep "PROBLEM" plink.sexcheck` mostrará todos los casos. Según el contexto del tutorial, parece haber **al menos 2 individuos** con discrepancias.

**Respuesta**: Revisar el output de `grep "PROBLEM" plink.sexcheck | wc -l`

**2. ¿Qué riesgo(s) se corre(n) si no se eliminaran?**

**Respuestas**:

a) **Confusión de identidad muestral**: La discrepancia sugiere que la muestra fue mal etiquetada o intercambiada con otra. Mantener estos individuos significa incluir datos asociados al fenotipo/ID incorrecto.

b) **Sesgo en análisis de asociación**: Si estamos estudiando rasgos relacionados con el sexo o cromosomas sexuales, los resultados estarán incorrectos.

c) **Problemas en análisis de ancestría**: Los patrones de cromosomas sexuales pueden influir en estimaciones de estructura poblacional.

d) **Violación de supuestos estadísticos**: Muchos análisis asumen que los datos de sexo son correctos para ajustar por covariables.

e) **Contaminación de resultados**: Un intercambio de muestras podría propagar errores a través de todo el análisis, invalidando conclusiones.

---

### Paso 3 - Tarea: Filtrado de SNPs

**1. ¿Cuál es el nombre del primer conjunto de datos que solo contiene SNPs en autosomas?**

**Respuesta**: `chilean_all48_hg19_7` 

(Generado tras extraer solo SNPs de cromosomas 1-22)

**2. ¿Cuántos SNPs se encontraban en cromosomas sexuales?**

Para calcular esto:

```
Total SNPs en chilean_all48_hg19_6 - Total SNPs en chilean_all48_hg19_7 = SNPs en cromosomas sexuales
```

**Respuesta**: Necesitas verificar el log de PLINK. Ejemplo de cálculo:

- Si chilean_all48_hg19_6 tenía 557,922 SNPs
- Y chilean_all48_hg19_7 tiene 557,000 SNPs
- Entonces: 557,922 - 557,000 = **922 SNPs en cromosomas sexuales**

**3. ¿Cómo calcularía el número de cromosomas que porta cada uno de los alelos para cada SNP?**

**Respuesta**:

El archivo `MAF_check.frq` contiene la columna `NCHROBS` que indica el número de cromosomas observados para cada SNP.

Para calcular el número de cromosomas que porta cada alelo:

- **Alelo menor**: `NCHROBS × MAF`
- **Alelo mayor**: `NCHROBS × (1 - MAF)`

Ejemplo del tutorial:

```
SNP rs4951929: MAF=0.08889, NCHROBS=90
- Alelo menor (A1): 90 × 0.08889 = 8 cromosomas
- Alelo mayor (A2): 90 × 0.91111 = 82 cromosomas
```

También puedes calcularlo desde el número de individuos:

- Si N individuos están genotipificados, NCHROBS = 2N (asumiendo datos diploides completos)
- Con 45 individuos: 2 × 45 = 90 cromosomas posibles

---

### Paso 4 - Tarea: HWE

**1. ¿Cuál es el nombre del archivo con los resultados de la prueba de HWE?**

**Respuesta**: `plink.hwe`

Este archivo contiene columnas como:

- CHR: cromosoma
- SNP: identificador del SNP
- TEST: tipo de test
- A1: alelo 1
- A2: alelo 2
- GENO: conteos genotípicos (observados/esperados)
- O(HET): heterocigotos observados
- E(HET): heterocigotos esperados
- P: valor p del test

**2. ¿Basándose en la distribución de los valores de p, le parece el umbral usado razonable o propondría otro valor?**

**Respuesta sugerida**:

El umbral de p < 1×10⁻⁶ (0.000001) es **razonable y estándar** en estudios genómicos por las siguientes razones:

**A favor del umbral usado**:

- Es un umbral conservador que solo elimina SNPs con desviaciones extremas de HWE
- Considera el problema de tests múltiples: con cientos de miles de SNPs, algunos mostrarán p-valores bajos por azar
- Los histogramas deberían mostrar una distribución uniforme de p-valores para la mayoría de SNPs, con solo una pequeña cola de valores extremos

**Consideraciones**:

- Si la población es mestiza o hay subestructura poblacional, cierta desviación de HWE es esperada y un umbral muy estricto podría ser contraproducente
- Para este estudio de estructura poblacional (no GWAS), podría considerarse un umbral menos estricto (p < 1×10⁻⁴) dado que:
  - Población chilena es mestiza
  - No estamos buscando asociaciones fenotípicas donde errores de genotipificación son más críticos

**Propuesta alternativa**: Mantener el umbral de 1×10⁻⁶ pero verificar visualmente los SNPs eliminados para asegurar que no se estén perdiendo variantes informativas sobre ancestría.

---

### Paso 5 - Tarea: Parentesco

**1. ¿Cuántos SNPs en aparente equilibrio de ligamiento se encontraron?**

**Respuesta**: Revisar el archivo `indepSNP.prune.in`

Comando para contar:

```bash
wc -l indepSNP.prune.in
```

**Respuesta esperada**: Aproximadamente 100,000-150,000 SNPs suelen quedar tras el pruning con parámetros `--indep-pairwise 50 5 0.2`, dependiendo del conjunto inicial.

**2. ¿Cuántos SNPs se eliminaron por estar en regiones de inversiones conocidas?**

Para calcularlo:

```bash
wc -l $T/inversion.txt
```

**Respuesta esperada**: Las inversiones comunes incluyen regiones en cromosomas 8, 17, etc. Probablemente cientos o pocos miles de SNPs.

**3. ¿Cuántos individuos quedaron luego del filtro de parentesco?**

Según el tutorial:

- Se comenzó con 48 individuos
- Se eliminaron por missingness y discrepancia de sexo: algunos individuos
- Se eliminaron por parentesco: ARI001, ARI021, ARI018 (3 individuos)

Del comando final:

```bash
plink -bfile chilean_all48_hg19_9 -remove to_romeve_by_relatedness.txt -make-bed --out chilean_all48_hg19_10
```

**Respuesta**: Aproximadamente **42-45 individuos**, dependiendo de cuántos se eliminaron en pasos anteriores. El log de PLINK indicará exactamente: "X people pass filters and QC."

**4. ¿Cuál fue el mayor coeficiente de parentesco efectivamente aceptado?**

Según el análisis en R mostrado en el tutorial:

```R
subset(rel, !IID1 %in% "ARI001" & !IID2 %in% "ARI001")
```

Los pares restantes tras eliminar individuos problemáticos son:

- ARI021-ARI018: PI_HAT = 0.2307
- ARI021-ARI015: PI_HAT = 0.2115
- ARI021-ARI019: PI_HAT = 0.2165
- ARI018-ARI014: PI_HAT = 0.2845
- ARI008-ARI019: PI_HAT = 0.2005

**Respuesta**: El mayor coeficiente de parentesco aceptado fue **PI_HAT = 0.2005** (entre ARI008 y ARI019), que está apenas por encima del umbral de 0.2 pero fue considerado aceptable dado que:

- Está muy cercano al límite
- Los coeficientes pueden estar sobreestimados en poblaciones mestizas
- Eliminar más individuos reduciría excesivamente el tamaño muestral

---

## Parte 2: Unir datos locales con 1000G

### Paso 1 - Observaciones

**Preguntas implícitas del proceso**:

**1. ¿Cuántos SNPs quedaron tras extraer solo los comunes?**

Revisar el output de:

```bash
wc -l common_snps.txt
```

**2. ¿Por qué es importante homologar la versión del genoma?**

**Respuesta**: Las coordenadas físicas de los SNPs (posición en pares de bases) cambian entre versiones del genoma de referencia (hg18, hg19/GRCh37, hg38/GRCh38). Si los datasets usan versiones diferentes:

- Los SNPs no se alinearán correctamente
- El merge fallará o producirá resultados incorrectos
- Las coordenadas no serán comparables

---

## Parte 3: Análisis de Estructura Poblacional

### Paso 3 - Tarea: Gráficos MDS

**1. En R, genere gráficos similares para las combinaciones Component 2 vs 3 y 3 vs 4. ¿Qué puede concluir de estos gráficos?**

**Script de R sugerido**:

```R
# Leer datos
MDS <- read.table("MDS_merge2.mds", header=T)
ethnicity <- read.table("ethnicityfile.txt", header=T)

# Merge de datos
merged_data <- merge(MDS, ethnicity, by.x=c("IID"), by.y=c("IID"))

# Definir colores para cada población
colors <- c("AFR"="brown", "EUR"="blue", "ASN"="green", 
            "AMR"="orange", "AYM"="red", "MAP"="purple")

# Gráfico C2 vs C3
pdf("MDS_C2_vs_C3.pdf")
plot(merged_data$C2, merged_data$C3,
     col=colors[merged_data$ethnicity],
     pch=19,
     xlab="Component 2",
     ylab="Component 3",
     main="MDS: Component 2 vs Component 3")
legend("topright", 
       legend=names(colors),
       col=colors,
       pch=19,
       cex=0.8)
dev.off()

# Gráfico C3 vs C4
pdf("MDS_C3_vs_C4.pdf")
plot(merged_data$C3, merged_data$C4,
     col=colors[merged_data$ethnicity],
     pch=19,
     xlab="Component 3",
     ylab="Component 4",
     main="MDS: Component 3 vs Component 4")
legend("topright",
       legend=names(colors),
       col=colors,
       pch=19,
       cex=0.8)
dev.off()
```

**Conclusiones esperadas**:

**Component 2 vs 3**:

- Puede revelar diferencias dentro de grupos continentales (ej: subpoblaciones africanas, europeas o asiáticas)
- Las muestras chilenas (AYM y MAP) podrían mostrar posición intermedia o específica dependiendo de su composición ancestral
- Menor varianza explicada que C1 vs C2, pero aún informativa

**Component 3 vs 4**:

- Captura variación genética más sutil
- Puede separar subpoblaciones específicas
- La estructura se vuelve menos clara, pero puede identificar:
  - Diferencias dentro de amerindios
  - Variación específica de poblaciones pequeñas
  - Efectos de deriva genética

**Interpretación general**:

- Los primeros componentes (C1, C2) capturan estructura continental mayor
- Componentes posteriores capturan estructura más fina (sub-poblacional)
- Para muestras chilenas mestizas, esperamos posición intermedia entre EUR, AFR y poblaciones nativas (AMR)

---

### Paso 4 - Tarea: Análisis ADMIXTURE

**1. ¿Cuántos SNPs quedaron luego del filtro?**

Revisar el log del comando:

```bash
plink --bfile MDS_merge --extract indepSNP.prune.in --make-bed --out MDS_merge_r2_lt_0.2
```

Buscar: "X variants and Y people pass filters"

**Respuesta esperada**: Aproximadamente 100,000-150,000 SNPs (los mismos del archivo indepSNP.prune.in que se usaron para el análisis de parentesco).

**2. ADMIXTURE asume que los individuos no están emparentados. Sin embargo, no realizamos ningún filtro. ¿Por qué?**

**Respuesta**:

**Ya se realizó el filtro de parentesco en el Paso 5 de la Parte 1**, donde:

- Se identificaron pares de individuos con PI_HAT ≥ 0.2
- Se eliminaron 3 individuos (ARI001, ARI021, ARI018)
- El dataset `chilean_all48_hg19_10` ya contiene solo individuos no emparentados

**Flujo de análisis**:

1. Paso 5 Parte 1: Se creó `chilean_all48_hg19_10` (sin individuos emparentados)
2. Este dataset se usó para el merge con 1000G
3. El dataset final `MDS_merge` ya incluye el filtro de parentesco de las muestras chilenas
4. Los datos de 1000G ya venían pre-procesados y filtrados por parentesco

**Por lo tanto**: No fue necesario realizar un nuevo filtro de parentesco porque los datos ya estaban limpios en ese aspecto.

**Nota adicional**: ADMIXTURE es sensible a parentesco porque:

- Viola el supuesto de independencia entre individuos
- Puede inflar artificialmente ciertas componentes ancestrales
- Reduce la efectividad del tamaño muestral
- Por eso fue crítico filtrar en el Paso 5

---

### Paso 5 - Interpretación de Resultados ADMIXTURE

**Preguntas de reflexión (no explícitas pero útiles)**:

**1. ¿Cuál es el valor de K óptimo según validación cruzada?**

Revisar los archivos de log:

```bash
grep CV MDS_merge_r2_lt_0.2.K*.log
```

El K con menor CV error es el más apropiado para los datos.

**2. ¿Qué revela el gráfico de ADMIXTURE sobre las muestras chilenas?**

**Interpretación esperada**:

Para **K=3** (probablemente AFR, EUR, ASN/Nativo):

- MAP (Mapuches): Alta proporción de componente nativa americana
- AYM (Aymaras): Similar o mayor componente nativa que MAP
- Ambas poblaciones pueden mostrar algo de mezcla europea

Para **K=4-6**:

- Separación más fina de componentes
- Posible diferenciación entre poblaciones nativas
- Evidencia de mezcla tri-híbrida (EUR, AFR, Nativa) en algunas muestras

**Comparación con poblaciones de referencia**:

- AMR (mexicanos, puertorriqueños) mostrarán patrones similares a chilenos pero con diferentes proporciones
- Muestras chilenas deberían agruparse cerca de AMR pero con características distintivas

---

## Resumen de Archivos a Generar/Revisar

### Para entregar como tareas:

1. **Documento con respuestas** (este archivo)
2. **Scripts de R** para gráficos MDS adicionales
3. **Tablas resumen** con:
   - Número de SNPs/individuos en cada paso de filtrado
   - Coeficientes de parentesco identificados
   - CV errors de ADMIXTURE
4. **Gráficos generados**:
   - MDS C2 vs C3
   - MDS C3 vs C4
   - (Los demás ya se generaron en el tutorial)

---

## Notas Metodológicas Importantes

### Sobre el Control de Calidad:

- Los filtros son secuenciales y el orden importa
- Filtros menos estrictos primero (0.2) para eliminar lo más problemático
- Filtros estrictos después (0.02) sobre datos ya mejorados

### Sobre Estructura Poblacional:

- MDS y ADMIXTURE son complementarios
- MDS: muestra relaciones genéticas en espacio continuo
- ADMIXTURE: modela proporción de ancestría de poblaciones discretas

### Sobre Poblaciones Chilenas:

- MAP (Mapuche): Mayor grupo indígena de Chile, principalmente en sur
- AYM (Aymara): Grupo andino del norte de Chile
- Ambos esperamos tengan alta ancestría nativa americana pero con posible mezcla europea por historia colonial
