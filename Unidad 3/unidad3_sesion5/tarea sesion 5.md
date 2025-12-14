# Informe Trabajo Práctico: Análisis Germinal y Somático con nf-core/sarek

**Nombre del Estudiante:** [Javier Torres]
**Fecha:** [13/12/2025]

## 1. Introducción

En este trabajo práctico se aplicó el pipeline bioinformático **nf-core/sarek** para el análisis de variantes genómicas. El objetivo principal fue identificar y comparar variantes constitucionales (germinales) y variantes adquiridas (somáticas) utilizando datos de secuenciación. Posteriormente, se realizó una anotación biológica utilizando bases de datos como **OncoKB** y **gnomAD** para interpretar la relevancia clínica de los hallazgos.

## 2. Metodología

El análisis se llevó a cabo en el clúster de cómputo [Bioinfo1], utilizando el gestor de flujos de trabajo **Nextflow** y el pipeline **sarek**.

### Estructura de trabajo

Se creó un directorio de trabajo llamado `pipeline_sarek` con los subdirectorios `data`, `code` y `results`.

### Comandos utilizados

Para la ejecución, se utilizaron scripts en Bash que envuelven la ejecución de Nextflow. Los comandos se ejecutaron desde el directorio `pipeline_sarek/code`.

**1. Análisis Germinal (HaplotypeCaller):**
Se utilizó el script `sarek_germinal.sh`.

```bash
./sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S13_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S13_R2.fastq.gz ../results 
```

**2. Análisis Somático (Mutect2):**
Se utilizó el script `sarek_somatic.sh`

```bash
./sarek_somatic.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S13_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S13_R2.fastq.gz ../results 
```

Se utilizó un archivo de configuración personalizado (local_sarek_8cpus.config) para limitar el uso de recursos y evitar errores de memoria en el entorno compartido:

Max CPUs: 2

Max Memory: 4 GB

Executor: Local (Singularity)

## **3. Reporte de errores**

a continuaciónse describe por qué no se pudo completar el pipeline exitosamente

**3.1 Conflicto de Archivos (FileAlreadyExistsException)**

**Descripción:** El gestor de flujo de trabajo (Nextflow) falló al intentar sobrescribir los archivos de reporte de ejecución previos. **Evidencia (Log):**

```
Caused by: java.nio.file.FileAlreadyExistsException: ../results/pipeline_info/execution_report_...html
...
nextflow.exception.AbortOperationException: Timeline file already exists
```

**Análisis:** La configuración predeterminada del pipeline (`nextflow.config`) no tenía habilitada la directiva `overwrite = true` para los informes de trazabilidad (Timeline y Report). Al intentar reanudar (`-resume`) o ejecutar una nueva instancia sobre el mismo directorio de salida, el sistema bloqueó la escritura para evitar la pérdida accidental de registros previos.



**3.2 Ejecución inconmpleta del pipeline**

Por el error mencionado en el primer punto, el pipeline solamente generó los reportes de calidad Fastqc de las lecturas forward y reverse, para luego ser interrumpido por el error mencionado anteriormtente, los reportes HTML serán incluidos en el repositorio como prueba del desarrollo. Sin embargo, no se halló una manera de ejecutar el llamado de variantes de manera exitosa
