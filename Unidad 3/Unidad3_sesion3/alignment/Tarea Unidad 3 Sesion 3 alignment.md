# Tarea Unidad 3 Sesion 3

Javier Torres

1. Realizar el alineamiento contra el genoma humano hg19 de las lecturas R1 y R2 del paciente seleccionado para la tarea de control de calidad de lecturas de secuencia.

```
se llevó a cabo el alineamiento con las muestras correspondientes,
en este caso S13
```

2. Utilizando una línea de comando, encuentre la primera lectura en el archivo SAM que contenga bases enmascaradas (secuencias suavizadas por soft-clipping)

```bash
samtools view S13_sorted_RG.bam | grep "[0-9]S" | head -n 1


M03564:2:000000000-D29D3:1:1101:3546:9628       99      chr1    43803496       60       6S160M  =       43803561        268     GTCTCCGGCAGGCACACAGTGGCGGAGAAGATGCCCTCCTGGGCCCTCTTCATGGTCACCTCCTGCCTCCTCCTGGCCCCTCAAAACCTGGCCCAAGTCAGCAGCCAAGGTGAGGTGCACAGAGGGTGGAGATCACCTATGCCCAGGAAGAGGGAGCCCTGGGAGG  AAAACFCBCCCCGEGGGGGGGGGGGGGEGFHHHHHHHGGHHHGGHGEHHHFHHHHFGHFHGHHHHGHHHHHHHGHHHHHGHGGFHHGGFHHHHHGHHGFHHHHHHHHHHGFHFHG2FFHHHHHFG<??>??FCGHHHFGHHFHHHHGAHFHFGF<EEFGFHHGGEC  MC:Z:203M      MD:Z:160 RG:Z:sample     NM:i:0  AS:i:160        XS:i:21
```

3. Muestre el registros de la lecturas en el archivo SAM e identifique y explique el código CIGAR de esa lectura.

```bash
El código CIGAR es 6S160M, significa que 6 bases en los extremos de la
secuencia no fueron alineados por soft-clipping, seguidas de 160 que
si se alinearon
```

4. Generar un reporte técnico de calidad del alineamiento con *qualimap*.

```bash
scp -r bioinfo1@genoma.med.uchile.cl:~/jtorres/Tareas_BioinfRepro2025_JTorres/Unidad3/sesion3/S13_qualimap
```

5. Seleccionar 4 figuras que a su juicio sean las más informativas sobre la calidad de los datos y del ensamble.

Figura 1. Coverage histogram: siendo el mayor valor de cobertura igual a cero, significa que hay regiones que no fueron cubiertas 







Figura 2. Insert Size Histogram: la media de longitud de las secuencias están entre 225 y 275 pares de bases, lo que indica uniformidad dentro de la librería







Figura 3. Mapping quality histogram: La mayoria de las lecturas tienen una calidad de 60, por lo que es muy poco probable que esten mal alineadas







Figura 4. GC content distribution: Existe una gran variación en la abundacia de GC significa que existe un sesgo en la amplificación 



6.  Conclusiones: Aunque se evindencia en las figuras que hay regiones que no fueron cubiertas y hay un sesgo de amplificación, se tiene un porcentaje de lecturas de un 99.9 y un promedio de la calidad de 58.8, lo que nos permite concluir que la alineación fue exitosa 


