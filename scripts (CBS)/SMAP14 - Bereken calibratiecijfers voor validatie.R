# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

#
# Bereken calibratiecijfers voor validatie
#

#
# Init
#

# Laad packages
library(data.table)
library(magrittr)

# Laad functies
source("functies/calibratie.R")

#
# Bereken calibratiecijfers
#

calibratie(ind = "drinker")
calibratie(ind = "drinker_zwaar")
calibratie(ind = "richtlijn_alcohol")
calibratie(ind = "drinker_overm")
calibratie(ind = "drinker_overm_oud")
calibratie(ind = "overgewicht")
calibratie(ind = "obesitas")
calibratie(ind = "roker")
calibratie(ind = "ervgez_goed")
calibratie(ind = "ziek_lang")
calibratie(ind = "bep_vwgez")
calibratie(ind = "bep_vwgez_ernstig")
calibratie(ind = "ziek_lang_bep")
calibratie(ind = "bep_gehoor")
calibratie(ind = "bep_gezicht")
calibratie(ind = "beb_mobiel")
calibratie(ind = "bep_minst_een")
calibratie(ind = "regie_leven_matig")
calibratie(ind = "angstdep_matig")
calibratie(ind = "angstdep_hoog")
calibratie(ind = "richtlijn_beweeg")
calibratie(ind = "sporter")
calibratie(ind = "eenzaam")
calibratie(ind = "eenzaam_ernstig")
calibratie(ind = "eenzaam_emo")
calibratie(ind = "eenzaam_soc")
calibratie(ind = "eenzaam_75p")
calibratie(ind = "eenzaam_ernstig_75p")
calibratie(ind = "eenzaam_emo_75p")
calibratie(ind = "eenzaam_soc_75p")
calibratie(ind = "vrwwerk")
calibratie(ind = "rondkmoeite_12mnd")
calibratie(ind = "mantelzorger")
calibratie(ind = "ontvmz_12mnd_65p")
calibratie(ind = "ontvmz_nu_65p")
