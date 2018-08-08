#
# Kaarten
#

#
# Init ----
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(sf)
library(dplyr)
library(RColorBrewer)

# Laad functies
source("functies/kaart.R")

#
# Lees data ----
#

# Lees buurt, wijk en gemeente geometrieen
bu.sf <- st_read(dsn = "data/gebieden/cbs_buurt_2016.geojson", quiet = TRUE)
wk.sf <- st_read(dsn = "data/gebieden/cbs_wijk_2016.geojson", quiet = TRUE)
gm.sf <- st_read(dsn = "data/gebieden/cbs_gemeente_2016.geojson", quiet = TRUE)

# Kleine opschoonactie van de *.sf objecten
bu.sf <- bu.sf %>% filter(statnaam != "") %>% select(statcode) %>% transmute(bu_code = statcode)
wk.sf <- wk.sf %>% filter(statnaam != "") %>% select(statcode) %>% transmute(wk_code = statcode)
gm.sf <- gm.sf %>% filter(statnaam != "") %>% select(statcode) %>% transmute(gm_code = statcode)

#
# Kaart per gekozen indicator ----
#

# Stel palet in
pal <- colorRampPalette(colors = brewer.pal(name = "YlGnBu", n = 9))

#
# Buurt ----
#

kaart(niveau = "bu", pal = pal, ind = "drinker")
kaart(niveau = "bu", pal = pal, ind = "drinker_zwaar")
kaart(niveau = "bu", pal = pal, ind = "drinker_overm")
kaart(niveau = "bu", pal = pal, ind = "richtlijn_alcohol")
kaart(niveau = "bu", pal = pal, ind = "drinker_overm_oud")
kaart(niveau = "bu", pal = pal, ind = "overgewicht")
kaart(niveau = "bu", pal = pal, ind = "obesitas")
kaart(niveau = "bu", pal = pal, ind = "roker")
kaart(niveau = "bu", pal = pal, ind = "ervgez_goed")
kaart(niveau = "bu", pal = pal, ind = "ziek_lang")
kaart(niveau = "bu", pal = pal, ind = "bep_vwgez")
kaart(niveau = "bu", pal = pal, ind = "bep_vwgez_ernstig")
kaart(niveau = "bu", pal = pal, ind = "ziek_lang_bep")
kaart(niveau = "bu", pal = pal, ind = "bep_gehoor")
kaart(niveau = "bu", pal = pal, ind = "bep_gezicht")
kaart(niveau = "bu", pal = pal, ind = "beb_mobiel")
kaart(niveau = "bu", pal = pal, ind = "bep_minst_een")
kaart(niveau = "bu", pal = pal, ind = "regie_leven_matig")
kaart(niveau = "bu", pal = pal, ind = "angstdep_matig")
kaart(niveau = "bu", pal = pal, ind = "angstdep_hoog")
kaart(niveau = "bu", pal = pal, ind = "mantelzorger")
kaart(niveau = "bu", pal = pal, ind = "sporter")
kaart(niveau = "bu", pal = pal, ind = "eenzaam")
kaart(niveau = "bu", pal = pal, ind = "eenzaam_ernstig")
kaart(niveau = "bu", pal = pal, ind = "eenzaam_emo")
kaart(niveau = "bu", pal = pal, ind = "eenzaam_soc")
kaart(niveau = "bu", pal = pal, ind = "eenzaam_75p")
kaart(niveau = "bu", pal = pal, ind = "eenzaam_ernstig_75p")
kaart(niveau = "bu", pal = pal, ind = "eenzaam_emo_75p")
kaart(niveau = "bu", pal = pal, ind = "eenzaam_soc_75p")
kaart(niveau = "bu", pal = pal, ind = "vrwwerk")
kaart(niveau = "bu", pal = pal, ind = "rondkmoeite_12mnd")
kaart(niveau = "bu", pal = pal, ind = "ontvmz_12mnd_65p")
kaart(niveau = "bu", pal = pal, ind = "ontvmz_nu_65p")

#
# Wijk ----
#

kaart(niveau = "wk", pal = pal, ind = "drinker")
kaart(niveau = "wk", pal = pal, ind = "drinker_zwaar")
kaart(niveau = "wk", pal = pal, ind = "drinker_overm")
kaart(niveau = "wk", pal = pal, ind = "richtlijn_alcohol")
kaart(niveau = "wk", pal = pal, ind = "drinker_overm_oud")
kaart(niveau = "wk", pal = pal, ind = "overgewicht")
kaart(niveau = "wk", pal = pal, ind = "obesitas")
kaart(niveau = "wk", pal = pal, ind = "roker")
kaart(niveau = "wk", pal = pal, ind = "ervgez_goed")
kaart(niveau = "wk", pal = pal, ind = "ziek_lang")
kaart(niveau = "wk", pal = pal, ind = "bep_vwgez")
kaart(niveau = "wk", pal = pal, ind = "bep_vwgez_ernstig")
kaart(niveau = "wk", pal = pal, ind = "ziek_lang_bep")
kaart(niveau = "wk", pal = pal, ind = "bep_gehoor")
kaart(niveau = "wk", pal = pal, ind = "bep_gezicht")
kaart(niveau = "wk", pal = pal, ind = "beb_mobiel")
kaart(niveau = "wk", pal = pal, ind = "bep_minst_een")
kaart(niveau = "wk", pal = pal, ind = "regie_leven_matig")
kaart(niveau = "wk", pal = pal, ind = "angstdep_matig")
kaart(niveau = "wk", pal = pal, ind = "angstdep_hoog")
kaart(niveau = "wk", pal = pal, ind = "mantelzorger")
kaart(niveau = "wk", pal = pal, ind = "sporter")
kaart(niveau = "wk", pal = pal, ind = "eenzaam")
kaart(niveau = "wk", pal = pal, ind = "eenzaam_ernstig")
kaart(niveau = "wk", pal = pal, ind = "eenzaam_emo")
kaart(niveau = "wk", pal = pal, ind = "eenzaam_soc")
kaart(niveau = "wk", pal = pal, ind = "eenzaam_75p")
kaart(niveau = "wk", pal = pal, ind = "eenzaam_ernstig_75p")
kaart(niveau = "wk", pal = pal, ind = "eenzaam_emo_75p")
kaart(niveau = "wk", pal = pal, ind = "eenzaam_soc_75p")
kaart(niveau = "wk", pal = pal, ind = "vrwwerk")
kaart(niveau = "wk", pal = pal, ind = "rondkmoeite_12mnd")
kaart(niveau = "wk", pal = pal, ind = "ontvmz_12mnd_65p")
kaart(niveau = "wk", pal = pal, ind = "ontvmz_nu_65p")

#
# Gemeente ----
#

kaart(niveau = "gm", pal = pal, ind = "drinker")
kaart(niveau = "gm", pal = pal, ind = "drinker_zwaar")
kaart(niveau = "gm", pal = pal, ind = "drinker_overm")
kaart(niveau = "gm", pal = pal, ind = "drinker_overm_oud")
kaart(niveau = "gm", pal = pal, ind = "richtlijn_alcohol")
kaart(niveau = "gm", pal = pal, ind = "overgewicht")
kaart(niveau = "gm", pal = pal, ind = "obesitas")
kaart(niveau = "gm", pal = pal, ind = "roker")
kaart(niveau = "gm", pal = pal, ind = "ervgez_goed")
kaart(niveau = "gm", pal = pal, ind = "ziek_lang")
kaart(niveau = "gm", pal = pal, ind = "bep_vwgez")
kaart(niveau = "gm", pal = pal, ind = "bep_vwgez_ernstig")
kaart(niveau = "gm", pal = pal, ind = "ziek_lang_bep")
kaart(niveau = "gm", pal = pal, ind = "bep_gehoor")
kaart(niveau = "gm", pal = pal, ind = "bep_gezicht")
kaart(niveau = "gm", pal = pal, ind = "beb_mobiel")
kaart(niveau = "gm", pal = pal, ind = "bep_minst_een")
kaart(niveau = "gm", pal = pal, ind = "regie_leven_matig")
kaart(niveau = "gm", pal = pal, ind = "angstdep_matig")
kaart(niveau = "gm", pal = pal, ind = "angstdep_hoog")
kaart(niveau = "gm", pal = pal, ind = "mantelzorger")
kaart(niveau = "gm", pal = pal, ind = "sporter")
kaart(niveau = "gm", pal = pal, ind = "eenzaam")
kaart(niveau = "gm", pal = pal, ind = "eenzaam_ernstig")
kaart(niveau = "gm", pal = pal, ind = "eenzaam_emo")
kaart(niveau = "gm", pal = pal, ind = "eenzaam_soc")
kaart(niveau = "gm", pal = pal, ind = "eenzaam_75p")
kaart(niveau = "gm", pal = pal, ind = "eenzaam_ernstig_75p")
kaart(niveau = "gm", pal = pal, ind = "eenzaam_emo_75p")
kaart(niveau = "gm", pal = pal, ind = "eenzaam_soc_75p")
kaart(niveau = "gm", pal = pal, ind = "vrwwerk")
kaart(niveau = "gm", pal = pal, ind = "rondkmoeite_12mnd")
kaart(niveau = "gm", pal = pal, ind = "ontvmz_12mnd_65p")
kaart(niveau = "gm", pal = pal, ind = "ontvmz_nu_65p")
