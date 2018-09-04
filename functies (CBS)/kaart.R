# Functie om een kaart te maken van de voorspellingen op buurt, wijk of gemeenteniveau

kaart <- function(
  ind, niveau = "bu",
  pal = NULL, border = NA,
  breaks = "quantile", nbreaks = 10,
  key.pos = 1,
  main = ind, ...) {
  
  # Input:
  # ind    = indicator
  # niveau = bu, wk of gm
  # overige argumenten -> zie help(plot.sf)
  
  #
  # Lees indicator data ----
  #
  
  # Path
  path <- "resultaten/buurt-wijk-gemeente cijfers"
  
  # Maak bestandsnaam
  filename <- paste0(niveau, "_", ind, ".txt")
  
  # Lees data
  data <- read.delim(file = file.path(path, filename))
  
  #
  # Maak kaart ----
  #
  
  if (niveau == "bu") {
    # Buurt
    bu.sf <- merge(x = bu.sf, y = data, by = "bu_code")
    plot(bu.sf[, "prevalentie"], pal = pal, border = border, breaks = breaks, nbreaks = nbreaks, key.pos = key.pos, main = main, ...)
    
  } else if (niveau == "wk") {
    # Wijk
    wk.sf <- merge(x = wk.sf, y = data, by = "wk_code")
    plot(wk.sf[, "prevalentie"], pal = pal, border = border, breaks = breaks, nbreaks = nbreaks, key.pos = key.pos, main = main, ...)
    
  } else {
    # Gemeente
    gm.sf <- merge(x = gm.sf, y = data, by = "gm_code")
    plot(gm.sf[, "prevalentie"], pal = pal, border = border, breaks = breaks, nbreaks = nbreaks, key.pos = key.pos, main = main, ...)
    
  }
}