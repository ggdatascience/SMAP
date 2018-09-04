#
# Fit modellen en voorspel individuele uitkomsten per GGD - predicties
#

#
# Init ----
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(data.table)
library(sf)
library(magrittr)

# Laad functies
source("functies/selectrin.R")
source("functies/smapmodel.R")

#
# Lees data ----
#

# Lees R binary pop.data
load(file = "data/populatie/SMAP2016_populatie_schoon_volledig_extra.bin")

# Lees R binary gemon.data
load(file = "data/gemon/gemon2016_schoon.bin")

# Lees R binary bu.sf
load(file = "data/gebieden/cbs_buurt_2016.bin")

#
# Fit modellen ----
#

# We krijgen uiteindelijk per indicator per GGD een los bestandje met:
# - rinpersoon
# - waargenomen uitkomst obs (met veel NA's dus)
# - voorspelde uitkomst pred

# Het fitten en voorspellen gaat met een functie-aanroep
# Selecties, bijvoorbeeld op leeftijd of GGD regio, gaat op basis van rinpersoon, bijvoorbeeld leeftijd %in% 65:120
# We ook met deze functie aanroep validaties maken met validatie = TRUE
# Bij het selecteren van de rinpersonen gaat deze validatie indicator mee
# Uitvoer van de functie smapmodel wordt dan naar betreffende 'predicties' of 'validaties' map wegggeschreven
# Wil je een ander path, pas dat dan aan in de smapmodel functie

# Deze indicatoren voor alle leeftijden
# Selecteer rinpersonen om op te fitten en te voorspellen
rin <- selectrin(subset = NULL, validatie = FALSE)
# Fit en voorspel
smapmodel(rin = rin, ind = "drinker")
smapmodel(rin = rin, ind = "drinker_zwaar")
smapmodel(rin = rin, ind = "drinker_overm")
smapmodel(rin = rin, ind = "drinker_overm_oud")
smapmodel(rin = rin, ind = "richtlijn_alcohol")
smapmodel(rin = rin, ind = "overgewicht")
smapmodel(rin = rin, ind = "obesitas")
smapmodel(rin = rin, ind = "roker")
smapmodel(rin = rin, ind = "ervgez_goed")
smapmodel(rin = rin, ind = "ziek_lang")
smapmodel(rin = rin, ind = "bep_vwgez")
smapmodel(rin = rin, ind = "bep_vwgez_ernstig")
smapmodel(rin = rin, ind = "ziek_lang_bep")
smapmodel(rin = rin, ind = "bep_gehoor")
smapmodel(rin = rin, ind = "bep_gezicht")
smapmodel(rin = rin, ind = "beb_mobiel")
smapmodel(rin = rin, ind = "bep_minst_een")
smapmodel(rin = rin, ind = "regie_leven_matig")
smapmodel(rin = rin, ind = "angstdep_matig")
smapmodel(rin = rin, ind = "angstdep_hoog")
smapmodel(rin = rin, ind = "mantelzorger")
smapmodel(rin = rin, ind = "sporter")
smapmodel(rin = rin, ind = "eenzaam")
smapmodel(rin = rin, ind = "eenzaam_ernstig")
smapmodel(rin = rin, ind = "eenzaam_emo")
smapmodel(rin = rin, ind = "eenzaam_soc")
smapmodel(rin = rin, ind = "vrwwerk")
smapmodel(rin = rin, ind = "rondkmoeite_12mnd")

# Mantelzorg voor 65+
rin <- selectrin(subset = "leeftijd %in% 65:120", validatie = FALSE)
smapmodel(rin = rin, ind = "ontvmz_12mnd_65p")
smapmodel(rin = rin, ind = "ontvmz_nu_65p")

# Eenzaamheid voor 75+
# We kopieren de eenzaamheidsvariabelen en voegen daar _75p aan toe
# Dat werkt makkelijker met bestandsnamen
gemon.data[, eenzaam_75p         := eenzaam]
gemon.data[, eenzaam_ernstig_75p := eenzaam_ernstig]
gemon.data[, eenzaam_emo_75p     := eenzaam_emo]
gemon.data[, eenzaam_soc_75p     := eenzaam_soc]
rin <- selectrin(subset = "leeftijd %in% 75:120", validatie = FALSE)
smapmodel(rin = rin, ind = "eenzaam_75p")
smapmodel(rin = rin, ind = "eenzaam_ernstig_75p")
smapmodel(rin = rin, ind = "eenzaam_emo_75p")
smapmodel(rin = rin, ind = "eenzaam_soc_75p")
