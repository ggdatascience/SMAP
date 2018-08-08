#
# Aggregeer individuele uitkomsten naar buurt-wijk-gemeente 
#

#
# Init ----
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(data.table)
library(magrittr)

# Laad functies
source("functies/ind2buwkgm.R")

#
# Lees data ----
#

# Lees R binary pop.data
load(file = "data/populatie/SMAP2016_populatie_schoon_volledig_extra.bin")

#
# Aggregeer individuele uitkomsten ----
#

ind2buwkgm(ind = "drinker")
ind2buwkgm(ind = "drinker_zwaar")
ind2buwkgm(ind = "drinker_overm")
ind2buwkgm(ind = "drinker_overm_oud")
ind2buwkgm(ind = "richtlijn_alcohol")
ind2buwkgm(ind = "overgewicht")
ind2buwkgm(ind = "obesitas")
ind2buwkgm(ind = "roker")
ind2buwkgm(ind = "ervgez_goed")
ind2buwkgm(ind = "ziek_lang")
ind2buwkgm(ind = "bep_vwgez")
ind2buwkgm(ind = "bep_vwgez_ernstig")
ind2buwkgm(ind = "ziek_lang_bep")
ind2buwkgm(ind = "bep_gehoor")
ind2buwkgm(ind = "bep_gezicht")
ind2buwkgm(ind = "beb_mobiel")
ind2buwkgm(ind = "bep_minst_een")
ind2buwkgm(ind = "regie_leven_matig")
ind2buwkgm(ind = "angstdep_matig")
ind2buwkgm(ind = "angstdep_hoog")
ind2buwkgm(ind = "mantelzorger")
ind2buwkgm(ind = "sporter")
ind2buwkgm(ind = "eenzaam")
ind2buwkgm(ind = "eenzaam_ernstig")
ind2buwkgm(ind = "eenzaam_emo")
ind2buwkgm(ind = "eenzaam_soc")
ind2buwkgm(ind = "eenzaam_75p")
ind2buwkgm(ind = "eenzaam_ernstig_75p")
ind2buwkgm(ind = "eenzaam_emo_75p")
ind2buwkgm(ind = "eenzaam_soc_75p")
ind2buwkgm(ind = "vrwwerk")
ind2buwkgm(ind = "rondkmoeite_12mnd")
ind2buwkgm(ind = "ontvmz_12mnd_65p")
ind2buwkgm(ind = "ontvmz_nu_65p")
