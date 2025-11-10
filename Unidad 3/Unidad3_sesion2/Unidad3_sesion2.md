# cBioPortal para analizar datos genómicos de cáncer

## Autor: Karen Oróstica, PhD / Estudiante: Javier Torres

## # 🧬 Tarea: Exploración e interpretación de datos genómicos en cBioPortal

### 29 de octubre

## 🎯 Objetivo

Explorar un estudio real disponible en [cBioPortal](https://www.cbioportal.org) para:

1. Analizar alteraciones genéticas en un tipo de cáncer específico,  
2. Filtrar pacientes con una mutación relevante, y  
3. Interpretar la información clínica y genómica obtenida.

---

## 🧩 Parte 1: Selección del estudio (15 min)

1. Ingresa a [https://www.cbioportal.org](https://www.cbioportal.org).  
2. Explora el listado de estudios y selecciona **un tipo de cáncer sólido** (por ejemplo: *Lung adenocarcinoma*, *Pancreatic cancer*, *Breast cancer*, *Colorectal cancer*).  
3. El estudio elegido debe tener **al menos 100 pacientes** y **datos genómicos y clínicos disponibles**.

**Completa la siguiente información:**

- **Nombre del estudio:**  
  
  >  _Testicular Germ Cell Cancer (TCGA, Firehose Legacy)_

- **Número total de pacientes:**  
  
  > 150 pacientes

- **Institución responsable:**  
  
  > Firehose Legacy

![aaa](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/fed9570216b4087ba9e61790207e68274d53d5a5/Unidad%203/Unidad3_sesion2/pesta%C3%B1a_summary.png)

---

## 🧬 Parte 2: Análisis genómico (25 min)

1. Ve a la pestaña **Summary** del estudio.  
2. Localiza la tabla **“Mutated Genes”**.  
3. Identifica los **5 genes con mayor frecuencia de mutación**.

| #   | Gen    | N° de mutaciones | N° de pacientes | Frecuencia (%) |
| --- | ------ | ---------------- | --------------- | -------------- |
| 1   | MUC2   | 34               | 31              | 20             |
| 2   | KIT    | 29               | 28              | 18.1           |
| 3   | TVP23C | 27               | 27              | 17.4           |
| 4   | MUC4   | 31               | 24              | 15.5           |
| 5   | FRG1BP | 23               | 23              | 14.8           |

4. Selecciona **uno de esos genes** **TVP23C** y filtra las muestras (→ **Select Samples**).  
   Observa cómo cambian los gráficos del resumen.

**Responde:**

- ¿Cuántos pacientes presentan esa mutación?  
  
  > 27 pacientes

- ¿Qué tipo de mutación es más frecuente (missense, nonsense, frameshift)?  
  
  > missense

- ¿Qué vías de señalización aparecen alteradas en la pestaña *Pathways*?  
  
  > HIPPO, WNT, TP53, entre otras

---

## 👩‍⚕️ Parte 3: Análisis clínico (15 min)

1. Entra en la pestaña **Clinical Data**.  

2. Examina las variables demográficas:
   
   - Distribución por sexo  
   - Distribución por edad  
   - Distribución por raza (si está disponible)

3. Calcula:
   
   - **Rango de edad (edad máxima − edad mínima):**  
     
     > 21-66 años
   
   - **Mediana de edad (usando “Compare Groups → Median”):**  
     
     > 31 - 32 años

![a](https://github.com/Auraterrae/Tareas_BioinfRepro2025_JTorres/blob/fed9570216b4087ba9e61790207e68274d53d5a5/Unidad%203/Unidad3_sesion2/pesta%C3%B1a_clinical.png)

4. **Interpreta los resultados:**
   
   - ¿Existe una predominancia por sexo o edad?  
     
     > existe una predominancia de pacientes menores a 40 años 
   
   - ¿Qué implicancias podría tener esa distribución para el estudio del cáncer elegido?  
     
     > que la mutación del gen TVP23C es más frecuente en pacientes menores de 40 años

---

## 🧠 Parte 4: Análisis interpretativo (10 min)

Redacta un breve comentario (5–10 líneas) respondiendo:

> ¿Qué relación observas entre las mutaciones más frecuentes y las características clínicas del grupo?  
> ¿Por qué podría ser relevante este gen como biomarcador o diana terapéutica?

_Respuesta:_

```
En casi el 41% de los pacientes con las 6 mutaciones más frecuentes
presentan etapa linfática T1, considerando tambien que la media de paci-
entes es relativamente baja (31-32 años en el caso de TVP23C) puede
llegar a ser un marcador interesante para una diana terapética ya que
además presentó una frecuencia del 26.2%, en comparación con la mutación
Más frecuente MUC4 con 30.1%, probabilidades tan cercanas entre las
mutaciones de 150 pacientes hace que cualquiera de las 6 mutaciones más
frecuentes sean una opción considerable  
```
