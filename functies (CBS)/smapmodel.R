# Functie om SMAP model te fitten en voorspellingen te maken
# Als je je model wilt herformuleren, bijvoorbeeld met een extra voorspeller,
# doe dat dan hieronder in de modelformule

smapmodel <- function(rin, ind, buffer = 5000, return.model.object = FALSE) {

  # Input:
  # rin          = lijst met rin.fit, rin.pred en validatie indicator
  # ind          = naam van de gezondheidsindicator
  # buffer       = grootte van de buffer (meters) rondom ggd regio
  # model.object = return model object? (evt voor inspectie)
  
  # Require packages
  require(mgcv)
  
  # Laad functies
  source("functies/subset.data.ggd.R")
  
  #
  # Voorbereidend werk ----
  #
  
  # Creeer dataset om op te fitten
  fit.data <- merge(
    x = pop.data[rinpersoon %in% rin$rin.fit, ],
    y = cbind(
      gemon.data[rinpersoon %in% rin$rin.fit, .(rinpersoon)],
      gemon.data[rinpersoon %in% rin$rin.fit, ind, with = FALSE]),
    by = "rinpersoon",
    all.x = TRUE)
  
  # Creeer dataset om mee te voorspellen
  pred.data <- merge(
    x = pop.data[rinpersoon %in% rin$rin.pred, ],
    y = cbind(
      gemon.data[rinpersoon %in% rin$rin.pred, .(rinpersoon)],
      gemon.data[rinpersoon %in% rin$rin.pred, ind, with = FALSE]),
    by = "rinpersoon",
    all.x = TRUE)
  
  # Welke unieke ggd regiocodes zitten er in fit.data?
  ggd <- fit.data[, gg_code] %>%
    droplevels %>%
    levels
  
  # Loop over ggd regiocodes (ook al is het er maar een)
  for (ggd.i in ggd) {

    # Toon voortgang
    print(paste(Sys.time(), ind, ggd.i, sep = " - "))
    
    # Subset fit.data en pred.data voor ggd.i -> fit.data.ggd en pred.data.ggd
    # Echter, om randeffecten te voorkomen wordt fit.data.ggd groter gemaakt met een buffer
    # Dit maakt het net iets ingewikkelder...
    tmp <- subset.data.ggd(
      fit.data = fit.data,
      pred.data = pred.data,
      ggd = ggd.i,
      bu.sf = bu.sf,
      buffer = buffer)
    
    # Haal objecten uit tmp
    fit.data.ggd  <- tmp$fit.data.ggd
    pred.data.ggd <- tmp$pred.data.ggd
    bu.nb         <- tmp$bu.nb
    rm(tmp)

    # Voor de makkelijkheid hernoemen we ind naar obs
    # Zo kunnen we in de modelformule telkens obs gebruiken
    fit.data.ggd  %>% setnames(old = ind, new = "obs")
    pred.data.ggd %>% setnames(old = ind, new = "obs")
    
    #
    # Fit model ----
    #
    
    # Een paar zaken aangaande de modelformulatie:
    # - Alle numerieke variabelen gaan erin als P-spline met 10 refdf, behalve hhgrootte (refdf = 5)
    # - Alle categorische variabelen gaan erin als random effect
    # - Buurt gaat erin als ruimtelijke gecorreleerd r.e. met refdf 10x zo klein als het aantal buurten
    #   Meer duurt alleen maar langer en is totaal overbodig
    # - Zowel de P-splines als random effecten zorgen voor regularisatie (smoothing) bij te weinig waarnemingen
    # - Met select = TRUE worden smooths (spline of r.e.) die er niet toe doen op 0 gezet
    # - Iedere categorie binnen geslacht, herkomst, burgelijke staat en opleiding krijgt zijn eigen leeftijdseffect
    # - Herkomst, burgelijke staat en opleiding hebben een interactie met geslacht

    # Fit model aan fit.data.ggd (althans, probeer dat)
    mod <- try(bam(
      formula = obs ~
        s(leeftijd, by = geslacht,  bs = "ps", k = 10) +
        s(leeftijd, by = herkomst,  bs = "ps", k = 10) +
        s(leeftijd, by = burgstaat, bs = "ps", k = 10) +
        s(leeftijd, by = opleiding, bs = "ps", k = 10) +
        s(geslacht, herkomst,  bs = "re") +
        s(geslacht, burgstaat, bs = "re") +
        s(geslacht, opleiding, bs = "re") +
        s(hhtype, bs = "re") +
        s(hhgrootte, bs = "ps", k = 5) +
        s(hhinkomensbron, bs = "re") +
        s(hhwoningbezit, bs = "re") +
        s(hhinkomen, bs = "ps", k = 10) +
        s(hhvermogen, bs = "ps", k = 10) +
        s(oad, bs = "ps", k = 10) +
        s(bu_code, bs = "mrf", k = bu.nb %>% length %>% divide_by(5) %>% round, xt = list(nb = bu.nb)),
      data = fit.data.ggd,
      family = binomial,
      drop.unused.levels = FALSE,
      discrete = TRUE,
      select = TRUE),
      silent = TRUE)
    
    # Als class(mod) is "try-error" -> simplificeer het model
    # De fout wordt veroorzaakt door de interactie leeftijd x herkomst -> weg ermee
    # Herkomst zit er overigens nog steeds in via geslacht x herkomst
    if (any(class(mod) == "try-error")) {
      mod <- bam(
        formula = obs ~
          s(leeftijd, by = geslacht,  bs = "ps", k = 10) +
          s(leeftijd, by = burgstaat, bs = "ps", k = 10) +
          s(leeftijd, by = opleiding, bs = "ps", k = 10) +
          s(geslacht, herkomst,  bs = "re") +
          s(geslacht, burgstaat, bs = "re") +
          s(geslacht, opleiding, bs = "re") +
          s(hhtype, bs = "re") +
          s(hhgrootte, bs = "ps", k = 5) +
          s(hhinkomensbron, bs = "re") +
          s(hhwoningbezit, bs = "re") +
          s(hhinkomen, bs = "ps", k = 10) +
          s(hhvermogen, bs = "ps", k = 10) +
          s(oad, bs = "ps", k = 10) +
          s(bu_code, bs = "mrf", k = bu.nb %>% length %>% divide_by(5) %>% round, xt = list(nb = bu.nb)),
        data = fit.data.ggd,
        family = binomial,
        drop.unused.levels = FALSE,
        discrete = TRUE,
        select = TRUE)
    }
    
    #
    # Voorspel ----
    #
    
    # Voorspel uitkomst
    pred <- predict(
      object = mod,
      newdata = pred.data.ggd,
      type = "response")
    
    # pred.data.ggd is een data.table met rinpersoon, pred en obs
    pred.data.ggd <- cbind(
      pred.data.ggd[, .(rinpersoon, obs)],
      as.data.table(pred))
    setkey(pred.data.ggd, rinpersoon)
    
    #
    # Nawerk
    #
    
    # Stel uitvoer path in
    if (rin$validatie) {
      path <- "resultaten/validaties ggd"
    } else {
      path <- "resultaten/predicties ggd"
    }
    
    # Maak bestandsnaam
    filename <- paste0(ind, " - ", ggd.i, ".bin")
    
    # Sla pred.data.ggd op als R binary
    save(pred.data.ggd, file = file.path(path, filename))
    
    # Einde ggd-loop
  }

  # Return eventueel model object ter inspectie
  if (return.model.object) return(mod)
  
}
