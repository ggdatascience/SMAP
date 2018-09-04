# Functie om calibratiecijfers te berekenen
# De voorspelde prevalenties worden opgehak in klassen (op basis van quantiles)
# Per klasse wordt voorspelde prevalentie gemiddeld, alsmede de waargenomen uitkomst
# Bij een goed model dienen dienen deze gemiddelden op de 1:1 lijn te liggen

calibratie <- function(ind, n.klassen = 200) {
  
  #
  # Lees indicator data ----
  #
  
  # Path
  path <- "resultaten/validaties nl"

  # Maak bestandsnaam
  filename <- paste0(ind, ".bin")
  
  # Lees individuele uitkomsten NL (smap.data)
  load(file = file.path(path, filename))
  
  #
  # Calibratiecijfers ----
  #
  
  # Hak predicties op in categorieen op basis van quantiles
  smap.data[, pred.cat := cut(pred,
    breaks = quantile(pred, prob = seq(from = 0, to = 1, length = n.klassen + 1), na.rm = TRUE),
    right = FALSE,
    include.lowest = TRUE)]
  
  # Aggregeer obs en pred per categorie
  cali.data <- smap.data[, .(
    pred = mean(pred),
    obs = mean(obs, na.rm = TRUE),
    populatie = .N),
    by = pred.cat]
  
  # Sorteer op pred.cat
  setkey(cali.data, pred.cat)
  
  # Verwijder pred.cat
  cali.data[, pred.cat := NULL]
  
  #
  # Schrijf resultaten weg ----
  #
  
  # Extra: rond prevalenties af op 3 cijfers achter komma
  cali.data[, obs  := obs  %>% round(digits = 3)]
  cali.data[, pred := pred %>% round(digits = 3)]
  
  # Stel uitvoer path in
  path <- "resultaten/calibratiecijfers"
  
  # Bewaar als tab-gescheiden tekstbestand
  write.table(cali.data,
    file = file.path(path, paste0("cali_", ind, ".txt")),
    sep = "\t",
    quote = FALSE,
    row.names = FALSE)
  
}
