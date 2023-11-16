library(shiny)
library(tidyverse)
library(shinydashboard)
library(shinyjs)
library(waiter)
library(herramientas)
library(plotly)
library(comunicacion)
# Procesamiento de los datos que toman los indicadores 

# Datos de CST para puestos de trabajo y PIBDT
cst_url <- "https://www.yvera.tur.ar/sinta/informe/documentos/descarga/6553c4d345bbf461829270.xlsx"

temp <- tempfile()

con <- RCurl::getBinaryURL(url = cst_url,  ssl.verifypeer = FALSE)

writeBin(con, con = temp)

cst_excel <- readxl::read_excel(temp,skip = 6)


cst <- cst_excel %>% 
  janitor::clean_names() %>% 
  rename("indicador" = indicadores_turisticos_en_percent_sobre_el_total) %>% 
  filter(indicador %in% c("Puestos de trabajo en las industrias turísticas  (en miles)","Producto bruto interno directo turístico (PBIDT)")) %>% 
  pivot_longer(cols = 2:9,names_to = "anio",values_to = "valor") %>% 
  mutate(anio = str_replace(anio,"ano_",""),
         valor = as.numeric(valor))

cst_empleo <- paste0(format(round(cst[cst$indicador == "Puestos de trabajo en las industrias turísticas  (en miles)" & cst$anio == max(cst$anio),"valor"]/1000,2),decimal.mark=",")," M")


#Datos de informalidad MOMENTÁNEAMENTE MANUALES

cst_empleo_excel <- readxl::read_excel(temp,skip = 7,sheet=3) %>% 
  janitor::clean_names() %>% 
  mutate(puestos_reg=as.numeric(asalariados_registrados),
         puestos_noreg = as.numeric(asalariados_no_registrados)) %>% 
  filter(!is.na(puestos_reg) & industrias_turisticas == "Total Industrias turísticas") %>% 
  select(industrias_turisticas,puestos_reg,puestos_noreg) %>% 
  mutate(anio = c(2004,2016:2022)) 

empleo_cat <- cst_empleo_excel  %>% 
  select(anio,puestos_reg,puestos_noreg) %>% 
  mutate(asal_total = puestos_reg+puestos_noreg,
         tasa_informal = puestos_noreg/(asal_total))

empleo_informal <- paste0(empleo_cat %>% 
  filter(anio == max(anio)) %>% 
  mutate(tasa_informal = round(tasa_informal*100,2)) %>% 
  pull(tasa_informal) %>% 
  format(decimal.mark=","),"%")

cst_pibdt <- paste0(cst %>% 
  filter(indicador == "Producto bruto interno directo turístico (PBIDT)" & valor<1) %>% 
  filter(anio == max(anio)) %>% 
  mutate(valor = round(100*valor,2)) %>% 
  pull(valor) %>% 
  format(decimal.mark=","),"%")

comptur <- read_file_srv("/srv/DataDNMYE/evyth/comportamiento_turistico/EVyTH_BASE USUARIO_COMPTUR2006-10-11a22_PERSONAS.sav") 


#Proporción de la población que al menos realizó un viaje en el año
prop_viaje <- comptur %>%
  filter(anio >= 2010) %>%
  group_by(anio, al_menos_un_viaje) %>%
  summarise(casos = sum(pondera, na.rm = T)) %>%
  ungroup() %>%
  group_by(anio) %>%
  mutate(total = sum(casos)) %>%
  ungroup() %>%
  mutate(tipo_poblacion = "Viajeros",
         participacion = casos/total) %>%
  filter(al_menos_un_viaje == 1) %>%
  select(indice_tiempo=anio, tipo_poblacion, participacion)

propension <- paste0(prop_viaje %>% 
  filter(indice_tiempo==max(indice_tiempo)) %>% 
  mutate(participacion = round(100*participacion,1)) %>% 
  pull(participacion) %>% 
  format(decimal.mark=","),"%")

##### Gini de viajes turísticos

evyth <- arrow::read_parquet("/srv/DataDNMYE/evyth/base_trabajo/evyth_base_de_trabajo.parquet") %>%
  mutate(p006_agrup = case_when(p006_agrup == 9 ~ 99,
                                TRUE ~ p006_agrup)) %>%
  filter(tipo_visitante == 1 & anio > 2011 & !is.na(pondera)) %>% #turistas sin na en pondera
  # crear_etiqueta(
  # ) %>%
  mutate(motivo = case_when(px10_1_t == 1 ~ "Vacaciones, ocio",
                            px10_1_t == 2 ~ "Visita a familiares y amigos",
                            px10_1_t == 3 ~ "Trabajo, negocios",
                            px10_1_t == 4 ~ "Otros"))
anios_completos <- evyth %>% group_by(anio,trimestre) %>% 
  summarise(n=n()) %>% 
  group_by(anio) %>% 
  summarise(n=n()) %>% 
  filter(n == 4) %>% 
  pull(anio)

gini <- evyth %>%
  filter(anio %in% anios_completos) %>% 
  #filter(px10_1_t == 1) %>% #solo viajes de ocio
  group_by(anio, quintil_pcf_visitante, id_hogar, miembro, pondera) %>%
  summarise(viajes  = n())

gini_quintiles <- gini %>%
  group_by(anio, quintil_pcf_visitante) %>%# agupamos por quintil de ingreso
  summarise(viajes = sum(viajes * pondera)) %>% # calculamos cantidad de viajes de cada quintil de ingreso
  ungroup() %>%
  group_by(anio) %>%
  arrange(anio, quintil_pcf_visitante) %>%
  mutate(prop_viajes = viajes/sum(viajes), # calculamos la prop de viajes que explica cada quintil
         prop_viajes_acum = cumsum(prop_viajes), # calculos el acumulado
         prop_pob = 0.2, #dado que cada fila es un quintil entero se supone que agrupa el 20% de la pob
         prop_pob_acum = cumsum(prop_pob), #acumulado de pob
         componente_gini = case_when(
           quintil_pcf_visitante == 1 ~ prop_viajes*0.2, #gini para primer quintil
           T ~ (prop_viajes_acum+lag(prop_viajes_acum))*(prop_pob_acum-lag(prop_pob_acum)) #
         ))
gini_anual <- gini_quintiles %>%
  group_by(anio) %>%
  summarise(indice = 1-sum(componente_gini))

gini_viajes <- gini_anual %>% 
  filter(anio==max(anio)) %>% 
  mutate(indice = round(100*indice,1)) %>% 
  pull(indice) %>% 
  format(decimal.mark=",")

# Viajes de ocio
gini_ocio <- evyth %>%
  filter(anio %in% anios_completos) %>% 
  filter(px10_1_t == 1) %>% #solo viajes de ocio
  group_by(anio, quintil_pcf_visitante, id_hogar, miembro, pondera) %>%
  summarise(viajes  = n())

gini_quintiles_ocio <- gini_ocio %>%
  group_by(anio, quintil_pcf_visitante) %>%# agupamos por quintil de ingreso
  summarise(viajes = sum(viajes * pondera)) %>% # calculamos cantidad de viajes de cada quintil de ingreso
  ungroup() %>%
  group_by(anio) %>%
  arrange(anio, quintil_pcf_visitante) %>%
  mutate(prop_viajes = viajes/sum(viajes), # calculamos la prop de viajes que explica cada quintil
         prop_viajes_acum = cumsum(prop_viajes), # calculos el acumulado
         prop_pob = 0.2, #dado que cada fila es un quintil entero se supone que agrupa el 20% de la pob
         prop_pob_acum = cumsum(prop_pob), #acumulado de pob
         componente_gini = case_when(
           quintil_pcf_visitante == 1 ~ prop_viajes*0.2, #gini para primer quintil
           T ~ (prop_viajes_acum+lag(prop_viajes_acum))*(prop_pob_acum-lag(prop_pob_acum)) #
         ))

gini_anual_ocio <- gini_quintiles_ocio %>%
  group_by(anio) %>%
  summarise(indice = 1-sum(componente_gini))

gini_viajes_ocio <- gini_anual_ocio %>% 
  filter(anio==max(anio)) %>% 
  mutate(indice = round(100*indice,1)) %>% 
  pull(indice) %>% 
  format(decimal.mark=",")

# Gasto

gini_quintiles_gasto <- evyth %>%
  filter(anio %in% anios_completos) %>% 
  group_by(anio, quintil_pcf_visitante) %>%# agupamos por quintil de ingreso
  summarise(gasto = sum(pondera*gasto_pc,na.rm=T)) %>% # calculamos cantidad de viajes de cada quintil de ingreso
  ungroup() %>%
  group_by(anio) %>%
  arrange(anio, quintil_pcf_visitante) %>%
  mutate(prop_gasto = gasto/sum(gasto), # calculamos la prop de viajes que explica cada quintil
         prop_gasto_acum = cumsum(prop_gasto), # calculos el acumulado
         prop_pob = 0.2, #dado que cada fila es un quintil entero se supone que agrupa el 20% de la pob
         prop_pob_acum = cumsum(prop_pob), #acumulado de pob
         componente_gini = case_when(
           quintil_pcf_visitante == 1 ~ prop_gasto*0.2, #gini para primer quintil
           T ~ (prop_gasto_acum+lag(prop_gasto_acum))*(prop_pob_acum-lag(prop_pob_acum)) #
         ))

gini_anual_gasto <- gini_quintiles_gasto %>%
  group_by(anio) %>%
  summarise(indice = 1-sum(componente_gini))

gini_gasto <- gini_anual_gasto %>% 
  filter(anio==max(anio)) %>% 
  mutate(indice = round(100*indice,1)) %>% 
  pull(indice) %>% 
  format(decimal.mark=",")
# loading_screen <- tagList(
#   h3("Cargando...", style = "color:gray;"),
#   img(src = "https://tableros.yvera.tur.ar/recursos/logo_mintur_color.png", height = "200px")
# )

gini_todos <- gini_anual %>% 
  mutate(indicador = "Viajes totales") %>% 
  bind_rows(gini_anual_ocio %>% 
              mutate(indicador = "Viajes de Ocio")) %>% 
  bind_rows(gini_anual_gasto %>% 
              mutate(indicador ="Gasto turístico"))

