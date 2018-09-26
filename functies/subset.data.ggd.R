# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

# Functie om data te splitten, gegeven een ggd regiocode
# Ophakken gaat in een:
# - Estimation subset = GGD regio met buffer
# - Predictie  subset = GGD regio zonder buffer
# De buffer voeren we in om randeffecten uit te schakelen
#
# Bovendien geeft deze funtie een burenlijst terug
# Deze is nodig voor het ruimtelijke random effect

subset.data.ggd <- function(fit.data, pred.data, ggd, bu.sf, buffer = 5000) {
  
  # Input:
  # fit.data  = dataset om op te fitten
  # pred.data = dataset om mee te voorspellen
  # ggd       = ggd regiocode
  # bu.sf     = buurtgeometrieen, deze gebruiken we voor het maken van de subsets en burenlijst
  # buffer    = grootte van de buffer, default = 5000 meter

  # Laad functies
  source("functies/sf2nb.R")
  
  #
  # Buurten per ggd ----
  #
  
  # Welke gm_codes liggen in de ggd?
  # Let op! We gaan er vanuit dat iedere gemeente vertegenwoordigd is in fit.data
  # Dat hoeft niet zo te zijn bij kleine sample sizes!
  # Mis je een gemeente, dan worden de buurten ervan hieronder niet geselecteerd!
  # Moeten we in de toekomt nog robuust maken
  gm_code.ggd <- fit.data[gg_code %in% ggd, gm_code] %>%
    droplevels %>%
    levels
  
  # Maak een subset van bu.sf voor de ggd. Dit gaat op basis van gm_code
  bu.sf.ggd <- bu.sf %>%
    subset(subset = gm_code %in% gm_code.ggd)
  
  # Creeer buffer rond bu.sf.ggd
  # Het model fitten we namelijk met deze extra buurten erbij
  buf <- bu.sf.ggd %>% 
    st_union %>%
    st_buffer(dist = buffer, nQuadSegs = 6)
  
  # Selecteer buurten in ggd + buffer
  bu.sf.ggd_buf <- bu.sf[st_intersects(buf, bu.sf %>% st_centroid) %>% unlist, ]
  rm(buf) # Kan weg
  
  # Verwijder niet-gebruikte levels in bu.sf.ggd en bu.sf.ggd_buf
  # (beetje suf dat we niet direct droplevels kunnen losaten op sf objecten...)
  bu.sf.ggd    $bu_code <- bu.sf.ggd    $bu_code %>% droplevels
  bu.sf.ggd_buf$bu_code <- bu.sf.ggd_buf$bu_code %>% droplevels
  
  # Maak burenlijst op basis van bu.sf.ggd_buf
  bu.nb <- bu.sf.ggd_buf %>% sf2nb
  
  # Geef deze lijst de namen van de levels van bu_code in bu.sf.ggd_buf
  # We hebben deze namen nodig in de ruimtelijke term van het model
  names(bu.nb) <- bu.sf.ggd_buf$bu_code %>% levels
  
  #
  # Maak fit.data en pred.data per ggd ----
  #
  
  # fit.data.ggd  wordt fit.data  per ggd met    buffer
  # pred.data.ggd wordt pred.data per ggd zonder buffer
  fit.data.ggd  <- fit.data [bu_code %in% bu.sf.ggd_buf$bu_code, ]
  pred.data.ggd <- pred.data[bu_code %in% bu.sf.ggd    $bu_code, ]
  
  # Zorg ervoor dat de levels van bu_code in beide subsets
  # gelijk zijn aan de namen van bu.nb (ook al woont er niemand)
  # We hebben deze namen nodig in de ruimtelijke term van het model
  fit.data.ggd [, bu_code := factor(bu_code, levels = names(bu.nb))]
  pred.data.ggd[, bu_code := factor(bu_code, levels = names(bu.nb))]
  
  #
  # Return output
  #
  
  return(list(
    fit.data.ggd  = fit.data.ggd,
    pred.data.ggd = pred.data.ggd,
    bu.nb = bu.nb))
}
