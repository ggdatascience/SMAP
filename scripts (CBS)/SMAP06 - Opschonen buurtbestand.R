# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

#
# Opschonen buurtbestand
#

#
# Init
#

# Laad packages
library(sf)

#
# Lees buurt simple features
#

# Een simple feature is een dataframe met een geometrie kolom eraan
# cbs_buurt_2016.geojson is afkomstig van pdok.nl
# Vraag Jan van de Kassteele hoe dit te verkrijgen
bu.sf <- st_read(dsn = "data/gebieden/cbs_buurt_2016.geojson", quiet = TRUE)

#
# Opschonen bu.sf
#

# Verwijder overtollige records en variabelen
# We houden alleen buurtcode en geometrieen over
bu.sf <- bu.sf %>% subset(
  subset = statnaam != "",
  select = c("statcode", "geometry"))

# En verder
bu.sf <- within(bu.sf, {
  # Voeg gm_code toe
  # Deze hebben we bij de modellen nodig om op te selecteren
  gm_code <- statcode %>%
    substr(start = 3, stop = 6) %>% 
    paste0("GM", .) %>% 
    factor
  # Hernoem statcode naar bu_code
  bu_code <- statcode %>% droplevels
  rm(statcode)
})

#
# Bewaar bu.sf als R binary
#

# Bewaar als R binary
save(bu.sf, file = "data/gebieden/cbs_buurt_2016.bin")
