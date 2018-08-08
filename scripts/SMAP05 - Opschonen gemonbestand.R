#
# Opschonen gemonbestand ----
#

#
# Init
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(data.table)
library(magrittr)

#
# Lees gemon data ----
#

# Lees R binary gemon.data
load(file = "data/gemon/gemon2016.bin")

#
# Hernoem variabelen ----
#

# Check dat volgorde van oude- en nieuwe namen overeenkomen
# Zie pdf's in folder data/microdata_meta

# Voor
names(gemon.data)

# Hernoem
gemon.data %>% setnames(
  old = c(
    "RINPersoon",
    "LFALA201", "LFALA213", "LFALS231", "LFALS230", "LFALS232",
    "AGGWS204", "AGGWS205",
    "LFRKA205",
    "KLGGA208",
    "CALGA260", "CALGA261", "CALGA262", "CALGS260",
    "LGBPS203", "LGBPS204", "LGBPS205", "LGBPS209",
    "GGRLS203",
    "GGADA202", "GGADA203",
    "RLBEW", "FITNORM", "COMBNORM", "SPORTER",
    "GGEES217", "GGEES209", "GGEES215", "GGEES216",
    "MMVWA201", "MMIKA201",
    "MCMZGS203", "MCMZOS304", "MCMZOS305"),
  new = c(
    "rinpersoon",
    "drinker", "drinker_zwaar","drinker_overm", "drinker_overm_oud", "richtlijn_alcohol",
    "overgewicht", "obesitas",
    "roker",
    "ervgez_goed",
    "ziek_lang", "bep_vwgez", "bep_vwgez_ernstig", "ziek_lang_bep",
    "bep_gehoor", "bep_gezicht", "beb_mobiel", "bep_minst_een",
    "regie_leven_matig",
    "angstdep_matig", "angstdep_hoog",
    "norm_beweeg", "norm_fit", "norm_combi", "sporter",
    "eenzaam", "eenzaam_ernstig", "eenzaam_emo", "eenzaam_soc",
    "vrwwerk", "rondkmoeite_12mnd",
    "mantelzorger", "ontvmz_12mnd_65p", "ontvmz_nu_65p"))

# Na
names(gemon.data)

#
# Hercodeer variabelen ----
#

# Bekijk de variabelen om te zien wat 0 en 1 moeten zijn:
# Zie ook gemon pdf in folder data/microdata_meta
summary(gemon.data)

# Vaak zijn er drie levels en NA's
# Maak van factor een integer en trek er 1 vanaf
# Nee/niet -> 1 -> 0
# Ja/wel   -> 2 -> 1
# Onbekend -> 3 -> 2 -> NA
# NA       -> NA
gemon.data[, drinker           := drinker           %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, drinker_zwaar     := drinker_zwaar     %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, drinker_overm     := drinker_overm     %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, drinker_overm_oud := drinker_overm_oud %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, richtlijn_alcohol := richtlijn_alcohol %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, overgewicht       := overgewicht       %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, obesitas          := obesitas          %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, roker             := roker             %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, ervgez_goed       := ervgez_goed       %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, ziek_lang         := ziek_lang         %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, bep_vwgez         := bep_vwgez         %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, bep_vwgez_ernstig := bep_vwgez_ernstig %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, ziek_lang_bep     := ziek_lang_bep     %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, bep_gehoor        := bep_gehoor        %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, bep_gezicht       := bep_gezicht       %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, beb_mobiel        := beb_mobiel        %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, bep_minst_een     := bep_minst_een     %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, regie_leven_matig := regie_leven_matig %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, angstdep_matig    := angstdep_matig    %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, angstdep_hoog     := angstdep_hoog     %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, mantelzorger      := mantelzorger      %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, norm_beweeg       := norm_beweeg       %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, norm_fit          := norm_fit          %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, norm_combi        := norm_combi        %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, sporter           := sporter           %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, eenzaam           := eenzaam           %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, eenzaam_emo       := eenzaam_emo       %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, eenzaam_soc       := eenzaam_soc       %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, vrwwerk           := vrwwerk           %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, rondkmoeite_12mnd := rondkmoeite_12mnd %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, ontvmz_12mnd_65p  := ontvmz_12mnd_65p  %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]
gemon.data[, ontvmz_nu_65p     := ontvmz_nu_65p     %>% as.integer %>% subtract(1) %>% ifelse(. == 2, yes = NA, no = .)]

# eenzaam_ernstig heeft 4 levels:
# Nee/niet -> 1 -> 0
# Ja/wel   -> 2 -> 1
# nvt      -> 3 -> 2 -> 0
# Onbekend -> 4 -> 3 -> NA
# NA       -> NA
gemon.data[,
  eenzaam_ernstig := eenzaam_ernstig %>% as.integer %>% subtract(1) %>%
    ifelse(. == 2, yes =  0, no = .) %>% 
    ifelse(. == 3, yes = NA, no = .)]

#
# Verwijder overbodige records ----
#

# Er zijn records met duplicaten van rinpersoon
(rinpersoon.dub <- gemon.data[
  gemon.data[, rinpersoon] %>% duplicated %>% which,
  rinpersoon])

# Dubbele rinpersonen, dat willen we niet
# Maak nu twee subsets:
# 1. Met unieke rinpersoon -> OK, doen we niets mee
# 2. Met duplicate rinpersoon
gemon.data.uni <- gemon.data[!(rinpersoon %in% rinpersoon.dub), ]
gemon.data.dub <- gemon.data[  rinpersoon %in% rinpersoon.dub , ]

# Voor gemon.data.dub, behoud per duplicaat rinpersoon het record met de minste missings
# rbind deze records in tmp
tmp <- data.table()
for (rinpersoon.i in rinpersoon.dub) {
  tmp <- rbind(tmp, 
    gemon.data.dub[rinpersoon %in% rinpersoon.i, ][
      gemon.data.dub[rinpersoon %in% rinpersoon.i, ] %>%
        is.na %>%
        apply(MARGIN = 1, FUN = sum) %>%
        which.min, ])
}

# rbind tmp nu aan gemon.dat.uni. Dit wordt de nieuwe gemon.data
gemon.data <- rbind(gemon.data.uni, tmp)

# Tot slot, records met alleen maar NA mogen eruit. Hebben we niets aan
rec.allNA <- gemon.data[, -c("rinpersoon")] %>% is.na %>% apply(MARGIN = 1, FUN = all)
gemon.data <- gemon.data[!rec.allNA, ]

# Reset key
setkey(gemon.data, rinpersoon)

#
# Bewaar gemon.data als R binary
#

# Bewaar als R binary
save(gemon.data, file = "data/gemon/gemon2016_schoon.bin")
