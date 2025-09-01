# Tarea 2

## En este archivo markdown se resgistra todo el desarrollo de los ejercicios propuestos en la sesion 2, unidad 1 del curso *BioinfoRepro*

#### 1. Primero que todo, creamos nuestro repositorio en github llamado ["Tareas_BioinfRepro2025_JTorres" ](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres)

#### 2. Luego, establecemos el directorio en el que queremos trabajar dentro de git bash

![a](/imagen1.png)

#### 3. Clonamos el repositorio del curso como se solicita con el siguiente prompt

```bash
git clone https://github.com/u-genoma/BioinfinvRepro.git --branch master --single branch
```

#### 4. Agregamos al profesor Ricardo como colaborador del repositorio para que pueda supervisar el trabajo

![aa](/imagen%202.png)

#### 5.  Analizamos el script de pipeline propuesto de ejemplo

```
#!/bin/bash 

src=$HOME/research/project 

files=”sample_01 
sample_02 
sample_03” 

#
# Align with GSnap and convert to BAM
# 
for file in $files
do
    gsnap -t 36 -n 1 -m 5 -i 2 --min-coverage=0.90 \
            -A sam -d gac_gen_broads1_e64 \
            -D ~/research/gsnap/gac_gen_broads1_e64 \
            $src/samples/${file}.fq > $src/aligned/${file}.sam
    samtools view -b -S -o $src/aligned/${file}.bam $src/aligned/${file}.sam 
    rm $src/aligned/${file}.sam 
done

#
# Run Stacks on the gsnap data; the i variable will be our ID for each sample we process.
# 
i=1 
for file in $files 
do 
    pstacks -p 36 -t bam -m 3 -i $i \
              -f $src/aligned/${file}.bam \
              -o $src/stacks/ 
    let "i+=1"; 
done 

# 
# Use a loop to create a list of files to supply to cstacks.
# 
samp="" 
for file in $files 
do 
    samp+="-s $src/stacks/$file "; 
done 

# 
# Build the catalog; the "&>>" will capture all output and append it to the Log file.
# 
cstacks -g -p 36 -b 1 -n 1 -o $src/stacks $samp &>> $src/stacks/Log 

for file in $files 
do 
    sstacks -g -p 36 -b 1 -c $src/stacks/batch_1 \
             -s $src/stacks/${file} \ 
             -o $src/stacks/ &>> $src/stacks/Log 
done 

#
# Calculate population statistics and export several output files.
# 
populations -t 36 -b 1 -P $src/stacks/ -M $src/popmap \
              -p 9 -f p_value -k -r 0.75 -s --structure --phylip --genepop
```

#### ¿Cuántos pasos tiene este script?

Contiene 5 pasos, cada uno de ellos separados por un # donde se explica que es lo que hace cada pipeline

#### ¿Si quisieras correr este script y que funcionara en tu propio equipo, qué línea deberías cambiar y a qué?

La variable src= $HOME/research/project es el directorio de trabajo donde se ubican todos los datos a utilizar, en caso de utilizarlo en mi equipo , este deberia ser modificado a la ruta donde se ubiquen mis archivos de manera local

#### ¿A qué equivale `$HOME`?

$HOME como se mencionó anteriormente, es el directorio de trabajo que utiliza el usuario apra trabajar

#### ¿Qué paso del análisis hace el programa `gsnap`?

Gsnap es un programa e alineamiento standard, utilizado para comparar las lecturas con un genoma de referencia 

#### ¿Qué hace en términos generales cada uno de los loops?

1. El primer loop lee los archivos .fq para alinearlos con el genoma de referencia usando gsnap, creando como resultado archivos .bam

2. El segundo loop construye loci individuales usando pstack

3. El tercer loop crea un string con cad auno de los archivos resultantes de pstacks para luego usarla en cstacks

4. El cuarto loop corre sstacks para compararla con los catálogos de ctacks para identificar loci compartidos 
