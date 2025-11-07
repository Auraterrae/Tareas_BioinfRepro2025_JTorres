
#### Load packages:
library(admixtools)
library(tidyverse)

#### Definir poblaciones
target3 <- c("Pima.DG","Karitiana.DG","Surui.DG","PEL.DG","Mixe.DG")
source3 <- c("USA_Anzick_realigned.SG","USA_Ancient_Beringian.SG","USA_Nevada_SpiritCave_11000BP.SG")
outgroup3 <- c("Mbuti.DG", "CHB.DG", "Papuan.DG", "Russia_UstIshim_IUP.DG", "Denisova.DG")

# Añadimos la población extra del test qpWave
all_pops <- c(target3, source3, outgroup3, "India_GreatAndaman_100BP.SG")
prefix <- "C:/Users/Public/bioinfo1/popgen_shared/v62.0_1240k_public" 
outdir <- "aadr_1000G_f2_proyect3"

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

f3_results <- f3(f2_blocks, pop1="Mbuti.DG", pop2=target3, pop3=source3)

print(f3_results)

# Las poblaciones americanas  modernas comparten deriva genética de las poblaciones fuente

#### f4 tests: Chequeos de asimetría
# ¿Están los targets más cerca de Anzick o de Ancient Beringian?

f4_results <- f4(f2_blocks, 
                 pop1 = target3, 
                 pop2 = "USA_Anzick_realigned.SG",
                 pop3 = "USA_Ancient_Beringian.SG",
                 pop4 = "Mbuti.DG")

print(f4_results)

#  Ninguna de las poblaciones presenta resutados significativos a excepción de PEL.DG , con una afinidad mayor a Anzik

#### qpWave: testear el rango
# Bucle para el test principal (target + todas las sources)

wave_results_1 <- lapply(target3, function(targ) {
  print(paste("Corriendo qpWave 1 para:", targ))
  qpwave(f2_blocks,
         left = c(targ, source3),
         right = outgroup3)
})
names(wave_results_1) <- target3

print(wave_results_1)

# Con el modelo de 3 fuentes tenemos significancia estadistica para todos los target

# Test específico de Karitiana (¿señal "Population Y"?)

wave_results_2 <- qpwave(f2_blocks,
                         left = c("Karitiana.DG","USA_Ancient_Beringian.SG","India_GreatAndaman_100BP.SG"),
                         right = outgroup3)

print(wave_results_2)

#Con este test comprobamos si katiriana se explica con las otras dos poblaciones o si necesita una tercera corriente de ancestría, este ultimo escenario parece ser el significativo apoyando la hipótesis de la poblacion Y

#### qpAdm: modelos de mezcla
# Modelo de 2 vías (Anzick + Beringian)

admix_2way <- lapply(target3, function(targ) {
  print(paste("Corriendo qpAdm 2-vías para:", targ))
  qpadm(f2_blocks, 
        left = c(targ, source3[1:2]), # source3[1:2] = Anzick y Beringian
        right = outgroup3, 
        target = targ)
})
names(admix_2way) <- target3

print(admix_2way)

#Aunque tenemos un p value significativo, las proporciones que se entregan son imposibles, pasamos al de 3 vias

# Modelo de 3 vías (Anzick + Beringian + SpiritCave)

admix_3way <- lapply(target3, function(targ) {
  print(paste("Corriendo qpAdm 3-vías para:", targ))
  qpadm(f2_blocks, 
        left = c(targ, source3), 
        right = outgroup3, 
        target = targ)
})
names(admix_3way) <- target3

print(admix_3way)

# Aunque este modelo tambien falle en explicar la ancestría, lo más probable es que estas 3 poblaciones sean demasiado cercanas entre si y no que no exista deriva genetica entre ellas 
