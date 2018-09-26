# SMAP - Small area estimation for policy makers
# Delen van dit script mogen gekopieerd worden voor eigen gebruik
# onder vermelding van de auteur en een referentie naar het SMAP artikel in IJHG (2017)
# Auteur: Jan van de Kassteele - RIVM

#
# Selecteren gezondheidsindicatoren
# Converteer SPSS gemondbestand naar R binary
#

#
# Init
#

# Laad packages
library(foreign)
library(data.table)
library(magrittr)

#
# Lees gezondheidsmonitor data
#

# Lees gemon data (duurt lang!)
# Je kunt de warnings negeren
gemon.data <- read.spss(file = "G:/GezondheidWelzijn/GEMON/2016/GEZOMONITOR2016V2.SAV") %>% 
  as.data.table

#
# Selecteer gezondheidsindicatoren
# Als je andere indictoren wilt toevoegen, dan doe je dat hier
#

# Maak selectie
gemon.data <- gemon.data[, .(
  # RINPERSOON hebben we altijd nodig voor de koppeling met het populatiebestand
  RINPERSOON,
  # Indicatoren SMAP2016
  LFALA201, LFALA213, LFALS231, LFALS230, LFALS232,
  AGGWS204, AGGWS205,
  LFRKA205,
  KLGGA208,
  CALGA260, CALGA261, CALGA262, CALGS260,
  LGBPS203, LGBPS204, LGBPS205, LGBPS209,
  GGRLS203,
  GGADA202, GGADA203,
  KI_RLBEW2017, KIsporter,
  GGEES217, GGEES209, GGEES215, GGEES216,
  MMVWA201,
  MMIKA201,
  MCMZGS203, MCMZOS304, MCMZOS305
)]

#
# Enkele kleine aanpassingen aan gemon.data
#

# Converteer RINPERSOON naar integer (was character)
gemon.data[, RINPERSOON := as.integer(RINPERSOON)]

# Set key RINPERSOON
gemon.data %>% setkey(RINPERSOON)

#
# Bewaar gemon.data als R binary
#

# Bewaar als R binary
save(gemon.data, file = "data/gemon/gemon2016.bin")
