# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

#
# Calibratieplots
#

#
# Init
#

# Laad packages
library(magrittr)

# Laad functies
source("functies/calibratieplot.R")

#
# Calibratieplot per indicator
#

calibratieplot(pch = "+", ind = "drinker")
calibratieplot(pch = "+", ind = "drinker_zwaar")
calibratieplot(pch = "+", ind = "drinker_overm")
calibratieplot(pch = "+", ind = "drinker_overm_oud")
calibratieplot(pch = "+", ind = "richtlijn_alcohol")
calibratieplot(pch = "+", ind = "overgewicht")
calibratieplot(pch = "+", ind = "obesitas")
calibratieplot(pch = "+", ind = "roker")
calibratieplot(pch = "+", ind = "ervgez_goed")
calibratieplot(pch = "+", ind = "ziek_lang")
calibratieplot(pch = "+", ind = "bep_vwgez")
calibratieplot(pch = "+", ind = "bep_vwgez_ernstig")
calibratieplot(pch = "+", ind = "ziek_lang_bep")
calibratieplot(pch = "+", ind = "bep_gehoor")
calibratieplot(pch = "+", ind = "bep_gezicht")
calibratieplot(pch = "+", ind = "beb_mobiel")
calibratieplot(pch = "+", ind = "bep_minst_een")
calibratieplot(pch = "+", ind = "regie_leven_matig")
calibratieplot(pch = "+", ind = "angstdep_matig")
calibratieplot(pch = "+", ind = "angstdep_hoog")
calibratieplot(pch = "+", ind = "richtlijn_beweeg")
calibratieplot(pch = "+", ind = "sporter")
calibratieplot(pch = "+", ind = "eenzaam")
calibratieplot(pch = "+", ind = "eenzaam_ernstig")
calibratieplot(pch = "+", ind = "eenzaam_emo")
calibratieplot(pch = "+", ind = "eenzaam_soc")
calibratieplot(pch = "+", ind = "eenzaam_75p")
calibratieplot(pch = "+", ind = "eenzaam_ernstig_75p")
calibratieplot(pch = "+", ind = "eenzaam_emo_75p")
calibratieplot(pch = "+", ind = "eenzaam_soc_75p")
calibratieplot(pch = "+", ind = "vrwwerk")
calibratieplot(pch = "+", ind = "rondkmoeite_12mnd")
calibratieplot(pch = "+", ind = "mantelzorger")
calibratieplot(pch = "+", ind = "ontvmz_12mnd_65p")
calibratieplot(pch = "+", ind = "ontvmz_nu_65p")
