# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

# Functie om rinpersonen te selecteren op basis van bijvoorbeeld leeftijd
# Ook kun je aangeven of je gemon.data wilt ophakken in een training- en testset

selectrin <- function(subset = NULL, validatie = FALSE) {
  
  # Input:
  # subset    = logische expressie om op te selecteren, bijvoorbeeld leeftijd %in% 65:120
  # validatie = hak gemon.data op in 2/3 fit en 1/3 predictiedeel?
  
  # De variabelen op te selecteren zitten niet in gemon.data, wel in pop.data
  # Selecteer daarom eerst de rinpersonen uit pop.data en haal deze vervolgens uit gemon.data
  # Maar vindt er uberhaupt selectie plaats?
  if (is.null(subset)) {
    # Bij lege subset, selecteer alle personen
    rin.pop <- pop.data[, rinpersoon]
  } else {
    # Bij geen lege subset, selecteer dan op basis van subset
    rin.pop <- pop.data[subset %>% parse(text = .) %>% eval, rinpersoon]
  }
  rin.gemon <- gemon.data[rinpersoon %in% rin.pop, rinpersoon]
  
  # Voor validatie, hak rin.gemon op in 2/3 training deel en 1/3 test deel
  # rin.pop hebben we dan niet meer nodig
  if (validatie) {
    set.seed(2016)
    rin.train <- rin.gemon %>% sample(size = 2/3*length(rin.gemon) %>% round) %>% sort
    rin.test <- rin.gemon[!(rin.gemon %in% rin.train)]
    
    # Return output bij validatie
    return(list(
      rin.fit = rin.train,
      rin.pred = rin.test,
      validatie = validatie))
  }
  
  # Return output bij predictie
  return(list(
    rin.fit = rin.gemon,
    rin.pred = rin.pop,
    validatie = validatie))
}
