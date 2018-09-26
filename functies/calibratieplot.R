# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

# Functie om een calibratieplot te maken

calibratieplot <- function(ind, gel, main = ind, ...) {
  
  #
  # Lees indicator data ----
  #
  
  # Stel path in
  path <- "resultaten/calibratiecijfers"
  
  # Maak bestandsnaam
  filename <- paste0("cali_", ind, ".txt")
  
  # Lees data
  data <- read.delim(file = file.path(path, filename))
  
  #
  # Bereken betrouwbaarheidsintervallen voor gemiddelde van de waarnemingen ----
  #
  
  n.obs <- data$populatie %>% mean
  p <- pretty(data$pred, n = 30)
  p.lwr <- qbeta(p = 0.025, shape1 = p*n.obs + 0.5, shape2 = (1 - p)*n.obs + 0.5)
  p.upr <- qbeta(p = 0.975, shape1 = p*n.obs + 0.5, shape2 = (1 - p)*n.obs + 0.5)
  
  #
  # Maak calibratieplot ----
  #
  
  with(data, plot(pred, obs, asp = 1, main = main, ...))
  matlines(p, cbind(p.lwr, p.upr), col = 1, lty = 2)
  abline(0, 1)
  
}
