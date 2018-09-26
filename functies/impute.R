# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

impute <- function(formula, data, newdata, ...) {
  # formula = random forest formule
  # data    = data om te fitten
  # newdata = data om te imputeren
  # ...     = overige argumenten die rfparallel ingaan
  
  # Fit random forest model
  rf.model <- rfparallel(formula = formula, data = data, ...)
  
  # Trek naam van response variable uit rf.model object
  resp <- rf.model %>% use_series("terms") %>% attr("dataClasses") %>% extract(1) %>% names
  
  # Welke records in newdata hebben missende response?
  resp.na <- paste0("newdata[, ", resp, "] %>% is.na") %>% parse(text = .) %>% eval
  
  # Maak predicties voor missende response
  pred <- predict(rf.model, newdata = newdata[resp.na, ])
  
  # Vervang missende reponse door predicties
  newdata[resp.na, resp] <- pred
  
  # Return output
  return(newdata)
}
