---
Título: "Reporte de Expresión Diferencial: Comparación de Tejidos"
Autor: "J. Torres"
Fecha: "16 de Diciembre, 2025"
---

# Introducción

El objetivo de este análisis es identificar genes diferencialmente expresados (DE) entre muestras de tejido cardíaco (**Heart**) y muscular (**Muscle**) utilizando el paquete `edgeR` en R. Se utilizó un pipeline estándar de filtrado, normalización TMM y pruebas estadísticas exactas sobre datos de *Illumina Mouse Ref-8*.

El diseño experimental comparó 4 réplicas biológicas de tejido muscular (referencia) contra 4 réplicas de tejido cardíaco.

# 1. Análisis Multidimensional (MDS)

Para evaluar la similitud entre las muestras y validar la consistencia biológica, se generó un gráfico MDS.

![MDS](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/b9f2f4607095c704dc19cf00480059540f07d22e/Unidad%204/Sesion%201/MDS_Final_Corregido.png)

**Interpretación:**
Se observa una separación clara entre los dos grupos experimentales en la primera dimensión. Las muestras de Corazón (Heart) se agrupan distintivamente separadas de las muestras de Músculo (Muscle), lo que indica que las diferencias biológicas entre tejidos son mayores que la variabilidad técnica intra-grupo.

# 2. Resultados de Expresión Diferencial (Heart vs Muscle)

Se utilizó el `exactTest` para comparar los grupos, estableciendo "Muscle" como referencia. Se consideraron significativos los genes con un **FDR < 0.05**.

| Categoría                      | Cantidad de Genes | Interpretación                             |
|:------------------------------ |:----------------- |:------------------------------------------ |
| **Up-regulated** (LogFC > 0)   | **741**           | Genes más expresados en Corazón            |
| **Down-regulated** (LogFC < 0) | **731**           | Genes más expresados en Músculo            |
| **Total DE**                   | **1472**          | Total de genes diferencialmente expresados |

### Genes más significativos

A continuación se muestran los genes con mayor significancia estadística (menor FDR) encontrados en el análisis:

| ID Sonda (Illumina) | LogFC | FDR      | Regulación     |
|:------------------- |:----- |:-------- |:-------------- |
| ILMN_2768252        | 3.45  | 2.22e-41 | UP (Corazón)   |
| ILMN_2610744        | 3.20  | 9.01e-43 | UP (Corazón)   |
| ILMN_2691157        | -2.45 | 5.22e-43 | DOWN (Músculo) |
| ILMN_2766727        | -2.24 | 7.85e-35 | DOWN (Músculo) |

# 3. Visualización de Resultados

### Volcano Plot

El siguiente gráfico muestra la distribución global de los cambios de expresión. Los puntos rojos indican genes que cumplen el criterio de significancia estadística.

![volcano](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/b9f2f4607095c704dc19cf00480059540f07d22e/Unidad%204/Sesion%201/Volcano_Final_Corregido.png)

### Heatmap (Top 50 Genes)

Se realizó un agrupamiento jerárquico de los 50 genes más variables para visualizar los patrones de expresión entre las réplicas.

![heatmap](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/b9f2f4607095c704dc19cf00480059540f07d22e/Unidad%204/Sesion%201/Heatmap_Final_Corregido.png)

# Conclusión

El análisis de expresión diferencial reveló un perfil transcripcional distintivo entre el tejido cardíaco y el muscular. Se identificaron un total de **1472 genes** con diferencias significativas de expresión.

La presencia de una cantidad equilibrada de genes sobre-expresados (741) y sub-expresados (731) sugiere que, aunque ambos son tejidos contráctiles estriados, poseen programas genéticos especializados y bien definidos que los diferencian funcionalmente.
