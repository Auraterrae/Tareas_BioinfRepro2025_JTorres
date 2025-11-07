# Project 1: Do all present-day populations from Europe display the same 3-way admixture?

#### Load packages:
library(admixtools)
library(tidyverse)

#### Definir poblaciones
# He añadido más poblaciones europeas a 'target1' como sugería el comentario
target1 <- c("GBR.DG", "IBS.DG", "TSI.DG", "French.DG", "Basque.DG", "Italian_North.DG", "FIN.DG")
source1 <- c("Turkey_Marmara_Barcin_N.AG", "Russia_Samara_EBA_Yamnaya.AG", "Luxembourg_Mesolithic.DG")
outgroup1 <- c("Mbuti.DG", "CHB.DG", "Papuan.DG", "Russia_UstIshim_IUP.DG", "Denisova.DG")
setwd("C:/Users/torre/OneDrive/Escritorio/daos bioinfo/popgen_shared")
all_pops <- c(target1, source1, outgroup1)
prefix <- "v62.0_1240k_public" # Asegúrate que la ruta al prefijo sea correcta
outdir <- "aadr_1000G_f2_proyect1"

#### Get f2_blocks. (Ejecutar solo una vez)
 extract_f2(pref = prefix,
            outdir = outdir,
            pops = all_pops,
            overwrite = TRUE,
            blgsize = 0.05,
            verbose = TRUE)

#### Load f2_blocks
f2_blocks <- f2_from_precomp(outdir)

#### Outgroup-f3: shared drift entre target y sources
# pop1=outgroup; pop2=target; pop3=sources

f3_results <- f3(f2_blocks, pop1="Mbuti.DG", pop2=target1, pop3=source1)
print(f3_results)

## Todas las poblaciones objetivo muestran valores f3 positivos y estadisticamente
## significativos con las tres poblaciones fuente, confirmando que han contribuido 
## genéticamente a las poblaciones modernas 


#### f4 tests: Chequeos de asimetría
# ¿Están las poblaciones objetivo más cerca de alguna de las fuentes potenciales?

f4_results <- f4(f2_blocks, 
                 pop1 = target1, 
                 pop2 = "Turkey_Marmara_Barcin_N.AG",  # Anatolia EEF
                 pop3 = "Luxembourg_Mesolithic.DG",    # WHG
                 pop4 = "Mbuti.DG")                   # Outgroup

print(f4_results)

## Según los valores Z y est positivos en todas las poblaciones objetivos podemos
## concluir que las poblaciones europeas modernas están más relacionadas con los 
## cazadores recolectores occidentales que con Anatolia EEF

f4_results_2 <- f4(f2_blocks, 
                   pop1 = target1, 
                   pop2 = "Turkey_Marmara_Barcin_N.AG", # Anatolia EEF
                   pop3 = "Russia_Samara_EBA_Yamnaya.AG", # Steppe
                   pop4 = "Mbuti.DG")
## Resultados f4 Target vs Anatolia/Steppe
print(f4_results_2)

## Todas las poblaciones objetivos muestran valores est y Z score positivos
## por lo que las poblaciones europeas modernas estan mas relacionadas a Steppe que Anatolia

#### qpWave: testear el rango (cuántas fuentes de ancestría se necesitan)
# Usamos lapply para correr qpWave por cada población en target1

wave_results <- lapply(target1, function(targ) {
  print(paste("Corriendo qpWave para:", targ))
  qpwave(f2_blocks,
         left = c(targ, source1),
         right = outgroup1)
})
names(wave_results) <- target1

print(wave_results)

## El F4rank 2 funciona con p values altos mientras que rank 1 y 0 fallan en terminos de p-value, por lo que el modelos de 3 vias es suficiente para explicar la ancestría de las poblaciones objetivo con estas fuentes

#### qpAdm: modelos de mezcla de 2 y 3 vías
# Usamos lapply para correr qpadm por cada población en target1

# Modelo de 2 vías (Ej: EEF + WHG)
print("Ejecutando qpAdm 2-vías (EEF + WHG)...")
admix_2way_A <- lapply(target1, function(targ) {
  print(paste("Corriendo qpAdm 2-vías A para:", targ))
  qpadm(f2_blocks, 
        left = c(targ, "Turkey_Marmara_Barcin_N.AG", "Luxembourg_Mesolithic.DG"), 
        right = outgroup1, 
        target = targ)
})
names(admix_2way_A) <- target1
print(admix_2way_A)

# Modelo de 2 vías (Ej: EEF + Steppe)
print("Ejecutando qpAdm 2-vías (EEF + Steppe)...")
admix_2way_B <- lapply(target1, function(targ) {
  print(paste("Corriendo qpAdm 2-vías B para:", targ))
  qpadm(f2_blocks, 
        left = c(targ, "Turkey_Marmara_Barcin_N.AG", "Russia_Samara_EBA_Yamnaya.AG"), 
        right = outgroup1, 
        target = targ)
})
names(admix_2way_B) <- target1
print(admix_2way_B)


# Modelo de 3 vías (EEF + WHG + Steppe)
print("Ejecutando qpAdm 3-vías...")
admix_3way <- lapply(target1, function(targ) {
  print(paste("Corriendo qpAdm 3-vías para:", targ))
  qpadm(f2_blocks, 
        left = c(targ, source1), 
        right = outgroup1, 
        target = targ)
})
names(admix_3way) <- target1

print(admix_3way)

## COnsideran que el modelo de 3 fuentes necesitamos singnificancia estadística y que las proporciones en weights sean positivas, en este caso la unica poblacion que cumple con estas condiciones es Basque.DG, ya que todas las demas tienes proporciones negativas indicando que estas fuentes no son las indicadas para explicar su ancestría 
