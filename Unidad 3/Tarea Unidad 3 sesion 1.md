# Tarea Unidad 3 sesion 1

### Javier Torres Jofré

1. Primero que todo, contamos los reads del archivo: `zcat ~/181004_curso_calidad_datos_NGS/fastq_raw/S13_R1.fastq.gz | grep -c "^@"` y en nuestro caso la respuesta es 30361

2. Luego, visualizamos las primeras 40 lineas del mismo:
   
   `zcat ~/181004_curso_calidad_datos_NGS/fastq_raw/S13_R1.fastq.gz | head -n 40`

3. Segun el resultado del codigo anterior, la tercera lectura es `@M03564:2:000000000-D29D3:1:1101:16753:1407 1:N:0:CAGATCCA+TAAGACAC
   CAGATAAAATTCGAGGACAGAGACGGAGCGGGGAGGAGGAAGGTGCGGGAGGGCAGGCGGTGCAAACGTAGGTAGTAGAGCTGGACTCCACAGGGCCCTCAGCTCTGCCTGGCGCAGAGCTCCTGGGCCAAGGTGCTGACTCACTAGTCCCTTGTCAGCCACTGTCACGGGTATGGGCGAGCCCGCATGTGCTGCAGGCAGCTCCGACGGGCCCGACACCTGACCCCTGACTGCAGCTACGTCTGCACTAT
   +
   AAAA?FDFFBFF1FGE11GAGGBAE0BEEEC??AAEGA/EHF?BCFE/////>/F>>AEGE@EGFHHCHGF<>FD12BFGBGBC001FHHHB0GA/CCH/01<1FFBDFF1>G-.A<-</<<CCB/...AG..C/:CFHB0FFF0BFCFGFF0/009;BFA9/9C0FGBGA9@B/9FF----9E@<?A?9BFB//9B-AFB?FFF-@==-@----;-@@FF/BBFFFF--;///////9B--;--//99//` donde los caracteres presentes después del signo + son aquellas lineas que se dan los valores del índice de calidad según las interpretaciones de la tabla phred+33

4. A continuación se presenta una tabla con las primeras 10 baes de calidad 
   
   | **Carácter** | **Valor ASCII Decimal** | **Calidad Q (ASCII - 33)** |
   | ------------ | ----------------------- | -------------------------- |
   | **B**        | 66                      | **Q33**                    |
   | **B**        | 66                      | **Q33**                    |
   | **B**        | 66                      | **Q33**                    |
   | **B**        | 66                      | **Q33**                    |
   | **B**        | 66                      | **Q33**                    |
   | **F**        | 70                      | **Q37**                    |
   | **F**        | 70                      | **Q37**                    |
   | **F**        | 70                      | **Q37**                    |
   | **F**        | 70                      | **Q37**                    |
   | **B**        | 66                      | **Q33**                    |

5. Generamos un informe de calidad para las muestras crudas y podadas
   
   crudas
   
   `fastqc ../181004_curso_calidad_datos_NGS/fastq_raw/S13_R1.fastq.gz -o .
   fastqc ../181004_curso_calidad_datos_NGS/fastq_raw/S13_R2.fastq.gz -o .`
   
   podadas
   
   `fastqc ../181004_curso_calidad_datos_NGS/fastq_filter/S13_R1_filter.fastq.gz -o .
   fastqc ../181004_curso_calidad_datos_NGS/fastq_filter/S13_R2_filter.fastq.gz -o .`
   
   Luego descargarmos los archivos de calidad ejecutando este comando en la consola local
   
   `scp [bioinfo1@genoma.med.uchile.cl](mailto:bioinfo1@genoma.med.uchile.cl):"/home/bioinfo1/jtorres/Tareas_BioinfRepro2025_JTorres/Unidad3/sesion1/S13*fastqc.html" .`
   
   Tal como podemos observar en el diagrama de calidad de R1 y R2 crudo
   
   [(imagen 1)](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/2bb79fbd8e140c476951619fe0517eb1085ec398/Unidad%203/Q_raw_S13_R1.jpg)
   
   [(imagen3)](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/5c318822ea5e6499b8753861dcb3c2cefd4f8393/Unidad%203/Q_raw_S13_R2.jpg))
   
   y filtrado
   
   [(imagen 2)](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/2bb79fbd8e140c476951619fe0517eb1085ec398/Unidad%203/Q_filter_S13_R1.jpg)
   
   [(imagen4)](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/5c318822ea5e6499b8753861dcb3c2cefd4f8393/Unidad%203/Q_filter_S13_R2.jpg)
   
   los valores del indice de calidad interpretado versus observado coinciden bastante, ademas de haber una mejora en la calidad general de las lecturas en la muestra filtrada, para este caso la figura de calidad por base es muy util ya que hace un gráfico de cajas con el promedio y la desviación estándar de los valores de calidad para cada una de las bases 
