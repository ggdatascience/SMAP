# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

#
# Voeg uitkomsten per GGD samen tot een NL bestand - validaties
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

mergeggd(validatie = TRUE, ind = "drinker")
mergeggd(validatie = TRUE, ind = "drinker_zwaar")
mergeggd(validatie = TRUE, ind = "richtlijn_alcohol")
mergeggd(validatie = TRUE, ind = "drinker_overm")
mergeggd(validatie = TRUE, ind = "drinker_overm_oud")
mergeggd(validatie = TRUE, ind = "overgewicht")
mergeggd(validatie = TRUE, ind = "obesitas")
mergeggd(validatie = TRUE, ind = "roker")
mergeggd(validatie = TRUE, ind = "ervgez_goed")
mergeggd(validatie = TRUE, ind = "ziek_lang")
mergeggd(validatie = TRUE, ind = "bep_vwgez")
mergeggd(validatie = TRUE, ind = "bep_vwgez_ernstig")
mergeggd(validatie = TRUE, ind = "ziek_lang_bep")
mergeggd(validatie = TRUE, ind = "bep_gehoor")
mergeggd(validatie = TRUE, ind = "bep_gezicht")
mergeggd(validatie = TRUE, ind = "beb_mobiel")
mergeggd(validatie = TRUE, ind = "bep_minst_een")
mergeggd(validatie = TRUE, ind = "regie_leven_matig")
mergeggd(validatie = TRUE, ind = "angstdep_matig")
mergeggd(validatie = TRUE, ind = "angstdep_hoog")
mergeggd(validatie = TRUE, ind = "richtlijn_beweeg")
mergeggd(validatie = TRUE, ind = "sporter")
mergeggd(validatie = TRUE, ind = "eenzaam")
mergeggd(validatie = TRUE, ind = "eenzaam_ernstig")
mergeggd(validatie = TRUE, ind = "eenzaam_emo")
mergeggd(validatie = TRUE, ind = "eenzaam_soc")
mergeggd(validatie = TRUE, ind = "eenzaam_75p")
mergeggd(validatie = TRUE, ind = "eenzaam_ernstig_75p")
mergeggd(validatie = TRUE, ind = "eenzaam_emo_75p")
mergeggd(validatie = TRUE, ind = "eenzaam_soc_75p")
mergeggd(validatie = TRUE, ind = "vrwwerk")
mergeggd(validatie = TRUE, ind = "rondkmoeite_12mnd")
mergeggd(validatie = TRUE, ind = "mantelzorger")
mergeggd(validatie = TRUE, ind = "ontvmz_12mnd_65p")
mergeggd(validatie = TRUE, ind = "ontvmz_nu_65p")

