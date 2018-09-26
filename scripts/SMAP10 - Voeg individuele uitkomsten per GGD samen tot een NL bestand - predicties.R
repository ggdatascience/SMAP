# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

#
# Voeg uitkomsten per GGD samen tot een NL bestand - predicties
#

#
# Init
#

# Laad packages
library(data.table)
library(magrittr)

# Laad functies
source("functies/mergeggd.R")

#
# Lees data
#

# Lees R binary pop.data
load(file = "data/populatie/SMAP2016_populatie_schoon_volledig_extra.bin")

#
# Voeg samen
#

# Net als bij smapmodel wordt het uitvoer path ingesteld met de validatie indicator
# Als je dit path wilt wijzigen, doe dit dan in de mergeggd functie

mergeggd(validatie = FALSE, ind = "drinker")
mergeggd(validatie = FALSE, ind = "drinker_zwaar")
mergeggd(validatie = FALSE, ind = "drinker_overm")
mergeggd(validatie = FALSE, ind = "drinker_overm_oud")
mergeggd(validatie = FALSE, ind = "richtlijn_alcohol")
mergeggd(validatie = FALSE, ind = "overgewicht")
mergeggd(validatie = FALSE, ind = "obesitas")
mergeggd(validatie = FALSE, ind = "roker")
mergeggd(validatie = FALSE, ind = "ervgez_goed")
mergeggd(validatie = FALSE, ind = "ziek_lang")
mergeggd(validatie = FALSE, ind = "bep_vwgez")
mergeggd(validatie = FALSE, ind = "bep_vwgez_ernstig")
mergeggd(validatie = FALSE, ind = "ziek_lang_bep")
mergeggd(validatie = FALSE, ind = "bep_gehoor")
mergeggd(validatie = FALSE, ind = "bep_gezicht")
mergeggd(validatie = FALSE, ind = "beb_mobiel")
mergeggd(validatie = FALSE, ind = "bep_minst_een")
mergeggd(validatie = FALSE, ind = "regie_leven_matig")
mergeggd(validatie = FALSE, ind = "angstdep_matig")
mergeggd(validatie = FALSE, ind = "angstdep_hoog")
mergeggd(validatie = FALSE, ind = "richtlijn_beweeg")
mergeggd(validatie = FALSE, ind = "sporter")
mergeggd(validatie = FALSE, ind = "eenzaam")
mergeggd(validatie = FALSE, ind = "eenzaam_ernstig")
mergeggd(validatie = FALSE, ind = "eenzaam_emo")
mergeggd(validatie = FALSE, ind = "eenzaam_soc")
mergeggd(validatie = FALSE, ind = "eenzaam_75p")
mergeggd(validatie = FALSE, ind = "eenzaam_ernstig_75p")
mergeggd(validatie = FALSE, ind = "eenzaam_emo_75p")
mergeggd(validatie = FALSE, ind = "eenzaam_soc_75p")
mergeggd(validatie = FALSE, ind = "vrwwerk")
mergeggd(validatie = FALSE, ind = "rondkmoeite_12mnd")
mergeggd(validatie = FALSE, ind = "mantelzorger")
mergeggd(validatie = FALSE, ind = "ontvmz_12mnd_65p")
mergeggd(validatie = FALSE, ind = "ontvmz_nu_65p")
