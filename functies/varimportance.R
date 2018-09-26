# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

# Variable importance plot

varimportance <- function(formula, data, main = NULL, saveplot = FALSE, path = NULL, ...) {
  # formula    = random forest formule
  # data       = data om te fitten
  # main       = plot titel
  # saveplot   = plot opslaan als pdf?
  # path       = locatie van de pdf's
  # ...        = overige argumenten die rfparallel ingaan
  
  # Fit random forest model
  rf.model <- rfparallel(formula = formula, data = data, importance = TRUE, ...)
    
  # Open verbinding naar pdf  
  if (saveplot) pdf(file = file.path(path, paste0(main, ".pdf")))
  
  # Variable importance plot
  varImpPlot(rf.model, type = 1, main = main)
  
  # Save plot
  if (saveplot) dev.off()
}
