# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

# Functie om individuele predicties te aggregeren naar buurt, wijk en gemeente
# Uitvoer wordt weggeschreven als tab-gescheiden tekstbestand

# Opmerking!
# Voorlopig nu even: aggregatie op basis van *_code in pop.data (2016 indeling)
# Te doen voor later: spatial join vindt plaats op basis van XY-coordinaten uit pop.data

ind2buwkgm <- function(ind) {
  
  #
  # Lees indicator data ----
  #
  
  # Path
  path <- "resultaten/predicties nl"
  
  # Maak bestandsnaam
  filename <- paste0(ind, ".bin")
  
  # Lees individuele uitkomsten NL (smap.data)
  load(file = file.path(path, filename))
  
  #
  # Voeg smap.data samen met pop.data ----
  #
  
  smap.data <- merge(
    x = smap.data[, .(rinpersoon, pred)],
    y = pop.data[, .(rinpersoon, bu_code, wk_code, gm_code)],
    by = "rinpersoon")
  
  #
  # Aggregeer per buurt, wijk en gemeente ----
  #
  
  # Middel de predicties en tel het aantal records
  # Hernoem pred -> prevalentie
  bu.data <- smap.data[, .(prevalentie = mean(pred), populatie = .N), by = bu_code]
  wk.data <- smap.data[, .(prevalentie = mean(pred), populatie = .N), by = wk_code]
  gm.data <- smap.data[, .(prevalentie = mean(pred), populatie = .N), by = gm_code]
  
  # Buurten en wijken met 0 populatie zijn eruit gevallen (gemeentes hebben nooit 0 inwoners)
  # Voeg deze weer toe d.m.v. een merge
  bu.data <- merge(x = data.table(bu_code = bu.data[, bu_code] %>% levels), y = bu.data, all.x = TRUE)
  wk.data <- merge(x = data.table(wk_code = wk.data[, wk_code] %>% levels), y = wk.data, all.x = TRUE)
  
  # Zijn er minder dan 10 records per buurt of wijk, zet prevalentie en populatie dan op NA
  bu.data[populatie < 10, c("prevalentie", "populatie") := NA]
  wk.data[populatie < 10, c("prevalentie", "populatie") := NA]
  
  #
  # Schrijf resultaten weg
  #

  # Extra: rond prevalenties af op 3 cijfers achter komma
  bu.data[, prevalentie := prevalentie %>% round(digits = 3)]
  wk.data[, prevalentie := prevalentie %>% round(digits = 3)]
  gm.data[, prevalentie := prevalentie %>% round(digits = 3)]
  
  # Stel uitvoer path in
  path <- "resultaten/buurt-wijk-gemeente cijfers"

  # Bewaar als tab-gescheiden tekstbestand
  write.table(bu.data, file = file.path(path, paste0("bu_", ind, ".txt")), sep = "\t", quote = FALSE, row.names = FALSE)
  write.table(wk.data, file = file.path(path, paste0("wk_", ind, ".txt")), sep = "\t", quote = FALSE, row.names = FALSE)
  write.table(gm.data, file = file.path(path, paste0("gm_", ind, ".txt")), sep = "\t", quote = FALSE, row.names = FALSE)
  
}
