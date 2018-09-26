# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

# Functie om losse ggd uitvoer samen te voegen tot een NL bestand

mergeggd <- function(ind, validatie = FALSE) {
  
  # Input:
  # ind        = naam van de gezondheidsindicator
  # validatie  = indien TRUE, dan wordt pred niet overschreven door obs

  #
  # Voorbereidend werk ----
  #
  
  # GGD regio's komen uit pop.data, de levels van gg_code
  ggd <- pop.data$gg_code %>% levels
  
  # Maak smap.data, een selectie van pop.data met alleen rinpersoon en gg_code
  smap.data <- pop.data[, .(rinpersoon, gg_code)]

  # Loop over ggd regiocodes
  for (ggd.i in ggd) {
    
    # Toon voortgang
    print(paste(Sys.time(), ind, ggd.i, sep = " - "))
    
    #
    # Lees pred.data voor ggd.i ----
    #
    
    # Stel invoer path in
    if (validatie) {
      path <- "resultaten/validaties ggd"
    } else {
      path <- "resultaten/predicties ggd"
    }
    
    # Maak bestandsnaam
    filename <- paste0(ind, " - ", ggd.i, ".bin")
    
    # Laad pred.data.ggd
    load(file = file.path(path, filename))
    
    #
    # Voeg pred.data.ggd toe aan smap.data ----
    #
    
    # 1. In pred.data.ggd, hernoem obs -> obs.tmp en pred -> pred.tmp
    #    Dit voorkomt dat obs en pred bij het samenvoegen met smap.data (met obs en pred reeds aanwezig) verdubbeld worden
    pred.data.ggd %>%
      setnames(
        old = c("obs", "pred"),
        new = c("obs.tmp", "pred.tmp"))
    
    # 2. Voeg pred.data.ggd toe aan smap.data
    smap.data <- merge(
      x = smap.data,
      y = pred.data.ggd,
      by = "rinpersoon",
      all.x = TRUE)
    
    # 3. Kopieer, alleen voor ggd.i, obs.tmp en pred.tmp naar obs en pred
    #    Zo overschrijven we de reeds bestaande obs en pred niet
    smap.data[gg_code %in% ggd.i, obs  := obs.tmp]
    smap.data[gg_code %in% ggd.i, pred := pred.tmp]
    
    # 4. Bij predicties, vervang pred door obs als deze niet missend is
    #    Dit doen we NIET bij de validaties, want daar hebben we de originele pred voor nodig
    if (!validatie) smap.data[gg_code %in% ggd.i & !is.na(obs), pred := obs]
    
    # 5. Verwijder obs.tmp en pred.tmp uit smap.data
    smap.data[, obs.tmp  := NULL]
    smap.data[, pred.tmp := NULL]
    
    # Einde ggd-loop
  }
  
  # Verwijder alle records met missende predictie
  # Deze rinpersonen zijn namelijk nooit voorspeld en kunnen er gewoon uit
  smap.data <- smap.data[!is.na(pred), ]
  
  #
  # Bewaar smap.data als R binary
  #
  
  # Verwijder gg_code uit smap.data
  smap.data[, gg_code := NULL]
  
  # Stel uitvoer path in
  if (validatie) {
    path <- "resultaten/validaties nl"
  } else {
    path <- "resultaten/predicties nl"
  }
  
  # Maak bestandsnaam
  filename <- paste0(ind, ".bin")
  
  # Bewaar als R binary
  save(smap.data, file = file.path(path, filename))
  
}