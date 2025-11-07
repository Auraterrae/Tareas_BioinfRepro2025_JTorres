##️ Proyecto 2: Modelo de formación de la Estepa

### Script `project2_completo.R`

# Project 2: Steppe formation model

#### Load packages:
library(admixtools)
library(tidyverse)

#### Definir poblaciones
target2 <- c("Russia_MLBA_Sintashta.AG", "Kazakhstan_Maitan_MLBA_Alakul.AG", "Russia_LBA_Srubnaya_Alakul.SG")
source2 <- c("Iran_GanjDareh_N.AG", "Russia_Sidelkino_HG.SG")
outgroup2 <- c("Mbuti.DG", "CHB.DG", "Papuan.DG", "Russia_UstIshim_IUP.DG", "Denisova.DG")

setwd("C:/Users/Public/bioinfo1")

all_pops <- c(target2, source2, outgroup2)
prefix <- "C:/Users/Public/bioinfo1/popgen_shared/v62.0_1240k_public" # Asegúrate que la ruta al prefijo sea correcta
outdir <- "aadr_1000G_f2_proyect2"

#### Get f2_blocks. (Ejecutar solo una vez)
extract_f2(pref = prefix,
            outdir = outdir,
            pops = all_pops,
            overwrite = TRUE,
            blgsize = 0.05,
            verbose = TRUE)

#### Load f2_blocks
f2_blocks <- f2_from_precomp(outdir)


#### Outgroup-f3: shared drift

f3_results <- f3(f2_blocks, pop1="Mbuti.DG", pop2=target2, pop3=source2)

print(f3_results)

## El modelo confirmaque que las poblaciones de la edad de bronce estan relacionadas con las de estepa con números muy significativos, aunque sidelkino tiene valores mas altos que iran

#### f4 tests: Chequeos de asimetría
# ¿Están los targets más cerca de Irán_N o de Sidelkino_HG?

f4_results <- f4(f2_blocks, 
                 pop1 = target2, 
                 pop2 = "Iran_GanjDareh_N.AG",
                 pop3 = "Russia_Sidelkino_HG.SG",
                 pop4 = "Mbuti.DG")

print(f4_results)

# las tres poblaciones están mas relacionadas con los cazadores recolectores de sidelkino que los agricultores de iran 

#### qpWave: testear el rango
# Usamos lapply para correr qpWave por cada población en target2

wave_results <- lapply(target2, function(targ) {
  print(paste("Corriendo qpWave para:", targ))
  qpwave(f2_blocks,
         left = c(targ, source2),
         right = outgroup2)
})
names(wave_results) <- target2

print(wave_results)

# los tres modelos de dos vias son estadisticamente significativos para explicar los datos, procedemos a qpadm

#### qpAdm: modelos de mezcla de 2 vías
# Usamos lapply para correr qpadm por cada población en target2

admix_2way <- lapply(target2, function(targ) {
  print(paste("Corriendo qpAdm 2-vías para:", targ))
  qpadm(f2_blocks, 
        left = c(targ, source2), 
        right = outgroup2, 
        target = targ)
})
names(admix_2way) <- target2

print(admix_2way)

# los resultados permiten concluir que las poblaciones de la edad de bronce se han formado de una combinación entre los agricultores de iran y los cazadores recolectores del este, tienendo estos últimos un mayor aporte genético en general