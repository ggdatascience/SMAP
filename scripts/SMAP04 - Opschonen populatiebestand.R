#
# Opschonen populatiebestand
#

#
# Init
#

# Extra library path
.libPaths("G:/8_Utilities/R/Lib3")

# Laad packages
library(data.table)
library(magrittr)
library(forcats)

#
# Lees populatie data
#

# Lees R binary pop.data
load(file = "data/populatie/SMAP2016_populatie.bin")

#
# Hernoem variabelen
#

# Check dat volgorde van oude- en nieuwe namen overeenkomt
# Zie pdf's in folder data/microdata_meta

# Voor
names(pop.data)

# Hernoem
pop.data %>% setnames(
  old = c(
    "RINPERSOON", "GBAGESLACHT", "ETNGRP", "GBABURGERLIJKESTAATNW",
    "TYPHH", "AANTALPERSHH", "OPLNIVSOI2016AGG4HBMETNIRWO",
    "INHBBIHJ", "INHEHALGR", "INHP100HBEST", "VEHP100HVERM",
    "gem2016", "wc2016", "bc2016", "XCOORDADRES", "YCOORDADRES", "leeftijd"),
  new = c(
    "rinpersoon", "geslacht", "herkomst", "burgstaat",
    "hhtype", "hhgrootte", "opleiding",
    "hhinkomensbron", "hhwoningbezit", "hhinkomen", "hhvermogen",
    "gm_code", "wk_code", "bu_code", "xcoord", "ycoord", "leeftijd"))

# Na
names(pop.data)

#
# Zet variabelen op logische(re) volgorde
#

pop.data <- pop.data[, .(
  rinpersoon, leeftijd, geslacht, herkomst, burgstaat, opleiding,
  hhtype, hhgrootte, hhinkomensbron, hhwoningbezit, hhinkomen, hhvermogen,
  gm_code, wk_code, bu_code, xcoord, ycoord)]

#
# Hercodeer variabelen
#

# Zie populatiebestand in SPSS file voor juiste labels
# of pdf's in folder data/microdata_meta

# Geslacht
pop.data[,
  geslacht := geslacht %>% factor %>% fct_collapse(
    man   = "1",
    vrouw = "2")]

# Herkomst
pop.data[,
  herkomst := herkomst %>% factor %>% fct_collapse(
    nederland  = "0",
    marokko    = "1",
    turkije    = "2",
    suriname   = "3",
    antillen   = "4",
    ovnietwest = "5",
    ovwest     = "6")]

# Burgelijke staat
# Partnerschap -> gehuwd
pop.data[,
  burgstaat := burgstaat %>% factor %>% fct_collapse(
    ongehuwd   = "O",
    gehuwd     = c("H", "P"),
    gescheiden = c("S", "SP"),
    verweduwd  = c("W", "WP"),
    NULL       = "")]

# Huishoudtype
# Institutioneel -> overig
pop.data[,
  hhtype := hhtype %>% factor %>% fct_collapse(
    eenpers             = "1",
    ongehuwd_zonderkind = "2",
    gehuwd_zonderkind   = "3",
    ongehuwd_metkind    = "4",
    gehuwd_metkind      = "5",
    eenouder            = "6",
    overig              = c("7", "8"))]

# Opleiding
# Voor naamgeving is doorgaans de grootste categorie genomen
pop.data[,
  opleiding := opleiding %>% factor %>% fct_collapse(
    basisonderwijs           = c("1111", "1112"),
    vmbo_basis_kader         = c("1211", "1212", "1213"),
    vmbo_gemengd_theoretisch = c("1221", "1222"),
    mbo_basis_vak            = c("2111", "2112"),
    mbo_middenkader          = "2121",
    havo_vwo                 = c("2131", "2132"),
    bachelor                 = c("3111", "3112", "3113"),
    master                   = c("3211", "3212", "3213"))]

# Huishoudgrootte
# Blijft integer. >= 10 -> 10
pop.data[hhgrootte >= 10, hhgrootte := 10]

# Huishoud inkomensbron
pop.data[,
  hhinkomensbron := hhinkomensbron %>% factor %>% fct_collapse(
    loon          = "11",
    loon_dirgradh = "12",
    zelfstandig   = c("13", "14"),
    uitk_ww       = "21",
    uitk_bijstand = "22",
    uitk_socvoorz = "23",
    uitk_ziekteao = "24",
    uitk_pensioen = "25",
    studiefin     = "26",
    vermogen      = "30",
    NULL          = "99")]

# Huishoud woningbezit
pop.data[,
  hhwoningbezit := hhwoningbezit %>% factor %>% fct_collapse(
    eigen              = "1",
    huur_zondertoeslag = "2",
    huur_mettoeslag    = "3",
    institutioneel     = "8",
    NULL               = "9")]

# Huishoudinkomen en huishoudvermogen
# Blijft integer. Institutioneel (-2) en particulier onbekend (-1) -> NA
pop.data[, hhinkomen  := hhinkomen  %in% c(-2, -1) %>% ifelse(yes = NA, no = hhinkomen)]
pop.data[, hhvermogen := hhvermogen %in% c(-2, -1) %>% ifelse(yes = NA, no = hhvermogen)]

# Gemeentecode, wijkcode en buurtcode
# Voeg GM, WK of BU toe, met voorloopnullen
pop.data[, gm_code := paste0("GM", gm_code %>% formatC(width = 4, flag = "0")) %>% factor]
pop.data[, wk_code := paste0("WK", wk_code %>% formatC(width = 6, flag = "0")) %>% factor]
pop.data[, bu_code := paste0("BU", bu_code %>% formatC(width = 8, flag = "0")) %>% factor]
# NA's moeten NA blijven en niet "GM  NA"
pop.data[gm_code ==     "GM  NA", gm_code := NA]
pop.data[wk_code ==   "WK    NA", wk_code := NA]
pop.data[bu_code == "BU      NA", bu_code := NA]
pop.data[, gm_code := gm_code %>% droplevels]
pop.data[, wk_code := wk_code %>% droplevels]
pop.data[, bu_code := bu_code %>% droplevels]

#
# Bewaar pop.data als R binary
#

# Bewaar als R binary
save(pop.data, file = "data/populatie/SMAP2016_populatie_schoon.bin")
