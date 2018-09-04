#
# Imputeren populatiebestand ----
#

#
# Init
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(data.table)
library(magrittr)
library(sf)
library(randomForest)

# Laad functies
source("functies/rfparallel.R")
source("functies/varimportance.R")
source("functies/impute.R")

#
# Lees data ----
#

# Lees R binary pop.data
load(file = "data/populatie/SMAP2016_populatie_schoon.bin")

# Lees R binary bu.sf
# Nodig voor voor imputatie missende XY coordinaten
load(file = "data/gebieden/cbs_buurt_2016.bin")

#
# Voorbereidend werk ter imputatie ----
#

# Set seed
set.seed(2016)

# Maak hhinkomen en hhvermogen categorisch
# Dit versnelt de RF fit enorm
# Zetten we later weer terug
pop.data[, hhinkomen.cat  := hhinkomen  %>% cut(breaks = seq(from =  1, to = 101, by = 5), right = FALSE, include.lowest = TRUE)]
pop.data[, hhvermogen.cat := hhvermogen %>% cut(breaks = seq(from =  1, to = 101, by = 5), right = FALSE, include.lowest = TRUE)]

# Trek 50,000 random samples uit pop.data, anders duurt het RF fitten veel te lang
# We gebruiken pop.data.sub straks ook voor imputatie
# Omdat RF geen NA's pakt als voorspellers, halen we deze NA's eerst uit pop.data
pop.data.sub <- pop.data[,
  .(leeftijd, geslacht, herkomst, burgstaat, opleiding,
    hhtype, hhgrootte, hhinkomensbron, hhwoningbezit, hhinkomen, hhvermogen,
    hhinkomen.cat, hhvermogen.cat)] %>%
  na.omit %>% 
  extract(sample.int(
    n = nrow(.),
    size = 50000))

#
# Inspecteer welke variabelen voorspellend zijn ----
#

# Inspectie gaat met variable importance plot uit randomForest package
# Voorspellers met groote MeanDecreaseAccuracy zijn goede voorspellers

# # Het inspecteren hieronder kun je later uitcommentarieeren,
# # want we doen dit slechts eenmalig
# 
# # Burgelijke staat
# varimp(
#   formula = burgstaat ~ leeftijd + geslacht + herkomst + opleiding +
#     hhtype + hhgrootte + hhinkomensbron + hhwoningbezit + hhinkomen + hhvermogen,
#   data = pop.data.sub,
#   main = "Burgelijke staat",
#   save = TRUE)
# 
# # Huishoudgrootte
# varimportance(
#   formula = hhgrootte ~ leeftijd + geslacht + herkomst + burgstaat + opleiding +
#     hhtype + hhinkomensbron + hhwoningbezit + hhinkomen + hhvermogen,
#   data = pop.data.sub,
#   main = "Huishoudgrootte",
#   saveplot = TRUE,
#   path = "resultaten/variable importance plots")
# 
# # Huishoudtype
# varimportance(
#   formula = hhtype ~ leeftijd + geslacht + herkomst + burgstaat + opleiding +
#     hhgrootte + hhinkomensbron + hhwoningbezit + hhinkomen + hhvermogen,
#   data = pop.data.sub,
#   main = "Huishoudtype",
#   saveplot = TRUE,
#   path = "resultaten/variable importance plots")
# 
# # Huishoudwoningbezit
# varimportance(
#   formula = hhwoningbezit ~ leeftijd + geslacht + herkomst + burgstaat + opleiding +
#     hhtype + hhgrootte + hhinkomensbron + hhinkomen + hhvermogen,
#   data = pop.data.sub,
#   main = "Huishoudwoningbezit",
#   saveplot = TRUE,
#   path = "resultaten/variable importance plots")
# 
# # Huishoudinkomensbron
# varimportance(
#   formula = hhinkomensbron ~ leeftijd + geslacht + herkomst + burgstaat + opleiding +
#     hhtype + hhgrootte + hhwoningbezit + hhinkomen + hhvermogen,
#   data = pop.data.sub,
#   main = "Huishoudinkomensbron",
#   saveplot = TRUE,
#   path = "resultaten/variable importance plots")
# 
# # Huishoudinkomen
# varimportance(
#   formula = hhinkomen.cat ~ leeftijd + geslacht + herkomst + burgstaat + opleiding +
#     hhtype + hhgrootte + hhinkomensbron + hhwoningbezit + hhvermogen,
#   data = pop.data.sub,
#   main = "Huishoudinkomen",
#   saveplot = TRUE,
#   path = "resultaten/variable importance plots")
# 
# # Huishoudvermogen
# varimportance(
#   formula = hhvermogen.cat ~ leeftijd + geslacht + herkomst + burgstaat + opleiding +
#     hhtype + hhgrootte + hhinkomensbron + hhwoningbezit + hhinkomen,
#   data = pop.data.sub,
#   main = "Huishoudvermogen",
#   saveplot = TRUE,
#   path = "resultaten/variable importance plots")
# 
# # Opleiding
# varimportance(
#   formula = opleiding ~ leeftijd + geslacht + herkomst + burgstaat + 
#     hhtype + hhgrootte + hhinkomensbron + hhwoningbezit + hhinkomen + hhvermogen,
#   data = pop.data.sub,
#   main = "Opleiding",
#   saveplot = TRUE,
#   path = "resultaten/variable importance plots")

#
# Imputateer populatiekarakteristieken ----
#

# Grasadder:
# De missings bij veel variabelen vallen precies samen met de missings van de voorspellende variabelen
# Dat is iets dat we hierboven even genegeerd hebben
# Gevolg is dat je niet zomaar de alle variabelen kunt gebruiken om te voorspellen
# We gaan daarom sequentieel imputeren, zo goed mogelijk met wat we al wel hebben
#
# Stappenplan:
# 1. Neem de variabele met minste missings
# 2. Bekijk aan de hand van de variable importance plots van hierboven
#    welke variabelen voorspellend zijn (praktijk: neem gewoon alles)
# 3. Voeg alleen die variabelen toe als ze volledig beschikbaar zijn

# Welk aantal en percentage records mist er? 
pop.data %>% sapply(FUN = is.na) %>% colSums %>% sort
pop.data %>% sapply(FUN = is.na) %>% colMeans %>% multiply_by(100) %>% sort %>% round(digits = 2)

# Burgelijke staat
pop.data <- impute(
  formula = burgstaat ~ leeftijd + geslacht + herkomst,
  data = pop.data.sub,
  newdata = pop.data)

# Huishoudtype
# Doen we voor hhgrootte
# burgstaat is hier een sterke voorspeller
# hhgrootte hangt meer af van hhtype dan andersom
pop.data <- impute(
  formula = hhtype ~ leeftijd + geslacht + herkomst + burgstaat,
  data = pop.data.sub,
  newdata = pop.data)

# Huishoudgrootte
# (negeer warning over datatype 'integer')
pop.data <- impute(
  formula = hhgrootte ~ leeftijd + geslacht + herkomst + burgstaat + hhtype,
  data = pop.data.sub,
  newdata = pop.data)

# Nu komt een lastige puzzel:
# hhwoningbezit hhinkomensbron hhinkomen hhvermogen hangen erg met elkaar samen
# Aangezien er niet echt een logische oplossing is doen we de imputatie op volgorde van aantal missings

# Huishoudwoningbezit
# Voeg droplevels toe aan pop.data.sub wegens het volledig ontbreken
# van 'institutioneel woningbezit' daarin
pop.data <- impute(
  formula = hhwoningbezit ~ leeftijd + geslacht + herkomst + burgstaat +
    hhtype + hhgrootte,
  data = pop.data.sub %>% droplevels,
  newdata = pop.data)

# Huishoudinkomensbron
pop.data <- impute(
  formula = hhinkomensbron ~ leeftijd + geslacht + herkomst + burgstaat +
    hhtype + hhgrootte + hhwoningbezit,
  data = pop.data.sub,
  newdata = pop.data)

# Huishoudinkomen
# Doen we voor hhvermogen
# Idee is dat vermogen volgt uit inkomen in plaats van andersom
pop.data <- impute(
  formula = hhinkomen.cat ~ leeftijd + geslacht + herkomst + burgstaat +
    hhtype + hhgrootte + hhwoningbezit + hhinkomensbron,
  data = pop.data.sub,
  newdata = pop.data)
# Bouw hhinkomen.cat weer om naar integer door te samplen uit betreffende categorie
# [1, 6)  -> 1 -> 0 -> 0 -> 1 t/m 5,
# [6, 11) -> 2 -> 1 -> 5 -> 6 t/m 10, etc
pop.data[, 
  hhinkomen := hhinkomen %>% is.na %>% ifelse(
    yes = hhinkomen.cat %>% as.integer %>%
      subtract(1) %>% multiply_by(5) %>%
      add(sample(1:5, size = nrow(pop.data), replace = TRUE)),
    no = hhinkomen)]

# Huishoudvermogen
pop.data <- impute(
  formula = hhvermogen.cat ~ leeftijd + geslacht + herkomst + burgstaat +
    hhtype + hhgrootte + hhwoningbezit + hhinkomensbron + hhinkomen,
  data = pop.data.sub,
  newdata = pop.data)
# Bouw hhvermogen.cat weer om naar integer door te samplen uit betreffende categorie
pop.data[, 
  hhvermogen := hhvermogen %>% is.na %>% ifelse(
    yes = hhvermogen.cat %>% as.integer %>%
      subtract(1) %>% multiply_by(5) %>%
      add(sample(1:5, size = nrow(pop.data), replace = TRUE)),
    no = hhvermogen)]

# Opleiding
pop.data <- impute(
  formula = opleiding ~ leeftijd + geslacht + herkomst + burgstaat +
    hhtype + hhgrootte + hhwoningbezit + hhinkomensbron + hhinkomen + hhvermogen,
  data = pop.data.sub,
  newdata = pop.data)

# Verwijder overbodige variabelen
pop.data <- subset(pop.data, select = -c(hhinkomen.cat, hhvermogen.cat))

#
# Imputeer buurtcodes en XY coordinaten ----
#

# Op basis van populatiekenmerken gaan we per gemeente 'uitrekenen' wat de meest waarschijnlijke buurt is
# Uit de buurtcode volgt wijkcode
# Als laatste bepalen we de XY coordinaten aan de hand van de centroiden van de buurt

# Missende gemeenten kunnen we echt niets mee -> eruit
# (2016: 1 persoon)
pop.data <- pop.data[!is.na(gm_code), ]

# In welke gemeenten missen één of meer buurten?
(gm_code.NA <- pop.data[is.na(bu_code), gm_code] %>% droplevels %>% levels)

# Loop over deze gemeenten
# (duurt lang, dus ga maar lekker even koffie halen)
for (gm_code.i in gm_code.NA) {
  
  # Print voortgang
  print(gm_code.i)
  
  # Maak een subset van pop.data om op te fitten
  # Deze subset betreft alleen gm_code.i (met niet missende bu_code)
  # Als deze subset meer dan 50000 records bevat,
  # trek dan een random sample van 50000 records uit deze subset
  # Dit versnelt de boel enorm
  if (nrow(pop.data[gm_code == gm_code.i & !is.na(bu_code), ]) > 50000) {
    pop.data.sub <- pop.data[gm_code == gm_code.i & !is.na(bu_code), ] %>%
      extract(sample.int(
        n = nrow(.),
        size = 50000)) %>% 
      droplevels
  } else {
    pop.data.sub <- pop.data[gm_code == gm_code.i & !is.na(bu_code), ] %>%
      droplevels
  }

  # Imputeer bu_code voor gm_code.i
  pop.data.gm_code.i <- impute(
    formula = bu_code ~ leeftijd + geslacht + herkomst + burgstaat +
      hhtype + hhgrootte + hhwoningbezit + hhinkomensbron + hhinkomen + hhvermogen + opleiding,
    data    = pop.data.sub,
    newdata = pop.data[gm_code == gm_code.i, ])
  
  # Voeg geimputeerde bu_code toe aan pop.data
  pop.data[
    gm_code == gm_code.i,
    bu_code := pop.data.gm_code.i[, bu_code]]
  
  # Einde loop
}

# Missende wk_code volgt uit bu_code
pop.data[
  is.na(wk_code),
  wk_code := bu_code %>%
    substr(start = 3, stop = 8) %>% 
    paste0("WK", .) %>% 
    factor(levels = pop.data$wk_code %>% levels)]

# Missende coordinaten volgen uit buurtcentroiden
# Eerst een kleine opschoonactie van bu.sf
# Haal essentie eruit: bu_code, X, Y
bu.data <- cbind(data.table(
  bu_code = bu.sf$bu_code),
  bu.sf %>% st_centroid %>% st_coordinates)

# Rond X en Y af en maak integer
# (voorkomt warnings bij het samenvoegen dadelijk)
bu.data[, X := X %>% round %>% as.integer]
bu.data[, Y := Y %>% round %>% as.integer]

# Maak levels van bu_code in pop.data gelijk aan die van bu.data
pop.data[,
  bu_code := bu_code %>% factor(
    levels = levels(bu.data$bu_code),
    labels = levels(bu.data$bu_code))]

# Tijdelijke merge van pop.data met bu.data
pop.data <- merge(
  x = pop.data,
  y = bu.data,
  by = "bu_code")

# Waar xcoord en ycoord missen, vul X en Y in
pop.data[is.na(xcoord), xcoord := X]
pop.data[is.na(ycoord), ycoord := Y]

# Verwijder X en Y weer uit pop.data
pop.data <- subset(pop.data, select = -c(X, Y))

#
# Bewaar pop.data als R binary
#

# Bewaar als R binary
save(pop.data, file = "data/populatie/SMAP2016_populatie_schoon_volledig.bin")
