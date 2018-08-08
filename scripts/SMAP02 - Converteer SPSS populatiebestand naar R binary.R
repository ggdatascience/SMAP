#
# Converteer SPSS populatiebestand naar R binary
#

#
# Init
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(data.table)
library(magrittr)

#
# Lees population data
#

# Dit geeft waarschijnlijk waarschuwingen over 'bumping into type character, coercing from integer'
# Reden: sommige records van gem2016, wc2016, bc2016 bevatten ---- or -- (= missing)
# Wordt hieronder opgelost
pop.data <- fread(input = "data/populatie/SMAP2016_populatie.dat")

#
# Enkele kleine aanpassingen aan pop.data
#

# Bereken leeftijd and selecteer leeftijd >= 19 op 2016-09-01
pop.data[,
  leeftijd := ((2016*365.25 + 09*30.4375 + 01 - (GBAGEBOORTEJAAR*365.25 + GBAGEBOORTEMAAND*30.4375 + 15))/365.25) %>% 
    floor %>% 
    as.integer]
pop.data <- pop.data[leeftijd >= 19, ]

# Herstel missende gem2016, wc2016, bc2016
# Doe dit door ze te converteren naar to integers. Dit maakt ze NA
# De waarschuwing 'NAs introduced by coercion' is precies wat we willen
pop.data[, gem2016 := as.integer(gem2016)]
pop.data[, wc2016  := as.integer( wc2016)]
pop.data[, bc2016  := as.integer( bc2016)]

# Verwijder ongebruikte variabelen
pop.data <- subset(pop.data, select = -c(GBAGEBOORTEJAAR, GBAGEBOORTEMAAND))

# Set key RINPERSOON
pop.data %>% setkey(RINPERSOON)

#
# Bewaar pop.data als R binary
#

# Bewaar als R binary
save(pop.data, file = "data/populatie/SMAP2016_populatie.bin")
