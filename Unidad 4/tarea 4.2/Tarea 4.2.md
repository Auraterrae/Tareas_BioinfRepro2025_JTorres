# Reporte Final: Análisis de Clustering Jerárquico

**Asignatura:** Bioinformática  
**Muestras analizadas:** Corazón (Heart) vs Músculo (Muscle)

## 1. Selección de k (Método del Codo)

Se generaron gráficos de Suma de Cuadrados (WSS) para determinar el número óptimo de grupos.

![Gráfico WSS Muestras y Sondas](C:/Users/torre/OneDrive/Escritorio/tarea 4.2/WSS.png)

* [cite_start]**Muestras:** El gráfico muestra una caída drástica en $k=2$ lo que justifica la partición en dos grandes grupos[cite: 5].
* [cite_start]**Sondas:** Para los genes, el codo se estabiliza cerca de $k=4$, sugiriendo distintos módulos de co-expresión[cite: 6].

## 2. Clustering de Muestras (Euclidiana)

[cite_start]Se utilizó la distancia euclidiana sobre los genes diferencialmente expresados[cite: 56].

![Dendrograma de Muestras](C:/Users/torre/OneDrive/Escritorio/tarea 4.2/clustering muestras.png)

**Análisis:**
Las muestras se agrupan principalmente por su estado de preparación (Normal vs Diluida). [cite_start]Este "efecto de lote" domina la señal, agrupando muestras de distintos tejidos según si fueron diluidas o no[cite: 49, 50].

Se aplicó un corte de $k=2$ (ver recuadros rojos en la imagen).

## 3. Clustering de Sondas (Pearson)

[cite_start]Para los genes, se utilizó el complemento de la correlación de Pearson para agrupar por perfiles de expresión[cite: 53].

![Dendrograma de Sondas](C:/Users/torre/OneDrive/Escritorio/tarea 4.2/cñustering sondas.png)

**Análisis:**
El árbol de genes muestra varios bloques de co-regulación. [cite_start]Se identificaron 4 clústeres principales (recuadro azul) que representan genes que suben o bajan de manera coordinada entre las muestras cardíacas y musculares[cite: 66, 67].

## Conclusión

[cite_start]El análisis de clustering confirma que los datos poseen una estructura técnica fuerte (dilución), pero el uso de métricas como Pearson en los genes permite identificar patrones biológicos coherentes[cite: 69].
