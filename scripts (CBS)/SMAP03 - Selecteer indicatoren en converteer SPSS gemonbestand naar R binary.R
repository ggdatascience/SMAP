#
# Selecteren gezondheidsindicatoren
# Converteer SPSS gemondbestand naar R binary
#

#
# Init
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(foreign)
library(data.table)
library(magrittr)

#
# Lees gezondheidsmonitor data
#

# Lees gemon data (duurt lang!)
# Je kunt de warnings negeren
gemon.data <- read.spss(file = "G:/1_MicroData/GEMON/2016/GEZOMONITOR2016V1.SAV") %>% 
  as.data.table

#
# Selecteer gezondheidsindicatoren
# Als je andere indictoren wilt toevoegen, dan doe je dat hier
#

# Maak selectie
gemon.data <- gemon.data[, .(
  # RINPersoon hebben we altijd nodig voor de koppeling met het populatiebestand
  RINPersoon,
  # Indicatoren SMAP2016
  LFALA201, LFALA213, LFALS232, LFALS230, LFALS231,
  AGGWS204, AGGWS205,
  LFRKA205,
  KLGGA208,
  CALGA260, CALGA261, CALGA262, CALGS260,
  LGBPS203, LGBPS204, LGBPS205, LGBPS209,
  GGRLS203,
  GGADA202, GGADA203,
  MCMZGS203,
  RLBEW, FITNORM, COMBNORM, SPORTER,
  GGEES217, GGEES209, GGEES215, GGEES216,
  MMVWA201,
  MMIKA201,
  MCMZOS304, MCMZOS305
)]

#
# Enkele kleine aanpassingen aan gemon.data
#

# Converteer RINPersoon naar integer (was character)
gemon.data[, RINPersoon := as.integer(RINPersoon)]

# Set key RINPersoon
gemon.data %>% setkey(RINPersoon)

#
# Bewaar gemon.data als R binary
#

# Bewaar als R binary
save(gemon.data, file = "data/gemon/gemon2016.bin")
