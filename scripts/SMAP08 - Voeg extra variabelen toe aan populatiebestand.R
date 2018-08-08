#
# Toevoegen extra variabelen aan populatiebestand
#

# Als je extra voorspellers hebt die niet uit de microdata komen
# dan kun je ze hier toevoegen aan het populatiebestand

#
# Init
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(data.table)
library(magrittr)

#
# Lees data
#

# Lees R binary pop.data
load(file = "data/populatie/SMAP2016_populatie_schoon_volledig.bin")

# Lees Kerncijfers_wijken_en_buurten_2016.csv
# Download: http://10.2.13.22/Statweb/selection/?VW=T&DM=SLNL&PA=83487ned&D1=2%2c105&D2=a&HDR=T&STB=G1
# Nodig voor OAD per buurt
oad.data <- fread(
  input = "data/gebieden/Kerncijfers_wijken_en_buurten_2016.csv",
  skip = 3, select = 2:3, fill = TRUE)

# Lees Gebieden_in_Nederland_2016.csv
# Download: http://10.2.13.22/Statweb/selection/?VW=T&DM=SLNL&PA=83287ned&D1=0,13&D2=a&HDR=T&STB=G1
# Nodig voor koppeling gemeentes - GGD'en
ggd.data <- fread(
  input = "data/gebieden/Gebieden_in_Nederland_2016.csv",
  skip = 4, select = 2:3, fill = TRUE)

# Hier je eigen variabele
# ...

#
# Opschonen oad.data
#

# Hernoem variabelen
names(oad.data) <- c("bu_code", "oad")

# Het laatste record bevat niets, kan eruit
oad.data <- oad.data[-nrow(oad.data), ]

# oad.data bevat OAD per gemeente, wijk en buurt
# We hebben alleen buurten nodig
oad.data <- oad.data[bu_code %>% substr(start = 1, stop = 2) == "BU", ]

# Maak juiste datatype van bu_code (factor) en oad (integer)
# Negeer warning 'NAs introduced by coercion' 
oad.data[, bu_code := bu_code %>% as.factor]
oad.data[, oad := oad %>% as.integer]

# Vervang NA door 0
# Buurten met NA zijn (vaak) nieuwbouwwijken, water of buitengebieden -> OAD = 0
oad.data[, oad := oad %>% is.na %>% ifelse(yes = 0, no = oad)]

# Hercodeer OAD naar percentielen: onderste 1% tot bovenste 1%
oad.data[, oad := oad %>% cut(
  breaks = quantile(., prob = seq(from = 0, to = 1, by = 0.01)),
  labels = FALSE, include.lowest = TRUE, right = FALSE)]
  
#
# Opschonen ggd.data
#

# Hernoem variabelen
names(ggd.data) <-  c("gm_code", "gg_code")

# Het laatste record bevat niets, kan eruit
ggd.data <- ggd.data[-nrow(ggd.data), ]

# Maak van beide codes een factor
ggd.data[, gm_code := gm_code %>% factor]
ggd.data[, gg_code := gg_code %>% factor]

#
# Voeg extra variabelen toe aan pop.data
#

pop.data <- merge(pop.data, oad.data, by = "bu_code", all.x = TRUE, sort = FALSE)
pop.data <- merge(pop.data, ggd.data, by = "gm_code", all.x = TRUE, sort = FALSE)

# Zet key terug naar rinpersoon
pop.data %>% setkey(rinpersoon)

#
# Bewaar pop.data als R binary
#

# Bewaar als R binary
save(pop.data, file = "data/populatie/SMAP2016_populatie_schoon_volledig_extra.bin")
